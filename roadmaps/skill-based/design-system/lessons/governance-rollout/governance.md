---
title: Governance
track: design-system
group: Governance & rollout
tags: [design-system, governance]
prerequisites: [making-a-design-system, contribution-guidelines]
see-also: [contribution-guidelines, documentation, milestones]
---

# Governance

Governance is the operating model of a design system: who decides what goes in, how changes are proposed and reviewed, and how the system stays coherent as more teams depend on it.

## Why it matters

A system without governance forks: every team adds its own [[button]] variant, the token list bloats to 40 greys, and "consistency" quietly dies. Governance is what lets a system scale past its core team — it answers "can I add this?" before someone builds it twice. The choice of model is mostly a throughput-vs-coherence trade: too closed and teams route around you (shadow components), too open and the API churns until nobody trusts it. It is the day-one job that pairs with [[contribution-guidelines]], not a phase you bolt on after launch.

## How it works

Pick a model by team count and pace, then make the decision path explicit:

| Model | Who contributes | Best for | Risk |
|---|---|---|---|
| Centralized | core team only | small org, <5 consumers | bottleneck, backlog |
| Federated | trained reps per team | mid org, 5-20 consumers | drift between reps |
| Open / community | anyone, core reviews | large org, mature system | review load, churn |

Most systems start centralized and move to federated as adoption grows. The governable surface — what a proposal can touch — is **tokens, [[component]]s, [[pattern]]s, and [[guidelines]]**; each needs an owner and a bar for "in". Run changes through a lightweight RFC: a one-page proposal (problem, options, decision) reviewed against a public rubric (does it generalize past one team? does it duplicate an existing part?). Enforce what you can in code (lint, [[code-style]], CI) so prose rules don't carry the whole load, and record decisions so they aren't re-litigated.

## Example

A 12-team org runs a federated model. Each team names one "design system champion" with merge rights on their domain; the core team owns tokens and breaking changes. A proposal for a new `Stepper` enters as a 1-page RFC: it must show 2+ teams need it and that no [[card]]/[[forms]] composition already covers it. Decision in one weekly triage, recorded in a public log. Result: the catalog grows ~3 components a quarter, deliberately, instead of 30 ad-hoc forks across teams.

## Pitfalls

- **No model at all** — "everyone owns it" means no one does; the system rots into incoherence within a year.
- **Centralized at scale** — one core team gatekeeping 20 teams becomes a 6-week backlog, and teams build shadow components to escape it.
- **Process without enforcement** — rules that live only in prose get ignored; encode the enforceable ones in lint and CI.
- **Unrecorded decisions** — the same "do we add this?" argument recurs quarterly because no one wrote down the last answer.

## See also

- [[contribution-guidelines]]
- [[milestones]]
- [[documentation]]
