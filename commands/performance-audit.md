Perform a comprehensive web performance audit of this project and generate a full HTML report. Follow every step below.

---

## Phase 1 — Discover the project

1. Identify the framework and version from `package.json`.
2. Identify the deployment target (Vercel, Netlify, Cloudflare, self-hosted, etc.) from config files (`vercel.json`, `netlify.toml`, `wrangler.toml`, etc.).
3. Identify the image handling library (`next/image`, `nuxt/image`, Astro `<Image>`, plain `<img>`, etc.).
4. Identify the CSS approach (Tailwind, CSS Modules, styled-components, plain CSS).
5. List all routes/pages to be audited.

---

## Phase 2 — Audit JavaScript bundle

Check `package.json` dependencies for:

| Issue | What to look for |
|---|---|
| Oversized dependencies | Libraries where a smaller alternative exists (e.g. `moment` → `dayjs`, `lodash` → native JS or `lodash-es`, `date-fns` full import vs tree-shaken) |
| Duplicate functionality | Two libraries doing the same thing (e.g. both `axios` and `fetch`, both `react-query` and `swr`) |
| Client-side-only imports in server components | In Next.js App Router, check that heavy client libraries aren't imported in server components (e.g. charting libraries, animation libraries loaded unnecessarily on the server) |
| Missing dynamic imports | Large components (modals, drawers, rich text editors, charts, maps) that should be `dynamic(() => import(...), { ssr: false })` in Next.js or `defineAsyncComponent` in Vue |
| Missing `"use client"` boundaries | In Next.js App Router, confirm that the "use client" boundary is as deep as possible — don't mark a whole page client when only a small interactive widget needs it |

Check build output if available (`next build` output, `.next/analyze/`, `dist/` stats):
- List any chunk larger than 100KB (gzipped) as a candidate for splitting
- Identify any third-party scripts (analytics, chat widgets, tag managers) loaded synchronously in `<head>`

---

## Phase 3 — Audit images

For every image in the project:

| Check | Standard |
|---|---|
| Format | AVIF or WebP for all photographs. SVG for icons/logos. No PNG for photos. |
| Sizing | Image rendered size must match or be close to the `src` intrinsic size. A 1200×800 image used at 400×267 is 9× oversized. |
| Lazy loading | Images below the fold must have `loading="lazy"`. The hero/LCP image must NOT have `loading="lazy"` — it needs `loading="eager"` or `fetchpriority="high"`. |
| Explicit dimensions | All images must have explicit `width` and `height` (or aspect ratio CSS) to prevent layout shift (CLS). |
| Next.js `<Image>` usage | Verify `sizes` prop is set correctly for responsive images. Verify `priority` is set on the LCP image. Verify `placeholder="blur"` is used for above-fold images. |
| External images | Next.js `next.config.js` must have the remote domain in `images.remotePatterns`. |

---

## Phase 4 — Audit fonts

| Check | Standard |
|---|---|
| Loading strategy | Fonts must use `font-display: swap` or `font-display: optional`. Never `block`. |
| Subsetting | Check if only the character sets needed are loaded (e.g. Latin-only for English-language sites). |
| Self-hosting | Google Fonts loaded via `<link>` from Google's CDN adds a DNS lookup and render-blocking request. `next/font` or `@fontsource` packages self-host automatically — verify these are used if fonts are present. |
| Preloading | The primary body font should be `<link rel="preload" as="font" crossorigin>` in `<head>`. |
| Number of font files | Each additional font weight/style is a separate network request. Flag if more than 3–4 font files are loaded. |

---

## Phase 5 — Audit third-party scripts

List every third-party script loaded (analytics, chat, video embeds, tag managers, heatmaps, A/B testing). For each:

| Check | Standard |
|---|---|
| Loading strategy | Scripts should use `strategy="lazyOnload"` (Next.js `<Script>`) or `defer`/`async` attributes. Never bare `<script src>` in `<head>`. |
| Render blocking | Any script in `<head>` without `defer` or `async` blocks rendering. Flag it. |
| Tag manager payload | If Google Tag Manager or similar is present, note that its payload is unbounded — every tag added through the UI affects performance silently. |
| Video embeds | YouTube/Vimeo iframes should use a facade (load the thumbnail, inject the iframe only on click). Flag any direct `<iframe>` embeds. |

---

## Phase 6 — Audit Core Web Vitals patterns

Check the code for patterns that cause Core Web Vitals failures:

### Largest Contentful Paint (LCP) — target < 2.5s
- Is the LCP element (hero image or hero heading) immediately visible, or hidden behind a fade-in/reveal animation?
- Is the LCP image lazy-loaded? (It must not be.)
- Is the LCP image fetchpriority set to `"high"`?
- Are there any render-blocking resources in `<head>` that delay the LCP element from painting?

### Cumulative Layout Shift (CLS) — target < 0.1
- Do images lack explicit `width`/`height`? These cause layout shift when they load.
- Do fonts cause FOIT/FOUT (invisible/unstyled text) that shifts layout when they swap?
- Are ads, embeds, or dynamic content inserted above existing content without reserved space?
- Does any component animate `top`, `left`, `margin`, `padding`, or `height` on load? (Use `transform` instead — it doesn't trigger layout.)

### Interaction to Next Paint (INP) — target < 200ms
- Are there event handlers that do heavy synchronous work (sorting large arrays, complex state updates)?
- Are there `useEffect` hooks that run expensive operations on user interactions?
- Is state lifted too high, causing large component trees to re-render on every keystroke?
- Are list components rendering without `key` props or with unstable keys?

---

## Phase 7 — Audit caching and headers

Check `next.config.js`, `vercel.json`, `netlify.toml`, or server config for:

| Asset type | Recommended cache header |
|---|---|
| Static assets with hashed filenames (`_next/static/`) | `Cache-Control: public, max-age=31536000, immutable` |
| HTML pages | `Cache-Control: public, max-age=0, must-revalidate` (or short `s-maxage` for CDN) |
| API routes | `Cache-Control: no-store` (unless explicitly cacheable) |
| Images via CDN | `Cache-Control: public, max-age=86400` |

Flag any static assets not set to long-lived cache. Flag any HTML pages with very long cache times (stale content risk).

---

## Phase 8 — Generate HTML reports

Create two reports in the `reports/` folder (create it if it doesn't exist):

### Report 1: `performance-audit-YYYY-MM-DD.html` (Technical — for the developer)

Include:
- Date of audit
- Framework and deployment target
- Summary table: LCP, CLS, INP patterns — Pass / Warning / Fail
- Bundle analysis: large chunks, unnecessary dependencies, missing dynamic imports
- Image violations: file path, issue, recommended fix
- Font loading issues: file, issue, fix
- Third-party script table: name, loading strategy, blocking status
- Caching gaps: asset type, current header, recommended header
- Each issue with: severity (Critical / High / Medium / Low), file path, line reference where possible, code showing the problem, recommended fix

### Report 2: `performance-owner-report-YYYY-MM-DD.html` (Plain English — for the stakeholder)

Include:
- Why page speed matters (SEO ranking, conversion rates, bounce rates — with real benchmarks)
- What a user on a mobile connection currently experiences
- Traffic-light summary: page load speed, image optimisation, search ranking impact, mobile experience
- Top 3 fixes and the expected improvement for each
- What the developer will do
- No code, no jargon

---

## Phase 9 — Apply fixes (unless told to audit-only)

Unless the user says "audit only", apply:

1. Add `loading="lazy"` to below-fold images
2. Add `priority` / `fetchpriority="high"` to the LCP image
3. Add explicit `width` and `height` to images missing them
4. Convert `strategy="beforeInteractive"` scripts to `strategy="lazyOnload"` where appropriate
5. Replace `moment` with `dayjs` if found (update imports throughout)
6. Add dynamic imports for large below-fold components (confirm with user before moving server components)
7. Add `font-display: swap` to custom font declarations
8. Add `@media (prefers-reduced-motion)` to animations that could cause CLS
9. Add recommended cache headers to `next.config.js` or `vercel.json`

Do NOT automatically:
- Remove third-party scripts (business decision, confirm with user first)
- Change image formats (requires design/asset pipeline change, flag and recommend)
- Split large chunks (requires architectural review, flag and recommend)

After applying safe fixes, update the report with a "Post-fix" column.

---

## Output

When done, tell the user:
- Estimated LCP, CLS, INP impact of the found issues (range, not precise — "likely 0.3–0.8s LCP improvement")
- How many issues were fixed vs flagged for manual review
- The path to each report
- Any items that require decisions (removing scripts, image format changes, major refactors)
