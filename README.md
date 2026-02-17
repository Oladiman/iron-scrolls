# ⚔ Iron Scrolls

> *"A master does not carry their techniques in their hands — they carry them in their scrolls."*

**Iron Scrolls** is a personal collection of [Claude Code](https://claude.ai/claude-code) custom slash commands. Clone this repo on any machine and run the installer to have every command available instantly in any project.

---

## What are Claude Code custom commands?

Claude Code supports user-defined `/slash-commands` stored as markdown files in `~/.claude/commands/`. When you type `/command-name` in a Claude Code session, the contents of that file are expanded as a fully-structured prompt — giving you repeatable, project-agnostic workflows without retyping.

Iron Scrolls is the permanent home for these commands, versioned on GitHub so they're always one `git clone` + `bash install.sh` away on any new machine.

---

## Installation

```bash
git clone https://github.com/damidipo/iron-scrolls.git
cd iron-scrolls
bash install.sh
```

That's it. All commands in `commands/` are copied to `~/.claude/commands/`. Open any Claude Code session and they're available immediately.

### Updating

When new commands are added or existing ones are updated, pull and re-run:

```bash
git pull
bash install.sh
```

The installer overwrites existing commands and reports what changed.

---

## Commands

### `/seo-audit`

A complete SEO audit workflow for Next.js App Router projects.

**What it does:**

| Phase | Action |
|---|---|
| 1 | Discovers project structure and router type |
| 2 | Audits every route for `title`, `description`, `canonical`, Open Graph, Twitter Card, and `noindex` |
| 3 | Checks root layout for `metadataBase` and default OG/Twitter |
| 4 | Checks `robots.ts` and `sitemap.ts` |
| 5 | Checks for JSON-LD structured data (Organization, WebSite, TouristTrip, etc.) |
| 6 | Scans all image `alt` attributes for violations (empty, file-name-style, implementation-detail strings) |
| 7 | Identifies thin pages and duplicate-content URLs |
| 8 | Generates two HTML reports in `reports/`: a technical developer report and a plain-English owner report |
| 9 | Applies all fixes (unless you say "audit only") |

**Usage:**

```
/seo-audit
```

Or to skip fixes and only generate reports:

```
/seo-audit audit only
```

**Reports generated:**

| File | Audience |
|---|---|
| `reports/seo-audit-YYYY-MM-DD.html` | Developer — full technical breakdown with code snippets and severity ratings |
| `reports/seo-owner-report-YYYY-MM-DD.html` | Business owner — traffic-light table, plain English, no code |

---

## Project structure

```
iron-scrolls/
├── commands/
│   └── seo-audit.md    # /seo-audit command prompt
├── install.sh           # Copies commands to ~/.claude/commands/
└── README.md
```

---

## Adding new commands

1. Create a new `.md` file in `commands/` — the filename becomes the slash command name.
   - `commands/pr-review.md` → `/pr-review`
   - `commands/refactor.md` → `/refactor`
2. Write the prompt as markdown inside the file.
3. Run `bash install.sh` to install it locally.
4. Commit and push so it's available everywhere.

---

## Philosophy

The name *Iron Scrolls* comes from the Wuxia tradition — where a master's techniques are preserved in iron-bound scrolls, passed down not by teaching but by letting the student read and internalize the knowledge themselves. These commands are the same: pre-encoded expertise that any session of Claude can pick up and execute faithfully.

---

## Requirements

- [Claude Code](https://claude.ai/claude-code) (any version)
- `bash` (macOS, Linux, or WSL on Windows)
- No other dependencies

---

*Maintained by [@damidipo](https://github.com/damidipo)*
