# claude-code-config

A public, opt-in Claude Code environment: `config/settings.json` linked into
the managed-settings drop-in directory, `config/CLAUDE.md` imported from the
user's CLAUDE.md, and the plugins of `.claude-plugin/marketplace.json`.
`README.md` documents it for users.

- Only what suits anyone who installs it goes here. A preference, a machine, a
  network or a stack belongs in a user's `~/.claude/` or a project's
  `.claude/settings.json`.
- No custom tooling: a need is covered by a native Claude Code feature
  (managed settings, managed CLAUDE.md, plugin, skill) or a maintained tool.
- `config/settings.json` loads at the managed level: a `deny` there can't be
  lifted by any other file. Prefer `ask` unless no legitimate request needs it.
- `config/CLAUDE.md` is loaded in every session of every installer: keep it
  short, general, free of HTML comments (they would reach the console
  `claudeMd`).
- After a change: `jq empty` on every JSON file, `claude plugin validate . --strict`
  and `claude plugin validate ./plugins/engineering-standards --strict`.
- A skill change bumps `version` in the plugin's `plugin.json`, otherwise
  installed copies stay on the old one; tag with `claude plugin tag`.
- CI also runs weekly against the latest Claude Code. GitHub disables
  scheduled workflows in a public repository after 60 days without activity:
  re-enable it in the Actions tab if it stops.
- A machine with the settings installed locks `engineering-standards` through
  managed `enabledPlugins`, so `--plugin-dir` and `claude plugin eval` ignore a
  local copy. Develop and evaluate the plugin on a machine without the link,
  or in CI.
- Every claim about a setting cites its page on code.claude.com/docs in the
  commit message.
- No secret, no personal data.
