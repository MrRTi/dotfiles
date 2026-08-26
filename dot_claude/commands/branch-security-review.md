---
description: Security review of the current branch against its detected upstream base
allowed-tools: Bash, Agent
---

1. Get the full pending-changes diff: run `git_security_diff` (deployed to `~/.local/bin/git_security_diff` — handles upstream/remote detection, merge-base safety, and working-tree/untracked coverage). If the command isn't found, report that `chezmoi apply` needs to run first and stop. If every section it prints reports as skipped/none, say so and stop.
2. Pass the diff output directly to the `reviewer-security` agent in the prompt — do not let it re-fetch its own diff (it defaults to `git diff HEAD` internally, which only covers the working-tree section, not the full branch picture this script provides).
3. Report findings as CRITICAL/HIGH/MEDIUM/LOW with file/line, same format as `reviewer-security`'s own output. Note explicitly any section the script reported as skipped, so it's clear what wasn't covered.
