---
name: tests
user-invocable: false
description: What makes a test worth keeping: a bug fix starts with a test seen failing, expected values come from the requirement, a failing test is not edited to pass unless the requested change made it obsolete, mocks are not the thing under test, external dependencies get a contract test, and code runs before it is called done. Use when writing, changing or reviewing tests, or making a failing test pass.
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
because the behavior is missing, not because of a mistake in the test. A bug
fix starts with that reproduction test.

The expected value comes from the requirement, not from running the code:
copying today's output into an assertion freezes today's bug.

A characterization test, which pins current behavior before a refactor, is
exempt from both rules: it passes from the start, and today's output is its
expected value.

A failing test is never edited, skipped or deleted to make it pass, and the
code never special-cases test inputs. When the change you were asked for makes
a test obsolete, update it and say so. When a test contradicts the requirement
for any other reason, stop and say which, instead of picking one.

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
