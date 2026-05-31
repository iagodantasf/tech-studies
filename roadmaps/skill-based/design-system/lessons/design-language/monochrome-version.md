---
title: Monochrome Version
track: design-system
group: Design language
tags: [design-system, color]
prerequisites: [color, functional-colors]
see-also: [dark-mode, accessibility, accessibility-testing]
---

# Monochrome Version

A grayscale rendering of the UI — every color collapsed to its luminance — used both as an accessibility test and as a real output mode (print, e-ink, high-contrast).

## Why it matters

Grayscale is the fastest audit of whether your design works without hue. If two states are distinguishable only by color, they vanish in monochrome — which is exactly what a red-green color-blind user (~8% of men) experiences. Designers who can read the UI in grayscale have already solved most color-blindness issues for free. It's also a genuine delivery target: thermal receipts, boarding passes, Kindle, and Windows High Contrast all strip or remap color.

## How it works

Convert by **perceived luminance**, not a naive desaturate, because equal-saturation colors can map to the same gray:

- **Luminance formula**: `Y ≈ 0.2126·R + 0.7152·G + 0.0722·B` (linearized). Green reads far brighter than blue at equal saturation.
- **The trap**: a mid red and a mid green often share near-identical luminance → identical gray. That's the visible proof of an unsafe pairing.
- **Fix with non-color cues**: icon, label, weight, shape, position, or underline — anything that survives the collapse.

| Element | Color cue | Monochrome-safe addition |
|---|---|---|
| Form error | red border | `!` icon + message |
| Required field | red asterisk | "(required)" text |
| Active tab | blue underline | bold weight + underline |
| Chart series | hue per line | dash pattern / direct labels |

Test it by toggling a CSS `filter: grayscale(1)` over a built screen, or auditing in a [[functional-colors]] review. This is a core check in [[accessibility-testing]].

## Example

A status dashboard uses green/amber/red dots for healthy/warning/down. Apply `grayscale(1)`: amber and red flatten to nearly the same gray — operators can't tell "warning" from "down." Fix: add a glyph per state (`✓ / ! / ✕`). Now luminance is irrelevant; the shape carries meaning. The same screen then prints correctly on a monochrome report.

## Pitfalls

- **Naive desaturation** — averaging RGB ignores that green ≫ blue in luminance; use the weighted formula.
- **Assuming grayscale = color-blindness** — it approximates total absence of hue; real CVD is partial, but grayscale is a strict, safe lower bound.
- **Color-only charts** — legends keyed purely by hue are unreadable in mono and for CVD; add patterns or direct labels.
- **Forgetting it's a real surface** — print/e-ink users get this mode whether you designed for it or not.

## See also

- [[dark-mode]]
- [[accessibility-testing]]
