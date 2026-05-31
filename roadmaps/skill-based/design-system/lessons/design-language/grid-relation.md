---
title: Grid Relation
track: design-system
group: Design language
tags: [design-system, layout]
prerequisites: [grid]
see-also: [breakpoints, defining-design-tokens, component]
---

# Grid Relation

How the grid, the spacing scale, type, and component dimensions all derive from one base unit, so every measurement in the system is a multiple of the same number.

## Why it matters

A [[grid]] in isolation only governs page columns; the *relation* is what makes a button's height, a card's padding, and an icon's size all land on the same rhythm. When everything is a multiple of 8 (or 4), values compose without surprises — stack two 24px rows and a 16px gap and you're still on-grid. Break the relation and you get a 14px gap next to a 16px margin: subtly off, impossible to debug, and the reason a layout "feels wrong" with no obvious cause.

## How it works

Pick one base (commonly **8px**, with a **4px** half-step for fine control) and derive everything from it:

- **Spacing scale** — `{4, 8, 12, 16, 24, 32, 48, 64}` — all multiples of 4, mostly of 8.
- **Component sizing** — heights snap to the scale: control height 40px, icon 24px, avatar 32px.
- **Type to grid** — line-height set so text blocks occupy whole-step multiples (16px text → 24px line = 3 steps).
- **Gutters/margins** — drawn from the same scale, so [[grid]] columns and component gaps agree.

| Element | Value | Steps of 8 |
|---|---|---|
| Card padding | 16px | 2 |
| Section gap | 32px | 4 |
| Button height | 40px | 5 |
| Icon | 24px | 3 |

The rule of thumb: *if a number isn't a multiple of the base, it needs justification.* The 4px half-step exists for the few cases (small icon insets, 1px borders aside) where 8 is too coarse. All of this lives in [[defining-design-tokens]] so [[component]] authors inherit it instead of inventing values.

## Example

A list row: vertical padding `space.2 = 8px`, avatar 32px (4 steps), 16px gap to text, row height resolves to 48px (6 steps). A whole feed of these rows tiles perfectly into the 8pt baseline grid — no half-pixel seams, no cumulative drift over 50 rows. Swap the avatar to 40px and the row recomputes to 56px, still on-grid, because every part references the scale.

## Pitfalls

- **Off-grid magic numbers** — a lone `13px` or `15px` padding breaks the rhythm and spreads via copy-paste.
- **Type ignoring the grid** — arbitrary line-heights push text blocks off the baseline; set line-height to whole steps.
- **Too fine a base** — a 1px or 2px base means "everything is on-grid," which is the same as no grid; 8px with a 4px half-step is the sweet spot.
- **Components hardcoding sizes** — bypassing the scale reintroduces the drift the relation exists to prevent.

## See also

- [[breakpoints]]
- [[defining-design-tokens]]
