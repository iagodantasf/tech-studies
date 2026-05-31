---
title: Component Catalog
track: design-system
group: Components
tags: [design-system, catalog]
prerequisites: [component]
see-also: [component-library, documentation, naming]
---

# Component Catalog

The browsable index of every component the system offers — name, status, anatomy, variants, props, do/don't — the place teams look before they build anything.

## Why it matters

A catalog is how the system gets *found* and trusted. Without one, engineers can't tell what exists, so they rebuild a [[dropdown]] that already ships, and designers spec a fourth banner style. The catalog answers "does this exist, is it stable, how do I use it" in seconds. It is the system's shop window; if it's stale or incomplete, adoption quietly dies and teams fork.

## How it works

Each entry is a structured record, not prose. A typical catalog page carries:

- **Status** — so consumers know what's safe to adopt.
- **Live examples** — interactive, not screenshots (Storybook, a docs sandbox). See [[documentation]].
- **Props / API table**, **anatomy**, **variants**, **states**, and **do/don't** guidance ([[guidelines]]).
- **Links** — to the component in the design tool and to source.

| Status | Meaning | Safe to use? |
|---|---|---|
| Stable | API frozen, supported | Yes |
| Beta | Usable, API may shift | With caution |
| Deprecated | Replaced; migration noted | No, migrate off |
| Planned | Not built yet | No |

Group entries by category (inputs, feedback, layout) and keep one canonical [[naming]] per concept. The catalog should be generated from source where possible so it cannot drift from the real [[component-library]].

## Example

A `Button` catalog entry: status **Stable**, an interactive matrix of `primary/secondary/danger × sm/md/lg`, a props table, anatomy (label + optional [[icon]]), a "don't put two primary buttons in one view" do/don't, plus links to Figma and the repo. A new engineer copies the import, picks a variant, and ships — without reading the source.

## Pitfalls

- **Stale catalog** — docs lagging code is worse than none; teams stop trusting it. Generate from source.
- **No status field** — consumers can't distinguish stable from experimental and get burned by churn.
- **Screenshots instead of live demos** — they rot and hide real behavior (focus, hover, keyboard).
- **Duplicate entries** — two names for one concept; enforce canonical [[naming]].

## See also

- [[component-library]]
- [[documentation]]
