---
description: Ce qui rend un test honnête — chargé en ouvrant un fichier de test
paths:
  - "**/*.{test,spec}.{ts,tsx,js,jsx,mjs,cjs,py,go,rs}"
  - "**/tests/**"
  - "**/__tests__/**"
  - "**/vitest.config.*"
  - "**/jest.config.*"
---

# Tests

Nommer la casse avant d'écrire le test : quel changement du code de production
le ferait échouer ? Sans réponse, le test ne vaut rien. S'il ne peut échouer que
sur une décision intentionnelle — valeur d'une constante, libellé exact — c'est
un détecteur de changement : il sonne aux refontes et dort sur les bugs.

Un double n'est jamais la chose testée. Une assertion sur un mock passe parce
que le mock est là. Assertion sur le comportement réel, ou pas d'assertion.

Connaître avant de simuler. Ne pas mocker une dépendance externe sans avoir
vérifié son contrat réel — ses `.d.ts`, son code, ou un test de
caractérisation. Un double bâti sur ma compréhension d'une API ne peut pas
révéler que ma compréhension est fausse. C'est la première cause de tests verts
sur du code faux.

Un test de contrat par dépendance externe, qui vérifie mes suppositions contre
la bibliothèque installée, sans réseau. C'est là qu'une montée de version fait
du bruit, plutôt qu'en production.

Exécuter avant de dire que c'est fini. Un script écrit et jamais lancé est un
script cassé : chemin nominal et chemin d'échec, au moins une fois chacun. Les
tests unitaires ne remplacent pas cette exécution, ils partagent mes
suppositions.
