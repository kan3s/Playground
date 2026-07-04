---
description: Fix a GitHub issue by number, from investigation to a ready-to-review pull request.
---

Issue number: $ARGUMENTS

1. Run `gh issue view $ARGUMENTS` to read the issue in full.
2. Reproduce or locate the bug in the codebase before writing any fix.
3. Propose a fix. If it touches more than one file or the cause isn't obvious,
   use Plan Mode and wait for my approval before editing.
4. Implement the fix.
5. Delegate to the test-writer subagent to add or update a test that would
   have caught this bug.
6. Run the project's test command and confirm it passes.
7. Use the /pr command to open a pull request, including "Closes #$ARGUMENTS"
   in the body so GitHub links and auto-closes the issue on merge.
