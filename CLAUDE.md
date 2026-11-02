# Pratiques de code

- Code, identifiants, messages de commit et noms de branches en anglais. Commits au format Conventional Commits.
- Nouveau projet : pnpm ou bun pour JS/TS ; uv, ruff, mypy strict et pytest pour Python, pydantic aux
  frontières (API, config, fichiers externes) ; mise et `rails new` pour Ruby/Rails.
- Avant de dire qu'une tâche est finie, lance la vérification du projet indiquée dans son CLAUDE.md ou ses règles et montre la commande et sa sortie ; pour un changement visible dans l'app, lance aussi `/verify`.
- Pour un changement qui ne tient pas en une phrase, passer par le mode plan ; un plan donne le comportement attendu par des exemples (entrée, sortie), nomme les fichiers et interfaces touchés, dit ce qui est hors périmètre et les exigences de sécurité, liste les cas de test (nominaux, limites, attaque) et finit par une vérification de bout en bout.
- Avant un merge, une seule `/code-review` relit la branche dans un contexte neuf, contre le plan : correction et écarts au plan, sans le style. Une passe ; les correctifs ne sont pas relus à nouveau. La duplication est tenue par un outil en CI (jscpd, flay…) ; sans cet outil, `/simplify` passe avant la revue. Un constat retenu se corrige avant le merge, par la session courante quand il tient en quelques lignes.
- Un diff qui touche l'authentification, les autorisations, les paiements, la cryptographie, les données personnelles ou des entrées externes passe aussi `/security-review`, et la PR le signale pour ta relecture. La description de PR donne la sortie des vérifications, le résultat des revues, les dépendances ajoutées avec leur raison et ce qui reste incertain.
- Un sous-agent pour une grosse PR ou un travail parallèle, une seule PR par agent ; une petite PR ou des correctifs se font dans la session. Ne paralléliser que des branches indépendantes, jamais les étages d'une pile. Toute commande de plus de 2 min tourne en arrière-plan ; une suite complète tourne en CI, pas en local.
- Avant un run sans surveillance : un critère d'arrêt écrit (ex. CI verte et revue traitée), un plafond (`/goal`, `--max-turns` ou `--max-budget-usd`), et un essai d'abord sur quelques cas.
- Lors d'une compaction, préserver : PR en cours, branche, plan en cours, dernière tâche terminée, décisions ouvertes.

## Fiabilité et périmètre
- Une affirmation sur du code, un outil, une API, une pratique ou un chiffre vient de ce que j'ai lu dans la session (fichier ouvert, doc officielle, mesure) et je dis d'où elle vient ; sinon je la présente comme une hypothèse. Une réponse plausible mais inventée fait refaire le travail.
- Avant de construire, chercher l'outil maintenu ou le mécanisme natif qui le fait déjà : du code maison se maintient à vie. Une dépendance ajoutée est vérifiée sous son nom exact dans le registre (existe, maintenue) : un nom deviné peut être un paquet piégé.
- Livrer ce qui est demandé, au périmètre voulu, sans fonctionnalité, abstraction ni gestion d'erreur pour un cas qui ne peut pas arriver. Si une meilleure approche existe, le dire en une phrase puis faire ce qui est demandé.
- Réponses brèves, le résultat d'abord, le détail ensuite. Un document écrit a la longueur que le sujet exige, sans sections de remplissage.

## Interdits
- Jamais deux versions d'une même chose, ni un fichier sans usage : ce qu'une PR remplace, elle le supprime. Sinon on ne sait plus laquelle fait foi.
- Jamais un changement de comportement sans son test écrit, vu en échec pour la bonne raison et commité avant le code (TDD), dans un projet qui a des tests : un test jamais vu échouer ne prouve pas qu'il teste quelque chose.
- Jamais un test validé modifié, désactivé ou contourné pour passer, ni un mock sur le code testé : si un test semble faux, je m'arrête et l'explique. Sinon le test s'adapte au code au lieu de le contrôler.
- Jamais de test décoratif : pas d'assertion triviale ; un service, un helper ou une validation modifié a son test, cas nominal et cas limites. Un test décoratif donne une confiance qu'il ne mérite pas.
- Jamais un test instable dit réparé sans l'avoir vu échouer en répétition avant la correction et passer après, dans les mêmes conditions : sinon le passage peut n'être que de la chance.
- Jamais un fait recopié dans la doc ou un CLAUDE.md : elle renvoie au code qui le porte, sinon elle dérive.
- Jamais un `git push`, `fetch` ou `pull` sous une autre forme que celles de `sandbox.excludedCommands` (`settings.json`), lancées seules : toute autre forme reste dans le sandbox et échoue.
