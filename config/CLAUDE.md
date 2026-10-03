# Working rules

## Don't reinvent the wheel

Before writing code, a script, a hook or a tool, look for what already exists —
a native feature of the platform, a standard, proven and maintained library or
tool — and use it. Custom code is allowed only when nothing robust covers the
need, and it is then limited to glue between existing pieces. This applies
everywhere: product code, scripts, CI, hooks and Claude Code configuration.

A dependency is adopted only if it is maintained, checked the same day and
cited: repository not archived, a release or a commit on the default branch
within the last six months, issues that get answers, real adoption (stars,
downloads). One that fails a criterion is reported as such, never added
silently. It must also fit the measured need: a robust tool that is too slow
or ill-suited is not the answer.

## Verify before claiming

For non-trivial SDK usage, code that talks to an external API, a third-party
config file, a major version bump and the first use of an SDK in a project,
don't state an API, a behavior or a config field from memory: read the
documentation and cite the URL and the field, or say you don't know.
Elsewhere, say when you are unsure instead of guessing.

Sources, in this order: Context7 MCP when it is installed, the official
documentation, the type definitions of the installed version, web search last.
A commit that changes a config file cites its source.

Never say "done", "green" or "fixed" without having run the validation and read
the exit codes. What did not run is reported as not run.

## Code

- YAGNI. No abstraction, feature flag or compatibility shim for a need that
  doesn't exist; three similar lines beat a premature abstraction.
- No comments by default. A comment only for a non-obvious why — a hidden
  constraint, a subtle invariant, a workaround for a specific bug. Never "added
  for ticket X": that belongs in the PR and in git blame.
- An `eslint-disable` hides the problem instead of solving it: find the code
  shape that doesn't trigger the rule. Same reflex for any obstacle — fix the
  cause, not the symptom.
- Strict validation at the boundaries (user input, external APIs), trust
  between internal functions: no defensive guard between two of your own
  functions.
- What falls outside the requested scope goes in a separate PR.

## Git

- English for code, commits, pull requests and branch names.
- Commits: `<type>(<scope>): <description>`. Types: `feat`, `fix`, `chore`,
  `refactor`, `test`, `docs`, `style`, `perf`, `ci`, `build`.
- A review finding is fixed before the merge, with a regression test when it
  is a bug. Nothing "for later".
- Never `--no-verify` or a skipped hook unless asked: a failing hook is a
  cause to fix. Stage files one by one.
- Confirm before a force push, `reset --hard`, `rm -rf`, dropping a database,
  deleting a remote branch, merging or closing a pull request.

## Human-only actions

2FA, access that requires a human, changes to your own permissions, actions on
a third-party account: say so and give the manual procedure, never a pretend
fix.
