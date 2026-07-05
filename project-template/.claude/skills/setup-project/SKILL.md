---
name: setup-project
description: Interactively sets up this project - captures the app idea and the user's coding experience level, asks product-context questions, then configures stack/commands/permissions/deploy target at a depth matched to that experience level. Use when starting a new project from the template, or whenever asked to set up or configure the project.
allowed-tools: AskUserQuestion, Read, Edit, Write, Glob, Grep, Bash
---

# Project setup wizard

Tailor this generic template to the specific project in the current directory,
calibrated to how much this person already knows. Ask one round of questions at
a time via AskUserQuestion - never dump everything at once.

## Step 1: Resolve the experience level (always, before anything else)

Check for `~/.claude/dev-profile.json`.

**If it exists** with an `expertiseLevel` value, ask one lightweight
confirmation instead of the full question:
"Last time you described your coding background as <level, in plain words>.
Still sound right?"
- "Yes, use that" -> use the stored level, go to Step 2.
- "No, let me pick again" -> ask the full question below, then overwrite the
  file with the new answer.

**If it doesn't exist yet** (first run ever), ask:
"How would you describe your coding background?"
- "I don't code" -> `beginner`
- "I've dabbled a little" -> `some-experience`
- "I've been building for a year or two" -> `intermediate`
- "I'm an experienced developer" -> `senior`

Write the result to `~/.claude/dev-profile.json`, e.g. `{"expertiseLevel": "beginner"}`.

This level governs the wording and depth of everything below - it changes HOW
questions get asked, not whether the underlying decisions get made.

## Step 2: Decide which path this run takes

Check whether this is a fresh template or an already-started codebase:
- Source files beyond the template skeleton (anything besides `CLAUDE.md`,
  `.claude/`, `.gitignore`, `.mcp.json`)?
- Does `CLAUDE.md`'s `Stack`/`Commands` sections already have real content
  (e.g. from `/init`), not placeholder comments?

Yes to either -> **existing code**, go to Step 3B.
No to both -> **fresh project**, go to Step 3A.

## Step 3A: Fresh project - idea first, then technical questions

**A1. Describe the idea.** Open text, not multiple choice: "Tell me what
you're trying to build - a sentence or two is plenty." If `$ARGUMENTS` was
provided when this was invoked, treat it as this description and skip asking.

**A2. Product-context questions - ask at every experience level.** Product
understanding matters regardless of technical skill, so don't skip this for
`senior` - just keep it terser for them and warmer for `beginner`. Only ask
what the description didn't already cover:
- Who's actually going to use this - just you, or other people too?
- What's the one core thing someone does when they open it?
- Does it need to remember anything between visits (saved data), or is each
  visit a blank slate?
- Anything you already know you want, beyond the core idea?

**A3. Technical questions - depth and framing scale with the experience level:**

- **`beginner`:** Don't present raw technical menus (framework names, deploy
  platforms) - there's no basis to evaluate them yet. Pick a sensible default
  yourself from the description and A2 answers, state it as a recommendation
  in outcome language, and ask a simple confirm/change question. Example:
  "I'd build this with [X] and put it on Vercel once it's ready - free, and
  gives you a link to share without managing a server. Sound good, or want to
  hear other options?" Skip the permission-mode question entirely - keep the
  template's `acceptEdits` default and just mention in passing that you'll
  check before anything unusual.
- **`some-experience`:** Present 2-3 curated options with short, jargon-light
  pros/cons instead of the full universe of choices. Ask permission mode as a
  simple binary: "Should I make routine changes automatically, or check with
  you each time?"
- **`intermediate`:** A standard technical setup conversation - real command
  names, standard permission-mode options - but offer a one-line gloss on
  less-common terms (e.g. what an MCP server is) if one comes up.
- **`senior`:** Terse, full control, minimal explanation. Skip a question
  entirely if the description already answered it (e.g. "targeting AWS"
  mentioned up front).

## Step 3B: Existing code - confirm, don't interview

Skip A1 and A2 entirely - the product already exists in some form, so don't
ask what it is. Detect what you can (stack, package manager, existing
commands), present it, and ask one confirm-or-correct question. Still scale
the wording by experience level (e.g. don't tell a `beginner` "no lockfile, no
lint config" without a one-line translation of why that matters), but the
question itself stays a single confirm, not an interview.

## Step 4: Apply the answers

- Fill in `CLAUDE.md`'s `Stack` and `Commands` sections directly with real
  values - remove the placeholder comments in those sections once filled.
- Add the actual test/build/lint commands to `.claude/settings.json` under
  `permissions.allow`, using the correct `Bash(<command>:*)` pattern (e.g.
  `Bash(npm test:*)`, `Bash(pytest:*)`).
- If a different permission mode was requested, update `defaultMode`.
- Leave `Project-specific conventions` and `Do not touch` in `CLAUDE.md`
  alone - those need human judgment, not inference.

## Step 5: Propose plugins, skills, and MCP servers - scaled by level too

Based on the confirmed stack, suggest 2-4 relevant pre-built skills/plugins or
a matching MCP server (e.g. Vercel, if that's the deploy target). Wait for
approval before installing anything, at every level - but translate the
pitch itself:
- `beginner` / `some-experience`: describe the benefit in outcome terms
  ("connect this to GitHub so your changes sync automatically") rather than
  naming the mechanism ("enable the GitHub MCP server").
- `intermediate` / `senior`: name things directly, as today.

## Step 6: Summarize

End with a short summary: what got configured automatically, what still needs
manual input, and what (if anything) was installed. Do not run `git push`,
`gh pr create`, or install any plugin/MCP server without an explicit yes on
that specific item.
