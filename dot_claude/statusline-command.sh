#!/usr/bin/env bash
# Claude Code status line — mirrors fish_prompt style
# Input: JSON via stdin

input=$(cat)


cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_5h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rate_7d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Shorten path: replace $HOME with ~, keep last 2 segments
home="$HOME"
short_path="${cwd/#$home/\~}"
# Keep only last 2 path components (mirrors prompt_pwd --full-length-dirs 1)
short_path=$(echo "$short_path" | awk -F'/' '{
    n=NF
    if (n <= 2) { print $0 }
    else { print "…/" $(n-1) "/" $n }
}')

# Git branch (skip optional lock to avoid blocking)
git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)

# ANSI colors
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Build output
output=""

# Directory in blue
output+=$(printf "${BLUE}%s${RESET}" "$short_path")

# Git branch in yellow
if [ -n "$git_branch" ]; then
    output+=$(printf " ${YELLOW}(%s)${RESET}" "$git_branch")
fi

# Model name
if [ -n "$model" ]; then
    output+=$(printf " | %s" "$model")
fi

# Context window — percentage only
if [ -n "$used_pct" ]; then
    output+=$(printf " | ctx: %.0f%%" "$used_pct")
fi

# Format unix timestamp as human-readable "Xh Ym" or "Xd Yh"
format_reset() {
    local ts=$1
    local now
    now=$(date +%s)
    local diff=$(( ts - now ))
    if [ "$diff" -le 0 ]; then
        echo "now"
    elif [ "$diff" -lt 3600 ]; then
        echo "$(( diff / 60 ))m"
    elif [ "$diff" -lt 86400 ]; then
        echo "$(( diff / 3600 ))h $(( (diff % 3600) / 60 ))m"
    else
        echo "$(( diff / 86400 ))d $(( (diff % 86400) / 3600 ))h"
    fi
}

# 5-hour usage limit
if [ -n "$rate_5h" ]; then
    pct=$(printf "%.0f" "$rate_5h")
    if [ -n "$rate_5h_resets" ]; then
        reset_str=$(format_reset "$rate_5h_resets")
        output+=$(printf " | 5h: %d%% (↺%s)" "$pct" "$reset_str")
    else
        output+=$(printf " | 5h: %d%%" "$pct")
    fi
fi

# 7-day usage limit
if [ -n "$rate_7d" ]; then
    pct=$(printf "%.0f" "$rate_7d")
    if [ -n "$rate_7d_resets" ]; then
        reset_str=$(format_reset "$rate_7d_resets")
        output+=$(printf " | 7d: %d%% (↺%s)" "$pct" "$reset_str")
    else
        output+=$(printf " | 7d: %d%%" "$pct")
    fi
fi

printf "%b\n" "$output"
