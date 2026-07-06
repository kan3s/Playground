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
8. Quick capture check: did this bug reveal an edge case, a gotcha, or a
   convention worth remembering (e.g. "this endpoint needs X validation
   because of Y")? Only speak up if something genuinely reusable surfaced. If
   so, propose ONE specific update with a one-line reason, and wait for a yes.
   Otherwise skip silently. As with `/new-feature`, hold `CLAUDE.md`'s
   `Primary approach` section to a much higher bar than a new skill or
   persona - a single bug fix is rarely enough evidence that the project's
   fundamental nature has changed; leave sustained-shift detection to
   `/reflect`.
