---
name: ship
description: Ce qu'un plan ajoute à la trame du mode plan, la revue avant merge et la description de PR. Charger avant d'écrire un plan en mode plan, avant `gh pr create` et avant de merger une PR.
---

# Plan

En plus de ce que demande le mode plan (contexte, approche, fichiers, réutilisation, vérification), un plan donne :
- le comportement attendu par des exemples (entrée, sortie) ;
- ce qui est hors périmètre et les exigences de sécurité ;
- les cas de test (nominaux, limites, attaque) avec leurs valeurs attendues, qui serviront aux tests.

# Avant le merge

- La duplication est tenue par un outil en CI (jscpd, flay…) ; sans cet outil, `/simplify` passe d'abord.
- Une seule `/code-review` relit la branche dans un contexte neuf, contre le plan : correction et écarts au plan, sans le style. Une passe ; les correctifs ne sont pas relus à nouveau.
- Un test commité avant le code n'est pas affaibli ensuite : `git diff <commit du test>..HEAD -- <fichiers de test>` est vide, ou la PR dit pourquoi.
- Un constat retenu se corrige avant le merge, par la session courante quand il tient en quelques lignes.
- Un diff qui touche l'authentification, les autorisations, les paiements, la cryptographie, les données personnelles ou des entrées externes est signalé dans la PR pour relecture humaine.

# Description de PR

Elle donne : la sortie des vérifications, le résultat des revues, les dépendances ajoutées avec leur raison, et ce qui reste incertain.
