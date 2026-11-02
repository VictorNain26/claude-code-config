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

## New machine

1. No `~/.claude` yet: `gh repo clone VictorNain26/claude-code-config ~/.claude`.
   An existing `~/.claude`: `cd ~/.claude && git init -b main && git remote add origin https://github.com/VictorNain26/claude-code-config.git && git pull origin main`.
   Git refuses to overwrite existing files and lists them: move them aside, merge what
   you want to keep, and run the pull again.
2. Install the `victorserv` wrapper as its repository's README says (`VictorNain26/victorserv`,
   `bin/victorserv`). `settings.json` allows `victorserv claude *` outside the sandbox and trusts
   that exact script.
3. Start `claude`. It installs the official marketplace and the plugins `settings.json` enables.
4. Check what the machine is missing with Claude Code's own diagnostics: `/doctor`,
   `/sandbox` (Dependencies tab) and `/plugin` (Errors tab, which names missing LSP binaries).
