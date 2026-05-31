---
title: Icon
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [defining-design-tokens]
see-also: [button, badge, accessibility]
---

# Icon

A small, scalable pictogram delivered as a consistent, token-sized set — the system's visual shorthand for actions, objects, and statuses.

## Why it matters

Icons are tiny but systemic: an inconsistent set (mixed stroke widths, optical sizes, or grids) makes a whole product feel unpolished, and unlabeled icon-only [[button]]s silently exclude screen-reader users. The icon component governs *how* SVGs are sized, colored, and labeled so 300 glyphs behave like one family. It's also a [[performance]] lever — how you ship icons decides bundle weight.

## How it works

Treat icons as a constrained, accessible asset pipeline:

- **Design grid** — all icons on one grid (commonly 24px) with a single stroke width and optical adjustments, so they align.
- **Sizing** — render at token sizes (`16 / 20 / 24`); `currentColor` so they inherit text color and theme automatically.
- **Accessibility** — decorative icon → `aria-hidden="true"`; meaningful standalone icon → an accessible label (`aria-label` / visually-hidden text).
- **Delivery** — SVG sprite, inline components, or icon font; prefer tree-shakeable SVG components for control and weight.

| Delivery | Pros | Cons |
|---|---|---|
| SVG sprite | One request, cached | Build step |
| Inline SVG component | Per-icon, tree-shake | Many imports |
| Icon font | Easy sizing | A11y/render quirks |

## Example

`<Icon name="trash" size="20" />` renders a 20px SVG using `currentColor`, so inside a red danger [[button]] it inherits the text color with no extra styling. As a standalone delete control, the button gets `aria-label="Delete"` because the icon alone conveys the action. The app imports only the ~12 icons it uses; the other 290 in the set never enter the bundle, keeping the payload small. See [[performance]].

## Pitfalls

- **Unlabeled icon-only controls** — a bare trash button is silent to screen readers; add an accessible name. See [[accessibility]].
- **Mixed grids/strokes** — glyphs from different sets clash; enforce one grid and weight.
- **Shipping the whole set** — bundling 300 icons for 12 used wastes payload; tree-shake.
- **Hardcoded fill color** — breaks theming; use `currentColor` or a token.

## See also

- [[button]]
- [[badge]]
