# claude-code-config

A ready-to-install [Claude Code](https://code.claude.com/docs) environment:
safe permission defaults, shared working rules, and skills that load only on
the files they apply to. It installs as
[managed settings](https://code.claude.com/docs/en/managed-settings), the
level above every user and project setting, so it holds on every machine that
has it. Your own preferences stay in your `~/.claude/`, which this repository
never touches.

Use it as is, or fork it for your team.

## What you get

| File | Contents | Delivered as |
|---|---|---|
| `policy/managed-settings.json` | permissions, bypass mode disabled, minimum Claude Code version, commit trailer, the plugin below | managed settings |
| `policy/CLAUDE.md` | working rules: reuse before writing, verify before claiming, code and git conventions | [managed CLAUDE.md](https://code.claude.com/docs/en/memory), loaded in every session, can't be excluded |
| `plugins/engineering-standards/` | skills `ui-design`, `tests`, `third-party-config`, each loaded only when Claude works on matching files | plugin from this repository's marketplace |

Permissions, in short:

- **allow**: read-only git, `gh` and `glab` commands, the test, lint, build and
  format scripts of pnpm, bun, uv, npx, and read-only Docker.
- **ask**: anything irreversible or shared — push, merge, force push,
  `reset --hard`, `rm -rf`, branch and tag deletion, `--amend`, `--no-verify`,
  publishing, PR/MR creation and merge, adding or removing a dependency,
  editing `.env` files and shell startup files.
- **deny**: reading secrets — `.env*` (except `.env.example`), keys,
  credential files, `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.kube`, the `gh` and
  `gcloud` configs, `~/.docker/config.json`, `~/.netrc`, `~/.npmrc`, `~/.pypirc`,
  `~/.git-credentials` — and `mkfs`, `dd`, `chmod 777`.

## Requirements

- Claude Code **2.1.283 or later** ([install](https://code.claude.com/docs/en/setup));
  the policy makes older versions refuse to start.
- Administrator rights on the machine (file install), or the Owner role in a
  Claude Team or Enterprise organization (console install).
- `git`; `jq` for the console install.

## Install

```bash
git clone https://github.com/VictorNain26/claude-code-config.git
cd claude-code-config
```

### On a machine — any account

Linux and WSL:

```bash
sudo install -Dm644 policy/managed-settings.json /etc/claude-code/managed-settings.d/50-claude-code-config.json
sudo install -Dm644 policy/CLAUDE.md /etc/claude-code/CLAUDE.md
```

macOS:

```bash
D="/Library/Application Support/ClaudeCode"
sudo install -d "$D/managed-settings.d"
sudo install -m644 policy/managed-settings.json "$D/managed-settings.d/50-claude-code-config.json"
sudo install -m644 policy/CLAUDE.md "$D/CLAUDE.md"
```

Windows, PowerShell as administrator:

```powershell
$D = "C:\Program Files\ClaudeCode"
New-Item -ItemType Directory -Force "$D\managed-settings.d" | Out-Null
Copy-Item policy\managed-settings.json "$D\managed-settings.d\50-claude-code-config.json"
Copy-Item policy\CLAUDE.md "$D\CLAUDE.md"
```

If `/etc/claude-code/CLAUDE.md` (or its macOS/Windows equivalent) already
exists, it belongs to another policy: append to it instead of replacing it.

The settings go in the `managed-settings.d/` drop-in directory so they can sit
next to another policy. Claude Code merges `managed-settings.json` first, then
the drop-ins in alphabetical order; lists combine, and for a single value the
later file wins
([managed-settings](https://code.claude.com/docs/en/managed-settings#split-a-file-based-policy-across-teams)).

### Claude Team or Enterprise organization

An Owner pastes the output of this command into
[Admin Settings > Claude Code > Managed settings](https://claude.ai/admin-settings/claude-code):

```bash
jq --rawfile md policy/CLAUDE.md 'del(."$schema") + {claudeMd: $md}' policy/managed-settings.json
```

Members receive it at their next start. Machines that sign in another way —
API key from another organization, Bedrock, Vertex, a custom base URL — don't
fetch it: give them the file install as well
([admin-setup](https://code.claude.com/docs/en/admin-setup)). When the
server delivers settings, Claude Code ignores the files on that machine by
default (`managedSourcesBehavior`).

### Fleet under MDM

On macOS, convert the keys of `policy/managed-settings.json` into a
`com.anthropic.claudecode` profile (objects as dictionaries, lists as plist
arrays); on Windows, store the whole JSON as a string in
`HKLM\SOFTWARE\Policies\ClaudeCode\Settings`. Deploy `policy/CLAUDE.md` to the
path above ([managed-settings](https://code.claude.com/docs/en/managed-settings)).

## Verify

- `claude doctor` reports no `Invalid settings` for the managed file.
- In a session, `/status` lists `Enterprise managed settings` under
  `Setting sources` — `(drop-ins)` for a file install — and no
  `Skipped sources` line names it.
- After the first session, `/plugin` shows
  `engineering-standards@claude-code-config` installed and enabled.

## Update

- **Plugin**: updates itself at startup (`autoUpdate: true`).
- **Policy**: `git pull`, then run the install commands again. Changes are
  listed in the [commit history](https://github.com/VictorNain26/claude-code-config/commits/master)
  and the [tags](https://github.com/VictorNain26/claude-code-config/tags).

## Uninstall

Remove the two files you installed — on Linux and WSL:

```bash
sudo rm /etc/claude-code/managed-settings.d/50-claude-code-config.json /etc/claude-code/CLAUDE.md
claude plugin marketplace remove claude-code-config
```

Use the macOS or Windows paths from [Install](#install) on those systems. For
the console install, clear the JSON in the admin console.

## Fork it for your team

- **Marketplace source**: point `extraKnownMarketplaces.claude-code-config.source`
  at your fork — `{"source": "github", "repo": "your-org/claude-code-config"}`,
  or for GitLab and other hosts
  `{"source": "git", "url": "https://gitlab.example.com/group/claude-code-config.git"}`
  ([marketplace-reference](https://code.claude.com/docs/en/plugins/marketplace-reference#marketplace-sources)).
- **Private fork**: every machine needs git read access without a prompt, for
  example `gh auth login && gh auth setup-git`. Team and Enterprise
  organizations can sync it from the admin console instead
  ([host-marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)).
- **Auto mode**: auto mode is the default starting mode since Claude Code
  2.1.283, and it only trusts the working repository and its remotes. Add an
  `autoMode.environment` block that starts with `"$defaults"` and names your
  organization, source-control org, internal domains, services and package
  registry ([auto-mode-config](https://code.claude.com/docs/en/auto-mode-config#define-trusted-infrastructure)).
- **Stack-specific permissions** belong in each project's committed
  `.claude/settings.json`, not here.

## Your own layer

Put personal choices in `~/.claude/settings.json` and `~/.claude/CLAUDE.md`:
language, theme, effort, status line, notifications, default permission mode,
your own MCP servers, an `autoMode` that describes your machines. Lists combine
with the managed ones ([settings](https://code.claude.com/docs/en/settings)):
you can add `allow`, `ask` and `deny` rules, and your `deny`/`ask` rules apply
on top of the managed `allow` list.

### Optional: sandbox

The [sandbox](https://code.claude.com/docs/en/sandboxing) enforces file and
network limits on shell commands at the OS level, which permission rules can't
do for scripts and subprocesses. It is not enabled here because it needs
per-machine setup and can break Docker and dev servers until tuned. To try it:

1. Linux and WSL2: `sudo apt-get install bubblewrap socat` (or `dnf`); on
   Ubuntu 24.04+, follow the AppArmor step in the sandboxing page. macOS needs
   nothing. Native Windows and WSL1 are not supported.
2. Add `"sandbox": {"enabled": true}` to `~/.claude/settings.json`.
3. Run `/sandbox` to check dependencies and status.

## Design decisions

- **`ask`, not `deny`, for irreversible actions.** "If a tool is denied at any
  level, no other level can allow it"
  ([permissions](https://code.claude.com/docs/en/permissions)), so a managed
  `deny` would block even an explicit request. `ask` prompts in every mode,
  including auto.
- **Dependency changes ask.** `policy/CLAUDE.md` requires vetting every new
  dependency; the prompt is where that happens.
- **Secrets are denied, not hooked.** `Read` rules cover Claude's own reads,
  including `cat`, `head`, `tail` and `sed` in Bash, not a script or container
  that opens the file — that is the sandbox's job. A secret-masking hook was
  measured at ~0.55 s per tool call and rejected.
- **Bypass mode is disabled**
  (`disableBypassPermissionsMode`, as in Anthropic's managed-settings
  examples). A managed environment that can be switched to "skip all checks"
  protects little.
- **Skills instead of rules.** A plugin can't ship CLAUDE.md or `rules/`
  ([plugins-reference](https://code.claude.com/docs/en/plugins-reference#standard-layout));
  a skill with `paths` loads on the same files
  ([skills](https://code.claude.com/docs/en/skills)).
- **Sparse marketplace checkout.** Machines clone only `.claude-plugin/` and
  `plugins/` (`sparsePaths`).

## Troubleshooting

- **Claude Code refuses to start and names a managed file**: the file isn't
  valid JSON. Fix or remove it.
- **A rule seems ignored**: `claude doctor` lists the entries it dropped.
- **The plugin doesn't install**: `claude plugin marketplace list` and the
  Errors tab of `/plugin`; for a private fork, check git access.
- **The file install has no effect**: another managed source wins on that
  machine; `/status` shows it under `Skipped sources`.

## Contributing

Changes go through pull requests; CI runs `claude plugin validate --strict`
and checks every JSON file. A change to a skill bumps `version` in
`plugins/engineering-standards/.claude-plugin/plugin.json`, then
`claude plugin tag plugins/engineering-standards --push` tags the release.

## License

[MIT](LICENSE)
