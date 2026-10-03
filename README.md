# claude-code-config

La configuration Claude Code commune à l'équipe : ce qui doit être identique
sur chaque machine. Les préférences de chacun restent dans sa propre couche
(`~/.claude/`), que ce dépôt ne touche pas.

## Ce qui est commun

| Fichier | Rôle | Livré comme |
|---|---|---|
| `policy/managed-settings.json` | permissions (allow d'outillage, ask, deny), attribution des commits et PR, sous-agents sur le modèle de la session, marketplace et plugin d'équipe | [managed settings](https://code.claude.com/docs/en/managed-settings) |
| `policy/CLAUDE.md` | instructions communes | [CLAUDE.md managé](https://code.claude.com/docs/en/memory) : chargé dans chaque session, impossible à exclure |
| `plugins/team-standards/` | skills chargées par chemin de fichier : `ui-design` (front), `tests` (fichiers de test) | plugin, depuis la marketplace `team-config` de ce dépôt (`.claude-plugin/marketplace.json`) |

Les managed settings sont au-dessus de tout autre niveau : un développeur ne
peut ni les retirer ni les contredire. Les listes (`permissions.allow`, `ask`,
`deny`, `autoMode.*`) se combinent avec les siennes au lieu de les remplacer
([settings](https://code.claude.com/docs/en/settings), « combines the lists
instead of picking one »).

## Installer

Une seule voie par organisation : quand les managed settings du serveur
livrent une clé, Claude Code ignore par défaut le fichier local
([managed-settings](https://code.claude.com/docs/en/managed-settings),
`managedSourcesBehavior`).

### Organisation Claude Team ou Enterprise

Un Owner colle le résultat de cette commande dans
[Admin Settings > Claude Code > Managed settings](https://claude.ai/admin-settings/claude-code) :

```bash
jq --rawfile md policy/CLAUDE.md 'del(."$schema") + {claudeMd: $md}' policy/managed-settings.json
```

Rien à installer sur les postes. `claude doctor` affiche la ligne
`Managed settings (remote)` ([server-managed-settings](https://code.claude.com/docs/en/server-managed-settings)).

### Tout autre compte (Pro, Max, clé API) ou poste géré à la main

Depuis un clone du dépôt, avec les droits administrateur :

```bash
# Linux et WSL
sudo install -Dm644 policy/managed-settings.json /etc/claude-code/managed-settings.d/50-team.json
sudo install -Dm644 policy/CLAUDE.md /etc/claude-code/CLAUDE.md
```

```bash
# macOS
D="/Library/Application Support/ClaudeCode"
sudo install -d "$D/managed-settings.d"
sudo install -m644 policy/managed-settings.json "$D/managed-settings.d/50-team.json"
sudo install -m644 policy/CLAUDE.md "$D/CLAUDE.md"
```

```powershell
# Windows, PowerShell en administrateur
$D = "C:\Program Files\ClaudeCode"
New-Item -ItemType Directory -Force "$D\managed-settings.d" | Out-Null
Copy-Item policy\managed-settings.json "$D\managed-settings.d\50-team.json"
Copy-Item policy\CLAUDE.md "$D\CLAUDE.md"
```

Le fichier va dans `managed-settings.d/` pour cohabiter avec une politique que
l'entreprise déposerait dans `managed-settings.json`. Mise à jour : `git pull`
puis les mêmes commandes.

### Parc sous MDM

Le contenu de `policy/managed-settings.json` se livre tel quel en profil macOS
(`com.anthropic.claudecode`) ou en valeur de registre Windows
(`HKLM\SOFTWARE\Policies\ClaudeCode\Settings`), et `policy/CLAUDE.md` au chemin
système ci-dessus ([managed-settings](https://code.claude.com/docs/en/managed-settings), « Delivery mechanisms »).

### Vérifier

- `/status` : `Enterprise managed settings` figure dans `Setting sources`.
- `/plugin` : `team-standards@team-config` est installé et activé.
- `claude auto-mode config` : les règles effectives.

## Adapter à l'entreprise

- **Forge.** La marketplace pointe vers ce dépôt sur GitHub
  (`extraKnownMarketplaces.team-config.source`). Si le dépôt part sur GitLab ou
  ailleurs : `{"source": "git", "url": "https://gitlab.example.com/groupe/claude-code-config.git"}`.
  Dépôt privé : chaque poste doit pouvoir le cloner avec ses identifiants git
  ([plugins/org](https://code.claude.com/docs/en/plugins/org)).
- **Mode auto.** Par défaut, le classifieur ne fait confiance qu'au dépôt de
  travail et à ses remotes. Quand l'organisation est connue, ajouter dans
  `policy/managed-settings.json` un bloc `autoMode.environment` qui commence
  par `"$defaults"` puis nomme l'organisation, la forge, les domaines et
  services internes ([auto-mode-config](https://code.claude.com/docs/en/auto-mode-config),
  « Define trusted infrastructure »). Les machines et réseaux de chacun vont
  dans son propre `~/.claude/settings.json`.

## La couche de chacun

Dans `~/.claude/settings.json` et `~/.claude/CLAUDE.md`, à la main ou avec son
propre outil de dotfiles :

- préférences : `language`, `theme`, `effortLevel`, `statusLine`, notifications ;
- mode par défaut (`permissions.defaultMode`), autorisations de lecture web,
  MCP perso ;
- `autoMode` qui décrit ses machines, son réseau, ses dépôts perso.

## Choix

- **Pas de hook.** Les fichiers de secrets sont fermés par `permissions.deny`,
  qui couvre Read et `cat`/`head`/`tail`/`sed`/`tee` dans Bash
  ([permissions](https://code.claude.com/docs/en/permissions)). Un hook de
  masquage gitleaks coûtait ~0,55 s par appel d'outil.
- **Règles par chemin en skills.** Un plugin ne charge ni CLAUDE.md ni
  `rules/` ; une skill avec `paths` se charge sur les mêmes fichiers
  ([skills](https://code.claude.com/docs/en/skills)).
- **Sous-agents** sur le modèle de la session : `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`,
  cohérent avec la section « Sous-agents » de `policy/CLAUDE.md`.
