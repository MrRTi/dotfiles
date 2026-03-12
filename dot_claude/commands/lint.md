---
description: Run linters on changed files (shellcheck, yamllint)
allowed-tools: Bash, Glob, Read
---

Lint all changed files using the appropriate linters.

1. Get the list of changed files:
   ```bash
   git diff --name-only HEAD
   ```
2. For each changed file, run the matching linter:
   - `.sh`, `dot_bashrc`, `executable_*`, `run_*` → `shellcheck --shell=bash <file>`
   - `.yaml`, `.yml` → `yamllint <file>` (if available, otherwise skip)
   - `.lua` → `luacheck <file>` (if available, otherwise skip)
   - `.py` → `ruff check <file>` (if available, otherwise skip)
3. Report all findings grouped by file.
4. If no linter issues found, say so clearly.
