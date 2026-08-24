---
description: Run formatters on changed files (shfmt, stylua, yamlfmt, black)
allowed-tools: Bash, Agent
---

Format all changed files using the appropriate formatters.

1. Get the list of changed files: `git diff --name-only HEAD`
2. Use the `formatter` agent to format them. Read that agent's file for the full formatter mapping.
3. Report which files were formatted and which formatters were skipped due to not being installed.
