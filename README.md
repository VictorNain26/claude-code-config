# claude-code-config

Le harness Claude Code de niveau utilisateur (`~/.claude/`), une seule source
pour toutes les machines, déployée par [chezmoi](https://www.chezmoi.io/).

## Contenu

| Source | Cible |
|---|---|
| `home/dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` — instructions globales |
| `home/dot_claude/rules/` | `~/.claude/rules/` — règles chargées par chemin |
| `home/dot_claude/private_settings.json.tmpl` + `home/.chezmoidata/claude.json` | `~/.claude/settings.json` (0600) |

`settings.json` est un template : `claude.settings` est commun, et
`claude.hosts.<hostname>` le complète pour chaque machine (aujourd'hui son
`autoMode.environment`). Claude Code n'a pas de réglages utilisateur locaux
(code.claude.com/docs/en/settings, « Settings precedence »), d'où ce découpage.
Une machine absente de `claude.hosts` fait échouer `chezmoi apply` au lieu
d'écrire des réglages incomplets.

Hors dépôt, par machine : `~/.claude.json` (serveurs MCP, état d'exécution),
`~/.claude/.credentials.json`, et les skills installés par leur outil officiel
(`npx ctx7 setup --claude` pour Context7).

## Installer une machine

Prérequis : Node et npm pour la statusline.

```bash
# chezmoi, depuis sa release officielle (sommes de contrôle vérifiées) ou : snap install chezmoi --classic
git clone https://github.com/VictorNain26/claude-code-config.git ~/projets/claude-code-config
mkdir -p ~/.config/chezmoi
printf 'sourceDir = "%s"\n' ~/projets/claude-code-config > ~/.config/chezmoi/chezmoi.toml
chezmoi diff          # ce qui changerait
chezmoi apply
npm install -g ccstatusline@2.2.30
```

Une nouvelle machine demande d'abord son entrée dans `claude.hosts`.

## Au quotidien

- Modifier le dépôt, puis `chezmoi apply`.
- Un réglage changé depuis Claude Code (`/effort`, `/config`, un plugin) s'écrit
  dans `~/.claude/settings.json` : `chezmoi diff` le montre, et le prochain
  `apply` l'écrase. Le reporter dans `home/.chezmoidata/claude.json` pour le
  garder.
- `chezmoi re-add ~/.claude/CLAUDE.md` rapatrie une modification faite en place
  (par `/memory` par exemple).

## Choix, et ce qui n'y est pas

- **Pas de hook.** Les fichiers de secrets sont cachés par les règles
  `permissions.deny` natives, qui couvrent Read et `cat`/`head`/`tail`/`sed`/`tee`
  dans Bash (code.claude.com/docs/en/permissions). Un hook de masquage gitleaks
  a été mesuré à ~0,55 s par appel d'outil en session réelle : écarté. Le
  sandbox natif et `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` échouent sous WSL2
  (`bwrap: Can't mkdir /mnt/c/Program Files/ClaudeCode`, Claude Code 2.1.283).
- **Statusline** : [ccstatusline](https://github.com/sirmalloc/ccstatusline),
  installé globalement et épinglé : ~0,25 s par rafraîchissement contre ~1,5 s
  via `npx`.
- **Sous-agents** : l'agent intégré `general-purpose`, forcé sur le modèle de la
  session par `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`.
