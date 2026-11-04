# Pratiques de code

- Code, identifiants, messages de commit et noms de branches en anglais. Commits au format Conventional Commits.
- Nouveau projet : pnpm ou bun pour JS/TS ; uv, ruff, mypy strict et pytest pour Python, pydantic aux
  frontières (API, config, fichiers externes) ; mise et `rails new` pour Ruby/Rails.
- Avant de dire qu'une tâche est finie, lance la vérification du projet indiquée dans son CLAUDE.md ou ses règles et montre la commande et sa sortie ; pour un changement visible dans l'app, lance aussi `/verify`.
- Pour un changement qui ne tient pas en une phrase, passer par le mode plan. Le contenu d'un plan, la revue avant merge et la description de PR suivent le skill `ship`.
- Un sous-agent pour une grosse PR ou un travail parallèle, une seule PR par agent ; une petite PR ou des correctifs se font dans la session. Ne paralléliser que des branches indépendantes, jamais les étages d'une pile. Un worktree neuf a ses dépendances avant toute commande : installées depuis le lockfile, ou liées (`worktree.symlinkDirectories`) hors d'un monorepo. Sans elles, les hooks git (lefthook…) passent sans rien vérifier ; dans un monorepo, des `node_modules` liés font vérifier le code contre les paquets d'une autre branche. Toute commande de plus de 2 min tourne en arrière-plan ; une suite complète tourne en CI, pas en local.
- Avant un run sans surveillance : un critère d'arrêt écrit (ex. CI verte et revue traitée), un plafond (`/goal`, `--max-turns` ou `--max-budget-usd`), et un essai d'abord sur quelques cas.
- Lors d'une compaction, préserver : PR en cours, branche, plan en cours, dernière tâche terminée, décisions ouvertes.

## Fiabilité et périmètre
- Une affirmation sur du code, un outil, une API, une pratique ou un chiffre vient de ce que j'ai lu dans la session (fichier ouvert, doc officielle, mesure) et je dis d'où elle vient ; sinon je la présente comme une hypothèse. Une réponse plausible mais inventée fait refaire le travail.
- Avant de construire, chercher l'outil maintenu ou le mécanisme natif qui le fait déjà : du code maison se maintient à vie. Une dépendance ajoutée est vérifiée sous son nom exact dans le registre (existe, maintenue) : un nom deviné peut être un paquet piégé.
- Livrer ce qui est demandé, au périmètre voulu, sans fonctionnalité, abstraction ni gestion d'erreur pour un cas qui ne peut pas arriver. Si une meilleure approche existe, le dire en une phrase puis faire ce qui est demandé.
- Un document écrit a la longueur que le sujet exige, sans sections de remplissage.
- Modifier les fichiers avec Edit ou Write, pas par une commande Bash : seuls les premiers sont suivis par les checkpoints et annulables par `/rewind`.

## Interdits
- Jamais deux versions d'une même chose, ni un fichier sans usage : ce qu'une PR remplace, elle le supprime. Sinon on ne sait plus laquelle fait foi.
- Jamais un changement de comportement sans son test écrit, vu en échec pour la bonne raison et commité avant le code (TDD), dans un projet qui a des tests : un test jamais vu échouer ne prouve pas qu'il teste quelque chose.
- Jamais un test validé modifié, désactivé ou contourné pour passer, ni un mock sur le code testé : si un test semble faux, je m'arrête et l'explique. Sinon le test s'adapte au code au lieu de le contrôler.
- Jamais de test décoratif : pas d'assertion triviale, ni de valeur attendue recalculée comme le fait le code (elle vient du plan ou de la spec) ; un service, un helper ou une validation modifié a son test, cas nominal et cas limites. Un test décoratif donne une confiance qu'il ne mérite pas.
- Jamais un test instable dit réparé sans l'avoir vu échouer en répétition avant la correction et passer après, dans les mêmes conditions : sinon le passage peut n'être que de la chance.
- Jamais un fait recopié dans la doc ou un CLAUDE.md : elle renvoie au code qui le porte, sinon elle dérive.
- Jamais un `git push`, `fetch` ou `pull` sous une autre forme que celles de `sandbox.excludedCommands` (`settings.json`), lancées seules : toute autre forme reste dans le sandbox et échoue.
