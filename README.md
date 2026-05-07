# Claude Code — Configuration globale

Configuration personnelle de Claude Code versionnée pour reproductibilité cross-machines.

## Contenu

| Path | Contenu |
|---|---|
| `CLAUDE.md` | Instructions globales (doc-first, code senior, sécurité, conventions) |
| `settings.json` | Permissions allow/deny/ask, plugins activés, hooks wirés, attribution, etc. |
| `hooks/` | 6 hooks bash (sécurité + scanners) |
| `commands/` | 13 slash commands (audit-codebase, pr, qa, ship, refactor, …) |
| `agents/` | 9 agents (code-reviewer, security-auditor, planner, …) |
| `rules/` | 4 path-scoped rules (architecture-review, code-quality, performance, test) |
| `scripts/` | 3 utility scripts Windows (check-claude, clean-reinstall, statusline) |

## Sources

- **Hooks / commands / agents / rules / scripts** : copiés depuis [FlorianBruniaux/claude-code-ultimate-guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide) (4216 ★).
- **CLAUDE.md global** : rédigé pour le profil solo dev TypeScript fullstack (Bun + Elysia + Drizzle + Mistral, Next.js, Expo).
- **settings.json** : composé selon la doc officielle [code.claude.com/docs/en/settings](https://code.claude.com/docs/en/settings).

## Install sur nouvelle machine (Windows)

Pré-requis : Git for Windows installé (Git Bash requis pour les hooks `.sh`).

```powershell
git clone https://github.com/<ton-user>/claude-code-config.git $env:USERPROFILE\claude-code-config
cd $env:USERPROFILE\claude-code-config
.\install.ps1
```

## Synchroniser après changements locaux

Quand tu modifies un fichier dans `~/.claude/`, lance :

```powershell
.\sync.ps1
git add .
git commit -m "chore: <scope> update"
git push
```

## Sécurité

Tout fichier sensible est exclu via `.gitignore` :
- `.credentials.json` (tokens OAuth Claude Code)
- `*.bak*` (backups)
- `settings.local.json` (préférences locales)
- `projects/`, `todos/`, `sessions/`, etc. (auto-géré)

**Vérification rapide avant push** :

```powershell
git ls-files | Select-String -Pattern '(credentials|secret|token|\.env)'
# Doit retourner rien
```

## Mise à jour des hooks/commands depuis le repo source

Les hooks/commands/agents/rules/scripts viennent de FlorianBruniaux/claude-code-ultimate-guide. Pour les mettre à jour :

```powershell
cd $env:USERPROFILE\Tools\claude-code-ultimate-guide
git pull
cd $env:USERPROFILE\claude-code-config
.\install.ps1   # re-copie les nouvelles versions vers ~/.claude/
.\sync.ps1      # capture les nouveaux fichiers depuis ~/.claude/ vers le repo
git diff        # review des changements
git commit -am "chore: refresh from upstream guide"
git push
```
