---
title: Design System vs Component Library
track: design-system
group: Fundamentals
tags: [design-system, terminology]
prerequisites: [need-of-a-design-system]
see-also: [component-library, defining-design-tokens, guidelines]
---

# Design System vs Component Library

A component library is the **coded set of reusable UI parts**; a design system is the larger product that *includes* that library plus tokens, patterns, guidelines, and governance.

## Why it matters

People use the terms interchangeably and then ship the wrong scope. "We have a design system" often means "we published a Storybook of buttons" — code with no design language, no [[microcopy-guidelines|content rules]], no accessibility contract, no owner. Knowing the boundary tells you what's still missing: a [[component-library]] answers *how do I render a button*; a design system answers *which button, when, with what label, and who decides*.

## How it works

Think of it as concentric scope. The library is one layer inside the system:

- **Design tokens** — the primitive values ([[color]], spacing, type) that everything else references. See [[defining-design-tokens]].
- **Component library** — coded, accessible primitives consuming those tokens: [[button]], [[input-text]], [[modal]].
- **Patterns** — recurring compositions (a form layout, an empty state). See [[pattern]].
- **Guidelines & content** — usage rules, [[placement-guidance]], [[microcopy-guidelines]], do/don't.
- **Governance** — versioning, contribution rules, ownership. See [[governance]] and [[contribution-guidelines]].

A library can exist alone; a design system cannot exist *without* a library (or its design-tool equivalent) but is not *reducible* to one.

| Aspect | Component library | Design system |
|---|---|---|
| Scope | Coded UI parts | Tokens + library + patterns + rules + governance |
| Answers | How to render | What to use, when, and why |
| Artifacts | Components, props | + tokens, docs, content, principles |
| Owner | A frontend team | A cross-functional team |

## Example

Team A ships `@acme/ui` with 30 React components — a **component library**. Team B wraps that same library with a [[color|token]] source consumed by web/iOS/Android, [[documentation]] pages, a Figma kit, [[accessibility]] criteria, and a [[governance]] model with a contribution process — that's a **design system**. Both have the same buttons; only B tells you which one to use on a destructive action and what to label it.

## Pitfalls

- **Calling a Storybook a "design system"** — sets the expectation of rules and governance that don't exist; adoption stalls when teams hit undocumented decisions.
- **Building tokens and components that disagree** — if the library hardcodes `#0A66FF` instead of `color.brand.primary`, the system has no single source of truth. See [[defining-design-tokens]].
- **No design-tool parity** — a code-only library leaves designers improvising, so design and code drift apart.

## See also

- [[component-library]]
- [[defining-design-tokens]]
