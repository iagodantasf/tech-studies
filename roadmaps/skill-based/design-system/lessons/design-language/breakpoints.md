---
title: Breakpoints
track: design-system
group: Design language
tags: [design-system, layout]
prerequisites: [grid]
see-also: [grid-relation, defining-design-tokens, component]
---

# Breakpoints

The named viewport widths at which the layout changes — grid columns, margins, or component arrangement shift to fit a new size class.

## Why it matters

Breakpoints turn "responsive" from guesswork into a named contract: instead of every page picking its own width to reflow, the system says `md = 768px` and everyone reflows there. They are where the [[grid]] changes shape — 4 columns below `md`, 12 above. Defining them as tokens means a designer's "tablet" and an engineer's media query refer to the *same* number, and a [[component]] can declare its behavior per size class instead of per device.

## How it works

Define **size classes**, not device names — you target width ranges, not specific phones:

- **A small, named set** — typically xs/sm/md/lg/xl, 4–6 total. More breakpoints multiply the layouts you must test.
- **Mobile-first** — author base styles for the smallest, then add `min-width` overrides upward. This degrades gracefully and keeps CSS additive.
- **Content-driven** — put a breakpoint where the layout actually breaks (text gets too wide, cards too cramped), not at a trendy device width.

| Token | min-width | Typical layout |
|---|---|---|
| sm | 640px | single column, larger type |
| md | 768px | grid expands, sidebar appears |
| lg | 1024px | full 12-col, multi-pane |
| xl | 1280px | max content width caps |

Express ranges as `min-width` and let them cascade. Pair with [[grid-relation]] so that at each class the columns, gutters, and margins all come from the spacing scale. Store the values in [[defining-design-tokens]] so JS, CSS, and design tools agree.

## Example

A product grid: base (mobile-first) = 1 column. At `md (768px)` → 2 columns, sidebar filter slides in. At `lg (1024px)` → 3 columns, 12-col grid, 64px margins. The same `Card` component is unchanged; only the container's grid reflows at the named widths. A new engineer reads `breakpoint.lg` in both the Figma frame and the media query — one source, no "is tablet 768 or 800?" debate.

## Pitfalls

- **Device-specific breakpoints** — "iPhone width" ages instantly as hardware changes; target content/width ranges.
- **Too many breakpoints** — 9 of them means 9 layouts to QA; keep to ~5 size classes.
- **Desktop-first overrides** — `max-width` chains are subtractive and fragile; mobile-first `min-width` is additive and resilient.
- **Magic numbers in media queries** — hardcoding `@media (768px)` across files instead of a token guarantees they drift out of sync.

## See also

- [[grid-relation]]
- [[defining-design-tokens]]
