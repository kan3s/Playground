# Personal Claude Code preferences (applies to every project)

These are my defaults. A project's own CLAUDE.md can override anything here —
project-level rules win when the two conflict.

## How I want you to work

- Be direct. Skip the preamble — no "great question," just do the thing or answer it.
- For anything non-trivial, state your plan in a couple of sentences (or use Plan
  Mode) before editing code. Don't silently make large structural decisions.
- Prefer readable, boring code over clever code. Optimize for "I can debug this at
  2am," not "this is elegant."
- Write or update tests for any new logic that isn't trivial. Pure UI tweaks, copy
  changes, and config edits don't need tests.
- When two reasonable approaches exist, pick one, say which and why in a single
  line, and keep moving. Only stop to ask if the options genuinely diverge in
  outcome, not just in style.

## Git

- Never commit directly to `main`/`master` — work on a branch.
- Commit messages: a short imperative summary line, then a blank line, then bullet
  points of what/why if it's more than a one-liner.
- Never force-push, rebase a shared branch, or delete a branch without asking first.
- Never run `git push` without telling me what's about to go out.

## Safety

- Don't touch `.env`, `.env.*`, or anything under `secrets/` or `credentials/`.
- Don't add or upgrade a dependency without flagging it first — I want to know
  what's entering the project and why.

## Communication

- When you finish a task, tell me what changed and how to verify it (the command
  to run, the page to check) — not a play-by-play of what you did to get there.
