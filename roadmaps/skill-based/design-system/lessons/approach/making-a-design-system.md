---
title: Making a Design System
track: design-system
group: Approach
tags: [design-system, strategy]
prerequisites: [need-of-a-design-system]
see-also: [making-it-from-scratch, making-it-from-existing-design, governance]
---

# Making a Design System

The first fork in the road: deciding *how* to build a design system — greenfield from first principles, or extracted from a product that already ships — and how to staff, scope, and sequence the work.

## Why it matters

A design system is a product with internal users, not a one-off deliverable, so the launch decision is mostly about **adoption risk**, not pixels. Teams that skip this framing build a beautiful library nobody migrates to: the classic failure is a v1 with 60 components and 0% production usage. The build path you pick (scratch vs. existing) determines your first 6 months — what you measure, who you negotiate with, and where the resistance comes from.

## How it works

Two foundational paths, chosen by how much UI already exists and how much of it you can change:

- **[[making-it-from-scratch]]** — define the [[design-language]] first, then tokens, then components. Right for a new product or a deliberate rebrand. Slower to first value, cleaner result.
- **[[making-it-from-existing-design]]** — start with an [[existing-design-analysis]] and a [[performing-a-visual-audit]], converge the variants, then codify. Right for a mature product. Faster wins, messier source of truth.

Scope and staff before you touch Figma:

| Decision | Cheap default | When to upgrade |
|---|---|---|
| Team | 1 designer + 1 engineer, part-time | Dedicated squad past ~5 consuming teams |
| Scope v1 | 8-12 core components | Patterns/templates after adoption proven |
| Source of truth | Tokens in JSON, one repo | Multi-platform pipeline |
| Cadence | Ship weekly, version with semver | RFC process once external teams depend on it |

Sequence is **tokens → components → patterns → docs**, with [[governance]] running alongside from day one, not bolted on after launch.

## Example

A 4-team org rebuilding its web app picks the *existing* path. Quarter 1: audit finds 14 button variants and 11 greys; they converge to 1 button (5 variants) and a 6-step grey ramp. Quarter 2: ship Button, Input, Modal, Card as a package; pilot with 1 team. Quarter 3: 3 of 4 teams on the [[component-library]], measured as % of PR-merged UI importing the package — the north-star adoption metric.

## Pitfalls

- **Boiling the ocean** — a 50-component v1 before anyone uses 5. Ship a thin vertical slice and prove adoption first.
- **No owner** — a "everyone's responsibility" system rots; name a maintainer and a [[contribution-guidelines]] path.
- **Picking scratch when you should extract** — rebuilding a mature product's UI from zero invites a years-long parallel-systems limbo.
- **Treating launch as the finish line** — adoption, support, and versioning are the actual job; budget for them.

## See also

- [[making-it-from-scratch]]
- [[making-it-from-existing-design]]
- [[governance]]
