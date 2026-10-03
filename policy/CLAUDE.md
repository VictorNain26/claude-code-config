<!--
Préférences transversales, chargées à chaque session et à chaque requête.
Les règles propres à un projet vivent dans son CLAUDE.md ; celles qui ne
servent que sur un type de fichier vivent dans ~/.claude/rules/ avec un
frontmatter `paths` et ne coûtent alors du contexte qu'à l'ouverture d'un
fichier concerné.

Critère d'ajout, à passer sur chaque ligne : est-ce que retirer cette ligne me
ferait faire une erreur ? Sinon, elle sort. Ce que le system prompt de Claude
Code dit déjà n'a pas à être répété ici : la répétition dilue le reste.
Ces commentaires HTML sont retirés avant injection en contexte.
-->

# Instructions globales

## Règle prioritaire : ne pas réinventer la roue

Avant d'écrire du code, un script, un hook ou un outil, chercher ce qui existe
déjà — fonctionnalité native de la plateforme, bibliothèque ou outil standard,
éprouvé et maintenu — et l'utiliser. Le sur-mesure n'est permis que si rien de
robuste ne couvre le besoin, et il se limite alors à la colle entre des briques
existantes. Vaut partout : code produit, scripts, CI, hooks et harness Claude
Code compris.

Une brique n'est retenue que si elle est maintenue, vérifié le jour même et
cité : dépôt non archivé, release ou commit sur la branche principale depuis
moins de six mois, issues qui reçoivent des réponses, adoption réelle (étoiles,
téléchargements). Une brique qui échoue à un critère se signale comme telle, on
n'en fait pas une dépendance en silence. Elle doit aussi tenir le besoin réel,
mesuré : un outil robuste mais trop lent ou mal adapté n'est pas la réponse.

## Ton

- Anglais pour le code, les commits, les PR et les noms de branche.
- Court et factuel, une phrase par étape. Pas d'emojis sauf demande.
- Un document écrit sur disque — rapport, README, plan — fait la longueur de
  son sujet : couvrir la matière sans section de remplissage, résumé redondant
  ni boilerplate.

## Vérifier avant d'affirmer

Ne jamais affirmer une API, un comportement ou un champ de config de mémoire :
soit j'annonce que je consulte la doc, je la lis et je cite l'URL et le champ
dans ma réponse, soit je dis que je ne sais pas.

Obligatoire avant d'écrire une config tierce (`eslint.config.*`,
`tsconfig.json`, `next.config.*`, `vite.config.*`, `tailwind.config.*`,
`app.config.*`, `turbo.json`, `drizzle.config.ts`, `.github/workflows/*.yml`,
`renovate.json`, `dependabot.yml`, `.coderabbit.yaml`, `Dockerfile`,
`pnpm-workspace.yaml`), un usage SDK non trivial, ou du code qui parle à une
API externe. Aussi : tout bump majeur, tout premier usage d'un SDK dans un
projet.

Sources, dans cet ordre : Context7 MCP, puis la doc officielle en WebFetch, puis
les `.d.ts` de la version installée dans `node_modules`, puis WebSearch en
dernier recours. Le commit qui modifie une config cite sa source.

**Ne jamais dire « fait », « vert » ou « corrigé » sans avoir lancé la
validation et lu les codes de sortie.** Ce qui n'a pas tourné se donne comme
tel.

## Code

- YAGNI. Pas d'abstraction, de feature flag ni de shim de compatibilité pour un
  besoin qui n'existe pas ; trois lignes similaires valent mieux qu'une
  abstraction prématurée.
- Zéro commentaire par défaut. Un commentaire seulement pour un WHY non évident
  — contrainte cachée, invariant subtil, workaround d'un bug précis. Jamais de
  « added for ticket X » : ça va dans le PR et le git blame.
- Un `eslint-disable` cache le problème au lieu de le résoudre : chercher la
  forme de code qui ne déclenche pas la règle. Même réflexe face à tout
  obstacle — la cause plutôt que le contournement.
- Validation stricte aux frontières (input utilisateur, API externe), confiance
  entre fonctions internes : pas de garde défensive entre deux fonctions à moi.
- Ce qui déborde du périmètre demandé ouvre un autre PR.

## Sous-agents

Déléguer seulement ce qui est gros, indépendant et parallélisable, ou une
exploration large dont je ne veux que la conclusion. Ce que je finis en quelques
appels d'outils, je le fais. Pas de sous-agent pour vérifier mon propre travail :
une seule revue indépendante en fin de branche. Un sous-agent qui écrit du code
tourne sur le modèle de la session ; `sonnet`/`haiku` seulement pour de la
recherche en lecture seule. Cette règle prime sur le choix de modèle des skills.

## Livraison

- Branches courtes, mergées au fil de l'eau, `main` à jour en continu.
- Worktree quand l'isolation est réelle — deux branches en parallèle, agents
  concurrents qui écrivent. En flux séquentiel il coûte des `node_modules` et
  des caches séparés pour rien.
- Méthode de merge proposée au cas par cas avec sa raison : merge commit quand
  chaque commit se tient seul, squash quand la PR est un seul changement noyé
  dans des allers-retours.
- Un finding de revue se corrige avant le merge, avec un test de non-régression
  quand c'est un bug. Rien « pour plus tard ».
- Commits : `<type>(<scope>): <description>` en anglais. Types : `feat`, `fix`,
  `chore`, `refactor`, `test`, `docs`, `style`, `perf`, `ci`, `build`.

## Sécurité opérationnelle

Jamais de `--no-verify` ni de skip de hook sans qu'on me le demande — un hook
qui échoue est une cause à traiter. Stager fichier par fichier. Confirmer avant
un force push, un `reset --hard`, un `rm -rf`, un drop de base, une suppression
de branche distante, un merge ou une fermeture de PR.

Auth 2FA, accès humain requis, modification de mes propres permissions, action
sur un compte tiers : le dire et donner la procédure manuelle, sans
pretend-fix.
