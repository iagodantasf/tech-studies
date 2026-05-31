---
title: Naming
track: design-system
group: Content & guidelines
tags: [design-system, naming]
prerequisites: [defining-design-tokens]
see-also: [defining-design-tokens, code-style, keywords-terminology]
---

# Naming

Naming is the convention that makes tokens, components, props, and variants predictable enough to *guess* — a structured grammar applied consistently across the system.

## Why it matters

Names are the public API of a design system; you rename a token far less often than you read it, so the cost of a bad name compounds. A predictable grammar means a developer can guess `color.text.disabled` exists without searching, and a reviewer can spot `btnColor2` as wrong on sight. Inconsistent naming is what turns a 400-token set into something only its author can navigate — the failure mode [[defining-design-tokens]] warns about.

## How it works

Tokens use a fixed ordered grammar, most-general to most-specific:

```
category . property . variant . state
color.text.primary           color.bg.danger.hover
space.inset.sm               size.icon.lg
```

| Layer | Convention | Example |
|---|---|---|
| Primitive | scale by number, no intent | `blue.500`, `space.4` |
| Semantic | intent, never value | `color.action`, not `color.blue` |
| Component | `component.part.variant.state` | `button.label.primary.hover` |
| Boolean prop | positive, no `is`-on-the-wire | `disabled`, not `notEnabled` |

Standing rules:

- **Name by intent, not value or appearance** — `color.danger`, never `color.red`; the red can change, the role won't.
- **Pick one casing per surface** — `kebab-case` tokens, `PascalCase` components, `camelCase` props (see [[code-style]]).
- **No magic numbers in names** — `grey3` hides meaning; `grey.300` ties to the scale.
- **Singular, full words** — `color` not `colors` or `clr`; abbreviations cost more than they save.

## Example

A team renames `$brandBlue`, `$blue2`, and `$accent` — three names for one value — to the tier `blue.500` (primitive) → `color.action` (semantic) → `button.bg.primary` (component). The first rebrand re-points `color.action` once; nothing referencing it changes. Compare the old world, where "which blue?" required reading every usage and a global find-replace that also hit unrelated blues.

## Pitfalls

- **Encoding the value** — `color.blue` / `grey3` couples a name to today's pixels and breaks at the next palette change.
- **Mixed grammars** — `bgColorPrimary` next to `color.bg.primary`; pick one order and enforce it in review.
- **Abbreviations** — `btn`, `clr`, `bg-pri` save keystrokes and cost comprehension; spell it out except universally-known `bg`.
- **Index suffixes for meaning** — `spacing-2` as "the medium one" breaks when you insert a value; map numbers to a real scale.

## See also

- [[defining-design-tokens]]
- [[code-style]]
