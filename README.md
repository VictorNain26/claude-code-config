# claude-code-config

Le harness Claude Code de niveau utilisateur (`~/.claude/`), une seule source
pour toutes les machines, déployée par [chezmoi](https://www.chezmoi.io/).

## Contenu

| Source | Cible |
|---|---|
| `home/dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` — instructions globales |
| `home/dot_claude/rules/` | `~/.claude/rules/` — règles chargées par chemin |
| `home/dot_claude/modify_private_settings.json` + `home/.chezmoidata/claude.json` | `~/.claude/settings.json` (0600), clés du dépôt seulement |

Claude Code écrit lui-même dans `~/.claude/settings.json` (`/config`, `/model`,
plugins : code.claude.com/docs/en/settings, « A change you made in Claude Code is
lost in new sessions »). Le fichier est donc un *modify template* chezmoi
(chezmoi.io/user-guide/manage-different-types-of-file) : à chaque `apply`, les
clés du dépôt remplacent celles de la machine, les autres restent telles que
Claude Code les a écrites, et `enabledPlugins` se fusionne plugin par plugin.
Une clé retirée du dépôt n'est pas retirée des machines.

`claude.settings` vaut partout ; `claude.hosts.<host>` le complète pour un rôle
de machine (`workstation`, `server`), surtout son `autoMode.environment`, que le
classifieur ne lit que dans les réglages utilisateur
(code.claude.com/docs/en/auto-mode-config, « Where the classifier reads
configuration »). Chaque machine déclare son rôle dans son `chezmoi.toml` ; sans
lui, `chezmoi apply` échoue au lieu d'écrire des réglages incomplets.

`autoMode.environment` est la liste complète, un emplacement par entrée, comme
l'écrit `/auto-mode-setup` (code.claude.com/docs/en/auto-mode-config, « Review
and save the draft ») : avec `"$defaults"`, l'entrée par défaut d'un emplacement
reste à côté de la nôtre et la contredit (`claude auto-mode critique`). Les
emplacements non personnalisés recopient `claude auto-mode defaults` : les
revoir quand Claude Code change ses valeurs par défaut. Les entrées décrivent
par rôle, pas par liste de dépôts ; les interdictions sont des règles
`soft_deny` (avec `"$defaults"`), pas du texte d'environnement. Ce qui ne vaut
que pour un dépôt va dans son `CLAUDE.md`, que le classifieur lit aussi.

Hors dépôt, par machine : `~/.claude.json` (serveurs MCP, état d'exécution),
`~/.claude/.credentials.json`, et les skills installés par leur outil officiel
(`npx ctx7 setup --claude` pour Context7).

## Installer une machine

Prérequis : Node et npm pour la statusline.

```bash
# chezmoi, depuis sa release officielle (sommes de contrôle vérifiées) ou : snap install chezmoi --classic
git clone https://github.com/VictorNain26/claude-code-config.git ~/projets/claude-code-config
mkdir -p ~/.config/chezmoi
printf 'sourceDir = "%s"\n[data]\nhost = "workstation"\n' ~/projets/claude-code-config > ~/.config/chezmoi/chezmoi.toml   # ou "server"
chezmoi diff          # ce qui changerait
chezmoi apply
npm install -g ccstatusline@2.2.30
```

Une machine d'un nouveau rôle demande d'abord son entrée dans `claude.hosts`.
Après l'`apply`, `claude auto-mode config` montre les règles effectives et
`claude auto-mode critique` relit les entrées ajoutées.

## Au quotidien

- Modifier le dépôt, puis `chezmoi apply`.
- Un réglage changé depuis Claude Code (`/effort`, `/config`, un plugin) s'écrit
  dans `~/.claude/settings.json`. Sur une clé que le dépôt ne fixe pas, il reste ;
  sur une clé qu'il fixe, le prochain `apply` le remplace : le reporter dans
  `home/.chezmoidata/claude.json` pour le garder. `chezmoi diff` montre l'écart.
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
