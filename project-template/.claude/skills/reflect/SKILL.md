---
name: reflect
description: Reviews recent work (commits and changes since the last reflection) and proposes updates to CLAUDE.md, skills, and personas based on patterns that emerged. Never writes anything without approval on that specific item. Use periodically, or whenever asked to review or capture what's been learned.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, AskUserQuestion
---

# Reflect: capture what's been learned

Look back over recent work and propose updates to this project's instructions -
`CLAUDE.md`, skills, personas - based on patterns that emerged. Never write
anything without an explicit yes on that specific item.

## 1. Gather context

- Check for a checkpoint from the last reflection (see Step 4). If one exists,
  run `git log <last-hash>..HEAD` to see only what's new since then. If none
  exists yet, default to the last 15-20 commits.
- Read the current `CLAUDE.md`, everything under `.claude/skills/`, and
  everything under `.claude/agents/` so you know what's already captured -
  don't propose something that's already covered.

## 2. Look for patterns worth capturing

Focus on things that recurred or would have saved real time if written down
earlier - the bar is "this would help next time," not "this happened once":
- A convention you had to explain, re-derive, or get corrected on more than once
- A new external service, dependency, or integration that isn't documented
  anywhere yet
- A recurring review comment or fix pattern a dedicated persona could catch
  automatically going forward
- Something in `CLAUDE.md`'s `Do not touch` or `Project-specific conventions`
  that's now stale given what's actually in the codebase
- Whether `CLAUDE.md`'s `Primary approach` section (if set) still matches what
  the codebase has actually become - this is the right place to catch that,
  since a real shift shows up as a pattern across several commits, not a
  single one. The per-feature/per-fix checkpoints deliberately hold this
  section to a high bar and mostly leave it alone; look here for whether the
  evidence has actually accumulated enough to justify changing it.
- Skills or personas that have become redundant with each other, or with what
  `Primary approach` now covers. Each one looked reasonable when it was
  proposed on its own - this is the pass that looks at the accumulated set
  and asks whether it still holds together, since nothing else does. More
  isn't automatically better; a cluttered `.claude/skills/` is harder to
  trust than a small, accurate one.

## 3. Propose, don't write

List every candidate together: what it is (new skill / new persona / edit to
an existing one / **merge or retire a redundant one** / edit to `CLAUDE.md`),
a one-line reason grounded in what you actually observed, and a rough preview
of what it would say or change. Use AskUserQuestion so each one can be
approved, rejected, or edited individually - not an all-or-nothing batch. Only
write the ones approved. If nothing cleared the bar in Step 2, say so plainly
rather than manufacturing proposals.

## 4. Mark the checkpoint

After this run - regardless of how many proposals were approved - record the
current commit hash in `.claude/.last-reflection` (create it if it doesn't
exist) so the next `/reflect` only reviews what's new since this pass instead
of re-scanning from the start.
