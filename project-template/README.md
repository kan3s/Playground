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
