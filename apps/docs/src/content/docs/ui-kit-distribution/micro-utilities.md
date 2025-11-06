---
title: Micro-Utilities
description: A small, ergonomic utility layer for page composition: container, stack, cluster, and grid.
---

## Utilities

Defined in `app/styles/app.css` under `@layer utilities`:

```css
/* app/styles/app.css (utilities excerpt) */
.container { width: min(100% - 2rem, 72rem); margin-inline: auto; }
.stack > * + * { margin-top: var(--space-4); }
.stack--sm > * + * { margin-top: var(--space-2); }
.stack--lg > * + * { margin-top: var(--space-6); }
.cluster { display:flex; flex-wrap:wrap; align-items:center; gap:var(--space-3); }
.cluster--lg { gap: var(--space-5); }
.grid { display:grid; gap:var(--space-5); }
@media (min-width:48rem){ .grid--2{grid-template-columns:repeat(2,1fr)} .grid--3{grid-template-columns:repeat(3,1fr)} }
```

## When to use

- Use micro-utilities for page composition and spacing between sections.
- Use CSS Modules for component-specific layout and look.
- Prefer component props for semantic variants (e.g., `Button variant="ghost"`).

## Tailwind → Micro-utilities mapping

| Tailwind utility (common)                 | Use this micro-utility              |
|------------------------------------------|-------------------------------------|
| `max-w-* mx-auto px-*`                   | `.container`                        |
| `space-y-*`                               | `.stack` / `.stack--sm` / `--lg`    |
| `flex gap-* items-center flex-wrap`      | `.cluster` / `.cluster--lg`         |
| `grid grid-cols-2 gap-*`                  | `.grid.grid--2`                     |
| `grid grid-cols-3 gap-*`                  | `.grid.grid--3`                     |
| `gap-*`                                   | `.cluster--lg` or `.grid` gap vars  |

> Extend the utilities only when needed; resist the urge to recreate Tailwind in the app.


