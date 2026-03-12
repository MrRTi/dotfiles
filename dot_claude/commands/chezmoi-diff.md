---
description: Preview what chezmoi would change on apply
allowed-tools: Bash
---

Run `chezmoi diff` and summarize what would change when applied.

1. Run:
   ```bash
   chezmoi diff
   ```
2. Group changes by target file.
3. For each file, briefly describe what changed (added lines, removed lines, permission changes).
4. If no changes, say "chezmoi is up to date — nothing to apply".
