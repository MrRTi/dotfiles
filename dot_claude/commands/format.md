---
description: Run formatters on changed files (shfmt, stylua, yamlfmt, black)
allowed-tools: Bash, Glob
---

Format all changed files using the appropriate formatters.

1. Get the list of changed files:
   ```bash
   git diff --name-only HEAD
   ```
2. For each changed file, run the matching formatter:
   - `.sh`, `dot_bashrc`, `executable_*`, `run_*` → `shfmt -w -i 2 -ci <file>`
   - `.lua` → `stylua <file>`
   - `.py` → `black <file> && isort <file>`
   - `.yaml`, `.yml` → `yamlfmt <file>`
   - `.json` → `jq '.' <file> > <file>.tmp && mv <file>.tmp <file>`
3. Skip any formatter that is not installed (check with `command -v` first).
4. Report which files were formatted and which formatters were skipped due to not being installed.
