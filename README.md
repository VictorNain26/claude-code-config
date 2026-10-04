# claude-code-config

A ready-to-use [Claude Code](https://code.claude.com/docs) environment you opt
into: safe permission defaults, shared working rules, and skills that load
only on the files they apply to. Install it once; `git pull` keeps it current.

Use it as is, or fork it for your team.

## What you get

| Path | Contents | How Claude Code loads it |
|---|---|---|
| `config/settings.json` | permissions, bypass mode disabled, the plugin below | a settings file linked into the managed-settings drop-in directory ([managed-settings](https://code.claude.com/docs/en/managed-settings)) |
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

Clone the repository into a directory you keep only for this install — the
links point at it, so every checkout there is live in all your sessions. If
you also work on the repository, do that in a second clone.

```bash
git clone https://github.com/VictorNain26/claude-code-config.git ~/.local/share/claude-code-config
cd ~/.local/share/claude-code-config
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

**Optional — a browser.** The `ui-design` skill asks Claude to look at a UI
change rendered before calling it done, and to say so when it can't.
[Playwright MCP](https://github.com/microsoft/playwright-mcp) gives it a
browser and screenshots; the plugin runs `npx @playwright/mcp@latest` on your
machine. To add it:

```bash
claude plugin install playwright@claude-plugins-official
```

On a Pro, Max, Team or Enterprise plan, outside WSL,
[Claude in Chrome](https://code.claude.com/docs/en/chrome) drives your own
browser instead: `claude --chrome`.

### Without admin rights

Copy the keys of `config/settings.json` into `~/.claude/settings.json`,
appending to the lists already there, and do step 2. Repeat the copy when
`config/settings.json` changes.

### For an organization

A drop-in linked to a user-writable clone is a convenience, not enforcement.
To enforce the configuration across a fleet, [fork](#make-it-yours) the
repository first — otherwise every machine follows this one's plugin
updates. Then:

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
sudo rm /etc/claude-code/managed-settings.d/50-claude-code-config.json
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

### Optional: sandbox, for you to turn on

The [sandbox](https://code.claude.com/docs/en/sandboxing) enforces file and
network limits on shell commands at the OS level, including for scripts and
`grep -r`, which permission rules can't cover. It also blocks things you may
need: Docker, servers running outside it (on Linux a sandboxed command's
`localhost` is its own), hosts you haven't allowed. So it isn't part of the
shared settings: turn it on in your own `~/.claude/settings.json`, and switch
it on or off at any time with `/sandbox`.

```json
{
  "sandbox": {
    "enabled": true,
    "excludedCommands": [
      "docker ps *", "docker logs *", "docker inspect *", "docker build *",
      "docker compose ps *", "docker compose logs *", "docker compose config *",
      "docker compose build *"
    ],
    "network": {
      "allowedDomains": [
        "registry.npmjs.org", "registry.yarnpkg.com", "pypi.org",
        "files.pythonhosted.org", "github.com", "api.github.com",
        "codeload.github.com", "objects.githubusercontent.com"
      ]
    }
  }
}
```

- **Linux**: install `bubblewrap` and `socat` (`sudo apt-get install bubblewrap
  socat`); on Ubuntu 24.04+, add the AppArmor profile from the sandboxing page.
  Tested on Ubuntu 24.04 with 2.1.288.
- **WSL2**: not yet — with 2.1.288 the first network connection of each
  sandboxed command fails (`Failed to connect to localhost port 3128`); the
  bug is reported to Anthropic.
- **Native Windows and WSL1**: the sandbox doesn't run.
- When a command fails inside it, Claude Code offers to rerun it outside the
  sandbox, through your permission mode.

## Design decisions

- **Settings as a drop-in, rules as an import.** The drop-in directory is the
  only native way to include a settings file whole, so an update replaces it
  instead of merging into yours; a CLAUDE.md import does the same for
  instructions. Both follow `git pull`.
- **Few prompts, on purpose.** Claude Code users approve 93% of permission
  prompts, and experienced users approve twice as often as new ones (Anthropic,
  [auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode),
  [How we contain Claude](https://www.anthropic.com/engineering/how-we-contain-claude)):
  a prompt on every push trains people to click through.
- **Sandbox recommended, not imposed.** Anthropic measured 84% fewer prompts
  with it
  ([Claude Code sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing)),
  and prompt injection runs attacker commands in up to 84% of attempts on
  coding agents ([Liu et al., 2025](https://arxiv.org/abs/2509.22040)). But at
  the managed level nobody could turn it off, and it blocks Docker, `gh` and
  local servers until tuned.
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
  dependency; the prompt is where that happens. `npx` has no allow rule for
  the same reason: without a terminal it installs a missing package without
  asking ([npm exec](https://docs.npmjs.com/cli/commands/npm-exec)), while
  `pnpm exec` only adds `node_modules/.bin` to the `PATH`
  ([pnpm exec](https://pnpm.io/cli/exec)).
- **Secrets are guarded by rules, not hooks.** `Read` deny rules don't reach
  a script, a container or `grep -r` run from a parent directory; the sandbox
  covers those when you turn it on, because Claude Code merges `Read` deny
  rules into it
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
  ([Gloaguen et al., 2026](https://arxiv.org/abs/2602.11988)), and this
  repository doesn't measure its own: the evals load the plugin's skills, not
  this file.
- **Skills instead of rules.** A plugin can't ship CLAUDE.md or `rules/`
  ([plugins-reference](https://code.claude.com/docs/en/plugins-reference#standard-layout));
  a skill with `paths` loads on the same files
  ([skills](https://code.claude.com/docs/en/skills)).
- **No hooks, agents or MCP servers forced on you.** Each one runs code, costs
  latency or widens what leaves the machine; Context7 and the browser stay
  opt-in steps.

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
and checks every JSON file. The skills have a `claude plugin eval` suite in
`plugins/engineering-standards/evals/`, run in CI on `opus` and `sonnet` when
the plugin changes and every week. Each case fails when its skill stops
loading, so a model or Claude Code change that breaks a skill shows up
([plugin-evals](https://code.claude.com/docs/en/plugin-evals)).
A change to a skill bumps `version` in
`plugins/engineering-standards/.claude-plugin/plugin.json`: installed copies
stay on the old version until it changes.

## License

[MIT](LICENSE)
