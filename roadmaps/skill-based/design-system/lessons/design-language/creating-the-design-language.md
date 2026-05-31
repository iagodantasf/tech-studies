---
title: Creating the Design Language
track: design-system
group: Design language
tags: [design-system, foundations]
prerequisites: [making-a-design-system]
see-also: [design-language, design-principles, defining-design-tokens]
---

# Creating the Design Language

The activity of deciding the visual and interaction vocabulary — color, type, space, grid, motion, voice — *before* any component is built, so every later decision has a rule to follow.

## Why it matters

Components are cheap once the language exists and expensive when it doesn't: build [[button]] first and you bake in an arbitrary blue, a one-off radius, and a padding nobody can justify, then copy those mistakes 40 times. The language is the layer that makes 200 components feel like one product. Sequencing matters — language → [[defining-design-tokens]] → [[creating-core-components]]. Skip the first step and tokens become a dump of magic numbers with no system behind them.

## How it works

Work top-down, fixing the abstract before the concrete:

- **Principles** — 3–5 statements that break ties (see [[design-principles]]). Decided first because they justify everything below.
- **Foundations** — the measurable primitives, each defined as a *scale*, not a single value:
  - [[color]] (hue ramps + [[functional-colors]]), type scale, spacing scale, [[grid]], radius, elevation, motion.
- **Encode** — freeze each foundation as named [[defining-design-tokens]] so code and design share one source.

| Layer | Output | Example |
|---|---|---|
| Principles | Tie-breaker rules | "Clarity over density" |
| Foundations | Scales | 8-step spacing, 10-step gray |
| Tokens | Named values | `space.4 = 16px` |
| Components | Coded parts | [[button]] using those tokens |

Constrain hard: a *scale* of 6–10 steps, not a continuum. Two type families max, one spacing base (usually 4 or 8 px). Fewer choices is the goal — see [[creating-the-design-language]] outputs feeding [[component]] work.

## Example

A team starts the language for a fintech app. Spacing base = 4px → scale `{4,8,12,16,24,32,48}`. Type base 16px, ratio 1.25 → `{16,20,25,31,39}`. Gray ramp = 10 steps. One brand hue, two accents. That entire set — ~40 values — becomes the token file every [[button]], [[card]], [[modal]] consumes. No screen introduces a 14px gap or a fifth gray.

## Pitfalls

- **Building components before the language** — you reverse-engineer principles from accidents; drift is already shipped.
- **Infinite scales** — "any spacing" defeats the point; a closed 6–8 step scale is the constraint that creates consistency.
- **Language with no token encoding** — a Figma styleguide that code can't read drifts from the app within a release.
- **Copy-pasting another brand's language** — Material's ramps encode *Google's* principles, not yours; steal the method, not the values.

## See also

- [[design-language]]
- [[design-principles]]
