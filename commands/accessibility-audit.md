Perform a comprehensive accessibility audit of this web project and generate a full HTML report. Follow every step below.

You can run a subset of phases by including a range in the command, e.g. `/accessibility-audit --phase 1-5` to run only the structural and ARIA checks without generating reports or applying fixes.

---

## Phase 1 — Discover the project structure

1. Identify the framework (Next.js, Nuxt, SvelteKit, Remix, plain HTML, etc.) from `package.json` or file structure.
2. List all route/page files and all component files in `components/` or `src/`.
3. Note the UI component library in use (shadcn/ui, Radix, MUI, Chakra, custom, etc.) — this affects which patterns to look for.

---

## Phase 2 — Audit semantic HTML

For every page and reusable component, check:

| Check | What to look for |
|---|---|
| Heading hierarchy | `<h1>` → `<h2>` → `<h3>` must be sequential, no skipped levels. Every page must have exactly one `<h1>`. |
| Landmark regions | Page must include `<main>`, `<nav>`, `<header>`, `<footer>`. No layout done purely with `<div>` where a semantic element fits. |
| Lists | Navigation links grouped as `<ul>/<li>`. Repeated items not using `<div>` stacks. |
| Tables | `<table>` elements must have `<caption>` or `aria-label`. Column headers use `<th scope="col">`, row headers use `<th scope="row">`. |
| Buttons vs links | `<button>` for actions (submit, open, toggle). `<a href>` for navigation. Never `<div onClick>` for either. |
| Forms | Every `<input>`, `<select>`, `<textarea>` must have an associated `<label>` via `for`/`id` or `aria-label`. Required fields need `aria-required="true"`. Error messages need `aria-describedby`. |

---

## Phase 3 — Audit ARIA usage

- Check for `aria-label` on icon-only buttons (no visible text).
- Check for `aria-expanded` on toggle buttons (menus, accordions, dropdowns) that open/close content.
- Check for `aria-controls` linking toggles to the element they control.
- Check for `aria-live="polite"` (or `aria-live="assertive"`) on regions that update dynamically (toasts, loading states, error messages).
- Check for `role="dialog"` + `aria-modal="true"` + `aria-labelledby` on modal dialogs.
- Flag any `aria-*` attributes used incorrectly (e.g. `aria-label` on non-interactive elements that could use visible text instead, redundant `role` attributes).
- Flag any elements with `tabindex` values greater than 0 (breaks natural tab order).

---

## Phase 4 — Audit keyboard navigation

Check components for:

| Component type | Required keyboard behaviour |
|---|---|
| Dropdown menus | Arrow keys navigate items. Escape closes. Focus returns to trigger. |
| Modal dialogs | Focus is trapped inside while open. Escape closes. Focus returns to trigger on close. |
| Carousels / sliders | Arrow keys navigate. Focus visible on active slide control. |
| Accordions | Enter/Space toggles. Arrow keys move between items. |
| Tabs | Arrow keys switch tabs. Tab key moves to tab panel content. |
| Date pickers | Arrow keys navigate calendar. Escape closes. |
| Custom select/combobox | Full keyboard-navigable. |

Flag any interactive component that can only be operated with a mouse.

---

## Phase 5 — Audit focus visibility

- Every focusable element must have a visible focus indicator (outline, ring, underline).
- Flag any CSS that uses `outline: none` or `outline: 0` without providing an alternative visible focus style.
- Check that focus rings have sufficient contrast against their background (3:1 minimum ratio per WCAG 2.1 SC 1.4.11).

---

## Phase 6 — Audit colour contrast

For every text colour + background colour combination visible in the component files:

| Text type | Minimum contrast ratio (WCAG AA) |
|---|---|
| Normal text (< 18pt / < 14pt bold) | 4.5:1 |
| Large text (≥ 18pt / ≥ 14pt bold) | 3:1 |
| UI component borders, focus indicators | 3:1 |
| Placeholder text | 4.5:1 |

Extract hex colour values from CSS/Tailwind classes and calculate contrast ratios. Flag any pairings that fail. Note which WCAG level they fail (AA vs AAA).

Look specifically for:
- Light grey placeholder text on white backgrounds
- White text on brand colour buttons (verify the specific shade)
- Disabled state text (still needs sufficient contrast even when disabled)

---

## Phase 7 — Audit images and media

- Every `<img>` and Next.js/Astro `<Image>` must have a non-empty `alt` attribute.
- Decorative images (spacers, borders, icons used purely visually) must have `alt=""`.
- Informative images must have descriptive alt text that conveys the content.
- Images that are also links must have alt text describing the link destination, not the image.
- Check for any `<video>` elements — they need `<track kind="captions">` for spoken content.
- Check for any `<audio>` elements — they need a transcript.
- Animated GIFs or auto-playing video need a way to pause/stop (WCAG 2.1 SC 2.2.2).

---

## Phase 8 — Audit motion and animation

- Check `transition`, `animation`, and `@keyframes` in CSS.
- Any non-trivial animation must respect `@media (prefers-reduced-motion: reduce)`.
- Auto-playing animations that last more than 5 seconds must have a pause control.

---

## Phase 9 — Audit touch targets

For mobile components:
- Interactive elements (buttons, links, inputs) must have a minimum tap target of 44×44px (WCAG 2.1 SC 2.5.5).
- Check that small icon buttons and close buttons (`×`) meet this size — they are the most common failure.

---

## Phase 10 — Generate HTML reports

Create two reports in an `accessibility-reports/` folder (or `reports/` if it already exists):

### Report 1: `accessibility-audit-YYYY-MM-DD.html` (Technical — for the developer)

Include:
- Date of audit
- WCAG level targeted (default: AA)
- Summary: issues by severity (Critical = WCAG A failures, High = WCAG AA failures, Medium = best practice, Low = AAA / advisory)
- Per-component breakdown: file path, line reference where available, exact issue, code showing the problem, and the recommended fix
- Contrast failure table: element, foreground hex, background hex, current ratio, required ratio
- Any framework-specific notes (e.g. shadcn Dialog missing `aria-describedby`, Next.js Image missing alt patterns)
- Severity colour coding: red / orange / yellow / green

### Report 2: `accessibility-owner-report-YYYY-MM-DD.html` (Plain English — for the stakeholder)

Include:
- Why accessibility matters (legal risk, usability, SEO impact)
- Traffic-light summary: keyboard navigation, screen reader support, colour contrast, mobile usability
- Top 3 things users with disabilities experience right now
- What will be fixed by the developer
- No code, no technical terms beyond basic descriptions

---

## Phase 11 — Apply fixes (unless told to audit-only)

Unless the user says "audit only", after generating the reports apply all fixes:

1. Add missing `aria-label` to icon-only buttons
2. Add `aria-expanded` and `aria-controls` to toggle buttons
3. Fix heading hierarchy violations
4. Add `<label>` associations to unlabelled form inputs
5. Add `role="dialog"` + focus trapping pattern to modals (note: if using shadcn/Radix, check if it's already handled)
6. Replace `outline: none` with visible focus ring alternatives
7. Add `alt` text to images with empty or missing alts
8. Add `@media (prefers-reduced-motion: reduce)` blocks to animations
9. Flag colour contrast failures — list the exact CSS variable or hex change needed (do not change brand colours without confirmation)

After applying fixes, update the report with a "Post-fix" column.

---

## Output

When done, tell the user:
- How many issues were found (by WCAG criterion and severity)
- How many were fixed
- Which issues require design decisions (colour changes, content rewrites) vs pure code fixes
- The path to each report
- Any items that need the designer's input (colour palette changes to meet contrast)
