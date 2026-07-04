# Using this template for a new project

1. Copy this whole `project-template/` folder into your new project's root, then
   rename/move things so the layout looks like:
   ```
   your-new-project/
   ├── CLAUDE.md
   ├── .claude/
   │   ├── settings.json
   │   └── settings.local.json.example   ← copy to settings.local.json, don't commit it
   └── ... your actual project files
   ```
2. Append the contents of `gitignore.append.txt` to your project's real `.gitignore`,
   then delete `gitignore.append.txt` and rename `settings.local.json.example` to
   `settings.local.json`.
3. Run `claude` in the project root, then run `/init`. It will read your actual code
   and fill in most of the `Commands` and `Structure` sections of `CLAUDE.md` for you.
4. Go back through `CLAUDE.md` by hand:
   - Fix anything `/init` guessed wrong.
   - Fill in `Project-specific conventions` and `Do not touch` yourself — those need
     your judgment, not code inspection.
5. Once your stack is known, add its test/build/lint commands to
   `.claude/settings.json` under `permissions.allow`, e.g. for an npm project:
   ```json
   "Bash(npm test:*)", "Bash(npm run build:*)", "Bash(npm run lint:*)"
   ```
   or for a Python project:
   ```json
   "Bash(pytest:*)", "Bash(ruff check:*)"
   ```
   This is the one step that has to happen per-project, since the template stays
   stack-agnostic on purpose.
6. This template also includes `.mcp.json` (a GitHub MCP connection) and
   `.claude/skills/a11y-conventions/` (an example project skill). To activate
   the GitHub MCP server, generate a fine-grained GitHub personal access token
   scoped to the repos you want Claude to touch, then set it as an environment
   variable (don't hardcode it — `.mcp.json` reads it via `${GITHUB_PAT}` so
   the token itself never gets committed):
   ```powershell
   [Environment]::SetEnvironmentVariable("GITHUB_PAT", "your-token-here", [EnvironmentVariableTarget]::User)
   ```
   Open a new terminal, run `claude`, then `/mcp` to confirm it connects.
7. Add more skills the same way as `a11y-conventions` — a folder under
   `.claude/skills/` with a `SKILL.md` (name + description frontmatter, then
   instructions in Markdown). Claude loads them automatically based on the
   description, so make that field specific.

