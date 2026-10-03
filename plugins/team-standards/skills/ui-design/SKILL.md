---
name: ui-design
user-invocable: false
description: Défauts designer lead — chargés uniquement sur du front (composants, styles, UI)
paths:
  - "**/*.{tsx,jsx}"
  - "**/*.{css,scss}"
  - "**/components/**"
  - "**/*.stories.*"
  - "**/tailwind.config.*"
---

# Designer lead — défauts UI

- **Tokens d'abord** : zéro valeur hardcodée (couleur, espacement, typo, rayon, ombre) → toujours via les tokens/variables du design system. La cohérence est structurelle, pas à l'œil.
- **Accessibilité non négociable** : contraste WCAG AA (4.5:1), cibles tactiles ≥44px, `aria-*`/rôles sémantiques, navigation clavier, focus visible. Un composant livré sans a11y est incomplet.
- **États complets** : tout élément interactif a hover/focus/active/disabled/loading/error/empty. Pas de composant « happy-path only ».
- **Cohérence > créativité locale** : réutiliser un composant/pattern existant avant d'en créer ; un nouveau composant doit être générique (variants), pas un one-off dupliqué. Un changement sur un composant partagé impacte tous ses usages — vérifier avant de livrer.
- **Mobile-first & responsive** : penser les breakpoints dès le départ, jamais un layout qui casse en petit écran.
- **Design doc-first** : avant d'inventer un pattern UI (modal, dropdown, toast, menu…), s'appuyer sur les conventions établies (Radix, shadcn, HIG Apple, Material) et la doc de la lib UI. Ne pas réinventer un primitive accessible.
- **Échelle d'espacement & typo** : espacements sur une base cohérente (multiples de 8px) via tokens, `gap` plutôt que des marges éparses ; échelle typo modulaire, `line-height` sans unité, longueur de ligne ~45–75 caractères (`max-inline-size: ~66ch`), unités relatives (`rem`/`ch`) — jamais de `px` fixe sur du texte (casse le zoom). ([web.dev typo](https://web.dev/learn/design/typography), [Material spacing](https://m3.material.io/foundations/layout/grids-spacing/grids))
- **Mouvement opt-in** : animation décorative dans `@media (prefers-reduced-motion: no-preference)` ; durées sobres (~200–300 ms micro-interactions), `ease-out` en entrée ; fallback opacité (pas de gros translate/scale) si `reduce`. ([WCAG 2.3.3](https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html), [web.dev motion](https://web.dev/learn/accessibility/motion))
- **Theming/dark** : `color-scheme: light dark` + `<meta name="color-scheme">` (évite le flash blanc) ; pas de blanc pur sur noir ; toggle qui **persiste** le choix. ([web.dev](https://web.dev/articles/light-dark))
- **Performance perçue (CLS ≤ 0,1)** : `width`/`height` ou `aspect-ratio` sur images/embeds, espace réservé pour tout contenu tiers ; skeletons plutôt que spinners. ([web.dev CLS](https://web.dev/articles/optimize-cls))
- **Formulaires** : `<label>` associé (jamais le placeholder seul), `type`/`inputmode` adaptés au clavier mobile, `autocomplete` sur les champs sensibles, validation inline **au blur** (pas à la frappe, pas que à la soumission) sans vider le champ en erreur. ([web.dev forms](https://web.dev/articles/sign-in-form-best-practices), [NN/g](https://www.nngroup.com/articles/errors-forms-design-guidelines/))
- **WCAG 2.2 (complète l'a11y ci-dessus)** : cible interactive **≥ 24×24 px** (plancher légal SC 2.5.8 ; viser ≥ 44 px en tactile), focus **non masqué** par un header/bandeau sticky (SC 2.4.11), landmarks HTML + ordre de focus = ordre visuel. ([W3C WCAG 2.2](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html))
- **Microcopie d'erreur** : nommer le problème + l'action corrective, composant adapté à la sévérité (toast pour un avertissement, modal réservé à l'irréversible). ([NN/g](https://www.nngroup.com/articles/error-message-guidelines/))
