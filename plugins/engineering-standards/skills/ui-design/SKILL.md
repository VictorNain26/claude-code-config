---
name: ui-design
user-invocable: false
description: UI rules for components, styles, forms and layouts: WCAG 2.2 accessibility, design tokens, interaction states, responsive layout, motion, dark mode, layout shift, form validation, error copy, visual check. Use when writing, changing or reviewing UI code: a component, a style, a form or a layout.
paths:
  - "**/*.{tsx,jsx,vue,svelte}"
  - "**/*.{css,scss}"
  - "**/components/**"
  - "**/*.stories.*"
  - "**/tailwind.config.*"
---

# UI rules

## Standards — WCAG 2.2

- Text contrast ≥ 4.5:1 (SC 1.4.3); interactive targets ≥ 24×24 px (SC 2.5.8),
  aim for 44 px on touch.
- Keyboard operable, visible focus never hidden behind a sticky header
  (SC 2.4.11), focus order matching visual order (SC 2.4.3).
- Semantic elements and roles first, `aria-*` only where HTML has no element.
- Every form field has a real `<label>` (SC 1.3.1, 3.3.2), never the
  placeholder alone.
- Motion beyond decoration respects `prefers-reduced-motion` (SC 2.3.3).

## Defaults — the project's design system wins where it differs

- Tokens only: no hardcoded color, spacing, type, radius or shadow.
- Every interactive state: hover, focus, active, disabled, loading, error, empty.
- Reuse and extend an existing component before adding one; a change to a
  shared component affects every usage — check them.
- Established primitives (Radix, shadcn, platform HIG) for modals, menus and
  toasts, never hand-rolled ones.
- Mobile-first breakpoints; `rem`/`ch` for text, unitless `line-height`,
  line length around 66ch.
- Media get `width`/`height` or `aspect-ratio`; skeletons over spinners.
- Inline validation on blur; never clear a field in error.
- Dark mode through `color-scheme` and tokens, persisted user choice.
- Error copy names the problem and the fix; modals only for the irreversible.

## Before calling it done

- Look at the change rendered, in a browser or a screenshot, at a mobile
  width and in every theme the project supports.
- Without a way to see it, say the rendering is unchecked; never describe how
  a UI looks from its code alone.
