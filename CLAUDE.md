# claude-code-config

A public Claude Code environment installed as managed settings; `README.md`
documents it for users.

- Only what suits anyone who installs it goes here. A preference, a machine, a
  network or a stack belongs in a user's `~/.claude/` or a project's
  `.claude/settings.json`.
- No custom tooling: a need is covered by a native Claude Code feature
  (managed settings, managed CLAUDE.md, plugin, skill) or a maintained tool.
- Every rule in `policy/managed-settings.json` binds every installer and can't
  be lifted: prefer `ask` to `deny` unless no legitimate request needs it.
- `policy/CLAUDE.md` is loaded in every session of every installer: keep it
  short, general, free of HTML comments (they would reach the console
  `claudeMd`).
- After a change: `jq empty` on every JSON file, `claude plugin validate . --strict`
  and `claude plugin validate ./plugins/engineering-standards --strict`.
- A skill change bumps `version` in the plugin's `plugin.json`, otherwise
  installed copies stay on the old one; tag with `claude plugin tag`.
- Every claim about a setting cites its page on code.claude.com/docs in the
  commit message.
- No secret, no personal data.
