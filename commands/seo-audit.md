Perform a comprehensive SEO audit of this Next.js project and generate a full HTML report. Follow every step below.

---

## Phase 1 — Discover the project structure

1. Find the framework version and router type (App Router vs Pages Router) from `package.json`.
2. List all route directories under `app/` (or `pages/`).
3. Identify which pages are "use client" components — these **cannot** export `metadata` directly and need a sibling `layout.tsx` server component.

---

## Phase 2 — Audit each route for metadata completeness

For every route, check whether it has:

| Signal | How to check |
|---|---|
| `title` | `export const metadata` or `generateMetadata` in the page or its layout |
| `description` | Same as above |
| `alternates.canonical` | Prevents duplicate-URL penalties |
| `openGraph` block | `title`, `description`, `url`, `type`, `images` |
| `twitter` block | `card`, `title`, `description` |
| `robots: { index: false }` | Required on transactional/private pages (cart, checkout, confirmation) |

Flag any route that is missing one or more of these as **ACTION REQUIRED**.

---

## Phase 3 — Check root layout

In `app/layout.tsx` (or equivalent), verify:
- `metadataBase` is set to the production URL (required for relative OG image paths to resolve correctly)
- Default `openGraph.siteName`, `openGraph.type`, `openGraph.locale` are present
- Default `twitter.card` and `twitter.site` are present

---

## Phase 4 — Check robots and sitemap

- Does `app/robots.ts` exist? If yes, verify it disallows `/api/`, transactional routes.
- Does `app/sitemap.ts` exist? If yes, verify it includes all public static routes and fetches dynamic routes (e.g. trip/product/blog detail pages) from the CMS or database.

---

## Phase 5 — Check structured data (JSON-LD)

- Look for `<script type="application/ld+json">` blocks in layouts.
- Identify which schemas are present (Organization, WebSite, TouristTrip, Product, Article, BreadcrumbList, etc.).
- Flag which important pages are missing structured data.

---

## Phase 6 — Check image alt text

Search all component files for `<Image` and `<img` tags. Flag any that have:
- `alt=""` (empty string — invisible to screen readers and search engines)
- `alt` values that are file names, paths, or implementation details (e.g. `alt="hamburger-menu"`, `alt="img-1"`)

These are high-priority fixes because Google can surface alt text as sitelinks.

---

## Phase 7 — Check for thin / duplicate pages

- Identify pages with no real content (stub pages, placeholder `<div>Text</div>` pages).
- Identify multiple URLs that serve the same legal/policy content — recommend `redirect()` from `next/navigation` to consolidate.

---

## Phase 8 — Generate the HTML reports

Create **two** HTML reports in a `reports/` folder at the project root:

### Report 1: `reports/seo-audit-YYYY-MM-DD.html` (Technical — for the developer)

Include:
- Date of audit
- Pass/Fail summary table for every route
- Per-route breakdown: what's present, what's missing, exact fix needed
- Code snippets showing the recommended fix for each issue
- robots.txt and sitemap.xml assessment
- Structured data gaps
- Alt text violations with file path and line number
- Priority ranking: Critical / High / Medium / Low

### Report 2: `reports/seo-owner-report-YYYY-MM-DD.html` (Plain English — for the business owner)

Include:
- What SEO is and why it matters for this business (1 paragraph)
- Simple traffic-light table (Green = done, Amber = in progress, Red = missing) for: Google listing quality, page titles, social sharing, site map, structured data
- What content or assets the owner needs to provide (OG images, business description, etc.)
- What has already been fixed
- What the developer will do next
- No code, no jargon

### Style both reports with:
- Clean sans-serif font (system-ui)
- Color-coded severity badges (red/amber/green)
- Collapsible sections if the report is long
- Print-friendly CSS

---

## Phase 9 — Apply fixes (unless told to audit-only)

Unless the user says "audit only", after generating the reports, apply all fixes:
1. Add missing `metadata` exports (or `layout.tsx` wrappers for client pages)
2. Add `metadataBase` and default OG/Twitter to root layout
3. Create `app/robots.ts` if missing
4. Create `app/sitemap.ts` if missing — ask the user how to fetch dynamic routes if the data source is unclear
5. Fix blank alt text and implementation-detail alt text on images
6. Replace stub pages with `redirect()` calls to the canonical page
7. Add JSON-LD schemas where missing (ask user for business details if needed: address, social links, phone)

After applying fixes, update `reports/seo-audit-YYYY-MM-DD.html` with a "Post-fix" column showing resolved vs still-open issues.

---

## Output

When done, tell the user:
- How many issues were found (by severity)
- How many were fixed
- The path to each report
- Any items that require their input (e.g. missing OG images, business address for JSON-LD, CMS API keys)
