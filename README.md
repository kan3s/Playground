# Personal Claude Code Starter Kit

A reusable setup so every new web app project starts with the same guardrails,
shortcuts, and conventions instead of being configured from scratch.

## How to install this

**Global layer — do this once, on your machine:**

| File in this kit | Goes to |
|---|---|
| `global/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `global/settings.json` | `~/.claude/settings.json` (merge by hand if you already have one) |
| `global/agents/*.md` | `~/.claude/agents/` |
| `global/commands/*.md` | `~/.claude/commands/` |

**Per-project layer — do this for every new project (once that stage exists below):**

Copy `project-template/` into a new repo's root, fill in the placeholders for that
project's stack, then run `/init` inside Claude Code so it fills in anything the
template couldn't know in advance.

## Status

- [x] **Global layer** — personal `CLAUDE.md`, `settings.json` (acceptEdits by default),
      a `code-reviewer` subagent, a `/pr` command
- [x] **Project template** — `CLAUDE.md` skeleton, `.claude/settings.json`,
      `.gitignore` additions, and a per-project `README.md` walking through setup
- [x] **Project subagents** — `test-writer` (writes tests, infers the framework
      in use), `security-reviewer` (read-only, auth/input/data-handling focus)
- [x] **Project commands** — `/new-feature` (plan → implement → test → summarize),
      `/fix-issue` (issue → fix → test → PR, composes with `/pr` and `test-writer`)
- [x] **GitHub MCP + example skill** — `.mcp.json` (GitHub, token via env var,
      never committed), `.claude/skills/a11y-conventions/` (example project skill)

Kit complete. Everything above is ready to copy into `~/.claude/` (global) and
into every new project (`project-template/`).

## Added after initial completion

- [x] **`setup-project` skill** — an interactive wizard (`.claude/skills/setup-project/`)
      that asks a few grouped questions via Claude Code's built-in AskUserQuestion
      tool, then fills in `CLAUDE.md`'s Commands section and
      `.claude/settings.json`'s allow list automatically. It also proposes
      relevant plugins/skills/MCP servers for the confirmed stack, but never
      installs anything without an explicit yes on that specific item.
- [x] **`scripts/new-project.ps1`** — pre-Claude scaffolding. Copies the
      template into a new folder, builds `.gitignore`, runs `git init`, then
      drops you straight into a `claude` session so `/setup-project` can take
      over. The two capabilities chain together: one command takes you from
      nothing to answering setup questions in Claude Code.

## Your setup, for reference

- Tech stack: varies per project → the project template stays stack-agnostic with
  placeholders rather than hardcoding one framework's commands.
- Default autonomy: `acceptEdits` (file edits auto-approved, commands still ask).
- Version control: GitHub → commands and hooks below assume `gh` CLI is installed
  and authenticated (`gh auth login` if you haven't already).
