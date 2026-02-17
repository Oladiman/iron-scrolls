Perform a comprehensive test coverage audit of this codebase and write all missing tests. Follow every step below.

You can run a subset of phases by including a range in the command, e.g. `/test-coverage --phase 1-3` to run only discovery and mapping phases without writing tests.

---

## Phase 1 — Discover the testing setup

1. Identify the test runner and framework from `package.json` (Jest, Vitest, Playwright, Cypress, Testing Library, etc.).
2. Identify the test configuration file (`jest.config.ts`, `vitest.config.ts`, `playwright.config.ts`, etc.).
3. Identify the coverage provider and thresholds configured (Istanbul/V8, `coverageThreshold` settings).
4. Identify the test file convention used in this project:
   - Co-located (`*.test.ts` / `*.spec.ts` next to source files)?
   - `__tests__/` directories?
   - Separate `tests/` or `test/` root directory?
5. List all existing test files and the source files they correspond to.
6. List source files that have no corresponding test file at all.

---

## Phase 2 — Run coverage and parse the report

1. Run the coverage command appropriate to the project:
   - Jest: `npx jest --coverage --coverageReporters=json-summary`
   - Vitest: `npx vitest run --coverage`
   - If neither is set up, skip to Phase 3 and note that coverage cannot be measured programmatically.
2. Parse the coverage summary output. For each source file record:
   - Statement coverage %
   - Branch coverage %
   - Function coverage %
   - Line coverage %
3. Identify files with less than 80% coverage as under-covered.
4. Identify the specific uncovered lines and branches from the coverage JSON (look for `0` in the `s` / `b` / `f` maps).

---

## Phase 3 — Map every untested code path

For each source file (prioritising files with <80% coverage and files with zero tests), read the file and identify:

| Code path type | What to find |
|---|---|
| Happy path | The normal successful execution path — is it covered? |
| Error paths | Every `catch` block, error return, thrown error — is each one tested? |
| Conditional branches | Every `if`/`else`, ternary, `switch` case, `??`, `&&`, `\|\|` — both branches tested? |
| Edge cases | Empty input, zero values, `null`/`undefined`, empty arrays, empty strings, boundary values |
| Async paths | Promise rejections, timeout paths, retry logic |
| Guard clauses | Early returns — are the conditions that trigger them tested? |
| Side effects | Calls to external services, database writes, event emissions — are they verified? |

List each untested path with the file, line range, and a one-line description of what it does.

---

## Phase 4 — Prioritise what to test

Rank untested paths by risk and value:

**P0 — Must test (business-critical):**
- Authentication and authorisation logic
- Payment processing and financial calculations
- Data mutations (create, update, delete operations)
- User-facing error messages and validation

**P1 — Should test (correctness-critical):**
- All utility functions and pure functions
- API route handlers (happy path + error path)
- Form validation logic
- Data transformation functions

**P2 — Good to test (regression value):**
- UI component rendering with different prop combinations
- Hook behaviour under state changes
- Loading and empty states in components

**P3 — Optional (low ROI):**
- Trivial getters/setters
- Pure presentational components with no logic
- Third-party library wrappers that add no logic

Produce a prioritised list before writing any tests.

---

## Phase 5 — Write missing unit tests

For each P0 and P1 untested path (and P2 if coverage is below 60%):

1. Write tests using the existing testing framework and testing library already in use (do not introduce new test libraries).
2. Follow the existing test file conventions in the project (file location, naming, import style, `describe`/`it`/`test` style preference).
3. Use the existing mock/stub patterns already present in the project (manual mocks in `__mocks__/`, `vi.mock`, `jest.mock`, MSW, etc.).

### Test structure standards:
- Each test must have a single, clear assertion target (no "test everything" tests).
- Test names must be human-readable: `it("returns null when the user has no active subscription")` not `it("works")`.
- Arrange / Act / Assert pattern — keep each section visually distinct.
- Mock external dependencies (databases, APIs, email services) — tests must not make real network calls.
- Do not test implementation details (don't assert that a specific private function was called — assert the observable output).

### For each test file written, cover:
- Happy path (the normal successful case)
- At least two error paths or edge cases
- Any conditional branches that aren't trivially obvious

---

## Phase 6 — Write missing integration tests (if integration test suite exists)

If the project has an existing integration or API test suite (Supertest, Playwright API testing, Cypress API commands):

1. Identify API endpoints with no integration test.
2. For each untested endpoint write tests that:
   - Call the real handler (not mocked)
   - Test with valid input (expect 200/201)
   - Test with invalid input (expect 400 with a validation error body)
   - Test with missing auth (expect 401)
   - Test ownership enforcement (authenticated as wrong user, expect 403)
3. Use the existing test database setup / teardown pattern in the project.

If no integration test suite exists, note this in the report as a recommendation — do not create one from scratch.

---

## Phase 7 — Write missing component tests (if UI component test suite exists)

If the project has existing component tests (Testing Library, Storybook interaction tests, Cypress component tests):

1. Identify UI components with logic that has no test:
   - Conditional rendering (`isLoading`, `isEmpty`, `isError` states)
   - User interactions (click handlers, form submit, keyboard events)
   - Props that change the component's behaviour
2. Write tests that render the component with the relevant props and assert the DOM output or behaviour.
3. Use `userEvent` over `fireEvent` for interaction tests.
4. Do not test styling or class names — test behaviour.

If no component test suite exists, note this in the report as a recommendation — do not create one from scratch.

---

## Phase 8 — Generate the coverage report

Create a file `test-coverage-YYYY-MM-DD.md` in the current directory (not committed) with:

```
# Test Coverage Report
**Date:** YYYY-MM-DD
**Test runner:** [Jest/Vitest/Playwright/etc.]
**Coverage before:** statements X% | branches X% | functions X% | lines X%
**Coverage after:** (re-run coverage after writing tests)

## Summary
One paragraph on the overall state of test coverage and the highest-risk gaps found.

## Files with zero tests
| File | Lines of logic | Risk |
|---|---|---|

## Coverage gaps addressed
| File | Path description | Test written | Priority |
|---|---|---|---|

## Coverage gaps remaining (P2/P3 — not auto-written)
| File | Path description | Why skipped |
|---|---|---|

## Recommendations
- Any missing test infrastructure (integration suite, component suite, coverage thresholds)
- Patterns that make code hard to test (tight coupling, no dependency injection)
- Suggested coverage threshold settings for `jest.config.ts` / `vitest.config.ts`
```

---

## Phase 9 — Enforce coverage thresholds (if not already configured)

If no `coverageThreshold` is set in the project's test config:

1. Based on the coverage achieved after writing tests, suggest thresholds at 5% below the current level (safe floor to prevent regressions without requiring a perfect baseline).
2. Add the threshold config to `jest.config.ts` / `vitest.config.ts` as a commented-out block with a note to uncomment when the team agrees on the level.
3. Do NOT enforce thresholds that would immediately break CI — the goal is to prevent regressions, not block current builds.

---

## Output

When done, tell the user:
- Coverage before and after (statements, branches, functions, lines)
- Count of test files created and tests written
- Count of P0/P1 paths covered vs remaining
- Files that still have zero tests (if any) and why they were skipped
- The path to the coverage report
- Any recommendations for test infrastructure improvements
