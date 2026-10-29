# Pratiques de code

- Code, identifiants, messages de commit et noms de branches en anglais. Commits au format Conventional Commits.
- Nouveau projet : pnpm ou bun pour JS/TS ; uv, ruff, mypy strict et pytest pour Python, pydantic aux
  frontières (API, config, fichiers externes) ; mise et `rails new` pour Ruby/Rails.
- Avant de dire qu'une tâche est finie, lance la vérification du projet indiquée dans son CLAUDE.md ou ses règles.
- Pour un changement qui ne tient pas en une phrase, passer par le mode plan ; un plan nomme les fichiers et interfaces touchés, dit ce qui est hors périmètre et finit par une vérification de bout en bout.
- Avant un merge, `/simplify` repère le code dupliqué ou réinventé, puis `/code-review` relit la branche dans un contexte neuf. Une PR sans code (doc, config) passe par `/code-review` seul : `/simplify` n'y a rien à chercher. Ne retenir que ce qui touche la correction ou les exigences du plan ; un constat retenu se corrige avant le merge.
- Un sous-agent reçoit une seule PR, jamais une chaîne : le suivant part d'un contexte neuf. Toute commande de plus de 2 min tourne en arrière-plan ; une suite complète tourne en CI, pas en local.
- Lors d'une compaction, préserver : PR en cours, branche, plan en cours, dernière tâche terminée, décisions ouvertes.

## Fiabilité et périmètre
- Une affirmation sur du code, un outil, une API, une pratique ou un chiffre vient de ce que j'ai lu dans la session (fichier ouvert, doc officielle, mesure) et je dis d'où elle vient ; sinon je la présente comme une hypothèse. Une réponse plausible mais inventée fait refaire le travail.
- Avant de construire, chercher l'outil maintenu ou le mécanisme natif qui le fait déjà : du code maison se maintient à vie.
- Livrer ce qui est demandé, au périmètre voulu, sans fonctionnalité, abstraction ni gestion d'erreur pour un cas qui ne peut pas arriver. Si une meilleure approche existe, le dire en une phrase puis faire ce qui est demandé.
- Réponses brèves, le résultat d'abord, le détail ensuite. Un document écrit a la longueur que le sujet exige, sans sections de remplissage.

## Interdits
- Jamais deux versions d'une même chose, ni un fichier sans usage : ce qu'une PR remplace, elle le supprime. Sinon on ne sait plus laquelle fait foi.
- Jamais un changement de comportement sans son test écrit et vu en échec d'abord (TDD), dans un projet qui a des tests : un test jamais vu échouer ne prouve pas qu'il teste quelque chose.
- Jamais de test décoratif : pas d'assertion triviale ; un service, un helper ou une validation modifié a son test, cas nominal et cas limites. Un test décoratif donne une confiance qu'il ne mérite pas.
- Jamais un test instable dit réparé sans l'avoir vu échouer en répétition avant la correction et passer après, dans les mêmes conditions : sinon le passage peut n'être que de la chance.
- Jamais un fait recopié dans la doc ou un CLAUDE.md : elle renvoie au code qui le porte, sinon elle dérive.
