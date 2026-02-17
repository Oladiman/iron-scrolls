# ⚔ Iron Scrolls

> *"A master does not carry their techniques in their hands — they carry them in their scrolls."*

**Iron Scrolls** is a collection of [Claude Code](https://claude.ai/claude-code) custom slash commands — pre-encoded expertise for SEO, accessibility, performance, security, code review, API design, and test coverage. Clone this repo on any machine and run the installer to have every command available instantly in any project.

📖 **Full documentation:** [Oladiman.github.io/iron-scrolls](https://Oladiman.github.io/iron-scrolls)
🤝 **Contributing:** [CONTRIBUTING.md](CONTRIBUTING.md)

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

### `/security-audit`

OWASP-aligned security audit for any web project.

| Phase | Action |
|---|---|
| 1 | Secrets exposure — hardcoded keys, `.env` not in `.gitignore`, `NEXT_PUBLIC_*` leaking secrets |
| 2 | Auth & authorisation — server-side session checks, ownership validation, password hashing, rate limiting |
| 3 | Injection — SQL, NoSQL, command injection |
| 4 | XSS — `dangerouslySetInnerHTML`, `innerHTML`, `eval()`, unsafe `href` |
| 5 | Security headers — CSP, X-Frame-Options, HSTS, Referrer-Policy, Permissions-Policy |
| 6 | CSRF — mutation endpoints protected, `SameSite` cookies |
| 7 | Dependencies — `npm audit` CVEs, outdated packages |
| 8 | File uploads — MIME validation, size limits, path traversal |
| 9 | Generates two HTML reports: developer report + plain-English stakeholder report |
| 10 | Applies safe fixes (headers, DOMPurify, `.env.example`, `.gitignore`) |

```
/security-audit
/security-audit audit only
```

**Frameworks:** Next.js, Express, Fastify, Hono, Nuxt, SvelteKit, any Node.js project

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/security-audit/)

---

### `/pr-review`

Structured pull request review for any codebase.

| Phase | Action |
|---|---|
| 1 | Change summary — reads commits, diff, PR description, categorises the change |
| 2 | Correctness — logic, edge cases, error handling, race conditions, type safety |
| 3 | Security — new input validation, new API auth, injection risks, new secrets |
| 4 | Performance — N+1 queries, unnecessary re-renders, blocking operations |
| 5 | Code quality — naming, dead code, magic numbers, debug statements, TODOs |
| 6 | Tests — coverage, quality, edge cases, broken existing tests |
| 7 | Conventions — formatting, import order, API response shape consistency |
| 8 | Documentation — README gaps, JSDoc, CHANGELOG |
| 9 | Generates structured review report with severity-ranked issues |
| 10 | Auto-fixes Critical/High safe issues (missing null checks, dead code, missing await) |

```
/pr-review
/pr-review review only
```

**Works on:** any git repository, any language or framework

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/pr-review/)

---

### `/api-design-review`

REST and GraphQL API design review.

| Phase | Action |
|---|---|
| 1 | Discovers all API routes (App Router, Pages Router, server actions, Express, tRPC, GraphQL) |
| 2 | Naming & URLs — plural nouns, kebab-case, correct hierarchy, versioning |
| 3 | HTTP method usage — GET is read-only, correct PUT/PATCH/DELETE semantics |
| 4 | Request validation — Zod/Joi schemas, type coercion, `stripUnknown` |
| 5 | Response design — status codes, consistent envelope, error shape, pagination |
| 6 | Auth & authorisation — all mutating endpoints protected, ownership checks |
| 7 | Rate limiting — auth endpoints, resource-intensive endpoints, `Retry-After` headers |
| 8 | Error handling — unhandled rejections, stack traces exposed to clients |
| 9 | Generates structured review report |
| 10 | Auto-fixes missing validation schemas, incorrect status codes, error shape, missing `await` |

```
/api-design-review
/api-design-review review only
```

**Frameworks:** Next.js, tRPC, GraphQL, Express, Fastify, Hono, Nuxt, SvelteKit

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/api-design-review/)

---

### `/test-coverage`

Test coverage audit — maps untested code paths by risk and writes the missing tests.

| Phase | Action |
|---|---|
| 1 | Discovers test runner (Jest/Vitest/Playwright), config, coverage provider, and file conventions |
| 2 | Runs coverage and parses results — maps every uncovered line and branch per file |
| 3 | Maps all untested paths: happy path, error paths, conditional branches, edge cases, async paths |
| 4 | Prioritises gaps as P0 (auth/payment/mutations), P1 (utilities/handlers), P2 (UI), P3 (trivial) |
| 5 | Writes missing unit tests for P0 and P1 gaps using your existing framework and patterns |
| 6 | Writes missing integration tests for untested API endpoints (if integration suite exists) |
| 7 | Writes missing component tests for untested conditional rendering (if component suite exists) |
| 8 | Generates `test-coverage-YYYY-MM-DD.md` with before/after coverage and remaining gaps |
| 9 | Adds safe coverage thresholds to test config as a commented-out floor (prevents regressions) |

```
/test-coverage
/test-coverage audit only
/test-coverage --phase 1-4
```

**Test runners:** Jest, Vitest, Playwright, Cypress, Testing Library

[Full docs →](https://Oladiman.github.io/iron-scrolls/commands/test-coverage/)

---

## Project structure

```
iron-scrolls/
├── commands/
│   ├── seo-audit.md              # /seo-audit
│   ├── accessibility-audit.md    # /accessibility-audit
│   ├── performance-audit.md      # /performance-audit
│   ├── security-audit.md         # /security-audit
│   ├── pr-review.md              # /pr-review
│   ├── api-design-review.md      # /api-design-review
│   └── test-coverage.md          # /test-coverage
├── site/                         # Astro + Starlight documentation site
│   └── src/content/docs/         # MDX pages for each command + blog
├── .github/
│   ├── ISSUE_TEMPLATE/           # New command, improvement, and bug templates
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── workflows/deploy.yml      # GitHub Actions → GitHub Pages
│   └── FUNDING.yml
├── posts/                        # Dev.to-ready article drafts
├── install.sh                    # Copies commands to ~/.claude/commands/
├── CONTRIBUTING.md
└── README.md
```

---

## Contributing

Contributions are welcome — new commands, improvements to existing ones, and docs fixes.

**Quick start:**

```bash
# Run the docs site locally
cd site && npm install && npm run dev

# Test a command locally after editing
bash install.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide: command quality standards, the phase structure conventions, how to write the docs page, and the PR checklist.

**Open an issue first** for new commands or significant changes. Use the [issue templates](https://github.com/Oladiman/iron-scrolls/issues/new/choose) to describe what you want to build.

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
