---
title: Performing a Visual Audit
track: design-system
group: Approach
tags: [design-system, audit]
prerequisites: [existing-design-analysis]
see-also: [color, grid, defining-design-tokens]
---

# Performing a Visual Audit

The hands-on capture step of an extraction: screenshotting every screen and state, then extracting the concrete color, type, spacing, and elevation values the product actually renders.

## Why it matters

It is the raw-data collection that makes [[existing-design-analysis]] possible — you can't converge a palette you've never enumerated. A thorough audit is also the single most persuasive artifact for leadership: a wall of 23 greys and 14 buttons makes the inconsistency undeniable in a way prose never does. It feeds directly into [[color]], [[grid]], and the token work in [[defining-design-tokens]].

## How it works

Capture broadly, extract precisely:

1. **Inventory the surface** — list every page, then every *state* per component (default, hover, focus, active, disabled, error, empty, loading). States are where audits silently go incomplete.
2. **Capture** — full-page screenshots at your real [[breakpoints]] (e.g. 360 / 768 / 1280). Don't eyeball; pull **computed styles** from devtools so you get the true rendered value, not the source.
3. **Extract by dimension** and tabulate frequency:

| Dimension | Capture method | Output |
|---|---|---|
| Color | computed `color` / `background` | hex list + counts |
| Type | computed size/weight/line-height | distinct combos |
| Spacing | measured gaps, paddings | value histogram |
| Elevation | box-shadow values | shadow set |

4. **Cluster** — group near-identical values (e.g. `#333` vs `#353535`) as merge candidates. The long tail collapses; the frequent head becomes the proposed scale.

Tools range from manual screenshots in a Figma board to crawlers (Project Wallace, CSS Stats) that dump every declared color and font-size automatically.

## Example

Auditing a dashboard: capturing the *table* component across states reveals the default row uses `#fafafa`, hover `#f5f5f5`, selected `#eef4ff` — three surfaces a static screenshot would have missed. Across the app, the CSS-Stats crawl reports 23 unique colors and 9 font-sizes; clustering proposes a 6-step grey ramp and a 6-size type scale, with every merge backed by a side-by-side screenshot for review.

## Pitfalls

- **Auditing only happy-path states** — disabled/error/empty hold their own off-scale values; miss them and the system ships with gaps.
- **Trusting source over computed** — declared CSS may be overridden by cascade or inline styles; audit what paints.
- **One breakpoint only** — desktop-only capture misses mobile-specific spacing and type that also need converging.
- **Screenshots without numbers** — pretty boards that don't extract concrete values can't drive a token decision; pair every image with its computed value.

## See also

- [[color]]
- [[grid]]
- [[defining-design-tokens]]
