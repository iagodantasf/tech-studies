---
title: Availability in numbers (the nines)
track: system-design
group: Fundamentals
tags: [system-design, availability]
prerequisites: [availability-patterns-failover-replication]
see-also: [health-performance-monitoring, load-balancers-l4-vs-l7-algorithms-active-passive-active-active]
---

# Availability in numbers (the nines)

Availability is quantified as a percentage of uptime — the "nines" — where each extra nine cuts allowed downtime by **~10×** and roughly multiplies cost and effort.

## Why it matters

"Highly available" is meaningless until you attach a number, because the budget changes everything: **99.9%** allows ~8.8 hours of downtime a year (a careless deploy fits), while **99.999%** allows ~5 minutes — no human can even respond in time, so it must be automated. SLAs are contractual and often refund-backed, so over-promising nines is a direct financial and engineering liability.

## How it works

Downtime budget = `(1 − availability) × period`. The canonical table:

| Availability | Downtime / year | Downtime / month |
|---|---|---|
| 99% ("two nines") | ~3.65 days | ~7.2 hours |
| 99.9% ("three nines") | ~8.76 hours | ~43.8 minutes |
| 99.99% ("four nines") | ~52.6 minutes | ~4.4 minutes |
| 99.999% ("five nines") | ~5.26 minutes | ~26 seconds |

Composition rules decide system-level availability:

- **In series** (a request needs every hop), availabilities **multiply**: two 99.9% services in a chain → 0.999 × 0.999 ≈ **99.8%**. More dependencies = lower combined uptime.
- **In parallel** (redundant copies, either suffices), *unavailabilities* multiply: two 99% replicas → 1 − 0.01² = **99.99%**. Redundancy via [[availability-patterns-failover-replication|failover]] is how you *add* nines.

Distinguish the metrics: **SLA** (the promise + penalty), **SLO** (your internal target, set tighter), **SLI** (the measured signal, e.g. success-rate). **Error budget** = 1 − SLO; spend it on releases, freeze deploys when it's exhausted.

## Example

An API fronts three series dependencies at 99.95% each: 0.9995³ ≈ **99.85%**, blowing a 99.9% SLA before any of *your* code runs. Fix the math by making the critical dependency redundant — two 99.95% replicas in parallel give 1 − 0.0005² ≈ 99.999%, lifting the chain back above target.

## Pitfalls

- **Ignoring dependency multiplication** — your service can't exceed the product of what it calls.
- **Counting only unplanned outages** — deploys, migrations, and maintenance windows burn the budget too.
- **A nine with no [[health-performance-monitoring|monitoring]]** — you can't honor an SLO you don't measure.

## See also

- [[availability-patterns-failover-replication]]
- [[health-performance-monitoring]]
