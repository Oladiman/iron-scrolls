Perform a thorough code review of the current pull request or the changes since the last commit on this branch, and generate a structured review report. Follow every step below.

---

## Phase 1 — Understand the change

1. Run `git log main..HEAD --oneline` (or `git log origin/main..HEAD --oneline`) to list all commits on this branch.
2. Run `git diff main...HEAD --stat` to get a file-by-file summary of what changed.
3. Read the PR title and description if available (`gh pr view` if the gh CLI is available).
4. Identify the category of change: new feature, bug fix, refactor, performance improvement, dependency update, docs, config change, or mixed.
5. List the files changed. Group them by concern (e.g. "UI components", "API routes", "tests", "config").

---

## Phase 2 — Correctness review

For every changed file, check:

| Check | What to look for |
|---|---|
| Logic correctness | Does the code do what the PR description says it does? Are there obvious off-by-one errors, wrong conditions, or incorrect data transformations? |
| Edge cases | Are null/undefined values handled? What happens with empty arrays, zero values, empty strings? |
| Error handling | Are errors caught and handled appropriately? Are `async/await` calls wrapped in try/catch or using `.catch()`? |
| Race conditions | Is there shared state that could be mutated concurrently? Are database writes atomic where they need to be? |
| Data integrity | Are there mutations that could leave data in a partially-updated state if an error occurs mid-operation? |
| Type safety | If TypeScript, are there `any` types, unchecked type assertions (`as SomeType`), or missing null checks? |
| Return values | Are all code paths guaranteed to return a value? Are promises always awaited? |

---

## Phase 3 — Security review

| Check | What to look for |
|---|---|
| New user input | Any new input from the user or external source must be validated and sanitised before use. |
| New API endpoints | Must have authentication and authorisation checks. |
| New database queries | Must use parameterised queries / ORM — no string concatenation with user data. |
| Secrets | No new hardcoded credentials, API keys, or private values. |
| Permissions | New file operations, system calls, or external HTTP requests — are they scoped appropriately? |
| Dependency additions | New packages in `package.json` — check for known CVEs, maintenance status, and package size impact. |

---

## Phase 4 — Performance review

| Check | What to look for |
|---|---|
| N+1 queries | Loops that make database calls per iteration. Should use batch queries or include/join. |
| Missing indexes | New query patterns on columns that likely lack an index (e.g. filtering by email, username, foreign keys). |
| Unnecessary re-renders | In React: state updates in loops, missing `useMemo`/`useCallback` for expensive operations passed as props, missing keys on list items. |
| Synchronous blocking | CPU-intensive operations on the main thread / event loop — should be deferred or offloaded. |
| New images without optimisation | Unoptimised images added to the repo or referenced without `next/image` / lazy loading. |
| Bundle size | New large dependencies added without a dynamic import for lazy loading. |

---

## Phase 5 — Code quality review

| Check | What to look for |
|---|---|
| Naming | Variable, function, and component names should be clear and consistent with the codebase convention (camelCase, PascalCase, snake_case — match what's already there). |
| Function length | Functions longer than ~50 lines are a candidate for decomposition. Flag but don't force-split. |
| Duplication | Code that already exists elsewhere in the codebase and is being duplicated rather than reused. |
| Dead code | Variables declared but never used. Functions defined but never called. Commented-out code blocks. |
| Magic numbers/strings | Literal values (e.g. `3600`, `"admin"`) used without a named constant. |
| Console/debug statements | `console.log`, `console.error`, `debugger` left in production code. |
| TODO comments | New `TODO`/`FIXME` comments — note them; they should be tracked as issues, not left in code. |

---

## Phase 6 — Test review

| Check | What to look for |
|---|---|
| Test coverage | Does the PR include tests for new functionality? If not, flag the untested paths. |
| Test quality | Are the tests testing behaviour or implementation details? Brittle snapshot tests, tests that mock everything, tests that only verify the mock was called. |
| Edge case tests | Are error paths, empty states, and boundary values tested? |
| Test naming | Do test names describe what the test verifies in plain language? |
| Existing test breakage | Do any existing tests fail with this change? If no test runner output is available, identify which existing tests are likely affected by the changed code. |

---

## Phase 7 — Consistency and conventions review

| Check | What to look for |
|---|---|
| Formatting | Code formatting should match the project's style (Prettier, ESLint). Flag obvious violations but don't nitpick minor style differences. |
| Import order | New imports should follow the project's existing import ordering convention. |
| Component patterns | New components should follow the same pattern as existing ones (prop interfaces, file structure, export style). |
| API response shape | New API endpoints should return responses in the same shape as existing endpoints. |
| Error response shape | Error responses must follow the existing error schema. |
| Commit messages | Do the commits in this PR follow the project's conventions? |

---

## Phase 8 — Documentation review

| Check | What to look for |
|---|---|
| README | Does the PR introduce new env vars, new commands, new setup steps, or new behaviour that the README doesn't mention? |
| Code comments | Complex logic should have a brief comment explaining *why* (not *what* — the code shows what). |
| Type documentation | Exported TypeScript types, interfaces, and public function signatures benefit from a JSDoc comment if not self-evident. |
| CHANGELOG | If the project has a CHANGELOG, was it updated? |

---

## Phase 9 — Generate the review report

Create a file `pr-review-YYYY-MM-DD-<branch-name>.md` in the current directory (not committed) with:

### Structure:

```
# PR Review: <branch name>
**Date:** YYYY-MM-DD
**Files changed:** N
**Commits:** N

## Summary
One paragraph describing what this PR does and the overall assessment (Approved / Approved with suggestions / Changes requested).

## Issues

### Critical (must fix before merge)
- [file:line] Description of the issue + recommended fix

### High (strongly recommended)
- [file:line] Description + fix

### Medium (suggested improvement)
- [file:line] Description + fix

### Low / nitpick (optional)
- [file:line] Description

## Positive observations
Brief notes on things done well — good patterns, clean abstractions, good test coverage, etc.

## Checklist
- [ ] Logic correct
- [ ] Edge cases handled
- [ ] Security: no new injection vectors
- [ ] Security: no hardcoded secrets
- [ ] Performance: no N+1 queries
- [ ] Tests present and meaningful
- [ ] No debug statements
- [ ] README updated if needed
```

---

## Phase 10 — Apply fixes (unless told to review-only)

Unless the user says "review only":

1. Fix all Critical issues automatically if the fix is clear and localised (dead code removal, missing null check, console.log removal, missing await, obvious off-by-one).
2. Fix High issues if they are safe and non-architectural (add missing error handling, fix type assertion, add input validation to a new endpoint).
3. Leave Medium and Low issues as annotations in the report — do not auto-change style or naming.
4. For any issue requiring architectural change or broader refactor, leave a detailed recommendation in the report only.

After applying fixes, update the report with a "Fixed" / "Flagged" / "Recommendation" column.

---

## Output

When done, tell the user:
- The overall assessment (Approved / Approved with suggestions / Changes requested)
- Count of issues by severity
- Which were fixed vs flagged
- The path to the review report
- Any blockers that should prevent merging
