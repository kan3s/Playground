# Personal Claude Code Setup

This repo *is* `~/.claude`. There's no separate config folder and no symlinks —
clone this repo to `~/.claude` (or run `install.ps1`, which does that for you),
and Claude Code reads its config directly from here. Editing a file in this
repo and editing the "real" config are the same action, because they're the
same file.

## Structure

```
~/.claude/                    (this repo)
├── install.ps1                One-time setup: prerequisites + wiring
├── CLAUDE.md                  Personal rules, apply to every project
├── settings.json              Default permission mode + allow/deny rules
├── agents/code-reviewer.md    Personal subagent, available everywhere
├── commands/pr.md             Personal /pr command, available everywhere
│
├── project-template/           Cloned into every NEW project (not read by
│   │                           Claude Code directly from here)
│   ├── CLAUDE.md               Stack-agnostic skeleton, /init fills it in
│   ├── .mcp.json                GitHub MCP, token via env var
│   └── .claude/
│       ├── settings.json        Self-contained project defaults
│       ├── agents/               test-writer, security-reviewer
│       ├── commands/             /new-feature, /fix-issue
│       └── skills/
│           ├── a11y-conventions/   Example project skill
│           └── setup-project/      Interactive wizard (AskUserQuestion)
│
└── scripts/
    └── new-project.ps1         Scaffolds a new project, then opens `claude`
```

`project-template/` and `scripts/` aren't Claude Code config — Claude Code
only looks at `CLAUDE.md`, `settings.json`, `agents/`, `commands/`, and
`skills/` directly under `~/.claude/`. They just live in this same repo for
convenience, since it's all "my personal Claude Code setup" either way.

## One-time setup

**On a machine that's never touched Claude Code:**
```powershell
git clone https://github.com/<you>/claude-config $HOME\.claude
cd $HOME\.claude
.\install.ps1
```

**On a machine that already has `~/.claude` (Claude Code has been run before,
or you're migrating from an older symlink-based version of this setup):**
```powershell
git clone https://github.com/<you>/claude-config $HOME\dev\claude-config-setup
cd $HOME\dev\claude-config-setup
.\install.ps1
```
`install.ps1` detects the existing `~/.claude`, removes any old symlinks,
copies this repo's files in (preserving Claude Code's own internal state),
and turns `~/.claude` itself into the git repo going forward.

Either way, `install.ps1` also installs Git/GitHub CLI/Claude Code if any are
missing, and adds a `newproj` shortcut to your PowerShell profile. Safe to
re-run — every step checks whether it's already done first.

## Day to day

```powershell
newproj my-cool-app
```
Scaffolds the project, runs `git init`, and drops you into a live Claude Code
session. Type `/setup-project` to answer a few questions (stack, commands,
permissions, deploy target) and have Claude fill in the rest. From there:
`/new-feature "..."` for new work, `/fix-issue 123` for bugs, `/pr` to open
a pull request.

## Why this structure

Earlier versions of this setup kept `~/.claude` and the source repo separate,
connected by symlinks, which needed Developer Mode enabled and was the most
fragile part of the whole system. Making `~/.claude` the repo directly
removes that failure mode entirely — one location, no links to break, still
fully versioned and portable to a new machine via `git clone`.
