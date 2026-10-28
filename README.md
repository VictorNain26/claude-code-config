# Claude Code user configuration

Victor's personal Claude Code configuration, versioned in place in `~/.claude`.

| File | Role |
| - | - |
| `CLAUDE.md` | Instructions loaded in every session |
| `rules/` | Topic rules, loaded on the paths in their frontmatter |
| `settings.json` | Permissions, strict sandbox, plugins, model settings |
| `statusline.sh` | Status line command referenced by `settings.json` |

`.gitignore` is a whitelist: the rest of `~/.claude` is data Claude Code writes itself
(transcripts, history, credentials, plugin installs), which must never be committed.
Where each file belongs and how it loads: https://code.claude.com/docs/en/claude-directory
