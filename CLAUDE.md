# claude-code-config

Configuration Claude Code commune à l'équipe ; `README.md` décrit le
déploiement.

- Ne va ici que ce qui doit être identique pour tous. Une préférence, une
  machine, un réseau ou un dépôt personnel va dans la couche de chacun
  (`~/.claude/`).
- Aucun outillage maison : un besoin se couvre par une fonction native de
  Claude Code (managed settings, CLAUDE.md managé, plugin) ou un outil maintenu.
- Après une modification : `jq empty` sur chaque JSON, `claude plugin validate .`
  et `claude plugin validate ./plugins/team-standards`.
- Une skill modifiée : incrémenter `version` dans son `plugin.json`, sinon les
  postes gardent l'ancienne.
- Toute affirmation sur un réglage cite sa page dans code.claude.com/docs, dans
  le message de commit.
- Aucune valeur secrète, aucune donnée personnelle.
