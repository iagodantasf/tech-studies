---
title: A/B Tests / Experiments
track: design-system
group: Quality
tags: [design-system, experiments]
prerequisites: [component]
see-also: [component-analytics, logging, governance]
---

# A/B Tests / Experiments

Running controlled experiments on component or pattern changes so the system evolves on evidence — measured impact on real user behavior — rather than on opinion.

## Why it matters

Changes at the system layer hit every product, so a "small" tweak to the primary [[button]] or a default [[forms]] layout moves metrics at enormous scale — for good or ill. An experiment lets you ship that change to a slice of traffic, measure the effect against a holdout, and roll forward only if it wins. It also resolves the recurring stakeholder standoff ("our team needs a bigger CTA") with data instead of seniority, which is critical for [[governance]] credibility.

## How it works

An A/B test splits users into a control (current) and one or more variants, then compares a pre-declared metric:

- **One change, one hypothesis** — "rounding card corners to 12px lifts card click-through" — stated *before* you look, so you can't rationalize noise after.
- **Randomize per user, hold it sticky** — bucket by a stable user/session id so a person sees one variant for the whole test; flipping mid-session poisons the result.
- **Power the sample** — compute sample size up front from baseline rate, minimum detectable effect, and α=0.05 / power=0.8. Underpowered tests "fail" real wins.
- **Decide on the primary metric** — declare it in advance; watch guardrails (errors, latency, bounce) so a CTR win that tanks task completion is caught.

| Term | Meaning | Trap if ignored |
|---|---|---|
| Control | unchanged baseline | no clean comparison |
| MDE | smallest effect worth detecting | wrong sample size |
| p-value | chance result is noise | peeking inflates it |
| Guardrail | metric that must not regress | local win, global loss |

System-level rollout uses the same feature-flag plumbing as a [[pilot]], just split rather than staged.

## Example

A team proposes a higher-contrast primary button. Ship variant B to 50% of users, target = checkout-start rate, MDE = 1%, which needs **~45,000 users/arm** for significance. After two weeks: B = **8.4%** vs control **8.0%**, p = 0.02, and the error-rate guardrail is flat. Promote B to the default token; the win is now the system standard, recorded for [[governance]]. Pair the readout with [[component-analytics]] to see *which* surfaces drove it.

## Pitfalls

- **Peeking and stopping early** — calling significance the first day it appears massively inflates false positives; wait for the planned sample.
- **No declared primary metric** — testing 12 metrics guarantees one looks "significant" by chance (multiple comparisons).
- **Sticky bucketing skipped** — re-randomizing per pageview mixes variants per user and erases the signal.
- **Ignoring guardrails** — a flashier component that lifts clicks but raises rage-clicks or errors is a net loss.

## See also

- [[component-analytics]]
- [[governance]]
