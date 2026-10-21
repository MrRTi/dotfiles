#!/usr/bin/env bash
# vim: set ft=sh :
# aibox policy library. Sourced by aibox and aibox-broker; defines functions only.
#
# Policy lives under $AIBOX_HOME (the chezmoi source's aibox/ dir), never in
# a repo the agent can write. Nothing here sources or evals policy files.

# Project id from a git remote URL: host + path, "/" -> "__", ".git" stripped.
#   git@gitlab.netology.ru:grp/repo.git    -> gitlab.netology.ru__grp__repo
#   ssh://git@host:2222/a/b.git            -> host__a__b
aibox_slug() {
  local url=${1%/} hostpath host path
  url=${url%.git}
  case $url in
    *://*)
      hostpath=${url#*://}
      hostpath=${hostpath#*@}
      host=${hostpath%%/*}
      path=${hostpath#*/}
      hostpath="${host%%:*}/$path"
      ;;
    *@*:*)
      hostpath=${url#*@}
      hostpath=${hostpath/://}
      ;;
    *) return 1 ;;
  esac
  printf '%s\n' "${hostpath//\//__}"
}

# Value of KEY from a KEY=VALUE file, or default. Parses only; the last
# assignment wins. A missing file yields the default.
aibox_config_get() {
  local file=$1 key=$2 default=$3 line val found=0
  if [[ -r $file ]]; then
    while IFS= read -r line || [[ -n $line ]]; do
      if [[ $line == "$key="* ]]; then
        val=${line#*=}
        found=1
      fi
    done <"$file"
  fi
  if ((found)); then
    printf '%s\n' "$val"
  else
    printf '%s\n' "$default"
  fi
}

# work|personal. Project config TIER wins; otherwise by path; unknown -> work.
aibox_tier() {
  local worktree=$1 config=$2 tier
  tier=$(aibox_config_get "$config" TIER "")
  case $tier in
    work | personal)
      printf '%s\n' "$tier"
      return 0
      ;;
  esac
  local home_real
  home_real=$(cd "$HOME" 2>/dev/null && pwd -P) || home_real=$HOME
  case "$worktree/" in
    "$HOME/Developer/personal/"* | "$home_real/Developer/personal/"*) printf 'personal\n' ;;
    *) printf 'work\n' ;;
  esac
}

# Lowercase hostname, at least two labels, last label starts with a letter
# (so no bare IPs), no wildcards, ports, paths or whitespace, <=253 chars.
aibox_validate_domain() {
  local d=$1
  ((${#d} > 0 && ${#d} <= 253)) || return 1
  [[ $d =~ ^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]([a-z0-9-]{0,61}[a-z0-9])?$ ]]
}

# Merged allowlist for a session: base + tier + project + session file.
# Comments (#...) and blanks dropped, invalid entries skipped, sorted unique.
aibox_merge_allow() {
  local tier=$1 slug=$2 session=$3 file line d
  for file in \
    "$AIBOX_HOME/allow/base.txt" \
    "$AIBOX_HOME/allow/$tier.txt" \
    "$AIBOX_HOME/projects/$slug/allow.txt" \
    "$session"; do
    [[ -r $file ]] || continue
    while IFS= read -r line || [[ -n $line ]]; do
      line=${line%%#*}
      read -r d _ <<<"$line" || true
      [[ -n ${d:-} ]] || continue
      aibox_validate_domain "$d" && printf '%s\n' "$d"
    done <"$file"
  done | sort -u
}

# Absolute, symlink-resolved git common dir of a path, or failure.
_aibox_common_dir() {
  local d
  d=$(git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 1
  (cd "$d" && pwd -P)
}

# Refuse to sandbox any worktree of the repo holding the policy itself:
# the agent would get write access to its own allowlists.
aibox_refuse_policy_repo() {
  local worktree=$1 policy wt
  policy=$(_aibox_common_dir "$AIBOX_HOME") || return 0
  wt=$(_aibox_common_dir "$worktree") || return 0
  if [[ $policy == "$wt" ]]; then
    printf 'aibox: refusing to run in the policy repo (%s)\n' "$worktree" >&2
    return 1
  fi
  # Any other clone of the same repo: its files reach the host via
  # push/pull + chezmoi apply, so the agent stays out of it entirely.
  local policy_remote wt_remote
  policy_remote=$(git -C "$AIBOX_HOME" remote get-url origin 2>/dev/null) || return 0
  wt_remote=$(git -C "$worktree" remote get-url origin 2>/dev/null) || return 0
  if [[ $(aibox_slug "$policy_remote") == "$(aibox_slug "$wt_remote")" ]]; then
    printf 'aibox: refusing to run in a clone of the policy repo (%s)\n' "$worktree" >&2
    return 1
  fi
}

# Project id for a worktree: slug of its origin remote, or local__<repo dir>
# for the ~/Developer/<group>/<repo>/<worktree> layout when there is none.
aibox_project_slug() {
  local worktree=$1 remote common
  if remote=$(git -C "$worktree" remote get-url origin 2>/dev/null); then
    aibox_slug "$remote"
    return
  fi
  common=$(_aibox_common_dir "$worktree") || return 1
  printf 'local__%s\n' "$(basename "$(dirname "$(dirname "$common")")")"
}
