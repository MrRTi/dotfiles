---
description: Review current changes using the reviewer agent
allowed-tools: Bash, Read, Grep, Glob, Agent
---

Run a code review on the current diff.

1. Check if there are staged changes: `git diff --staged --quiet`
2. If staged changes exist, review those. Otherwise review unstaged changes.
3. Use the `reviewer` agent to perform the review.
4. If only one language is present, prefer the specialist reviewer (e.g. `reviewer-shell` for shell-only changes).
