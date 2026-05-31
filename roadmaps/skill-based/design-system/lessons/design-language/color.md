---
title: Color
track: design-system
group: Design language
tags: [design-system, color]
prerequisites: [design-language]
see-also: [functional-colors, dark-mode, defining-design-tokens]
---

# Color

The system's color foundation: a small set of hue *ramps* (each a stepped scale of one hue) plus rules for how those steps map to UI roles.

## Why it matters

Color is where drift starts: ask "what blue?" with no system and you get `#0A66FF`, `#1976D2`, and `#2962FF` shipped on three screens. A ramp replaces "pick a blue" with "use `blue.600`," which is checkable in review and survives a rebrand as one token edit. It's also the foundation most entangled with [[accessibility]] — text contrast is a color decision, so the ramp must be designed for legibility, not just brand vibe.

## How it works

Define each hue as a **ramp of 9–11 steps** (e.g. 50, 100, … 900), then assign steps to roles:

- **Anchor on perceived lightness** — author ramps in a perceptual space (OKLCH/HSL-lightness), not raw hex, so steps feel evenly spaced. Equal hex jumps look lumpy.
- **Bake in contrast targets** — pick steps so that text/background pairs clear WCAG: **4.5:1** for body text, **3:1** for large text and UI boundaries.
- **Two layers of tokens**: primitive (`blue.600 = #2563EB`) → semantic (`color.action = blue.600`). Components reference the semantic layer only. See [[defining-design-tokens]].

| Token tier | Example | Who uses it |
|---|---|---|
| Primitive ramp | `gray.100 … gray.900` | The ramp definition |
| Semantic role | `color.text.default` | Components, designers |
| Component | `button.bg.hover` | One component |

Keep the palette tight: 1 brand hue, 1–2 accents, 1 neutral ramp (10 grays), plus the [[functional-colors]]. A 60-color palette is unmanageable; a healthy core is ~5 ramps.

## Example

Brand hue indigo, ramp authored in OKLCH at fixed lightness steps. Body text uses `indigo.50` on `indigo.700` (background) → measured **7.1:1**, passes AAA. The "primary action" semantic token points at `indigo.600`; when marketing rebrands to violet, only the 11 primitive steps change and every button, link, and focus ring follows. See [[dark-mode]] for the second mapping of the same roles.

## Pitfalls

- **Equal hex steps** — `#EEE,#DDD,#CCC` look uneven; humans perceive lightness non-linearly. Author in a perceptual model.
- **Components referencing primitives** — `button { background: blue.600 }` skips the semantic layer, so re-theming and [[dark-mode]] break.
- **Designing for light then bolting on dark** — the ramp must support both inversions from the start.
- **Brand color as text on white** — a vivid `blue.500` often fails 4.5:1; reserve mid-steps for fills, darker steps for text.

## See also

- [[functional-colors]]
- [[defining-design-tokens]]
