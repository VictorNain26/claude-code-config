---
paths:
  - "**/CLAUDE.md"
  - "**/.claude/**"
---

# Configuration des agents

Le fonctionnement de CLAUDE.md, des rules, skills, hooks et settings est dans la doc officielle
(code.claude.com/docs) ; ici, seulement mes choix.

- Une erreur d'agent qui se répète devient un contrôle automatique (hook, permission, lint, CI) ;
  sinon une ligne de CLAUDE.md ou une règle ; sinon un skill, si c'est une procédure.
- Un seul CLAUDE.md par dépôt, à la racine.
- Chaque projet a dans `.claude/settings.json` un hook `Stop` qui lance sa vérification rapide
  (typecheck, lint) quand elle tient en quelques secondes.
- Quand un agent ignore une règle écrite : `/doctor prompt-audit`, puis retirer ou automatiser.

## Interdits

- Jamais dans un projet une règle qui existe déjà dans `~/.claude/`, sauf si le dépôt est aussi ouvert
  sans `~/.claude` (CI, session cloud) : il garde alors ses propres garde-fous.
- Jamais une règle, un skill ou un plugin qui refait ce qu'un outil intégré, un plugin installé ou un
  MCP fait déjà : deux sources pour un même comportement finissent par se contredire.
