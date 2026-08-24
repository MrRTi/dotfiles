---
description: Run linters on changed files (shellcheck, yamllint)
allowed-tools: Bash, Glob, Read, Agent
---

Lint all changed files using the appropriate linters.

1. Get the list of changed files: `git diff --name-only HEAD`
2. For shell files (`.sh`, `dot_bashrc`, `executable_*`, `run_*`), use the `shellcheck` agent — read that agent's file for how it invokes shellcheck. Do not duplicate its logic here.
3. For everything else, run the matching linter directly:
   - `.yaml`, `.yml` → `yamllint <file>` (if available, otherwise skip)
   - `.lua` → `luacheck <file>` (if available, otherwise skip)
   - `.py` → `ruff check <file>` (if available, otherwise skip)
4. Report all findings grouped by file.
5. If no linter issues found, say so clearly.
