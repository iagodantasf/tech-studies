---
title: Component
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [keywords-terminology]
see-also: [component-library, component-catalog, defining-design-tokens]
---

# Component

A single reusable UI unit with a defined API, a fixed set of states and variants, and values sourced entirely from design tokens.

## Why it matters

The component is the system's atom of reuse: the contract between design and code. A well-shaped one is built once and placed thousands of times, so its quality is multiplied across the whole product. The boundary also matters — a [[component]] is *one* part ([[button]], [[avatar]]); a [[pattern]] arranges several. Blur that and the [[component-catalog]] fills with layouts masquerading as components.

## How it works

Three axes describe any component: **props** (the API), **variants** (named configurations), **states** (runtime conditions).

- **Anatomy** — name the parts (a card has *media / header / body / actions*) so [[naming]] and slots are consistent.
- **Variants** — discrete, enumerable forms; prefer one `variant` prop over many booleans.
- **States** — default / hover / focus-visible / active / disabled / loading / error / selected, as applicable.
- **Tokens in, no literals** — color, spacing, radius come from [[defining-design-tokens]] so theming is free.

| Concept | Definition | Example |
|---|---|---|
| Prop | Input controlling render | `size="md"` |
| Variant | Named configuration | `button` danger |
| State | Runtime condition | focused, disabled |
| Slot | Caller-filled region | card body |

Granularity rule of thumb: if two "variants" share almost no markup, they are two components; if they differ only by tokens, they are one.

## Example

`<Avatar size="md" src=… fallback="IF" status="online" />`. One component, props for size and source, a derived initials fallback when the image fails, an optional status dot — no destructive logic, no business rules. It reads `size.avatar.md` and `color.success` from tokens; a theme swap restyles every avatar with zero edits.

## Pitfalls

- **God components** — a `<Table>` that also fetches, sorts, paginates, and exports is unmaintainable; split responsibilities.
- **Prop sprawl** — 15+ props signals a missing composition boundary or a hidden second component.
- **Hardcoded values** — literals defeat tokens and break [[dark-mode]] and rebrands.
- **Calling a pattern a component** — keep the word for single units. See [[keywords-terminology]].

## See also

- [[component-library]]
- [[component-catalog]]
