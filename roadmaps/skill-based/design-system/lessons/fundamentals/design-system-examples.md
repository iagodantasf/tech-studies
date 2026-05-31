---
title: Design System Examples
track: design-system
group: Fundamentals
tags: [design-system, case-studies]
prerequisites: [need-of-a-design-system]
see-also: [design-system-vs-component-library, defining-design-tokens, accessibility]
---

# Design System Examples

A tour of well-known public design systems — what they optimize for and what you can borrow — so design decisions are anchored in proven prior art rather than invented from zero.

## Why it matters

Mature systems have already solved the hard, boring problems: naming, [[defining-design-tokens|token]] structure, [[accessibility]] criteria, contribution flow. Reading 3-4 of them before starting saves you from re-deriving a [[naming]] scheme or a [[color]] scale that someone has already pressure-tested across thousands of screens. They also calibrate scope — you see how much *documentation* and [[governance]] a real system carries.

## How it works

Each system reflects its parent org's priorities. Skim them along a few axes: token model, component breadth, accessibility stance, and openness.

| System | Owner | Notable for |
|---|---|---|
| Material Design | Google | Cross-platform spec + theming, motion guidance |
| Carbon | IBM | Open governance, strong accessibility, data-dense UI |
| Polaris | Shopify | Heavy content guidelines, commerce patterns |
| Lightning | Salesforce | Token-first; design tokens originated here |
| Primer | GitHub | Tight code/design parity, CSS utility primitives |
| Atlassian DS | Atlassian | Published principles + foundations split |

What to extract from each:

- **Foundations vs components split** — most separate [[color]]/type/space *foundations* from [[component|components]]; mirror that structure.
- **Token tiers** — Salesforce/Lightning popularized layered tokens (global → alias → component). See [[defining-design-tokens]].
- **Content as a first-class layer** — Polaris and Mailchimp treat voice/tone like a component. See [[microcopy-guidelines]].
- **Governance in the open** — Carbon and Primer show public [[contribution-guidelines]] and versioning you can copy.

## Example

Designing a destructive [[button]] label? Polaris prescribes specific verbs and warns against ambiguous ones; Carbon specifies the danger color token and required focus contrast; Material defines the elevation and ripple. Pulling one rule from each gives you a defensible default in minutes instead of a meeting.

## Pitfalls

- **Cloning Material wholesale** — it encodes Google's brand and Android conventions; copied verbatim it fights your product's identity. Borrow structure, not skin.
- **Copying components but skipping the rules** — the value is often in the [[guidelines]] and [[accessibility]] criteria, not the visuals.
- **Assuming "big company = right for you"** — an enterprise data system (Carbon) and a marketing-site system have different needs; match the example to your context.

## See also

- [[design-system-vs-component-library]]
- [[defining-design-tokens]]
