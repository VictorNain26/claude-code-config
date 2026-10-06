# Working rules

## Don't reinvent the wheel

- Don't write code, a script, a hook or a tool before checking for a native
  feature of the platform or a maintained library or tool that covers the
  need. When nothing robust does, custom code stays glue between existing
  pieces. This holds for product code, scripts, CI, hooks and Claude Code
  configuration.
- Don't add a dependency without checking it the same day and citing what you
  checked: repository not archived, a release or a commit on the default branch
  within the last six months, issues that get answers, real adoption (stars,
  downloads). Report one that fails a criterion; never add it silently. Don't
  adopt a robust tool that is too slow or ill-suited to the measured need.

## Verify before claiming

- Don't state an API, a behavior or a config field from memory for
  non-trivial SDK usage, code that talks to an external API, a third-party
  config file, a major version bump or the first use of an SDK in a project:
  read the documentation and cite the URL and the field, or say you don't
  know. Elsewhere, don't guess: say when you are unsure.
- Sources, in this order: Context7 MCP when it is installed, the official
  documentation, the type definitions of the installed version, web search
  last. Don't commit a config file change without citing its source.
- Never say "done", "green" or "fixed" without having run the validation and
  read the exit codes. Never report what did not run as passed: say it did
  not run.

## Code

- No abstraction, feature flag or compatibility shim for a need that doesn't
  exist; three similar lines beat a premature abstraction.
- No comments by default. A comment only for a non-obvious why — a hidden
  constraint, a subtle invariant, a workaround for a specific bug. Never "added
  for ticket X": that belongs in the PR and in git blame.
- No `eslint-disable`: it hides the problem. Find the code shape that doesn't
  trigger the rule. Same for any obstacle: don't work around the symptom, fix
  the cause.
- No defensive guard between two of your own functions: strict validation
  belongs at the boundaries only, user input and external APIs.
- Don't change anything outside the requested scope: it goes in a separate PR.

## Git

- English for code, commits, pull requests and branch names.
- Commits: `<type>(<scope>): <description>`. Types: `feat`, `fix`, `chore`,
  `refactor`, `test`, `docs`, `style`, `perf`, `ci`, `build`.
- Don't merge with a review finding open: fix it first, with a regression test
  when it is a bug. Nothing "for later".
- Never `--no-verify` or a skipped hook unless asked: a failing hook is a
  cause to fix. Never stage everything at once (`git add -A`, `git add .`,
  `git commit -a`): stage files one by one.
- Never start several PRs for one piece of work from the default branch: in a
  cascade, each branch starts from the previous one and each PR targets it.
  Merge bottom-up, retargeting the next PR onto the default branch after each
  merge.
- Confirm before a force push, `reset --hard`, `rm -rf`, dropping a database,
  deleting a remote branch, merging or closing a pull request.

## Human-only actions

Never pretend to fix 2FA, access that requires a human, changes to your own
permissions or actions on a third-party account: say so and give the manual
procedure.
