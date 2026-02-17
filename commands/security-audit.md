Perform a comprehensive security audit of this web project and generate a full HTML report. Follow every step below.

---

## Phase 1 — Discover the project

1. Identify the framework, version, and runtime from `package.json`.
2. Identify the deployment target and environment (Vercel, AWS, Docker, etc.) from config files.
3. Identify the authentication library in use (NextAuth, Clerk, Auth0, Supabase, custom JWT, etc.).
4. Identify the database layer (Prisma, Drizzle, raw SQL, Supabase, Mongoose, etc.).
5. List all API routes, server actions, and server-side data fetching functions.

---

## Phase 2 — Audit for secrets and credential exposure

Scan every tracked file (never scan `.env` — it should not be in git) for:

| Issue | What to look for |
|---|---|
| Hardcoded API keys | Strings matching patterns like `sk_live_`, `pk_live_`, `AIza`, `ghp_`, `xox`, bearer tokens, private key blocks |
| Connection strings | `mongodb+srv://`, `postgresql://`, `mysql://` with credentials embedded |
| Private keys | `-----BEGIN RSA PRIVATE KEY-----`, `-----BEGIN EC PRIVATE KEY-----` |
| JWT secrets | Variables named `JWT_SECRET`, `SECRET_KEY`, etc. assigned literal string values in code (not from `process.env`) |
| `.env` committed | Check `.gitignore` — if `.env`, `.env.local`, `.env.production` are not listed, flag as Critical |
| Secrets in client bundle | `NEXT_PUBLIC_*` variables that contain private API keys (these are embedded in the browser bundle) |

---

## Phase 3 — Audit authentication and authorisation

| Check | What to look for |
|---|---|
| Protected routes | Every page/API route that requires auth must verify the session server-side. Flag any route that relies only on client-side redirects. |
| Authorisation checks | Does each API endpoint check that the authenticated user is authorised for the requested resource? Check for missing ownership checks (e.g. `GET /api/orders/:id` — is the order verified to belong to the requesting user?). |
| Session handling | Sessions must be HTTP-only cookies or stored server-side. JWT in localStorage is a flag. Token expiry must be set. |
| Password handling | Passwords must be hashed (bcrypt, argon2, scrypt). Plain-text or MD5/SHA1 hashes are Critical. |
| OAuth state parameter | OAuth flows must use a CSRF `state` parameter. |
| Rate limiting | Auth endpoints (`/api/auth/signin`, `/api/auth/register`, password reset) must have rate limiting. |

---

## Phase 4 — Audit for injection vulnerabilities

### SQL injection
- Scan all database queries for string concatenation or template literals that include user input.
- Parameterised queries / prepared statements / ORM query builders are safe. Raw string builds are not.
- Example of vulnerable pattern: `` db.query(`SELECT * FROM users WHERE id = ${userId}`) ``

### NoSQL injection
- In MongoDB/Mongoose, check that user input is not passed directly as a query object.
- Vulnerable: `User.find({ username: req.body.username })` when `username` could be `{ $gt: "" }`.

### Command injection
- Check for `exec()`, `spawn()`, `eval()`, `Function()` calls that include user input.

### LDAP, XPath, XML injection
- Flag any LDAP queries or XML parsing that includes unsanitised user input.

---

## Phase 5 — Audit for XSS vulnerabilities

| Check | What to look for |
|---|---|
| `dangerouslySetInnerHTML` | Every use must sanitise input with DOMPurify or equivalent before rendering. Flag any direct use with user data. |
| `innerHTML` in vanilla JS | Same — must be sanitised. |
| Unescaped user content in templates | Server-rendered templates (EJS, Handlebars, Pug) must escape user data. Check for `{{{ }}}` (triple-brace unescaped) in Handlebars. |
| `href` from user input | A `href` set to user input can be `javascript:alert(1)`. Must be validated as a real URL. |
| `eval()` with user data | Flag any eval of user-controlled strings. |
| `postMessage` without origin check | `window.addEventListener('message', ...)` must check `event.origin`. |

---

## Phase 6 — Audit HTTP security headers

Check `next.config.js`, `vercel.json`, `netlify.toml`, `_headers`, or middleware for these headers:

| Header | Required value |
|---|---|
| `Content-Security-Policy` | Must exist and restrict `script-src`, `style-src`, `img-src`. Flag if missing entirely. |
| `X-Frame-Options` | `DENY` or `SAMEORIGIN` to prevent clickjacking |
| `X-Content-Type-Options` | `nosniff` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` or stricter |
| `Permissions-Policy` | Restrict camera, microphone, geolocation to only what's needed |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` (HTTPS only) |

Flag any missing headers as Medium severity. Missing CSP is High.

---

## Phase 7 — Audit CSRF protection

- API routes that mutate state (POST, PUT, PATCH, DELETE) must be protected against CSRF.
- In Next.js App Router, server actions are automatically CSRF-protected by the framework. Standard API routes are not — check for CSRF tokens or `SameSite=Strict` cookies.
- Check that forms POST to the same origin and don't rely on GET requests for mutations.

---

## Phase 8 — Audit dependency vulnerabilities

Run and interpret:

```bash
npm audit --audit-level=moderate
```

- List all vulnerabilities found: package name, vulnerability type, severity, fix available (yes/no).
- Flag Critical and High severity as action required.
- Check if any dependency is more than 2 major versions behind its latest release.
- Check for packages that have been deprecated or abandoned (no commits in 2+ years with open CVEs).

---

## Phase 9 — Audit file upload handling (if applicable)

If the project accepts file uploads:

| Check | Standard |
|---|---|
| File type validation | Must check MIME type server-side (not just client-side). Extension check alone is insufficient. |
| File size limits | Must enforce maximum file size server-side. |
| Storage location | Uploaded files must not be stored in a publicly accessible directory without access control. Never execute uploaded files. |
| Filename sanitisation | User-supplied filenames must be sanitised before use in file paths (path traversal: `../../etc/passwd`). |
| Malware scanning | For production apps handling untrusted uploads, flag the absence of malware scanning as a recommendation. |

---

## Phase 10 — Audit environment variable handling

- Every secret used in the codebase must come from `process.env` or equivalent — never hardcoded.
- All required environment variables must be documented in `.env.example` (with placeholder values, not real ones).
- Check that `.env.example` exists. If it doesn't, flag it and create one listing every `process.env.X` reference found in the codebase.
- `NEXT_PUBLIC_*` variables are bundled into the client — verify none of them contain secrets.
- Flag any `process.env` access without a fallback or validation at startup (missing env vars should fail loudly at boot, not silently at runtime).

---

## Phase 11 — Generate HTML reports

Create two reports in the `reports/` folder (create it if it doesn't exist):

### Report 1: `security-audit-YYYY-MM-DD.html` (Technical — for the developer)

Include:
- Date of audit
- Executive summary: critical / high / medium / low counts
- Per-issue detail: OWASP category, file path, line reference, vulnerable code snippet, recommended fix
- Dependency vulnerability table (from `npm audit` output)
- Security headers gap table: header, current status, required value
- `.env.example` status
- Severity colour coding (red / orange / yellow / green)

### Report 2: `security-owner-report-YYYY-MM-DD.html` (Plain English — for the stakeholder)

Include:
- What security means for this application and its users
- Risk summary: data at risk, attack surface, compliance implications (GDPR if EU users)
- Traffic-light summary: user data protection, authentication strength, dependency health, secrets management
- Top 3 risks explained in plain English
- What the developer will fix
- No code, no CVE numbers, no jargon

---

## Phase 12 — Apply fixes (unless told to audit-only)

Unless the user says "audit only", apply:

1. Add all missing environment variable names to `.env.example` (with `=` and a placeholder comment)
2. Add `.env`, `.env.local`, `.env.production`, `.env*.local` to `.gitignore` if missing
3. Add missing security headers to `next.config.js` headers config (or `middleware.ts`)
4. Fix `dangerouslySetInnerHTML` uses — wrap with DOMPurify sanitisation
5. Fix `href` from user input — add URL validation
6. Add `SameSite=Strict` to session cookie config if not set

Do NOT automatically:
- Change authentication architecture (flag and recommend)
- Fix SQL injection in raw queries without confirming the ORM migration path
- Remove or change functionality to fix authorisation gaps (flag with exact recommendation)
- Run `npm audit fix` automatically (can introduce breaking changes — show the command and recommend running manually)

After applying safe fixes, update the report with a "Post-fix" column.

---

## Output

When done, tell the user:
- How many vulnerabilities were found (by OWASP category and severity)
- How many were fixed vs flagged for manual review
- Whether any Critical issues (hardcoded secrets, missing auth, SQL injection) were found
- The path to each report
- Any items that require architectural decisions
