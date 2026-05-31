---
title: Instrumentation, alerts & visualization
track: system-design
group: Observability
tags: [system-design, observability]
prerequisites: [health-performance-monitoring]
see-also: [availability-in-numbers-the-nines, circuit-breaker-retry-throttling-bulkhead]
---

# Instrumentation, alerts & visualization

Instrumentation emits the raw telemetry, visualization turns it into dashboards you read, and alerting pages a human only when something actually needs action.

## Why it matters

[[health-performance-monitoring|Health and performance signals]] are worthless if nothing emits, stores, or surfaces them. This is the feedback loop that turns a 3am incident from "users tweet that we're down" into "an alert fired with a dashboard link before the error budget moved." Done badly, you get alert fatigue — so many pages that the real one gets muted.

## How it works

Telemetry comes in **three pillars**, each answering a different question:

| Pillar | Answers | Cost / cardinality |
|---|---|---|
| Metrics | How much / how often? | Cheap, aggregatable |
| Logs | What exactly happened? | Costly at volume |
| Traces | Where did the time go? | Sampled, per-request |

- **Metrics** are numeric time series; beware **cardinality** — a label like `user_id` multiplies series into the millions and melts your store. Keep labels low-cardinality (route, status, region).
- **Distributed tracing** propagates a **trace ID** across service hops so one slow request is visible end-to-end; **sample** (e.g. 1%) to bound cost, but always keep error traces.
- **Alert on symptoms, not causes.** Page on user-facing SLO breaches (error rate, p99 latency), not on "CPU > 80%" — high CPU may be fine. Tie alerts to **burn rate**: how fast you are spending the [[availability-in-numbers-the-nines|error budget]]. A fast burn (2% of monthly budget in 1h) pages immediately; a slow burn opens a ticket.

```
alert: HighErrorBurn
expr: error_ratio_5m > 14 * slo_target   # 14x burn
for:  2m
page: on-call          # symptom-based, fast-burn
```

Standardize on **OpenTelemetry** so instrumentation is vendor-neutral. Dashboards should lead with the golden signals up top, drill-downs below — and every alert should link to a runbook.

## Example

A checkout p99 spikes. The alert fires on the *symptom* (latency SLO), not a cause. On-call opens the linked dashboard, sees error rate flat but latency up, pulls a trace by ID, and finds 400ms in `inventory-svc` waiting on a DB lock — a path metrics alone could never have localized. The [[circuit-breaker-retry-throttling-bulkhead|circuit breaker]] had already shed load, buying time.

## Pitfalls

- **Alerting on causes** — paging on CPU/memory/disk produces noise; alert on user-visible symptoms and burn rate.
- **High-cardinality labels** — `user_id`/`request_id` as metric labels explode storage and queries; put those in logs/traces instead.
- **Non-actionable pages** — if an alert has no runbook and no action, it is a dashboard, not a page; demote it or delete it.
- **100% trace sampling** — full sampling is ruinously expensive; tail-sample to keep slow and errored requests, drop the boring ones.

## See also

- [[health-performance-monitoring]]
- [[availability-in-numbers-the-nines]]
