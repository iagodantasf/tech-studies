---
title: Creating Core Components
track: design-system
group: Components
tags: [design-system, components]
prerequisites: [defining-design-tokens, creating-the-design-language]
see-also: [component, component-library, button]
---

# Creating Core Components

The phase where the abstract design language becomes a small set of coded, accessible, token-consuming UI parts that every product composes from.

## Why it matters

Tokens and principles are inert until a real [[button]] renders them; core components are where the system first ships. Get the order and the first dozen right and the rest follow cheaply — get them wrong (hardcoded color, no focus state, a 12-prop API) and you copy the mistake into every later [[component]]. "Core" is deliberately small: the 10–15 parts that 80% of screens need, built deeply, before breadth.

## How it works

Pick by frequency, then build each to a fixed quality bar:

- **Inventory first** — audit real screens; the long tail is mostly [[button]], [[input-text]], [[forms]], [[card]], [[modal]], [[icon]], [[list]]. Build those before [[carousel]].
- **One source of values** — every visual comes from [[defining-design-tokens]]; no literal hex or px in component code.
- **States are mandatory** — default / hover / focus / active / disabled / loading / error, not just the happy path.
- **API minimal** — few props, sensible defaults, composition over a flag for every case.

| Wave | Components | Rationale |
|---|---|---|
| 1 | [[button]], [[icon]], [[input-text]] | On nearly every screen |
| 2 | [[forms]], [[card]], [[list]] | Compose wave 1 |
| 3 | [[modal]], [[dropdown]], [[banner]] | Overlays and feedback |

Definition of done per component: tokenized, all states, keyboard-operable, documented, in the design tool *and* code.

## Example

A team's first 12 components ship over two sprints. [[button]] alone carries variants `primary / secondary / danger / ghost` × sizes `sm / md / lg` × 7 states — one well-built part replaces ~40 ad-hoc buttons found in the audit. Each consumes `color.action`, `space.3`, `radius.md`; a later rebrand re-points those tokens and all 12 update with no code change.

## Pitfalls

- **Breadth before depth** — 60 shallow components beat by 12 solid ones; ship core deeply first.
- **Skipping states** — a button with no focus ring or disabled style fails [[accessibility]] and gets forked downstream.
- **Boolean explosion** — `isPrimary isDanger isGhost` should be one `variant` prop; flags multiply into impossible combinations.
- **Code-only delivery** — no Figma equivalent means designers can't use what you built. See [[component-library]].

## See also

- [[component]]
- [[component-library]]
