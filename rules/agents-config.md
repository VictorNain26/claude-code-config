---
paths:
  - "**/CLAUDE.md"
  - "**/.claude/**"
---

# Configuration des agents

- Un seul CLAUDE.md par dépôt, à la racine.
- Un projet dont la vérification rapide (typecheck, lint) tient en quelques secondes a dans
  `.claude/settings.json` un hook `Stop` qui la lance.
- Jamais dans un projet une règle qui existe déjà dans `~/.claude/`, sauf si le dépôt est aussi ouvert
  sans `~/.claude` (CI, session cloud) : il garde alors ses propres garde-fous.
