# Iron Scrolls — Build Plan

**Target date:** Tomorrow
**Live URL (day 1):** `https://damidipo.github.io/iron-scrolls`
**Custom domain (later):** TBD
**Estimated build time:** 4–6 hours

---

## Decisions locked in

| Question | Decision |
|---|---|
| Framework | Astro + Starlight |
| Hosting | GitHub Pages (free, zero infra) |
| Deploy | GitHub Actions (auto on push to `main`) |
| Monetization day 1 | GitHub Sponsors + Ko-fi |
| MVP scope | Landing page + `/seo-audit` command docs |

---

## Repository structure (target)

```
iron-scrolls/
├── commands/                        # Claude command files (what users install)
│   └── seo-audit.md
│
├── site/                            # Astro + Starlight website
│   ├── src/
│   │   ├── content/
│   │   │   └── docs/
│   │   │       ├── index.mdx        # Landing / hero page
│   │   │       └── commands/
│   │   │           └── seo-audit.mdx
│   │   ├── assets/
│   │   │   └── logo.svg             # Iron Scrolls mark
│   │   └── env.d.ts
│   ├── public/
│   │   └── favicon.svg
│   ├── astro.config.mjs
│   ├── package.json
│   └── tsconfig.json
│
├── .github/
│   ├── FUNDING.yml                  # GitHub Sponsors + Ko-fi buttons
│   └── workflows/
│       └── deploy.yml               # Auto-deploy to GitHub Pages
│
├── install.sh                       # One-command local installer
├── README.md
└── BUILDPLAN.md                     ← this file
```

---

## Phase 1 — Scaffold (est. 30 min)

### 1.1 — Init Astro + Starlight inside `site/`

```bash
cd iron-scrolls
npm create astro@latest site -- --template starlight --install --no-git
```

### 1.2 — Configure for GitHub Pages

Edit `site/astro.config.mjs`:

```js
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://damidipo.github.io',
  base: '/iron-scrolls',
  integrations: [
    starlight({
      title: 'Iron Scrolls',
      description: 'Claude Code custom slash commands. Clone, install, and ship faster.',
      logo: {
        src: './src/assets/logo.svg',
      },
      social: {
        github: 'https://github.com/damidipo/iron-scrolls',
      },
      customCss: ['./src/styles/custom.css'],
      sidebar: [
        {
          label: 'Get Started',
          items: [
            { label: 'Installation', link: '/install/' },
          ],
        },
        {
          label: 'Commands',
          items: [
            { label: '/seo-audit', link: '/commands/seo-audit/' },
          ],
        },
      ],
    }),
  ],
});
```

### 1.3 — Starlight theme customisation

Create `site/src/styles/custom.css`:

```css
/* Iron Scrolls brand colors */
:root {
  --sl-color-accent-low:  #1a120b;
  --sl-color-accent:      #c0392b;   /* iron red — power, mastery */
  --sl-color-accent-high: #e74c3c;
  --sl-color-white:       #f5f0eb;
  --sl-color-black:       #0d0905;
}
```

---

## Phase 2 — Content (est. 2 hours)

### 2.1 — Landing page `site/src/content/docs/index.mdx`

```mdx
---
title: Iron Scrolls
description: Claude Code custom slash commands. Clone, install, ship faster.
template: splash
hero:
  tagline: Ancient techniques for modern engineers.
  image:
    file: ../../assets/logo.svg
  actions:
    - text: Install
      link: /iron-scrolls/install/
      icon: right-arrow
      variant: primary
    - text: Browse Commands
      link: /iron-scrolls/commands/seo-audit/
      icon: open-book
---

## One command to rule your workflow

Iron Scrolls is a collection of [Claude Code](https://claude.ai/claude-code) slash commands —
structured prompts that turn Claude into a specialist for a specific engineering discipline.

Run `/seo-audit` in any Next.js project and Claude performs a complete SEO audit,
generates two professional reports, and applies every fix — in minutes, not days.

## Install in 30 seconds

\`\`\`bash
git clone https://github.com/damidipo/iron-scrolls.git
cd iron-scrolls
bash install.sh
\`\`\`

Then open any Claude Code session and type `/seo-audit`.
```

### 2.2 — `/seo-audit` command page `site/src/content/docs/commands/seo-audit.mdx`

Sections:
- What it does (phases table from command file)
- Usage examples (`/seo-audit`, `/seo-audit audit only`)
- What gets generated (report descriptions + screenshot placeholders)
- Frameworks supported (Next.js App Router v1, more coming)
- Example fixes it applies (with before/after code blocks)
- Link to the raw command source on GitHub

### 2.3 — Install page `site/src/content/docs/install.mdx`

Sections:
- Prerequisites (Claude Code, git, bash)
- Install steps (clone → run install.sh)
- Manual install (copy single file directly)
- Updating (git pull + bash install.sh)
- Windows note (WSL or Git Bash)

---

## Phase 3 — GitHub Actions deployment (est. 30 min)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: site/package-lock.json
      - run: npm ci
        working-directory: site
      - run: npm run build
        working-directory: site
      - uses: actions/upload-pages-artifact@v3
        with:
          path: site/dist

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/deploy-pages@v4
        id: deployment
```

### GitHub repo settings required (manual step, 2 min):
1. Go to `github.com/damidipo/iron-scrolls` → Settings → Pages
2. Source: **GitHub Actions**
3. Save

---

## Phase 4 — Monetization (est. 30 min)

### 4.1 — GitHub Sponsors button

Create `.github/FUNDING.yml`:

```yaml
github: damidipo
ko_fi: damidipo
```

This adds the **Sponsor** button to the GitHub repo header automatically.

To enable GitHub Sponsors:
1. Go to `github.com/sponsors/damidipo` and complete the onboarding (takes ~24h to approve)
2. Set up at least one tier (e.g. $3/mo "Supporter", $10/mo "Patron")

### 4.2 — Ko-fi

1. Create account at [ko-fi.com](https://ko-fi.com) with username `damidipo`
2. Set up profile and one-time donation page
3. Add Ko-fi button to Starlight site footer

Add to `site/astro.config.mjs` under `starlight({})`:

```js
components: {
  Footer: './src/components/Footer.astro',
},
```

Create `site/src/components/Footer.astro`:

```astro
---
import Default from '@astrojs/starlight/components/Footer.astro';
---
<Default><slot /></Default>
<div style="text-align:center; padding: 1rem 0; font-size: 0.85rem;">
  <a href="https://ko-fi.com/damidipo" target="_blank" rel="noopener">
    ☕ Support Iron Scrolls on Ko-fi
  </a>
  &nbsp;·&nbsp;
  <a href="https://github.com/sponsors/damidipo" target="_blank" rel="noopener">
    ♥ GitHub Sponsors
  </a>
</div>
```

---

## Phase 5 — QA & launch checklist

- [ ] Site builds locally (`cd site && npm run build && npm run preview`)
- [ ] GitHub Actions deploy succeeds on push to `main`
- [ ] Live at `https://damidipo.github.io/iron-scrolls`
- [ ] Install instructions work on a clean machine (or test in a new terminal)
- [ ] Ko-fi link works
- [ ] GitHub Sponsors button visible on repo
- [ ] `FUNDING.yml` committed and pushed
- [ ] README links updated to point to live site

---

## Post-launch (next week)

- Write a short post on [dev.to](https://dev.to) explaining the "hamburger-menu" sitelink problem and how `/seo-audit` found and fixed it — link to Iron Scrolls
- Submit to [Astro showcase](https://astro.build/showcase/) for free visibility
- Add `/accessibility-audit` as the second command (already have a clear spec)
- Consider adding a "Submit a command" GitHub issue template for community contributions

---

## Time breakdown

| Phase | Task | Est. |
|---|---|---|
| 1 | Scaffold + Astro config | 30 min |
| 2 | Landing page content | 45 min |
| 2 | `/seo-audit` docs page | 45 min |
| 2 | Install page | 20 min |
| 3 | GitHub Actions + Pages config | 30 min |
| 4 | FUNDING.yml + Ko-fi button | 30 min |
| 5 | QA + fixes | 30 min |
| — | **Total** | **~4 hours** |
