# claude-code-config

A ready-to-use [Claude Code](https://code.claude.com/docs) environment you opt
into: safe permission defaults, shared working rules, and skills that load
only on the files they apply to. Install it once; `git pull` keeps it current.

Use it as is, or fork it for your team.

## What you get

| Path | Contents | How Claude Code loads it |
|---|---|---|
| `config/settings.json` | permissions, bypass mode disabled, the plugin below | a settings file linked into the managed-settings drop-in directory ([managed-settings](https://code.claude.com/docs/en/managed-settings)) |
| `config/sandbox.json` | OS-level sandbox for shell commands, with registry and GitHub hosts allowed and read-only Docker commands excluded | a second drop-in, linked only where the sandbox works (see [step 1b](#install)) ([sandboxing](https://code.claude.com/docs/en/sandboxing)) |
| `config/CLAUDE.md` | working rules: reuse before writing, verify before claiming, code and git conventions | imported from your own `~/.claude/CLAUDE.md` ([memory](https://code.claude.com/docs/en/memory)) |
| `plugins/engineering-standards/` | skills `ui-design`, `tests`, `third-party-config`, each loaded when Claude reads or edits matching files | plugin from this repository's marketplace |

Permissions, in short:

- **allow without asking**: test, lint, build, format, typecheck and dev
  scripts of pnpm and bun, pytest/ruff/mypy through uv; installing from the
  lockfile (`pnpm install`, `bun install`, `uv sync`, all without a package
  argument); `git fetch`, `git pull`, commits, cherry-picks, new branches and
  worktrees; read-only `gh` and `glab`; Docker builds, logs and inspection.
  Read-only git and shell commands need no rule: Claude Code runs them without
  a prompt ([permissions](https://code.claude.com/docs/en/permissions)).
- **ask first** — rare, irreversible or public actions only: force pushes and
  remote branch deletion, local branch and tag deletion, `--no-verify`;
  adding, removing or upgrading a dependency; `dlx`/`bunx`; `docker exec`;
  publishing and releases; merging or closing a PR/MR; reading or editing a
  project `.npmrc`; editing shell startup files. Everyday actions such as
  pushing, opening a PR, `reset --hard` or `rm -r` are left to the permission
  mode: in auto mode, the default, Claude Code's classifier already blocks the
  destructive forms ([permission-modes](https://code.claude.com/docs/en/permission-modes)).
- **deny**: secret files — in the project, `.env` and `.env.*` (templates
  such as `.env.example`, `.sample`, `.template`, `.dist` stay readable),
  `.envrc`, `*.pem`, `*.key`, `*.p12`, `credentials.json`, `secrets.*`; in your
  home directory, `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.azure`, `~/.kube`, the `gh`
  and `gcloud` configs, `~/.docker/config.json`, `~/.git-credentials`,
  `~/.netrc`, `~/.npmrc`, `~/.pypirc`, `~/.claude/.credentials.json`. Claude
  can't read, create or edit them; you do. Also `mkfs`, `dd`, `chmod 777`.

In auto mode, Claude Code drops broad allow rules such as package-manager run
commands and lets its classifier decide instead
([permission-modes](https://code.claude.com/docs/en/permission-modes)), so
some "allow" entries only save prompts in the other modes.

## Requirements

- [Claude Code](https://code.claude.com/docs/en/setup), recent; tested with 2.1.288.
- `git`. Administrator rights for the settings link (see
  [without admin rights](#without-admin-rights) otherwise).
- A machine whose organization pushes its own managed settings (claude.ai
  console or MDM) ignores this drop-in by default: Claude Code applies only the
  highest-ranked managed source
  ([managed-settings](https://code.claude.com/docs/en/managed-settings)). Use
  [without admin rights](#without-admin-rights) there.

## Install

Clone the repository where it will stay — the install points at this
directory:

```bash
git clone https://github.com/VictorNain26/claude-code-config.git
cd claude-code-config
```

**1. Settings** — link `config/settings.json` into the drop-in directory.

Linux and WSL:

```bash
sudo mkdir -p /etc/claude-code/managed-settings.d
sudo ln -sf "$PWD/config/settings.json" /etc/claude-code/managed-settings.d/50-claude-code-config.json
```

macOS:

```bash
D="/Library/Application Support/ClaudeCode/managed-settings.d"
sudo mkdir -p "$D"
sudo ln -sf "$PWD/config/settings.json" "$D/50-claude-code-config.json"
```

Windows, PowerShell as administrator (a copy: run it again after each
`git pull`):

```powershell
$D = "C:\Program Files\ClaudeCode\managed-settings.d"
New-Item -ItemType Directory -Force $D | Out-Null
Copy-Item config\settings.json "$D\50-claude-code-config.json"
```

**1b. Sandbox — macOS and native Linux only.** Link `config/sandbox.json`
next to the settings. On Linux, install `bubblewrap` and `socat` first
(`sudo apt-get install bubblewrap socat`), and on Ubuntu 24.04+ follow the
AppArmor step of the [sandboxing page](https://code.claude.com/docs/en/sandboxing).

```bash
sudo ln -sf "$PWD/config/sandbox.json" /etc/claude-code/managed-settings.d/51-claude-code-config-sandbox.json
# macOS: same link in "/Library/Application Support/ClaudeCode/managed-settings.d"
```

Skip this step on WSL2 for now: with Claude Code 2.1.288, the first network
connection of each sandboxed command fails (`Failed to connect to localhost
port 3128`), so `git fetch` and similar commands fail at random. Skip it on
native Windows and WSL1, where the sandbox doesn't run. Without the link, the
permission rules still apply.

With the sandbox on, a command can't reach a server started outside it, such
as a dev server or a database in a container: on Linux a sandboxed command's
`localhost` is its own. Claude Code then offers to rerun the command outside
the sandbox, through your permission mode.

**2. Working rules** — import `config/CLAUDE.md` from your own CLAUDE.md.
Spaces in the path must be escaped with a backslash, or the import is ignored
([memory](https://code.claude.com/docs/en/memory#import-additional-files)).

macOS, Linux and WSL:

```bash
mkdir -p ~/.claude
printf '\n@%s/config/CLAUDE.md\n' "$(pwd | sed 's/ /\\ /g')" >> ~/.claude/CLAUDE.md
```

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude" | Out-Null
$p = (Get-Location).Path -replace '\\','/' -replace ' ','\ '
Add-Content -Encoding utf8 "$HOME\.claude\CLAUDE.md" "`n@$p/config/CLAUDE.md"
```

**3. Start Claude Code.** The first session registers the marketplace and
installs the plugin; it loads from the next start.

**Optional — Context7.** `config/CLAUDE.md` tells Claude to look library
documentation up in [Context7](https://github.com/upstash/context7) when it is
installed. It is a hosted MCP server: the library names and questions go to
Upstash. To add it:

```bash
claude plugin install context7@claude-plugins-official
```

### Without admin rights

Copy the keys of `config/settings.json` into `~/.claude/settings.json`,
appending to the lists already there, and do step 2. Repeat the copy when
`config/settings.json` changes.

### For an organization

A drop-in linked to a user-writable clone is a convenience, not enforcement.
To enforce the configuration across a fleet, [fork](#make-it-yours) the
repository first — otherwise every machine follows this one's plugin updates —
or pin the marketplace `source` to a tag with `ref`
([marketplace-reference](https://code.claude.com/docs/en/plugins/marketplace-reference#marketplace-sources)).
Then:

- **Claude Team or Enterprise**: an Owner pastes the output of this command into
  [Admin Settings > Claude Code > Managed settings](https://claude.ai/admin-settings/claude-code):

  ```bash
  jq --rawfile md config/CLAUDE.md 'del(."$schema") + {claudeMd: $md}' config/settings.json
  ```

  Machines that sign in another way (another organization's API key,
  Bedrock, Vertex, a custom base URL) don't fetch it: give them the file
  install too ([admin-setup](https://code.claude.com/docs/en/admin-setup)).
- **File or MDM**: copy `config/settings.json` into `managed-settings.d/` and
  `config/CLAUDE.md` to the managed CLAUDE.md path (`/etc/claude-code/CLAUDE.md`,
  `/Library/Application Support/ClaudeCode/CLAUDE.md`,
  `C:\Program Files\ClaudeCode\CLAUDE.md`), or deliver them through MDM
  ([managed-settings](https://code.claude.com/docs/en/managed-settings)).

## Verify

- `claude doctor` reports no `Invalid settings` for the linked file.
- In a session, `/status` lists `Enterprise managed settings` under
  `Setting sources` with `(drop-ins)`, and no `Skipped sources` line names it.
- `/plugin` shows `engineering-standards@claude-code-config` installed and
  enabled.
- Ask Claude what its working rules say about reusing existing tools: it
  quotes the "Don't reinvent the wheel" section of `config/CLAUDE.md`.

## Update

```bash
git pull
```

Settings and working rules follow the clone at the next session (copy again
on Windows). The plugin updates in the background and the new version loads at
the following launch
([plugins/loading](https://code.claude.com/docs/en/plugins/loading)). Changes
are listed in the
[commit history](https://github.com/VictorNain26/claude-code-config/commits/master).

## Uninstall

Remove the settings link, the plugin and its marketplace:

```bash
sudo rm -f /etc/claude-code/managed-settings.d/50-claude-code-config.json /etc/claude-code/managed-settings.d/51-claude-code-config-sandbox.json
claude plugin marketplace remove claude-code-config
```

On macOS, remove `/Library/Application Support/ClaudeCode/managed-settings.d/50-claude-code-config.json`;
on Windows, `Remove-Item "C:\Program Files\ClaudeCode\managed-settings.d\50-claude-code-config.json"`
as administrator. Then delete the `@…/config/CLAUDE.md` line from
`~/.claude/CLAUDE.md`.

### Upgrading from the `team-config` layout

Installs made before October 2026 used `managed-settings.d/50-team.json`, a
copied managed `CLAUDE.md` and the `team-config` marketplace. Remove them, then
install as above:

```bash
sudo rm /etc/claude-code/managed-settings.d/50-team.json /etc/claude-code/CLAUDE.md
claude plugin marketplace remove team-config
```

## Make it yours

- **Your preferences** — language, theme, effort, status line, default
  permission mode, your own MCP servers — go in `~/.claude/settings.json` and
  `~/.claude/CLAUDE.md`. Lists combine across files
  ([settings](https://code.claude.com/docs/en/settings)): you can add `allow`,
  `ask` and `deny` rules, and yours apply alongside these.
- **Auto mode** only trusts the working repository and its remotes. Describe
  your source-control org, internal domains and services in `autoMode.environment`,
  starting with `"$defaults"`
  ([auto-mode-config](https://code.claude.com/docs/en/auto-mode-config#define-trusted-infrastructure)).
- **Stack-specific permissions** belong in each project's committed
  `.claude/settings.json`.
- **A fork for your team**: point `extraKnownMarketplaces.claude-code-config.source`
  at it — `{"source": "github", "repo": "your-org/claude-code-config"}`, or for
  GitLab and other hosts `{"source": "git", "url": "https://gitlab.example.com/group/claude-code-config.git"}`
  ([marketplace-reference](https://code.claude.com/docs/en/plugins/marketplace-reference#marketplace-sources)).
  A private fork needs git read access without a prompt on every machine, for
  example `gh auth login && gh auth setup-git`
  ([host-marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)).

## Design decisions

- **Settings as a drop-in, rules as an import.** The drop-in directory is the
  only native way to include a settings file whole, so an update replaces it
  instead of merging into yours; a CLAUDE.md import does the same for
  instructions. Both follow `git pull`.
- **Few prompts, on purpose.** Claude Code users approve 93% of permission
  prompts, and experienced users approve twice as often as new ones (Anthropic,
  [auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode),
  [How we contain Claude](https://www.anthropic.com/engineering/how-we-contain-claude)):
  a prompt on every push trains people to click through. `ask` is kept for
  rare, irreversible or public actions; the classifier and the sandbox handle
  the rest.
- **Sandbox where it works.** It enforces file and network limits at the OS
  level, including for scripts and `grep -r`, which permission rules can't
  cover, and Anthropic measured 84% fewer prompts with it
  ([Claude Code sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing)).
  Prompt injection runs attacker commands in up to 84% of attempts on coding
  agents ([Liu et al., 2025](https://arxiv.org/abs/2509.22040)), so a boundary
  that doesn't depend on the model matters. It ships as a separate drop-in
  because it doesn't work everywhere yet.
- **`ask` rather than `deny`.** The drop-in sits at the managed level, and "if
  a tool is denied at any level, no other level can allow it"
  ([permissions](https://code.claude.com/docs/en/permissions)): a `deny` would
  block even an explicit request. `ask` prompts instead, in auto mode too.
  Secret files are the exception: only a `deny` also covers `cat`, `head` and
  the like in Bash — an `ask` rule on `.env` let `cat .env` through in a test
  on 2.1.288 — and a `Read` deny also blocks editing and creating the file
  (same page).
- **Exact forms for commands that take arguments.** A rule matches by prefix,
  so `git fetch*` would also allow `git fetch --upload-pack=<command>` and
  `pnpm install*` would allow `pnpm install <package>`. Those commands are
  allowed only without arguments.
- **Dependency changes ask.** `config/CLAUDE.md` requires vetting every new
  dependency; the prompt is where that happens.
- **Secrets are guarded by rules, not hooks.** `Read` deny rules cover
  Claude's own reads, including `cat`, `head`, `tail` and `sed` in Bash, not a
  script, a container or `grep -r` run from a parent directory — the sandbox
  covers those, because Claude Code merges `Read` deny rules into it
  ([sandboxing](https://code.claude.com/docs/en/sandboxing)). A
  secret-masking hook was measured at ~0.55 s per tool call and rejected.
- **Bypass mode is disabled** (`disableBypassPermissionsMode`, as in
  Anthropic's managed-settings examples): skipping every check would void the
  rest.
- **A short, mostly negative rule file.** `config/CLAUDE.md` is about 60
  lines. Claude models follow 98–100% of instructions up to about 50
  ([IFScale, 2025](https://arxiv.org/abs/2507.11538)), and in more than 5,000
  Claude Code runs, the rules that helped were constraints ("do not…") while
  positive directives such as "follow code style" hurt ([Guardrails Beat Guidance, 2026](https://arxiv.org/abs/2604.11088)).
  Whether a rule file helps at all is still debated
  ([Gloaguen et al., 2026](https://arxiv.org/abs/2602.11988)); the plugin's
  evals are where this repository measures it.
- **Skills instead of rules.** A plugin can't ship CLAUDE.md or `rules/`
  ([plugins-reference](https://code.claude.com/docs/en/plugins-reference#standard-layout));
  a skill with `paths` loads on the same files
  ([skills](https://code.claude.com/docs/en/skills)).
- **No hooks, agents or MCP servers forced on you.** Each one runs code, costs
  latency or widens what leaves the machine; Context7 stays an opt-in step.

## Troubleshooting

- **Claude Code refuses to start and names a managed file**: the file isn't
  valid JSON — `git pull` may have stopped mid-merge; fix the clone.
- **A rule seems ignored**: `claude doctor` lists the entries it dropped.
- **The plugin doesn't install**: `claude plugin marketplace list` and the
  Errors tab of `/plugin`; for a private fork, check git access.
- **The settings have no effect**: another managed source wins on that
  machine; `/status` shows it under `Skipped sources`.
- **The clone moved or was deleted**: the link now points nowhere; Claude Code
  starts without these settings (tested with 2.1.288). Recreate the link from
  the new location, or remove it.

## Contributing

Changes go through pull requests; CI runs `claude plugin validate --strict`
and checks every JSON file. A change to a skill bumps `version` in
`plugins/engineering-standards/.claude-plugin/plugin.json` — installed copies
stay on the old version until it changes — then
`claude plugin tag plugins/engineering-standards --push` tags the release.

## License

[MIT](LICENSE)
