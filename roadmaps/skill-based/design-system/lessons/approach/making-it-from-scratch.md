---
title: Making It from Scratch
track: design-system
group: Approach
tags: [design-system, greenfield]
prerequisites: [making-a-design-system]
see-also: [creating-the-design-language, defining-design-tokens, making-it-from-existing-design]
---

# Making It from Scratch

Building a design system top-down — principles and [[design-language]] first, then [[defining-design-tokens|tokens]], then components — with no legacy UI to reconcile against.

## Why it matters

Greenfield is the rare chance to get the foundations *clean*: one type scale, one spacing unit, semantic tokens from day one. It suits a new product, a 0→1 startup, or a full rebrand where leadership has agreed to replace the old UI wholesale. The trade-off is **slower time-to-first-value** — you invest in structure before any component ships, so the system can feel like overhead until the first screens land.

## How it works

Work strictly **outside-in**, each layer constraining the next:

1. **[[design-principles]]** — 3-5 statements that resolve arguments (e.g. "clarity over density"). These are the tie-breakers later.
2. **Foundations** — pick a base unit and ratios up front, because everything inherits them:

| Foundation | Typical scratch default |
|---|---|
| Spacing base | 4px (or 8px) grid |
| Type scale | 1.250 (major third) ratio |
| Grid | 12 columns, fixed gutter |
| Color | brand + neutral ramp, then [[functional-colors]] |

3. **Tokens** — encode foundations as a two-tier system: **primitive** (`grey-700`, `space-4`) feeding **semantic** (`text-default`, `space-inset-md`). Components only ever consume semantic tokens. See [[defining-design-tokens]].
4. **[[creating-core-components|Core components]]** — build the smallest set that composes the rest (Button, Input, Icon) before the long tail.

Because there is no audit step, the discipline that replaces it is **refusing one-off values** — every new color or spacing must justify a token or reuse one.

## Example

A fintech 0→1: principles agreed in week 1. Base unit 4px, type ratio 1.25 → sizes `12/14/16/20/25/31`. Tokens: 22 primitives + 30 semantics shipped before any component. Week 4 the first Button consumes only `bg-brand`, `text-on-brand`, `space-inset-md`, `radius-sm`. By week 8, 10 components share that one token file, so a brand color tweak is a one-line change.

## Pitfalls

- **Over-engineering before usage** — 200 tokens and a theming abstraction for an app with one theme. Build for today plus one obvious axis (e.g. [[dark-mode]]), not five hypothetical ones.
- **Skipping principles** — without tie-breakers, every component review reopens the same aesthetic debates.
- **Primitive tokens in components** — wiring `grey-700` straight into a Button defeats the semantic layer; it can't be retargeted for dark mode.
- **Analysis paralysis** — perfecting foundations while nothing ships. Timebox the foundation phase (e.g. 2-3 weeks) and learn from the first real screen.

## See also

- [[creating-the-design-language]]
- [[defining-design-tokens]]
- [[making-it-from-existing-design]]
