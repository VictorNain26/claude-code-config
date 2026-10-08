---
name: tests
user-invocable: false
description: What makes a test worth keeping: it is seen failing for the right reason, its expected values come from the requirement, a failing test is never edited to pass, mocks are not the thing under test, external dependencies get a contract test, and code runs before it is called done. Use when writing, changing or reviewing tests, or making a failing test pass.
paths:
  - "**/*.{test,spec}.{ts,tsx,js,jsx,mjs,cjs}"
  - "**/*_test.go"
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/*_test.rs"
  - "**/tests/**"
  - "**/__tests__/**"
  - "**/{vitest,jest,playwright}.config.*"
  - "**/conftest.py"
---

# Tests

Name the breakage before writing the test: which change to production code
would make it fail? Without an answer the test is worth nothing. If it can only
fail on an intentional decision — a constant's value, an exact label — it is a
change detector: it rings on refactors and sleeps through bugs.

See it fail for the right reason. For a bug fix or a change to existing
behavior, run the new test against the code without your change: it must fail
on its assertion, not on an import or a typo. A bug fix starts with that
reproduction test.

The expected value comes from the requirement, not from running the code:
copying today's output into an assertion freezes today's bug. A
characterization test is the exception to both rules: it pins current behavior
before a refactor, so it passes from the start.

A failing test is never edited, skipped or deleted to make it pass, unless the
change you were asked for is what makes it obsolete. The code never
special-cases test inputs. When a test contradicts the requirement or another
test, stop and say which, instead of picking one.

A double is never the thing under test. An assertion on a mock passes because
the mock is there. Assert on real behavior, or don't assert.

Know before you fake. Don't mock an external dependency without checking its
real contract — its type definitions, its code, or a characterization test. A
double built on your understanding of an API cannot reveal that the
understanding is wrong; it is the first cause of green tests on wrong code.

One contract test per external dependency, checking your assumptions against
the installed library, without network. That is where a version bump makes
noise, rather than in production.

Run before saying it's done. A script written and never run is a broken
script: happy path and failure path, at least once each. Unit tests don't
replace that run; they share your assumptions.
