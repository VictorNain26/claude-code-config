# claude-code-config

[![validate](https://github.com/VictorNain26/claude-code-config/actions/workflows/validate.yml/badge.svg)](https://github.com/VictorNain26/claude-code-config/actions/workflows/validate.yml)
[![evals](https://github.com/VictorNain26/claude-code-config/actions/workflows/evals.yml/badge.svg)](https://github.com/VictorNain26/claude-code-config/actions/workflows/evals.yml)

A ready-to-use [Claude Code](https://code.claude.com/docs) environment you opt
into: safe permission defaults, shared working rules, and skills that load
only on the files they apply to. Install it once; `git pull` updates the
settings and rules, and the plugin updates itself. Use it as is, or fork it
for your team.

## What you get

| Path | Contents | How Claude Code loads it |
|---|---|---|
| `config/settings.json` | permissions, bypass mode disabled, the plugin below | a settings file linked into the managed-settings drop-in directory ([managed-settings](https://code.claude.com/docs/en/managed-settings)) |
| `config/AGENTS.md` | working rules: reuse before writing, verify before claiming, code and git conventions | imported from your own `~/.claude/CLAUDE.md` ([memory](https://code.claude.com/docs/en/memory)); other agents read it as is ([other coding agents](#other-coding-agents)) |
| `plugins/engineering-standards/` | skills `ui-design`, `tests`, `third-party-config`, each loaded when Claude works on matching files | plugin from this repository's marketplace |

### Permissions

- **Allowed without a prompt**: test, lint, build, format, typecheck and dev
  scripts of pnpm, `bun test`, pytest/ruff/mypy through uv; installing from the
  lockfile (`pnpm install`, `bun install`, `uv sync`, all without a package
  argument); `git fetch`, `git pull`, commits, cherry-picks, new branches and
  worktrees; read-only `gh` and `glab`; Docker builds, logs and inspection.
  Read-only git and shell commands need no rule: Claude Code runs them without
  a prompt ([permissions](https://code.claude.com/docs/en/permissions)).
- **Ask first**, for rare, irreversible or public actions: force pushes and
  remote branch deletion, local branch and tag deletion, skipping git hooks
  (`--no-verify`, `git commit -n`, `core.hooksPath`); staging everything at
  once (`git add -A`, `git add .`, `git commit -a`); adding, removing or
  upgrading a dependency; `dlx`/`pnpx`/`bunx`/`uvx`; `docker exec`; `dd`,
  `sudo`, `su`, `doas`, `pkexec`, `run0`; publishing and releases; merging or
  closing a PR/MR; reading or editing a project `.npmrc`; editing shell
  startup files.
- **Denied**: secret files. In the project, `.env` and `.env.*` (templates
  such as `.env.example`, `.sample`, `.template`, `.dist` stay readable),
  `.envrc`, `*.pem`, `*.key`, `*.p12`, `credentials.json`, `secrets.json`,
  `secrets.yaml`, `secrets.yml`, `secrets.toml`; in your home directory,
  `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.azure`, `~/.kube`, the `gh`, `glab` and
  `gcloud` configs, uv's credential store, `~/.docker/config.json`,
  `~/.git-credentials`, `~/.netrc`, `~/.npmrc`, `~/.pypirc`, `~/.bunfig.toml`,
  `~/.claude/.credentials.json`, at their default paths. Claude's file tools,
  `cat`-like commands and shell redirects can't read, create or edit them; a
  script can, which only the [sandbox](#sandbox) stops. Also `mkfs`,
  `chmod -R 777` and `chmod 777 /`, with or without `sudo`.

Everything else, such as pushing, opening a PR, `reset --hard` or `rm -r`, is
left to your permission mode. In auto mode, the default in a terminal since
Claude Code 2.1.283, the classifier blocks the destructive forms, and Claude
Code drops broad allow rules such as package-manager run commands, so some
allow entries only save prompts in Manual mode
([permission-modes](https://code.claude.com/docs/en/permission-modes)).

## Requirements

- [Claude Code](https://code.claude.com/docs/en/setup), recent; tested with 2.1.288.
- `git`, and administrator rights for the settings link
  ([without admin rights](#without-admin-rights) otherwise).
- No other managed settings on the machine. When an organization pushes its
  own (claude.ai console or MDM), Claude Code applies only the highest-ranked
  managed source and ignores this drop-in
  ([managed-settings](https://code.claude.com/docs/en/managed-settings)); use
  [without admin rights](#without-admin-rights) there.

## Install

Clone the repository into a directory you keep only for this install: the
links point at it, so every checkout there is live in all your sessions. To
work on the repository, use a second clone.

```bash
git clone https://github.com/VictorNain26/claude-code-config.git ~/.local/share/claude-code-config
cd ~/.local/share/claude-code-config
```

### 1. Settings

Link `config/settings.json` into the managed-settings drop-in directory.

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

Windows, in PowerShell as administrator. This is a copy: run it again after
each `git pull`.

```powershell
$D = "C:\Program Files\ClaudeCode\managed-settings.d"
New-Item -ItemType Directory -Force $D | Out-Null
Copy-Item config\settings.json "$D\50-claude-code-config.json"
```

### 2. Working rules

Import `config/AGENTS.md` from your own `~/.claude/CLAUDE.md`. Spaces in the
path must be escaped with a backslash, or the import is ignored
([memory](https://code.claude.com/docs/en/memory#import-additional-files)).
These commands add the line once, however often you run them.

macOS, Linux and WSL:

```bash
mkdir -p ~/.claude
line="@$(pwd | sed 's/ /\\ /g')/config/AGENTS.md"
grep -qxF "$line" ~/.claude/CLAUDE.md 2>/dev/null || printf '\n%s\n' "$line" >> ~/.claude/CLAUDE.md
```

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude" | Out-Null
$line = "@" + ((Get-Location).Path -replace '\\','/' -replace ' ','\ ') + "/config/AGENTS.md"
$md = "$HOME\.claude\CLAUDE.md"
if (-not ((Test-Path $md) -and (Get-Content $md) -contains $line)) { Add-Content -Encoding utf8 $md "`n$line" }
```

### 3. Start Claude Code

The first session registers the marketplace and installs the plugin; it
loads from the next start.

### Without admin rights

Copy the keys of `config/settings.json` into `~/.claude/settings.json`,
appending to the lists already there, and do step 2. Repeat the copy when
`config/settings.json` changes.

### For an organization

A drop-in linked to a user-writable clone is a convenience, not enforcement.
To enforce the configuration across a fleet, [fork](#make-it-yours) the
repository first, otherwise every machine follows this one's plugin updates.
Then:

- **Claude Team or Enterprise**: an Owner pastes the output of this command into
  [Admin Settings > Claude Code > Managed settings](https://claude.ai/admin-settings/claude-code):

  ```bash
  jq --rawfile md config/AGENTS.md 'del(."$schema") + {claudeMd: $md}' config/settings.json
  ```

  Machines that sign in another way (another organization's API key,
  Bedrock, Vertex, a custom base URL) don't fetch it: give them the file
  install too ([admin-setup](https://code.claude.com/docs/en/admin-setup)).
- **File or MDM**: copy `config/settings.json` into `managed-settings.d/` and
  `config/AGENTS.md` to the managed CLAUDE.md path (`/etc/claude-code/CLAUDE.md`,
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
  quotes the "Don't reinvent the wheel" section of `config/AGENTS.md`.

## Optional add-ons

None of these is part of the shared settings: each one runs code, sends data
out of the machine or blocks tools you may need. Turn on the ones you want.

### Context7

`config/AGENTS.md` tells Claude to look library documentation up in
[Context7](https://github.com/upstash/context7) when it is installed. It is a
hosted MCP server: the library names and questions go to Upstash.

```bash
claude plugin install context7@claude-plugins-official
```

### A browser for UI checks

The `ui-design` skill asks Claude to look at a UI change rendered before
calling it done, and to say so when it can't.
[Claude in Chrome](https://code.claude.com/docs/en/chrome) drives your own
browser: `claude --chrome`, or `/chrome` and **Enabled by default**. It needs a
Pro, Max, Team or Enterprise plan signed in with `/login`. It opens its own
tabs but shares your browser's login state, so what it sees is what you see.
Its documentation lists WSL as unsupported, yet with 2.1.289 Claude Code in
WSL2 drove Chrome on Windows, which loaded a dev server running in WSL on
`localhost`.

Your profile is also its limit: a check that needs a clean browser (no service
worker, cache or cookie left from earlier visits) or a scenario replayed
identically fits a short throwaway script driving headless Chromium better.
No browser plugin is needed for that.

### Sandbox

The [sandbox](https://code.claude.com/docs/en/sandboxing) enforces file and
network limits on shell commands at the OS level, including for scripts and
`grep -r`, which permission rules can't cover. It also blocks things you may
need: Docker, servers running outside it (on Linux a sandboxed command's
`localhost` is its own), hosts you haven't allowed. Turn it on in your own
`~/.claude/settings.json`, and switch it on or off at any time with
`/sandbox`.

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
- **WSL2**: not yet. With 2.1.288 the first network connection of each
  sandboxed command fails (`Failed to connect to localhost port 3128`); the
  bug is reported to Anthropic.
- **Native Windows and WSL1**: the sandbox doesn't run.
- When a command fails inside it, Claude Code offers to rerun it outside the
  sandbox, through your permission mode.

### Other coding agents

The working rules are plain [AGENTS.md](https://agents.md) with no
Claude-specific syntax, so another agent can load the same file. Codex reads
`AGENTS.md` from its home directory, `~/.codex` unless `CODEX_HOME` is set,
in every project, and reads `AGENTS.override.md` there instead when it exists
([Codex AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)).
Its documentation describes no `@` imports, so link the file itself from the
clone. `ln` refuses to replace an `AGENTS.md` you already have: merge yours
into your own copy first, or keep it.

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}"
ln -s "$PWD/config/AGENTS.md" "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
```

On Windows, copy it instead and copy again after each `git pull`. Not tested
with Codex yet.

The rest stays Claude Code only: `config/settings.json` and the plugin. The
skills are [Agent Skills](https://agentskills.io) `SKILL.md` files, a format
other agents read, but each agent looks for them in its own directory.

## Update

```bash
git pull
```

Settings and working rules follow the clone at the next session (copy again
on Windows). The plugin updates in the background and the new version loads at
the following launch
([plugins/loading](https://code.claude.com/docs/en/plugins/loading)). Changes
are listed in the [commit history](https://github.com/VictorNain26/claude-code-config/commits/master).

Installs made before October 8, 2026 import `config/CLAUDE.md`, which no
longer exists: change that line in `~/.claude/CLAUDE.md` to
`config/AGENTS.md` before pulling, or no working rules load.

## Uninstall

Remove the settings link, the plugin and its marketplace:

```bash
sudo rm /etc/claude-code/managed-settings.d/50-claude-code-config.json
claude plugin marketplace remove claude-code-config
```

On macOS, remove `/Library/Application Support/ClaudeCode/managed-settings.d/50-claude-code-config.json`;
on Windows, `Remove-Item "C:\Program Files\ClaudeCode\managed-settings.d\50-claude-code-config.json"`
as administrator. Then delete the `@…/config/AGENTS.md` line from
`~/.claude/CLAUDE.md`, and uninstall the add-ons you installed, for example
`claude plugin uninstall context7@claude-plugins-official`.

## Make it yours

- **Your preferences** (language, theme, effort, status line, default
  permission mode, your own MCP servers) go in `~/.claude/settings.json` and
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
  at it, `{"source": "github", "repo": "your-org/claude-code-config"}`, or for
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
- **Rules in AGENTS.md.** AGENTS.md is the instruction file other coding
  agents read, so the rules don't tie you to Claude Code. Claude Code reads a
  project's AGENTS.md on its own, but not at the user level, hence the import
  from `~/.claude/CLAUDE.md`
  ([memory](https://code.claude.com/docs/en/memory#agents-md)).
- **Few prompts, on purpose.** Claude Code users approve 93% of permission
  prompts, and experienced users auto-approve twice as often as new ones
  (Anthropic,
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
  the like in Bash (an `ask` rule on `.env` let `cat .env` through in a test
  on 2.1.288), and a `Read` deny also blocks editing and creating the file
  with Claude's file tools (same page). Shell redirects and `tee` are checked
  against `Edit` rules only
  ([permissions](https://code.claude.com/docs/en/permissions#redirections)),
  so each secret also has an `Edit` deny: without it, `echo x > .env` created
  the file without a prompt on 2.1.294. So are `mkfs` and `chmod 777`, which
  no coding task needs.
- **A rule that must always hold is also a permission.** CLAUDE.md is context,
  not enforced configuration
  ([memory](https://code.claude.com/docs/en/memory)), while an ask rule
  prompts for any subcommand that matches, in auto mode too
  ([permissions](https://code.claude.com/docs/en/permissions#compound-commands)).
  So "stage files one by one" is both a line in `config/AGENTS.md` and ask
  rules on `git add -A`, `git add .` and `git commit -a`: the prompt only
  shows when Claude ignores the line.
- **Exact forms for commands that take arguments.** A rule matches by prefix,
  so `git fetch*` would also allow `git fetch --upload-pack=<command>` and
  `pnpm install*` would allow `pnpm install <package>`. Those commands are
  allowed only without arguments. The other way round, ask and deny rules
  cover the spellings Claude usually writes: `-n` for `--no-verify`, `-d` for
  `--delete`, the flag before or after the remote, `sudo` in front, which
  Claude Code doesn't strip before matching
  ([permissions](https://code.claude.com/docs/en/permissions#process-wrappers)).
  They are not a security boundary: bundled short flags (`-qn`), options
  before the subcommand (`git -C . push -f`) or a script
  get past them
  ([permissions](https://code.claude.com/docs/en/permissions#bash-rule-limits)).
  The working rules, the auto-mode classifier and the sandbox are the other
  layers.
- **Dependency changes ask.** `config/AGENTS.md` requires vetting every new
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
- **A short, mostly negative rule file.** `config/AGENTS.md` is about 60
  lines. Claude Opus 4 and Claude 3.7 Sonnet follow 99.6–100% of 50
  simultaneous instructions, Claude 3.5 Haiku 78%
  ([IFScale, 2025](https://arxiv.org/abs/2507.11538)), and in more than 5,000
  Claude Code runs, the rules that helped were constraints ("do not…") while
  positive directives such as "follow code style" hurt
  ([Guardrails Beat Guidance, 2026](https://arxiv.org/abs/2604.11088)).
  Whether a rule file helps at all is still debated
  ([Gloaguen et al., 2026](https://arxiv.org/abs/2602.11988)), and this
  repository doesn't measure its own: the evals load the plugin's skills, not
  this file.
- **Skills instead of rules.** A plugin can't ship CLAUDE.md or `rules/`
  ([plugins-reference](https://code.claude.com/docs/en/plugins-reference#standard-layout));
  a skill with `paths` loads on the same files
  ([skills](https://code.claude.com/docs/en/skills)).
- **No hooks, agents or MCP servers forced on you.** Each one runs code, costs
  latency or widens what leaves the machine; the [add-ons](#optional-add-ons)
  stay opt-in.

## Troubleshooting

- **Claude Code refuses to start and names a managed file**: the file isn't
  valid JSON; `git pull` may have stopped mid-merge. Fix the clone.
- **A rule seems ignored**: `claude doctor` lists the entries it dropped.
- **The plugin doesn't install**: `claude plugin marketplace list` and the
  Errors tab of `/plugin`; for a private fork, check git access.
- **The settings have no effect**: another managed source wins on that
  machine; `/status` shows it under `Skipped sources`.
- **The clone moved or was deleted**: the link now points nowhere; Claude Code
  starts without these settings (tested with 2.1.288). Recreate the link from
  the new location, or remove it.

## Contributing

Changes go through pull requests. Before opening one, run:

```bash
git ls-files -z '*.json' | xargs -0 -n1 jq empty
claude plugin validate . --strict
claude plugin validate ./plugins/engineering-standards --strict
```

CI runs the same checks, then `claude doctor` on the settings as installed; a
link check runs on `master` and every week. A change to a skill bumps
`version` in `plugins/engineering-standards/.claude-plugin/plugin.json`:
installed copies stay on the old version until it changes.

The skills have a `claude plugin eval` suite in
`plugins/engineering-standards/evals/`, run in CI on `opus` and `sonnet` when
the plugin changes and every week. Each case fails when its skill stops
loading, so a model or Claude Code change that breaks a skill shows up
([plugin-evals](https://code.claude.com/docs/en/plugin-evals)). A machine with
these settings installed can't evaluate a local copy, because the managed
`enabledPlugins` locks the installed plugin: let CI run the suite, or use a
machine without the link.

Report a security issue privately, as [SECURITY.md](SECURITY.md) describes.

## License

[MIT](LICENSE)
