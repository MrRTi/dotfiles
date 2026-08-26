---
description: Run a full security check — diff review plus a vulnerability scan
allowed-tools: Bash, Agent
---

Run a full security check: review what changed, then scan the project for known vulnerabilities.

1. Get the full pending-changes diff: run `git_security_diff` (same script `/branch-security-review` uses — handles committed-branch, working-tree, and untracked coverage together, including untracked file content). If the command isn't found, report that `chezmoi apply` needs to run first and stop. Pass its output directly to the `reviewer-security` agent in the prompt — do not let it re-fetch its own diff. If every section is skipped/none, say so and skip to step 2.
2. Scan the project: run both a filesystem scan and a config scan against the repo root, filtered to HIGH/CRITICAL severity. Use the `trivy` agent — read that agent's file for exact invocation and flags. Do not duplicate its invocation logic here. If `trivy` isn't installed, report that and skip this step.
3. Report both sections separately (Diff Review / Vulnerability Scan) with their own severity counts — don't merge them into one total, since a HIGH from the diff (new, actionable now) and a HIGH from trivy (pre-existing, may not be reachable) aren't the same urgency. Call out anything CRITICAL from the diff review as needing immediate attention.
