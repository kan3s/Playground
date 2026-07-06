---
description: Scaffold a new feature end-to-end - plan, implement, test, and summarize for review.
---

Feature requested: $ARGUMENTS

1. If no description was given above, ask me for one before doing anything else.
2. Enter Plan Mode: research the relevant parts of the codebase, propose an
   approach, and list the files you expect to touch. Wait for my approval
   before writing any code.
3. Once approved, implement the change.
4. Delegate to the test-writer subagent to add or update tests for the new logic.
5. Run the project's test command (from CLAUDE.md) and confirm it passes.
6. Summarize what changed and exactly how I should verify it manually.
7. Quick capture check: did building this reveal a convention, a new external
   service or dependency, or a domain rule worth remembering next time -
   something you had to work out or explain that isn't already in CLAUDE.md or
   an existing skill/persona? Only speak up if something genuinely new
   surfaced; most features won't need this. If something did, propose ONE
   specific update (a new skill, a new persona, or an addition to an existing
   one) with a one-line reason, and wait for a yes before creating or editing
   anything. Otherwise skip this step silently - don't manufacture a proposal
   just to have one. Hold `CLAUDE.md`'s `Primary approach` section to a much
   higher bar than a new skill or persona: propose changing it only if this
   one feature obviously reorients what the whole project is, not just
   because this particular feature happened to lean toward a different
   domain. A single feature is rarely enough evidence - a real, sustained
   shift is what `/reflect` is for, not this checkpoint.
