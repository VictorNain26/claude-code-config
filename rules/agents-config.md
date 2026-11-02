---
paths:
  - "**/CLAUDE.md"
  - "**/.claude/**"
---

# Configuration des agents

## La boucle d'apprentissage

Chaque constat de revue corrigé, ou chaque erreur d'agent que je reprends, va dans cet ordre vers :
un contrôle automatique (lint, hook, CI, permission) ; sinon un interdit dans CLAUDE.md ou une
règle ; sinon un skill, si c'est une procédure ; sinon rien, si l'erreur ne se répète pas. Une
contrainte réelle s'écrit en interdit, avec sa raison ; une préférence s'écrit en une phrase qui
dit ce qu'on veut.

Ce qui vaut pour tous mes projets va dans `~/.claude/` ; ce qui est propre à un projet, dans le
projet.

## Structure d'un projet

- `CLAUDE.md` à la racine, sous 200 lignes : la carte, les commandes, les interdits valables dans
  tout le dépôt. Un seul CLAUDE.md par dépôt.
- `.claude/rules/<sujet>.md` avec `paths:` (chemins depuis la racine) : les conventions d'une
  partie du code, chargées quand on ouvre un de ses fichiers.
- `.claude/skills/<nom>/` : une procédure qui ne sert que parfois.
- `.claude/settings.json` à la racine : les garde-fous du projet, dont un hook `Stop` qui lance la
  vérification rapide (typecheck, lint) quand elle tient en quelques secondes. Claude se lance à la racine du
  dépôt, seul endroit où ce fichier est lu.
- La doc pour humains reste dans `README.md` et `docs/` ; elle renvoie aux règles, sans les recopier.

## L'élagage

Chaque mois, et quand un agent ignore une règle écrite : lancer `/doctor prompt-audit`, qui repère
les instructions périmées, les chemins morts et les contradictions ; pour chaque ligne restante, se
demander si la retirer ferait faire une erreur ; retirer sinon, ou transformer en contrôle automatique.

## Interdits

- Jamais une règle en prose quand un contrôle automatique peut la tenir.
- Jamais dans un projet une règle qui existe déjà dans `~/.claude/`, sauf si le dépôt est aussi ouvert
  sans `~/.claude` (CI, session cloud) : il garde alors ses propres garde-fous.
- Jamais une règle, un skill ou un plugin qui refait ce qu'un outil intégré, un plugin installé ou un
  MCP fait déjà : deux sources pour un même comportement finissent par se contredire.
