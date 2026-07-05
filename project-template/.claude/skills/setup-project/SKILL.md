---
name: setup-project
description: Interactively tailor this project template to the current project - confirms stack, fills in commands, sets permissions, and proposes relevant plugins/skills/MCP servers. Use when starting a new project from the template, or whenever asked to set up or configure the project.
allowed-tools: AskUserQuestion, Read, Edit, Write, Glob, Grep, Bash
---

# Project setup wizard

Tailor this generic template to the specific project in the current directory.
Ask one round of questions at a time using the AskUserQuestion tool - don't
dump everything at once, and don't ask about anything you can already tell
from the repo itself.

## 0. Look before you ask

Before asking anything, check what's already inferable:
- Look for `package.json`, `requirements.txt`, `pyproject.toml`, `Gemfile`,
  `go.mod`, etc. to guess the language/framework/package manager.
- Check whether `CLAUDE.md`'s `Stack` and `Commands` sections still contain
  placeholder text (an empty line after the heading) or already have real
  content - if `/init` hasn't been run yet, tell me and suggest running it
  first, but continue with this wizard regardless if I want to proceed anyway.

Only ask about what you couldn't determine or need me to confirm.

## 1. Ask (via AskUserQuestion, grouped sensibly across a few calls)

If `$ARGUMENTS` was provided, treat it as a stack hint and confirm it rather
than asking from scratch.

- Stack: language/framework, package manager (skip what you already detected;
  confirm it in one question instead of re-asking)
- Commands: test, build, lint/format - propose what you inferred and let me
  confirm or correct rather than asking blind
- Permissions: keep the template's `acceptEdits` default for this project, or
  something stricter/looser
- Deploy target: Vercel, Netlify, self-hosted, none yet
- GitHub MCP: enable it now (needs `GITHUB_PAT` set), or skip for now

## 2. Apply the answers

- Fill in `CLAUDE.md`'s `Stack` and `Commands` sections directly with real
  values - remove the placeholder comments in those sections once filled.
- Add the actual test/build/lint commands to `.claude/settings.json` under
  `permissions.allow`, using the correct `Bash(<command>:*)` pattern for the
  tool in question (e.g. `Bash(npm test:*)`, `Bash(pytest:*)`).
- If a different permission mode was requested, update `defaultMode`.
- Leave `Project-specific conventions` and `Do not touch` in `CLAUDE.md`
  alone - those need my judgment, not inference, and shouldn't be guessed at.

## 3. Propose plugins, skills, and MCP servers - don't install anything yet

Based on the confirmed stack:
- Suggest 2-4 relevant pre-built skills or plugins (for example, a testing/
  browser-automation skill for a frontend-heavy stack, or a database skill if
  one was mentioned). If the `anthropics/skills` marketplace isn't added yet,
  note that `/plugin marketplace add anthropics/skills` would be needed first.
- If a deploy target was named and a matching MCP server exists (e.g. Vercel),
  propose adding it to `.mcp.json`.
- List each proposal with a one-line reason. Wait for me to say which ones to
  install before running anything.
- Only after I approve specific items: run the corresponding `/plugin install`
  command(s) or add the MCP server entry.

## 4. Summarize

End with a short summary: what got configured automatically, what still needs
my manual input, and what (if anything) was installed. Do not run
`git push`, `gh pr create`, or install any plugin/MCP server without an
explicit yes from me on that specific item.
