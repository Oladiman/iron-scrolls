# Contributing to Iron Scrolls

Contributions are welcome — new commands, improvements to existing ones, docs fixes, and anything that makes the collection more useful.

---

## Ways to contribute

| Type | What this looks like |
|---|---|
| **New command** | A brand-new slash command for a discipline not yet covered |
| **Command improvement** | Adding phases, fixing gaps, extending framework support |
| **Docs improvement** | Clearer explanations, better examples, typo fixes |
| **Bug report** | A command producing wrong output, missing a case, or breaking on a specific framework |

---

## Before you start

For new commands or significant changes, [open an issue first](https://github.com/Oladiman/iron-scrolls/issues/new/choose). Describe what you want to build and why. This avoids duplicate work and lets us discuss the approach before you write anything.

For small fixes (typos, clarifications, minor gaps), just open a PR directly.

---

## Running the project locally

### Commands (no setup needed)

The commands are plain `.md` files. Edit them in any text editor. To test locally:

```bash
bash install.sh
```

This copies all commands to `~/.claude/commands/`. Open any Claude Code session and the updated commands are available immediately.

### Docs site

```bash
cd site
npm install
npm run dev
```

Opens at `http://localhost:4321/iron-scrolls`. Edits to `.mdx` files hot-reload instantly.

To build and verify before submitting:

```bash
npm run build
```

The build must complete with zero errors before a PR is merged.

---

## Adding a new command

### 1 — Check the gap is real

The command should address a specific, repeatable engineering discipline that Claude can execute consistently. Good examples: `database-audit`, `docker-review`, `i18n-audit`. Avoid commands that are too vague (`code-quality`) or too narrow (`fix-this-one-thing`).

### 2 — Write the command file

Create `commands/your-command-name.md`. The filename becomes the slash command: `/your-command-name`.

**Structure every command like this:**

```markdown
Perform a [task description] of this [scope] and [output]. Follow every step below.

You can run a subset of phases by including a range in the command,
e.g. `/your-command-name --phase 1-3` to run only [description].

---

## Phase 1 — [Name]

[Numbered steps with specific, concrete instructions. Not vague guidance — exact things to look for, exact files to read, exact patterns to flag.]

---

## Phase N — Generate the report

Create a file `your-command-name-YYYY-MM-DD.md` in the current directory (not committed) with:

[Report structure]

---

## Phase N+1 — Apply fixes (unless told to [mode])

Unless the user says "[mode]":
1. [Specific things to auto-fix]

Do NOT automatically:
- [Things that need human judgement]

---

## Output

When done, tell the user:
- [What summary information to surface]
```

**Quality bar for a command:**

- **Specific over vague.** "Check for `dangerouslySetInnerHTML` uses that pass user data without calling `DOMPurify.sanitize()`" is good. "Check for security issues" is not.
- **Concrete outputs.** Every command must produce a report file with a predictable name and structure. Users should be able to share the report as-is.
- **Clear auto-fix boundaries.** Be explicit about what gets fixed automatically vs what gets flagged. Auto-fix only things that are unambiguously safe and localised. Never auto-fix architectural changes.
- **Phase modifier support.** Include the `--phase N-M` line at the top so users can run subsets.
- **Two reports where applicable.** Audit-style commands should generate a developer report (technical) and an owner/stakeholder report (plain English, no code).

### 3 — Test it

Install the command locally and run it against at least two different real projects. The command should:

- Complete without Claude asking for clarification
- Produce a useful report even on a "clean" project (no false positives)
- Find real issues on a project with known gaps

### 4 — Add the docs page

Create `site/src/content/docs/commands/your-command-name.mdx`. Follow the structure of an existing page (e.g. [pr-review.mdx](site/src/content/docs/commands/pr-review.mdx)):

```mdx
---
title: /your-command-name
description: One sentence. What it audits, what it outputs.
---

import { Aside, Badge } from '@astrojs/starlight/components';

<Badge text="Framework / scope" variant="note" />
<Badge text="Generates report" variant="success" />

[One paragraph summary]

---

## Usage
## What it reviews (phase table)
## Report generated
## What gets fixed automatically
## Framework support
## Install
```

### 5 — Update the sidebar and landing page

In `site/astro.config.mjs`, add your command to the `Commands` sidebar section:

```js
{ label: '/your-command-name', slug: 'commands/your-command-name' },
```

In `site/src/content/docs/index.mdx`, add a `<Card>` for your command in the `<CardGrid>`.

In `site/src/content/docs/install.mdx`, add your command to:
- The command list in step 3
- The `curl` single-install section
- The file tree

### 6 — Update the README

Add a section for your command to `README.md` following the existing pattern (name, phase table, usage examples, framework note, docs link). Update the project structure tree.

### 7 — Open a PR

Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md). The PR description should include:
- What the command does (one paragraph)
- What projects you tested it on
- Any design decisions that weren't obvious

---

## Improving an existing command

Open an issue describing the gap or problem first. Include:
- The framework / scenario where the command falls short
- What the command currently does
- What it should do instead

For small improvements (adding a check, clarifying a phase), a PR without an issue is fine.

---

## Docs improvements

The docs site lives in `site/src/content/docs/`. Each command has one `.mdx` page. The blog lives in `site/src/content/docs/blog/`.

For typos and small clarifications, just open a PR — no issue needed.

For structural changes to the site (new pages, new navigation sections), open an issue first.

---

## Commit style

```
type: short description (imperative, under 72 chars)

Optional body — explain the why, not the what. Reference issues with #N.
```

Types: `feat`, `fix`, `docs`, `refactor`, `chore`

Examples:
```
feat: add /database-audit command for Prisma and Drizzle

fix: seo-audit phase 3 missing robots meta check on Pages Router

docs: update accessibility-audit framework support table
```

---

## PR checklist

Before requesting review:

- [ ] `bash install.sh` runs cleanly
- [ ] Command tested against at least two real projects
- [ ] `npm run build` in `site/` completes with zero errors
- [ ] Docs page created and matches the command's phases
- [ ] Sidebar, landing page card, install page, and README all updated
- [ ] No CONTEXT.md, `.env`, or personal config files in the diff

---

## What won't be merged

- Commands that require API keys or external services to run (must work offline against local code)
- Commands that are too narrow to be useful across projects
- Docs-only changes that contradict the command's actual behaviour
- PRs that modify existing commands without a corresponding issue or discussion

---

*Questions? Open an issue or start a discussion. We'd rather you ask first than spend time on something that won't fit.*
