---
name: setup-project
description: Interactively sets up this project - captures the app idea and the user's coding experience level, asks product-context questions, configures stack/commands/permissions/deploy target at a depth matched to that experience, and writes standing CLAUDE.md instructions for communication style, decision-making autonomy, and a domain-appropriate primary approach. Use when starting a new project from the template, or whenever asked to set up or configure the project.
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

**A4. Propose a primary approach, based on the idea.** From the description and
A2 answers, infer what this project most calls for beyond generic engineering -
e.g. a UI/interaction-heavy consumer app calls for a designer's eye; a
data-heavy app calls for a data engineer's; an integration-heavy tool calls for
a backend architect's. This is **additive, never a replacement** - frame it as
bringing that lens *in addition to* solid engineering, not becoming that role
instead of an engineer. Correctness and maintainability still come first,
always. Most projects lean on one or two things, not a single rigid label -
say so if a project genuinely calls for more than one (e.g. "UI-heavy AND
handles payment data" warrants both a design eye and a security-first one).

State the proposed lens plainly and let it be confirmed or redirected, phrased
at the resolved experience level like everything else:
- `beginner` example: "Since this is very visual, I'll pay extra attention to
  how it looks and feels to use, not just whether the code works - sound
  right?"
- `senior` example: "This reads as UI-heavy - I'll weight design quality
  accordingly. Say if you'd frame it differently."

If nothing in the idea points toward a particular lens beyond ordinary
engineering, say so and skip this - don't manufacture one for its own sake.

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
- Write (or update) a `## Communication style` section in `CLAUDE.md`,
  translating the resolved experience level into a standing instruction for
  every future session in this project - not just this wizard:
  - `beginner`: "Explain technical terms in plain language the first time
    they come up. Don't assume familiarity with the command line, package
    managers, or dev tools beyond what's already been walked through. Prefer
    describing outcomes over mechanisms. Briefly state the reasoning behind
    non-obvious choices."
  - `some-experience`: "Assume basic familiarity with code and common tools,
    but briefly explain less-common concepts or unfamiliar library/framework
    specifics before using them."
  - `intermediate`: "Standard technical communication - assume familiarity
    with common patterns and tools; flag anything genuinely unusual."
  - `senior`: omit this section entirely, or keep it to one line - default
    communication style is already appropriate, no accommodation needed.
  Mark the section as generated by this wizard (a one-line comment is enough)
  so it's obviously editable by hand later, not mistaken for something sacred.
- Write an `## Autonomy level` section in `CLAUDE.md`, governing which
  in-session decisions get asked about versus just handled and reported -
  this is separate from `permissions.allow`/`defaultMode`, which govern tool
  access, not whether a question gets asked:
  - `beginner`: "Decide and proceed without asking on routine,
    easily-reversible technical decisions - exact command or library choice,
    internal code structure, minor formatting. There's no basis to evaluate
    these, so asking only adds friction without adding real control. When a
    subagent or review surfaces a well-understood, low-risk fix, apply it and
    report what changed rather than asking first. Still surface anything with
    a real, evaluable consequence (cost, speed, what data is collected or
    shown, whether something becomes public) - translated into outcome
    language, not mechanism, same as the setup questions."
  - `some-experience`: "Same principle, lighter touch on translation - some
    technical language is fine, but still resolve routine decisions silently
    and surface consequential ones plainly."
  - `intermediate` / `senior`: omit this section, or keep to one line -
    default behavior (ask before non-trivial technical decisions, standard
    technical language) is already appropriate.
  Regardless of tier, always end this section with the same fixed exceptions,
  worded plainly: "Always confirm before opening a real pull request,
  publishing or deploying anything, spending money, deleting data, or editing
  CLAUDE.md/a skill/a persona - these stay explicit confirmations at every
  experience level, no matter what the rest of this section says."
- If A4 produced a confirmed lens, write it as a `## Primary approach` section
  in `CLAUDE.md`, in plain instructive language (this section is read by
  Claude, not shown to the user, so write for clarity of instruction, not for
  the user's reading level). State it as additive to engineering judgment, not
  a replacement - e.g. "This project is UI/interaction-heavy. Bring a UI/UX
  designer's eye to it - visual hierarchy, spacing, interaction feedback,
  loading/empty/error states, accessibility - in addition to, never instead
  of, solid engineering. Correctness and maintainability still come first."
  Skip this section on the Path 3B (existing-code) run or if A4 found nothing
  to propose.

## Step 5: Propose additional capabilities - scaled by level, always approved individually

Based on the confirmed stack and, on the fresh-project path, the idea/product
answers from Step 3A (there's no idea context on the 3B/existing-code path, so
skip the skills/personas part of this step there and only do the plugins/MCP
part):

**Project-specific skills.** If the idea implies domain conventions worth
capturing (payments, real-time features, a data-sensitive domain, etc.),
propose 0-2 new skills under `.claude/skills/<name>/`. First check
`.claude/skills/` for anything that already covers similar ground - every
project already ships with `a11y-conventions`, so don't propose a redundant
accessibility skill, for example. Show a one-line description of what each
proposed skill would contain - only write the full file after approval.

**Project-specific personas.** Same idea, for `.claude/agents/`. If the domain
implies a reviewer role beyond the generic `code-reviewer` / `test-writer` /
`security-reviewer` every project already has (e.g. a `payments-reviewer` for
anything involving charges, an `api-contract-reviewer` for a public API),
propose 0-2 candidates. Check for overlap first - if `security-reviewer`
already covers the concern, propose extending its instructions instead of
creating a near-duplicate persona. Also check against whatever `CLAUDE.md`'s
`Primary approach` section already covers (from A4, if set) - the main agent
already brings that lens to everyday work, so only propose a dedicated persona
here if it offers something genuinely distinct, like a deeper periodic audit
rather than everyday attention (e.g. `a11y-conventions` plus the main agent's
own design lens may already be enough; a separate persona only earns its place
if it does more than restate the same concern).

**Plugins and MCP servers** - suggest 2-4 relevant pre-built skills/plugins or
a matching MCP server (e.g. Vercel, if that's the deploy target). If the
`anthropics/skills` marketplace isn't added yet, note that
`/plugin marketplace add anthropics/skills` would be needed first.

List every proposal from this step together, each with a one-line reason, and
wait for me to say which ones (if any) to actually create or install before
doing anything. Translate the pitch by experience level:
- `beginner` / `some-experience`: describe the benefit in outcome terms
  ("connect this to GitHub so your changes sync automatically") rather than
  naming the mechanism ("enable the GitHub MCP server").
- `intermediate` / `senior`: name things directly, as today.

## Step 6: Summarize

End with a short summary: what got configured automatically, what still needs
manual input, and what (if anything) was installed. Do not run `git push`,
`gh pr create`, or install any plugin/MCP server without an explicit yes on
that specific item.
