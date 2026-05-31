---
title: Grid
track: design-system
group: Design language
tags: [design-system, layout]
prerequisites: [design-language]
see-also: [grid-relation, breakpoints, defining-design-tokens]
---

# Grid

The shared layout structure — columns, gutters, margins, and an underlying spacing unit — that aligns content across screens so layouts feel deliberate rather than improvised.

## Why it matters

The grid is what makes unrelated screens feel like the same product. Without one, every page invents its own margins and a sidebar that's 240px here and 256px there; with one, "12 columns, 24px gutters" is a constraint designers and engineers share. It also ties layout to spacing: when the grid's base unit *is* the spacing scale's base unit, margins, gaps, and component padding all snap together. The grid is the skeleton; [[breakpoints]] decide when it changes shape.

## How it works

A grid is defined by a handful of parameters, all multiples of one base unit (4 or 8px):

- **Base unit** — usually 8px; every measure is a multiple, so the grid and spacing scale share arithmetic.
- **Columns** — commonly 12 (divisible by 2, 3, 4, 6 → flexible spans); 4 on mobile.
- **Gutter** — space *between* columns (e.g. 24px).
- **Margin** — outer page padding (e.g. 16px mobile, 64px desktop).
- **Max content width** — cap line length / layout (~1200–1440px) so it doesn't sprawl on wide monitors.

| Param | Mobile | Desktop |
|---|---|---|
| Columns | 4 | 12 |
| Gutter | 16px | 24px |
| Margin | 16px | 64px |
| Max width | 100% | 1200px |

Two flavors coexist: the **column grid** (horizontal layout) and the **baseline/8pt grid** (vertical rhythm — every element snaps to an 8px step). Freeze these as [[defining-design-tokens]] and see [[grid-relation]] for how components inherit them.

## Example

8px base, 12 columns, 24px gutters, 1200px max. A three-card row: container 1200px → minus margins → each card spans 4 columns. Card width computes to a clean multiple, gap = one gutter (24px), internal padding `space.4 = 16px`. Drop to mobile: grid becomes 4 columns, cards stack full-width. Nothing is eyeballed; every value derives from the grid.

## Pitfalls

- **Grid unit ≠ spacing unit** — a 12px grid with a 16px spacing scale fights itself; share one base.
- **Treating it as decoration** — a guide layer designers ignore is useless; the grid must drive real component widths and gaps.
- **No max width** — 12 columns stretched across a 4K monitor yields 200-character lines; cap content width.
- **Odd column counts** — 5 or 7 columns can't split evenly into halves/thirds; 12 is divisible by 2/3/4/6.

## See also

- [[grid-relation]]
- [[breakpoints]]
