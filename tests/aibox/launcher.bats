#!/usr/bin/env bats
# Tests for the aibox launcher (dot_local/bin/executable_aibox).

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  AIBOX="$REPO_ROOT/dot_local/bin/executable_aibox"
  export HOME="$BATS_TEST_TMPDIR/home"
  export AIBOX_HOME="$BATS_TEST_TMPDIR/policy/aibox"
  mkdir -p "$HOME/Developer/personal" "$AIBOX_HOME/allow"
  cp "$REPO_ROOT/aibox/lib.sh" "$AIBOX_HOME/lib.sh"
  printf 'openrouter.ai\n' >"$AIBOX_HOME/allow/base.txt"
}

git_new_repo() {
  git init -q -b main "$1"
  git -C "$1" -c user.name=t -c user.email=t@t -c commit.gpgsign=false \
    commit -q --allow-empty -m init
}

@test "info: shows project, tier and allowlist for a project dir" {
  git_new_repo "$HOME/Developer/personal/proj/main"
  git -C "$HOME/Developer/personal/proj/main" remote add origin git@github.com:me/proj.git
  mkdir -p "$HOME/Developer/personal/proj/main/sub"
  cd "$HOME/Developer/personal/proj/main/sub"

  run "$AIBOX" info
  [ "$status" -eq 0 ]
  [[ $output == *"project:  github.com__me__proj"* ]]
  [[ $output == *"tier:     personal"* ]]
  [[ $output == *"openrouter.ai"* ]]
}

@test "info: refuses in the policy repo" {
  git_new_repo "$BATS_TEST_TMPDIR/policy"
  cd "$BATS_TEST_TMPDIR/policy"
  run "$AIBOX" info
  [ "$status" -eq 1 ]
  [[ $output == *"refusing to run in the policy repo"* ]]
}

@test "outside a git repo: clear error" {
  mkdir -p "$BATS_TEST_TMPDIR/plain"
  cd "$BATS_TEST_TMPDIR/plain"
  run "$AIBOX" info
  [ "$status" -eq 1 ]
  [[ $output == *"not inside a git repository"* ]]
}

@test "unknown subcommand prints usage" {
  run "$AIBOX" frobnicate
  [ "$status" -eq 2 ]
  [[ $output == *"usage: aibox"* ]]
}
