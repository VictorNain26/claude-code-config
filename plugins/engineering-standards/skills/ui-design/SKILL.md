---
name: ui-design
user-invocable: false
description: Use when writing or reviewing UI components, styles, forms or layouts — design tokens, accessibility (WCAG 2.2), interaction states, responsive layout, motion, dark mode, layout shift, form validation, error copy.
paths:
  - "**/*.{tsx,jsx,vue,svelte}"
  - "**/*.{css,scss}"
  - "**/components/**"
  - "**/*.stories.*"
  - "**/tailwind.config.*"
---

# UI defaults

- **Tokens only**: no hardcoded color, spacing, type, radius or shadow; go through the design system's tokens or variables.
- **Accessibility is part of done**: contrast ≥ 4.5:1, interactive targets ≥ 24×24 px (aim for 44 px on touch), semantic roles and `aria-*`, keyboard navigation, visible focus never hidden behind a sticky header, focus order = visual order.
- **Every state**: hover, focus, active, disabled, loading, error, empty. No happy-path-only component.
- **Reuse before creating**: extend an existing component with variants rather than adding a one-off; a change to a shared component affects every usage — check them.
- **Established primitives**: modals, menus, toasts and the like follow the UI library's documented pattern (Radix, shadcn, platform HIG), never a hand-rolled one.
- **Mobile-first**: breakpoints from the start; nothing breaks on a small screen.
- **Spacing and type**: 8 px base through tokens, `gap` over scattered margins, unitless `line-height`, line length ~66ch, `rem`/`ch` for text — fixed `px` text breaks zoom.
- **Motion is opt-in**: decorative animation inside `@media (prefers-reduced-motion: no-preference)`; 200–300 ms, `ease-out` on enter; opacity fallback under `reduce`.
- **Dark mode**: `color-scheme: light dark` plus `<meta name="color-scheme">`, no pure white on black, the user's choice persists.
- **No layout shift**: `width`/`height` or `aspect-ratio` on media, reserved space for third-party content, skeletons over spinners.
- **Forms**: a real `<label>` (never the placeholder alone), fitting `type`/`inputmode`/`autocomplete`, inline validation on blur, never clear a field in error.
- **Error copy**: name the problem and the fix; toast for a warning, modal only for the irreversible.
