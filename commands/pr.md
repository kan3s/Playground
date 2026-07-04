---
description: Open a pull request for the current branch via gh CLI, with a standard summary/testing template.
---

1. Confirm the current branch isn't `main`/`master`. If it is, stop and tell me —
   don't proceed.
2. Run `git diff main...HEAD` (or the correct base branch) to see the full set of
   changes going into this PR.
3. Draft a PR with this structure:
   - **Summary** — 2-4 sentences on what changed and why
   - **Changes** — bullet list of the concrete changes
   - **Testing** — how you verified it, and how I should verify it
4. Show me the drafted title and body and wait for my go-ahead before running
   anything.
5. Once I approve, run `gh pr create --title "..." --body "..."`.
