---
title: "My nav icon became a Google sitelink. Here's why — and how I caught it."
published: true
description: "A single alt attribute turned a hamburger icon into a Google sitelink. Here's how /seo-audit from Iron Scrolls found it in seconds."
tags: seo, nextjs, webdev, tooling
cover_image:
---

We noticed something strange in Google Search Console.

Our site had a sitelink — that row of quick-links Google sometimes shows under a main search result. Sitelinks are great. They help users jump straight to the section they want. Ours said:

> **Hamburger-menu**

Not "About". Not "Book a trip". *Hamburger-menu.*

---

## What happened

Google builds sitelinks from what it can read about your pages. When there's no real metadata to work with, it reaches for whatever text it can find — headings, link text, alt attributes.

Our mobile nav icon had this:

```tsx
<Image src={menuIcon} alt="hamburger-menu" />
```

That was the only unique, descriptive text Google could find. So it used it.

Two things made this worse:

1. **No per-page `<title>` or `<meta name="description">`** — every page fell back to the root layout's generic title, so Google couldn't distinguish between them.
2. **No `metadataBase`** in the root layout — so relative Open Graph image URLs weren't resolving, meaning Google had nothing visual to anchor the page to either.

---

## The fix

Three changes:

**1. Fix the alt text**

```tsx
// before
<Image src={menuIcon} alt="hamburger-menu" />

// after
<Image src={menuIcon} alt="Open navigation menu" />
```

**2. Add per-page metadata to every route**

```ts
// app/about/page.tsx
export const metadata: Metadata = {
  title: "About — TripCooks",
  description: "We plan culinary travel experiences...",
  alternates: { canonical: "https://tripcooks.tours/about" },
  openGraph: { title: "About — TripCooks", ... },
};
```

For `"use client"` pages that can't export metadata directly, the fix is a sibling `layout.tsx` server component wrapper — the correct Next.js App Router pattern.

**3. Add `metadataBase` to the root layout**

```ts
export const metadata: Metadata = {
  metadataBase: new URL("https://tripcooks.tours"),
  // now all relative OG image paths resolve correctly
};
```

---

## How /seo-audit caught all of this

Before writing a single line of the fix, I ran `/seo-audit` — a Claude Code slash command that performs a full SEO audit on Next.js App Router projects.

It found:

- Every route missing a `title`, `description`, or `canonical`
- Missing `metadataBase` in the root layout
- The `alt="hamburger-menu"` violation (flagged under image alt audit)
- Missing `robots.ts` and `sitemap.ts`
- No Open Graph or Twitter Card defaults
- Pages that should be `noindex` (cart, checkout, payment confirmation) but weren't

Then it generated two HTML reports — one for the developer with file paths and line references, one in plain English for the client — and applied every safe fix automatically.

The whole thing took about four minutes.

---

## The command

`/seo-audit` is part of **Iron Scrolls** — a collection of Claude Code slash commands for audits, reviews, and coverage checks. Clone it once and every command is available in every project.

```bash
git clone https://github.com/Oladiman/iron-scrolls.git
cd iron-scrolls
bash install.sh
```

Then in any Next.js project:

```
/seo-audit
```

Nine phases. Two HTML reports. Fixes applied. Done.

[Documentation and all commands → Oladiman.github.io/iron-scrolls](https://Oladiman.github.io/iron-scrolls)

---

*The hamburger-menu sitelink is gone. Google's re-crawling now.*
