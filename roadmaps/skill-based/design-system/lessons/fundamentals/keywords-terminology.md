---
title: Keywords / Terminology
track: design-system
group: Fundamentals
tags: [design-system, glossary]
prerequisites: []
see-also: [defining-design-tokens, component, pattern]
---

# Keywords / Terminology

The shared vocabulary of a design system — token, primitive, component, variant, pattern, foundation — so that designers, engineers, and writers mean the same thing by the same word.

## Why it matters

Most design-system arguments are vocabulary collisions. One person's "component" is another's "pattern"; "variant" gets confused with "instance"; "primitive token" with "alias token." Nailing definitions early prevents a [[component-catalog]] where the same concept has three names and [[naming]] reviews that go in circles. The terms below recur across every later node.

## How it works

Most systems layer terms from raw value up to composed experience:

| Term | Meaning | Example |
|---|---|---|
| Design token | Named design decision as data | `color.brand.primary = #0A66FF` |
| Primitive / global token | Raw, context-free value | `blue.500` |
| Alias / semantic token | Intent-named, points to a primitive | `color.action` → `blue.500` |
| Foundation | Cross-cutting basics | color, type, spacing, [[grid]] |
| Component | Single reusable UI unit | [[button]], [[input-text]] |
| Variant | A component's configured form | `button` primary / danger |
| Instance | One placed use of a component | the Save button on this form |
| Pattern | Composition solving a recurring problem | a validated form layout |

Key relationships, in prose:

- **Tokens flow in tiers** — primitive → alias → component-level. Components reference *alias* tokens, not raw hex, so a rebrand re-points aliases once. See [[defining-design-tokens]].
- **Variant vs instance** — a [[component|variant]] is a defined configuration in the library; an *instance* is a single placement in a product. Many instances, few variants.
- **Component vs pattern** — a [[component]] is one part; a [[pattern]] arranges several to solve a job (search-with-results, empty state). See [[pattern]].
- **Foundations underpin everything** — [[color]], type, and [[grid]] spacing are referenced by every component.

## Example

A "destructive confirm dialog" decomposes cleanly: the **pattern** is confirm-before-destroy; its **components** are [[modal]] + [[button]]; the danger button is a **variant**; this one on the delete screen is an **instance**; its red comes from the alias **token** `color.danger` → primitive `red.600`. Each layer has exactly one correct word.

## Pitfalls

- **"Component" as a catch-all** — calling patterns, layouts, and tokens all "components" makes the [[component-catalog]] meaningless. Reserve the word for single units.
- **Naming tokens by value** — `color.blue` breaks the moment the brand blue changes; name by *intent* (`color.action`). See [[naming]].
- **Skipping alias tokens** — if components reference primitives directly, you lose the indirection that makes theming and [[dark-mode]] cheap.

## See also

- [[defining-design-tokens]]
- [[component]]
