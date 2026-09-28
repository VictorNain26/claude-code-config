# claude-code-config

Source chezmoi du harness utilisateur de Claude Code ; `README.md` décrit le
déploiement.

- Aucun outillage maison ici : un besoin se couvre par une fonction native de
  Claude Code ou un outil maintenu, installé par son canal officiel. Ce dépôt ne
  contient que de la configuration.
- Un réglage va dans `home/.chezmoidata/claude.json` — `claude.settings` s'il
  vaut partout, `claude.hosts.<hostname>` sinon —, puis `chezmoi diff` et
  `chezmoi apply`. Ne jamais éditer `~/.claude/settings.json` à la main pour un
  changement durable.
- Toute affirmation sur un réglage cite sa page dans code.claude.com/docs, dans
  le message de commit.
- Aucune valeur secrète : le dépôt se clone sur chaque machine. Les chemins de
  fichiers sensibles n'y figurent que dans `autoMode.environment`, pour le
  classifieur.
