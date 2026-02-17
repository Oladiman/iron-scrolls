# Iron Scrolls — Claude Code Instructions

These rules apply to every Claude Code session opened in this repository.

---

## Standing rule: keep README and docs in sync

**Every time a change is pushed to this repo, you must update both:**

1. **`README.md`** (root) — the GitHub-facing project README
2. **`site/src/content/docs/`** — the Starlight documentation site

Specifically:

### When a new command is added (`commands/*.md`)

- Add a full section to `README.md` with:
  - Command name as an `###` heading
  - One-line description
  - Phase table (| Phase | Action |)
  - Usage code block (`/command-name` and `/command-name audit only` if applicable)
  - Link to the full docs page
- Update `README.md` project structure tree to include the new file
- Create `site/src/content/docs/commands/<command-name>.mdx` with:
  - Frontmatter: `title`, `description`
  - Badges for framework support and report generation
  - Usage block
  - Full phases table
  - Reports tabs (developer + owner)
  - What gets fixed automatically
  - What is flagged but not auto-fixed (if applicable)
  - Framework support table
  - Install snippet + link to raw source
- Add the new command to the `sidebar` in `site/astro.config.mjs`
- Add a new `<Card>` to the `<CardGrid>` in `site/src/content/docs/index.mdx`
- Update the `~/.claude/commands/` tree in `site/src/content/docs/install.mdx`
- Update the manual `curl` install block in `site/src/content/docs/install.mdx`
- Run `npm run build` inside `site/` — must pass before committing

### When an existing command is updated (`commands/*.md`)

- Check whether the changes affect the phase table, framework support, or fix list in:
  - `README.md` (the section for that command)
  - `site/src/content/docs/commands/<command-name>.mdx`
- Update both if the behaviour description changed

### When the install script changes (`install.sh`)

- Review the install steps in `site/src/content/docs/install.mdx` for accuracy

---

## Commit conventions

- `feat: add /command-name command` — new command + docs
- `docs: update README and site for /command-name` — docs-only update
- `fix: ...` — bug fix in a command prompt
- `chore: ...` — repo maintenance

Always add `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>` to commit messages.

---

## Build check before every push

```bash
cd site && npm run build
```

Must complete with `[build] Complete!` and zero errors before pushing.

---

## File that must never be committed upstream

- `CONTEXT.md` — already in `.gitignore`. Never stage or commit this file.
