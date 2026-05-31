---
title: Documentation
track: design-system
group: Documentation
tags: [design-system, documentation]
prerequisites: [component, defining-design-tokens]
see-also: [guidelines, faqs, governance]
---

# Documentation

The site that turns a design system into a product people can adopt: the canonical reference for what exists, how to use it, and the rules that bind tokens, components, and patterns together.

## Why it matters

A component nobody can find gets rebuilt; an undocumented prop gets misused; an unwritten rule gets re-litigated in every review. Docs are the system's interface to its consumers — for most adopters the docs site *is* the design system, since they never open the source. The economics are stark: a single page answering "which input do I use?" deflects the same question asked by 40 teams, which is why mature systems (Polaris, Material, Carbon) invest in docs as a first-class product, not a README afterthought.

## How it works

Treat docs as a layered artifact, each layer serving a different reader:

| Layer | Answers | Example page |
|---|---|---|
| Foundations | the design language | [[color]], [[grid]], [[defining-design-tokens]] |
| Components | one unit's API + usage | [[button]] do/don't, props table |
| Patterns | composing units | a [[forms]] or empty-state flow |
| Guidelines | cross-cutting rules | [[accessibility]], [[microcopy-guidelines]] |
| Meta | how to engage | [[contribution-guidelines]], [[faqs]] |

The non-negotiable spine of a component page: **overview, live interactive example, props/API table, variants, states, do/don't pairs, accessibility notes, and the import line.** Generate what you can from source — props tables from types, examples from the live [[component-library]] — so docs can't drift from code. The rest (usage intent, do/don'ts) is hand-written and reviewed. Co-locate docs with components in the repo so a PR that changes the API and forgets the page fails review (see [[contribution-guidelines]]).

## Example

A `Button` page that prevents misuse, top to bottom:

```
Button
  Live demo (toggle variant / size / disabled)
  When to use   -> primary actions; one primary per view
  Props         | name     | type                    | default |
                | variant  | primary|secondary|danger | primary |
                | size     | sm|md|lg                | md      |
  Do  ✅ one primary button per screen
  Don't ✖ a row of three primary buttons
  Accessibility -> needs visible label; icon-only sets aria-label
  import { Button } from '@acme/ui'
```

That single "one primary per screen" do/don't pair, with a screenshot, settles an argument that would otherwise recur in dozens of design reviews.

## Pitfalls

- **Docs drift** — hand-maintained props tables fall behind the code within a release; generate from source so they can't.
- **Decoration, not decision** — a beautiful page that omits *when not to use* and *what to use instead* leaves the hard call to the reader.
- **No versioning** — one un-versioned site for a library teams upgrade asynchronously means half your audience reads docs for an API they don't have.
- **Reference without on-ramp** — perfect per-component pages but no "install / first component / theming" path strands newcomers at the door.

## See also

- [[guidelines]]
- [[faqs]]
