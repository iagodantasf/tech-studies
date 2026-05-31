---
title: Defining Design Tokens
track: design-system
group: Design tokens
tags: [design-system, design-tokens]
prerequisites: [design-language, color]
see-also: [file-formats, functional-colors, dark-mode]
---

# Defining Design Tokens

Design tokens are named, platform-agnostic key-value pairs (e.g. `color.bg.primary = #0A66FF`) that capture every visual decision as data, so the design language is consumed by reference instead of copied as raw literals.

## Why it matters

Tokens are the single source of truth that makes a rebrand a data edit instead of a find-and-replace across N codebases. The moment a component hardcodes `#0A66FF` or `16px`, that value is duplicated and will drift; a token gives it one canonical home that web, iOS, and Android all point at. They also make themes ([[dark-mode]], white-label) a swap of one layer rather than a fork of the whole library.

## How it works

The durable pattern is a **three-tier** scale so raw values change without breaking consumers:

| Tier | Example name | Value / reference | Who consumes it |
|---|---|---|---|
| Primitive (global) | `blue.500` | `#0A66FF` | tokens only, never UI |
| Semantic (alias) | `color.action.bg` | `{blue.500}` | components |
| Component | `button.primary.bg` | `{color.action.bg}` | one component |

Components reference **semantic** tokens, never primitives, so re-pointing `color.action.bg` from `blue.500` to `blue.600` updates every button at once. Token *types* cover color, spacing, sizing, typography (family/size/weight/line-height), radius, border, shadow, z-index, opacity, and motion (duration/easing). Naming is the hard part — a stable `category.property.variant.state` convention (see [[naming]]) is what keeps a 400-token set navigable. The values themselves come straight from the [[design-language]], [[color]] ramps, and the [[grid]] spacing scale.

## Example

A spacing scale defined once as primitives, aliased semantically:

```
space.1 = 4px   space.2 = 8px   space.3 = 12px   space.4 = 16px
space.inset.card = {space.4}     # card padding -> 16px
space.stack.sm   = {space.2}     # gap between stacked items -> 8px
```

Design ships dark mode by overriding only the semantic layer: `color.bg.surface` flips from `{grey.50}` to `{grey.900}`, while every component token and all primitives stay untouched — roughly 25 semantic overrides instead of editing hundreds of component values.

## Pitfalls

- **One flat tier** — exposing only `blue.500` to components means a palette change is a mass rename; the semantic layer exists precisely to absorb that.
- **Baking context into primitives** — naming a primitive `blue.primary` couples a raw value to a role; keep primitives literal (`blue.500`) and put intent in [[functional-colors]].
- **Over-tokenizing** — a token per one-off margin yields a set nobody can hold in their head. Tokenize repeated, decision-bearing values, not every number.
- **Tokens the code ignores** — if the [[component-library]] still hardcodes hex, the token set is documentation, not a source of truth.

## See also

- [[file-formats]]
- [[functional-colors]]
- [[naming]]
