#!/usr/bin/env bats
# Tests for aibox/lib.sh — project resolution and policy merge.

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  # shellcheck source=SCRIPTDIR/../../aibox/lib.sh
  source "$REPO_ROOT/aibox/lib.sh"

  export HOME="$BATS_TEST_TMPDIR/home"
  export AIBOX_HOME="$BATS_TEST_TMPDIR/policy"
  mkdir -p "$HOME" "$AIBOX_HOME/allow" "$AIBOX_HOME/projects"
}

git_new_repo() {
  git init -q -b main "$1"
  git -C "$1" -c user.name=t -c user.email=t@t -c commit.gpgsign=false \
    commit -q --allow-empty -m init
}

# --- aibox_slug -------------------------------------------------------------

@test "slug: scp-style ssh remote" {
  run aibox_slug "git@gitlab.netology.ru:grp/repo.git"
  [ "$status" -eq 0 ]
  [ "$output" = "gitlab.netology.ru__grp__repo" ]
}

@test "slug: https remote" {
  run aibox_slug "https://github.com/MrRTi/dotfiles.git"
  [ "$output" = "github.com__MrRTi__dotfiles" ]
}

@test "slug: ssh:// remote with port drops user and port" {
  run aibox_slug "ssh://git@gitlab.example.com:2222/a/b/c.git"
  [ "$output" = "gitlab.example.com__a__b__c" ]
}

# --- aibox_tier -------------------------------------------------------------

@test "tier: netology path is work" {
  run aibox_tier "$HOME/Developer/netology/x/main" "/nonexistent"
  [ "$output" = "work" ]
}

@test "tier: personal path is personal" {
  run aibox_tier "$HOME/Developer/personal/x/main" "/nonexistent"
  [ "$output" = "personal" ]
}

@test "tier: unknown path defaults to work" {
  run aibox_tier "/tmp/x" "/nonexistent"
  [ "$output" = "work" ]
}

@test "tier: project config TIER overrides path" {
  printf 'TIER=personal\n' > "$BATS_TEST_TMPDIR/config"
  run aibox_tier "$HOME/Developer/netology/x/main" "$BATS_TEST_TMPDIR/config"
  [ "$output" = "personal" ]
}

@test "tier: invalid TIER value in config falls back to path rule" {
  printf 'TIER=root\n' > "$BATS_TEST_TMPDIR/config"
  run aibox_tier "$HOME/Developer/personal/x/main" "$BATS_TEST_TMPDIR/config"
  [ "$output" = "personal" ]
}

# --- aibox_validate_domain ----------------------------------------------------

@test "validate: accepts plain hostname" {
  run aibox_validate_domain "docs.foo.dev"
  [ "$status" -eq 0 ]
}

@test "validate: rejects bad inputs" {
  local long
  long="$(printf 'a%.0s' {1..250}).com" # 254 chars
  for d in '*.evil.tld' '1.2.3.4' 'evil.tld/path' $'evil.tld\nall' '' 'localhost' \
           "$long" '-evil.tld' 'evil-.tld' 'EVIL.TLD' 'evil..tld' '.evil.tld' 'evil.tld:443'; do
    run aibox_validate_domain "$d"
    [ "$status" -ne 0 ] || { echo "accepted: [$d]"; return 1; }
  done
}

# --- aibox_merge_allow --------------------------------------------------------

@test "merge: layers combine, dedupe, drop comments and blanks" {
  printf 'openrouter.ai\n# comment\n\nrubygems.org\n' > "$AIBOX_HOME/allow/base.txt"
  printf 'rubyonrails.org  # trailing comment\nrubygems.org\n' > "$AIBOX_HOME/allow/work.txt"
  mkdir -p "$AIBOX_HOME/projects/p"
  printf 'docs.vendor.com\n' > "$AIBOX_HOME/projects/p/allow.txt"
  printf 'session.example.org\n' > "$BATS_TEST_TMPDIR/session"

  run aibox_merge_allow work p "$BATS_TEST_TMPDIR/session"
  [ "$status" -eq 0 ]
  [ "$output" = "$(printf 'docs.vendor.com\nopenrouter.ai\nrubygems.org\nrubyonrails.org\nsession.example.org')" ]
}

@test "merge: missing layers are fine" {
  printf 'openrouter.ai\n' > "$AIBOX_HOME/allow/base.txt"
  run aibox_merge_allow personal nope "/nonexistent"
  [ "$status" -eq 0 ]
  [ "$output" = "openrouter.ai" ]
}

@test "merge: invalid lines are dropped" {
  printf 'openrouter.ai\n*.evil.tld\n1.2.3.4\n' > "$AIBOX_HOME/allow/base.txt"
  run aibox_merge_allow work nope "/nonexistent"
  [ "$output" = "openrouter.ai" ]
}

# --- aibox_config_get ---------------------------------------------------------

@test "config_get: returns value" {
  printf 'PORTS=3000,5173\nCPUS=2\n' > "$BATS_TEST_TMPDIR/config"
  run aibox_config_get "$BATS_TEST_TMPDIR/config" CPUS 4
  [ "$output" = "2" ]
}

@test "config_get: missing key or file returns default" {
  printf 'PORTS=3000\n' > "$BATS_TEST_TMPDIR/config"
  run aibox_config_get "$BATS_TEST_TMPDIR/config" CPUS 4
  [ "$output" = "4" ]
  run aibox_config_get "/nonexistent" CPUS 4
  [ "$output" = "4" ]
}

@test "config_get: never executes file content" {
  # shellcheck disable=SC2016 # literal on purpose
  printf 'X=$(touch %s/pwned)\n' "$BATS_TEST_TMPDIR" > "$BATS_TEST_TMPDIR/config"
  run aibox_config_get "$BATS_TEST_TMPDIR/config" X ""
  [ "$output" = "\$(touch $BATS_TEST_TMPDIR/pwned)" ]
  [ ! -e "$BATS_TEST_TMPDIR/pwned" ]
}

# --- aibox_refuse_policy_repo -------------------------------------------------

@test "refuse: worktree of the policy repo is refused" {
  git_new_repo "$BATS_TEST_TMPDIR/dots/main"
  mkdir -p "$BATS_TEST_TMPDIR/dots/main/aibox"
  git -C "$BATS_TEST_TMPDIR/dots/main" worktree add -q "$BATS_TEST_TMPDIR/dots/feat" -b feat
  AIBOX_HOME="$BATS_TEST_TMPDIR/dots/main/aibox"

  run aibox_refuse_policy_repo "$BATS_TEST_TMPDIR/dots/feat"
  [ "$status" -eq 1 ]
  run aibox_refuse_policy_repo "$BATS_TEST_TMPDIR/dots/main"
  [ "$status" -eq 1 ]
}

@test "refuse: unrelated repo is allowed" {
  git_new_repo "$BATS_TEST_TMPDIR/dots/main"
  mkdir -p "$BATS_TEST_TMPDIR/dots/main/aibox"
  git_new_repo "$BATS_TEST_TMPDIR/other"
  AIBOX_HOME="$BATS_TEST_TMPDIR/dots/main/aibox"

  run aibox_refuse_policy_repo "$BATS_TEST_TMPDIR/other"
  [ "$status" -eq 0 ]
}

# --- aibox_project_slug -------------------------------------------------------

@test "project_slug: uses origin remote" {
  git_new_repo "$BATS_TEST_TMPDIR/r/main"
  git -C "$BATS_TEST_TMPDIR/r/main" remote add origin git@github.com:me/r.git
  run aibox_project_slug "$BATS_TEST_TMPDIR/r/main"
  [ "$output" = "github.com__me__r" ]
}

@test "project_slug: no remote falls back to repo folder name, same for every worktree" {
  git_new_repo "$BATS_TEST_TMPDIR/myproj/main"
  git -C "$BATS_TEST_TMPDIR/myproj/main" worktree add -q "$BATS_TEST_TMPDIR/myproj/feat" -b feat
  run aibox_project_slug "$BATS_TEST_TMPDIR/myproj/main"
  [ "$output" = "local__myproj" ]
  run aibox_project_slug "$BATS_TEST_TMPDIR/myproj/feat"
  [ "$output" = "local__myproj" ]
}

@test "refuse: another clone of the policy repo (same remote) is refused" {
  git_new_repo "$BATS_TEST_TMPDIR/dots/main"
  git -C "$BATS_TEST_TMPDIR/dots/main" remote add origin git@github.com:me/dotfiles.git
  mkdir -p "$BATS_TEST_TMPDIR/dots/main/aibox"
  git_new_repo "$BATS_TEST_TMPDIR/clone/main"
  git -C "$BATS_TEST_TMPDIR/clone/main" remote add origin https://github.com/me/dotfiles.git
  AIBOX_HOME="$BATS_TEST_TMPDIR/dots/main/aibox"

  run aibox_refuse_policy_repo "$BATS_TEST_TMPDIR/clone/main"
  [ "$status" -eq 1 ]
  [[ $output == *"clone of the policy repo"* ]]
}
