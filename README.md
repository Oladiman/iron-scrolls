# ⚔ Iron Scrolls

> *"A master does not carry their techniques in their hands — they carry them in their scrolls."*

**Iron Scrolls** is a personal collection of [Claude Code](https://claude.ai/claude-code) custom slash commands. Clone this repo on any machine and run the installer to have every command available instantly in any project.

📖 **Full documentation:** [Oladiman.github.io/iron-scrolls](https://Oladiman.github.io/iron-scrolls)

---

## What are Claude Code custom commands?

Claude Code supports user-defined `/slash-commands` stored as markdown files in `~/.claude/commands/`. When you type `/command-name` in a Claude Code session, the contents of that file are expanded as a fully-structured prompt — giving you repeatable, project-agnostic workflows without retyping.

Iron Scrolls is the permanent home for these commands, versioned on GitHub so they're always one `git clone` + `bash install.sh` away on any new machine.

---

## Installation

```bash
git clone https://github.com/Oladiman/iron-scrolls.git
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

Complete SEO audit for Next.js App Router projects.

| Phase | Action |
|---|---|
| 1 | Discovers project structure and router type |
| 2 | Audits every route for `title`, `description`, `canonical`, Open Graph, Twitter Card, and `noindex` |
| 3 | Checks root layout for `metadataBase` and default OG/Twitter |
| 4 | Checks `robots.ts` and `sitemap.ts` |
| 5 | Checks for JSON-LD structured data (Organization, WebSite, TouristTrip, etc.) |
| 6 | Scans all image `alt` attributes for violations |
| 7 | Identifies thin pages and duplicate-content URLs |
| 8 | Generates two HTML reports: developer report + plain-English owner report |
| 9 | Applies all fixes (unless you say "audit only") |

```
/seo-audit
/seo-audit audit only
```

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/seo-audit/)

---

### `/accessibility-audit`

WCAG 2.1 AA accessibility audit for any web framework.

| Phase | Action |
|---|---|
| 1 | Semantic HTML — heading hierarchy, landmark regions, forms, buttons vs links |
| 2 | ARIA — labels, expanded state, live regions, dialog roles, misuse |
| 3 | Keyboard navigation — dropdowns, modals, carousels, accordions, tabs, date pickers |
| 4 | Focus visibility — focus ring presence and contrast |
| 5 | Colour contrast — 4.5:1 normal text, 3:1 large text and UI components |
| 6 | Images and media — alt text, captions, transcripts, autoplay controls |
| 7 | Motion and animation — `prefers-reduced-motion` coverage |
| 8 | Touch targets — 44×44px minimum for interactive elements |
| 9 | Generates two HTML reports: developer report + plain-English stakeholder report |
| 10 | Applies ARIA, label, focus ring, and alt text fixes (flags colour issues without auto-changing) |

```
/accessibility-audit
/accessibility-audit audit only
```

**Frameworks:** React, Vue, Svelte, Astro, Next.js, Nuxt, plain HTML

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/accessibility-audit/)

---

### `/performance-audit`

Core Web Vitals performance audit for any web framework.

| Phase | Action |
|---|---|
| 1 | JS bundle — oversized deps, missing dynamic imports, `"use client"` boundary placement |
| 2 | Images — format, sizing, lazy loading, LCP priority, CLS dimensions |
| 3 | Fonts — `font-display`, self-hosting, subsetting, preloading |
| 4 | Third-party scripts — loading strategy, render-blocking, video facades |
| 5 | Core Web Vitals patterns — LCP, CLS, and INP anti-patterns in code |
| 6 | Caching — static asset headers, HTML caching, API route headers |
| 7 | Generates two HTML reports: developer report + plain-English stakeholder report |
| 8 | Applies safe fixes (lazy loading, font-display, cache headers, moment→dayjs) |

```
/performance-audit
/performance-audit audit only
```

**Frameworks:** Next.js, Nuxt, SvelteKit, Astro, Vite / CRA

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/performance-audit/)

---

## Project structure

```
iron-scrolls/
├── commands/
│   ├── seo-audit.md              # /seo-audit command prompt
│   ├── accessibility-audit.md    # /accessibility-audit command prompt
│   └── performance-audit.md      # /performance-audit command prompt
├── site/                         # Astro + Starlight documentation site
│   └── src/content/docs/         # MDX pages for each command
├── install.sh                    # Copies commands to ~/.claude/commands/
└── README.md
```

---

## Adding new commands

1. Create a new `.md` file in `commands/` — the filename becomes the slash command name.
2. Write the prompt as markdown inside the file — structure it as numbered phases with specialist-level instructions.
3. Run `bash install.sh` to install it locally and test it.
4. Create a matching docs page in `site/src/content/docs/commands/`.
5. Add the command to the sidebar in `site/astro.config.mjs`.
6. Commit and push — GitHub Actions deploys the site in ~15 seconds.

---

## Philosophy

The name *Iron Scrolls* comes from the Wuxia tradition — where a master's techniques are preserved in iron-bound scrolls, passed down not by teaching but by letting the student read and internalize the knowledge themselves. These commands are the same: pre-encoded expertise that any session of Claude can pick up and execute faithfully.

---

## Requirements

- [Claude Code](https://claude.ai/claude-code) (any version)
- `bash` (macOS, Linux, or WSL on Windows)
- No other dependencies

---

*Maintained by [@Oladiman](https://github.com/Oladiman)*
