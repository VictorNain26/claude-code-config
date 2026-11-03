---
name: ship
description: Contenu attendu d'un plan, déroulé de la revue avant merge et contenu d'une description de PR. Utiliser en écrivant un plan, avant un merge ou en créant une PR.
---

# Plan

Un plan donne :
- le comportement attendu par des exemples (entrée, sortie) ;
- les fichiers et interfaces touchés ;
- ce qui est hors périmètre et les exigences de sécurité ;
- les cas de test (nominaux, limites, attaque), dont les valeurs attendues serviront aux tests ;
- une vérification de bout en bout pour finir.

# Avant le merge

- La duplication est tenue par un outil en CI (jscpd, flay…) ; sans cet outil, `/simplify` passe d'abord.
- Une seule `/code-review` relit la branche dans un contexte neuf, contre le plan : correction et écarts au plan, sans le style. Une passe ; les correctifs ne sont pas relus à nouveau.
- Un constat retenu se corrige avant le merge, par la session courante quand il tient en quelques lignes.
- Un diff qui touche l'authentification, les autorisations, les paiements, la cryptographie, les données personnelles ou des entrées externes est signalé dans la PR pour relecture humaine.

# Description de PR

Elle donne : la sortie des vérifications, le résultat des revues, les dépendances ajoutées avec leur raison, et ce qui reste incertain.
