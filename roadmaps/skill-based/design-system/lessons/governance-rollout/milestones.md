---
title: Milestones
track: design-system
group: Governance & rollout
tags: [design-system, roadmap]
prerequisites: [making-a-design-system, governance]
see-also: [pilot, governance, component-analytics]
---

# Milestones

Milestones are the sequenced, measurable checkpoints a design system ships against — the roadmap that turns "build a design system" into a series of provable steps with adoption gates between them.

## Why it matters

A design system is a multi-quarter program, and the most common failure is invisible progress: months of work with no shippable proof and no way to defend the headcount. Milestones make the work legible to sponsors and force a thin-slice mentality — ship something real, prove it's used, then expand. They also encode sequence: tokens before components before patterns, so each milestone stands on a stable layer below it (see [[making-a-design-system]]). Crucially, the gate between milestones is an *adoption* number, not a *built* number.

## How it works

Define milestones as outcomes with an exit metric, not as feature lists:

| Milestone | Deliverable | Exit gate (real number) |
|---|---|---|
| M0 Foundations | tokens + [[design-language]] | 1 product themed end-to-end |
| M1 Core kit | 8-12 components, docs | published package, 1 [[pilot]] team shipping |
| M2 Adoption | onboarding, support | ≥50% of new UI imports the package |
| M3 Patterns | flows, templates | 3+ teams reuse a shared [[pattern]] |
| M4 Scale | federated [[governance]] | community contributes components |

Each milestone is bounded by what it *unblocks* next, so you never build a layer before its foundation is stable. Pick one north-star metric early — typically **% of PR-merged UI that imports the system** — and report it every milestone via [[component-analytics]], so "done" is observed, not asserted. Keep milestones quarter-sized; anything longer hides slippage.

## Example

A 4-team org plans four quarters. Q1 (M0): converge 14 button variants to one, ship a token set, theme the marketing site — gate met. Q2 (M1): release `@acme/ui@1.0` with 10 components and a docs site, one [[pilot]] team adopts. Q3 (M2): adoption metric hits 55% of new screens; the gate flips green and headcount is renewed on that number. Q4 (M3): two teams share an empty-state pattern. Each gate is a single measured percentage, reported to the sponsor, not a slide of screenshots.

## Pitfalls

- **Output milestones, not outcome** — "shipped 30 components" with 0% adoption is a red flag dressed as progress; gate on usage.
- **Boiling the ocean in M1** — a 50-component first release delays the only thing that matters, the first real adopter.
- **No exit metric** — milestones with vague "done" slip silently; attach a number you can observe.
- **Year-long milestones** — too coarse to catch slippage; keep them quarter-sized and reportable.

## See also

- [[pilot]]
- [[governance]]
