---
name: setup-project
description: Interactively sets up this project - captures the app idea and the user's coding experience level, asks product-context questions, configures stack/commands/permissions/deploy target (and a UI library, for frontend projects) at a depth matched to that experience, and writes standing CLAUDE.md instructions for communication style, decision-making autonomy, and a domain-appropriate primary approach. Use when starting a new project from the template, or whenever asked to set up or configure the project.
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

**If the confirmed stack renders UI in a browser** (a JS/web framework, not a
pure API/CLI/backend), also propose a UI library or component system
appropriate to that framework. Check `~/.claude/CLAUDE.md` for a "UI library
preferences" section first - if something there fits the confirmed framework,
lead with those rather than suggesting something generic; note that a source
in that list might be a component library, a Claude Code skill, or an MCP
server, and each gets set up differently (skills/MCP need actual installation
before Step 5's proposal step; component sources just get referenced by
`frontend-dev` directly). If nothing in the list fits (wrong framework, or no
preferences saved yet), fall back to a fresh suggestion - e.g. shadcn/ui +
Tailwind for a React-based stack, or an equivalent fit for whatever framework
was confirmed. Scale exactly like the rest of A3: `beginner` gets one clear
recommendation in outcome language ("this gives you polished-looking buttons
and forms without designing them from scratch"); `some-experience` gets 2-3
curated options; `intermediate`/`senior` gets it named directly, or skipped if
the description already implied a preference. Skip entirely if the project
has no UI.

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

If a UI library was chosen in A3, propose a `frontend-dev` persona scoped
specifically to it. Unlike `Primary approach` (which shapes the main agent's
everyday attention across *all* work), this is a delegate invoked
specifically to build or review components, with working knowledge of the
chosen library's actual conventions: match existing component patterns
already in the codebase before creating new ones, follow that library's own
composition/theming idioms rather than generic advice, and work alongside
`a11y-conventions` rather than duplicating it. How it actually reaches the
library depends on what kind of source it is - pull component code directly
for a source like Magic UI or React Bits, call its search tooling for a
skill-based source like UI UX Pro Max, or use its MCP tools for something
like 21st.dev - state which in the generated instructions rather than leaving
it vague. Give it `Read, Write, Edit, Glob, Grep` - unlike the read-only
reviewers, it needs to actually create files.

**Plugins, skills-with-their-own-installer, and MCP servers** - suggest 2-4
relevant pre-built options (e.g. a UI-focused skill from `CLAUDE.md`'s "UI
library preferences" list, or a matching MCP server like Vercel if that's the
deploy target). Unlike the project-specific skills/personas above, these are
things Claude doesn't author itself, so "write the file after approval"
doesn't apply here - the actual mechanism depends on what's being proposed,
and getting this wrong means claiming something is installed when it isn't:

- **A normal CLI installer** (e.g. a tool with its own `npx <package> init`,
  the way UI UX Pro Max works): this is an ordinary command, runnable via
  Bash like any other setup step. Run it after approval, then verify the
  files it claims to create actually exist before reporting success.
- **Claude Code's own plugin mechanism** (`/plugin marketplace add`, then
  `/plugin install` - the path Impeccable specifically documents): this is
  reported as an interactive, pick-from-a-list flow, not a plain scriptable
  command, and it's genuinely unclear whether that can be driven
  autonomously mid-session. State the exact commands needed, attempt them,
  and explicitly say so if it turns out this needs to be run by hand instead
  - never report this as done without having actually confirmed it.
- **An MCP server** (e.g. 21st.dev): write the `.mcp.json` entry - that part
  is a normal file write, no ambiguity - but say plainly that confirming the
  connection needs a fresh terminal and `/mcp`, the same as the GitHub MCP
  setup earlier in this project.
- **A component source with no installer at all** (Magic UI, React Bits):
  there's nothing to install now - just note that `frontend-dev` will pull
  from it directly when it actually builds something.

List every proposal from this step together, each with a one-line reason and
which of the above mechanisms it needs, and wait for me to say which ones (if
any) to actually create or install before doing anything. Translate the pitch
by experience level:
- `beginner` / `some-experience`: describe the benefit in outcome terms
  ("connect this to GitHub so your changes sync automatically") rather than
  naming the mechanism ("enable the GitHub MCP server").
- `intermediate` / `senior`: name things directly, as today.

## Step 6: Summarize

End with a short summary: what got configured automatically, what still needs
manual input, and what (if anything) was installed. Do not run `git push`,
`gh pr create`, or install any plugin/MCP server without an explicit yes on
that specific item.
