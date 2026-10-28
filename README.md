# Claude Code user configuration

Victor's personal Claude Code configuration, versioned in place in `~/.claude`.

| File | Role |
| - | - |
| `CLAUDE.md` | Instructions loaded in every session |
| `rules/` | Topic rules, loaded on the paths in their frontmatter |
| `settings.json` | Permissions, strict sandbox, plugins, model settings |
| `statusline.sh` | Status line command referenced by `settings.json` |
| `check.sh` | Lists what this machine is missing for `settings.json` to work |

`.gitignore` is a whitelist: the rest of `~/.claude` is data Claude Code writes itself
(transcripts, history, credentials, plugin installs), which must never be committed.
Where each file belongs and how it loads: https://code.claude.com/docs/en/claude-directory

## New machine

1. Put the repository in `~/.claude`, with `gh` signed in:
   - before Claude Code's first launch: `gh repo clone VictorNain26/claude-code-config ~/.claude`
   - if `~/.claude` already exists: `cd ~/.claude && git init -b main && git remote add origin https://github.com/VictorNain26/claude-code-config.git && git fetch origin && git checkout -f main`
2. Start `claude` once: it installs the official marketplace and downloads the plugins
   that `settings.json` enables.
3. Run `~/.claude/check.sh`, install whatever it reports as `MANQUANT`, and run it again
   until it exits cleanly.
