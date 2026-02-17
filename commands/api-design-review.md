Perform a comprehensive API design review for this project and generate a full report. Works for REST APIs, GraphQL APIs, and Next.js/Nuxt/SvelteKit API routes. Follow every step below.

---

## Phase 1 — Discover the API surface

1. Find all API route files:
   - Next.js App Router: `app/api/**/route.ts`
   - Next.js Pages Router: `pages/api/**/*.ts`
   - Next.js Server Actions: files with `"use server"` + exported async functions
   - Express/Fastify/Hono: route registration files
   - tRPC: router definition files
   - GraphQL: schema files (`.graphql`, `.gql`) and resolver files
2. List every endpoint with its method, path, and a brief description of what it does.
3. Identify the authentication/authorisation pattern used.
4. Identify the request/response serialisation format (JSON, FormData, multipart, etc.).

---

## Phase 2 — Naming and URL structure (REST)

For REST APIs, audit every endpoint URL:

| Check | Standard |
|---|---|
| Resource naming | URLs use plural nouns, not verbs: `/users` not `/getUsers`, `/orders/:id` not `/fetchOrder` |
| Consistent casing | URLs use kebab-case: `/payment-methods` not `/paymentMethods` or `/payment_methods` |
| Hierarchy | Nested resources reflect ownership: `/users/:id/orders` for orders belonging to a user |
| Actions on resources | Non-CRUD actions use a verb sub-resource: `POST /orders/:id/cancel` not `PUT /cancelOrder/:id` |
| ID format | IDs in paths should be consistent (all UUIDs, or all numeric, or all slugs — not mixed) |
| Versioning | Is there an API version prefix? (`/api/v1/`) — flag its presence or absence and recommend a strategy |
| Query parameter naming | Consistent casing (prefer camelCase or snake_case — not mixed). Common names: `page`, `limit`, `sort`, `order`, `q`, `filter` |

---

## Phase 3 — HTTP method usage (REST)

| Method | Correct use |
|---|---|
| `GET` | Read-only. Must have no side effects. Must be idempotent and cacheable. |
| `POST` | Create a new resource, or trigger a non-idempotent action. |
| `PUT` | Full replacement of a resource. Idempotent. |
| `PATCH` | Partial update of a resource. |
| `DELETE` | Remove a resource. Idempotent. |

Flag:
- GET requests that create or mutate data
- POST requests used where PUT/PATCH is more appropriate
- DELETE requests that accept a request body (not standard)
- Missing HEAD or OPTIONS support if the API is public

---

## Phase 4 — Request validation

For every endpoint, check:

| Check | What to look for |
|---|---|
| Input validation | Request body, path params, and query params must be validated (Zod, Joi, Yup, class-validator, or manual checks). Flag any endpoint that uses request data without validation. |
| Required vs optional | Is there a clear schema distinguishing required from optional fields? |
| Type coercion | Query params are always strings — are they coerced to numbers/booleans before use? |
| Unknown fields | Is `stripUnknown` / `.strict()` used to reject unexpected fields? (Prevents mass assignment vulnerabilities.) |
| File uploads | Max file size enforced? MIME type validated? (See security-audit for detail.) |
| Validation error format | Validation errors must return `400 Bad Request` with a structured error body — not a raw validation library stack trace. |

---

## Phase 5 — Response design

| Check | Standard |
|---|---|
| Success status codes | `200 OK` for reads, `201 Created` for resource creation, `204 No Content` for deletes with no body. Flag incorrect status codes. |
| Error status codes | `400` bad request, `401` unauthenticated, `403` unauthorised, `404` not found, `409` conflict, `422` unprocessable entity, `429` rate limited, `500` server error. Flag misuse. |
| Consistent response shape | All success responses should follow the same envelope (e.g. `{ data: ... }`) or be bare objects — not mixed. |
| Consistent error shape | All error responses must follow the same shape: `{ error: { code: string, message: string, details?: ... } }`. Flag any that return plain strings or inconsistent structures. |
| No sensitive data leakage | Responses must not include password hashes, internal IDs in unexpected contexts, stack traces, or internal file paths. |
| Pagination | List endpoints returning potentially large datasets must support pagination (`page`/`limit` or cursor-based). Flag any that return unbounded lists. |
| Field selection | Consider whether any list endpoint would benefit from sparse fieldsets (only return fields the client needs). |

---

## Phase 6 — Authentication and authorisation

| Check | What to look for |
|---|---|
| Auth on every mutating endpoint | Every POST/PUT/PATCH/DELETE route must verify authentication. Flag any that don't. |
| Resource ownership | Endpoints that operate on a specific resource (e.g. `/users/:id`, `/orders/:id`) must verify the authenticated user owns or has permission to access that resource. Flag missing ownership checks. |
| Role-based access | If roles exist, are they checked consistently? Hardcoded role strings vs constants? |
| Public endpoints documented | Intentionally public endpoints (health check, webhook receiver, public listing) should be clearly marked. |
| Webhook verification | Webhook receivers must verify the signature (Stripe, GitHub, etc. all provide `X-Signature` headers). |

---

## Phase 7 — Rate limiting and abuse prevention

| Check | Standard |
|---|---|
| Auth endpoints | Login, register, password reset, OTP verification must be rate-limited per IP and/or per user. |
| Resource-intensive endpoints | Search, export, report generation, and bulk operations should be rate-limited. |
| Public endpoints | Any unauthenticated endpoint should be rate-limited. |
| Rate limit headers | APIs should return `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` and `Retry-After` on 429. |
| Idempotency keys | Payment and financial endpoints should support `Idempotency-Key` headers to prevent double-charges. |

---

## Phase 8 — Error handling consistency

Check all API route files for:

- Unhandled promise rejections (missing try/catch around async operations)
- Generic catch blocks that swallow errors silently
- `500` responses that expose internal error messages or stack traces to the client
- Missing error handling for external API calls (what happens if the third-party API is down?)
- No global error handler middleware / Next.js error responses

---

## Phase 9 — Documentation

| Check | What to look for |
|---|---|
| OpenAPI/Swagger spec | Is there an `openapi.yaml` or auto-generated spec? If not, flag it as a recommendation for public APIs. |
| Route-level comments | Complex endpoints benefit from a brief JSDoc comment describing the expected inputs and outputs. |
| Auth requirements documented | Is it clear from the code which endpoints require authentication? |
| Changelog | Breaking changes to the API should be noted in a CHANGELOG. |

---

## Phase 10 — Generate the report

Create `api-design-review-YYYY-MM-DD.md` in the current directory (not committed) with:

```
# API Design Review
**Date:** YYYY-MM-DD
**Endpoints audited:** N
**API style:** REST / GraphQL / tRPC / Mixed

## Summary
Overall assessment and top 3 findings.

## Endpoint inventory
| Method | Path | Auth | Description | Issues |
|---|---|---|---|---|

## Issues

### Critical
- [METHOD /path] Issue description + recommended fix

### High
### Medium
### Low / Design suggestion

## Positive observations

## Recommendations (architectural)
Items that require broader discussion before implementing.
```

---

## Phase 11 — Apply fixes (unless told to review-only)

Unless the user says "review only", apply:

1. Add missing input validation schemas (Zod is preferred if already in the project) to endpoints that have none
2. Fix incorrect HTTP status codes (returning 200 for created resources → 201, etc.)
3. Standardise error response shape to match the most common existing pattern
4. Add missing `await` on async database calls in API routes
5. Add request method guards (return 405 for unhandled methods)
6. Add `.env.example` entries for any new environment variables found in API route code

Do NOT automatically:
- Add rate limiting (requires middleware setup decision)
- Change authentication architecture
- Add pagination to existing endpoints (breaking change — flag and recommend)
- Generate OpenAPI spec (flag and recommend a library)

---

## Output

When done, tell the user:
- Number of endpoints audited
- Top issues found (by category and severity)
- Which were fixed vs flagged
- Whether any breaking-change recommendations exist
- Path to the review report
