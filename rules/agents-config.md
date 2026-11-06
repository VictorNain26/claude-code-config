---
paths:
  - "**/CLAUDE.md"
  - "**/.claude/**"
---

# Configuration des agents

Le fonctionnement de CLAUDE.md, des rules, skills, hooks et settings est dans la doc officielle
(code.claude.com/docs) ; ici, seulement mes choix.

- Un seul CLAUDE.md par dépôt, à la racine.
- Chaque projet a dans `.claude/settings.json` un hook `Stop` qui lance son typecheck et son lint,
  jamais ses tests ni son build.
- Quand un agent ignore une règle écrite : `/doctor prompt-audit`, puis retirer ou automatiser.

## Interdits

- Jamais dans un projet une règle qui existe déjà dans `~/.claude/`, sauf si le dépôt est aussi ouvert
  sans `~/.claude` (CI, session cloud) : il garde alors ses propres garde-fous.
- Jamais une règle, un skill ou un plugin qui refait ce qu'un outil intégré, un plugin installé ou un
  MCP fait déjà : deux sources pour un même comportement finissent par se contredire.
- Jamais une consigne pour ce que Claude fait déjà par défaut (consignes des outils de Claude Code,
  guides de prompting du modèle) : elle coûte de l'attention à chaque session, et une consigne de
  revérification (« revérifie », « double-check ») fait sur-vérifier ; demander la preuve d'une
  vérification n'en est pas une. Une ligne garde sa raison d'être : un défaut relevé ou une source.
