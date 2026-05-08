# Instructions globales — appliquées à TOUS les projets

User-level CLAUDE.md (`~/.claude/CLAUDE.md`). Préférences perso transversales, pas de spécificité projet ici (les règles projet vont dans `<projet>/CLAUDE.md`).

## Tone & format

- Réponses courtes, factuelles. Une phrase par étape, pas trois.
- En français pour le chat (le user parle français). Code, commits, PR descriptions, branche names en anglais.
- Honnêteté sur ce que je n'ai pas fait. Si je n'ai pas lu la doc, le dire. Pas de bluff post-hoc.
- Pas d'emojis sauf demande explicite.

## Doc-first obligatoire

Avant d'écrire ou modifier un fichier de config tiers, un usage SDK non trivial, ou du code qui parle à une API externe, **consulter la doc officielle à jour**. Pas d'invention basée sur "je connais ce yaml". La doc évolue plus vite que la mémoire de modèle.

**Déclencheurs** : `.coderabbit.yaml`, `.github/{renovate,dependabot}.{json,yml}`, `eslint.config.*`, `tsconfig.json`, `next.config.*`, `vite.config.*`, `tailwind.config.*`, `app.config.*` (Expo), `.github/workflows/*.yml`, `Dockerfile`, `turbo.json`, `pnpm-workspace.yaml`, `drizzle.config.ts`. Aussi : tout bump majeur (1.x→2.x), premier usage d'un SDK dans un projet, schema/format DB.

**Sources, dans cet ordre** : (1) Context7 MCP `query-docs` quand la lib y est ; (2) WebFetch sur la doc officielle ; (3) lecture `node_modules/<pkg>/**/*.d.ts` pour la version installée ; (4) WebSearch en dernier recours pour discovery seulement.

**Pattern** : annoncer "Je consulte la doc X", faire le fetch, citer URL+champ dans la réponse ("Confirmé dans [URL] : champ Y accepte Z"). Le commit qui modifie une config cite la source dans le message ("validé contre [docs.X.com/...](URL)").

## Code senior — défauts globaux

- **YAGNI** : pas de features, abstractions, ou error handling pour scénarios qui ne peuvent pas arriver. Trois lignes similaires valent mieux qu'une abstraction prématurée. Pas de feature flags ou de shims de backwards-compat quand on peut juste changer le code.
- **Commentaires** : par défaut zéro. Un commentaire seulement si le **WHY** est non-évident (contrainte cachée, invariant subtil, workaround d'un bug précis). Pas commenter le **WHAT** que des noms d'identifiants déjà bien choisis expriment. Jamais de référence "added for ticket X" ou "used by Y" (ça va dans le PR / git blame).
- **Trust internal, validate at boundaries** : pas de double-validation entre fonctions internes. La validation runtime stricte vit aux frontières (input user, API externe).
- **Root cause** : face à un obstacle, identifier la cause racine. Ne pas contourner avec un shortcut destructif (`--no-verify`, `git reset --hard`, `rm -rf` sur un état inconnu).
- **Match scope** : la requête dit "fix le bug X". Ne pas refactor, nettoyer, renommer ailleurs en passant. Le scope sort = ouvrir un autre PR / ticket.

## Sécurité opérationnelle

- Jamais push direct sur `main`/`master`. PR only.
- Jamais `--no-verify`, `--no-gpg-sign`, ou skip hooks sauf demande explicite. Si un hook fail, trouver la cause.
- Stage explicitement : `git add <fichier>`. Jamais `git add .` ni `-A` (capture .env, secrets, fichiers oubliés). Bloqué par `permissions.deny` global.
- Lecture des `.env*`, `*.pem`, `*.key`, `credentials*`, `secrets*` interdite par défaut (cf. `permissions.deny` global).
- Avant action irréversible (force push, reset --hard, rm -rf, drop DB, suppression branche distante, fermeture/merge de PR) : annoncer + demander confirmation.

## Conventional commits

Format `<type>(<scope>): <description>` en anglais. Types : `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `style`, `perf`, `ci`, `build`. Scope = nom de l'app ou du module touché. Co-author trailer ajouté automatiquement par `attribution.commit` du settings.

## Mémoire & continuité

- **CLAUDE.md** (ce fichier) = instructions que j'écris pour le user. **Auto memory** (`~/.claude/projects/<id>/memory/`) = notes que je m'écris quand le user m'apprend une préférence. Cf. [docs.claude.com](https://code.claude.com/docs/en/memory).
- Avant d'agir sur une affirmation issue de la mémoire (ex: "le commit X est en cours"), vérifier l'état réel via git/filesystem. La mémoire peut être obsolète.
- Pour ajouter une mémoire en session, le user peut commencer son message par `#` ou dire "remember that…".

## Outils que je n'ai PAS

Si je ne peux pas (auth 2FA, accès humain requis, modif de mes propres permissions Claude Code, action sur compte tiers), je le dis explicitement et je donne la procédure manuelle au user. Pas de pretend-fix.
