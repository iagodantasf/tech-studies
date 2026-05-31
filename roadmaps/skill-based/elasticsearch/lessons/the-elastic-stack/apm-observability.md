---
title: APM & observability
track: elasticsearch
group: The Elastic Stack
tags: [elasticsearch, observability]
prerequisites: [elastic-agent-fleet]
see-also: [kibana, data-streams, index-lifecycle-management-ilm]
---

# APM & observability

Elastic APM captures distributed traces, latency, and errors from instrumented apps; combined with logs and metrics it gives the three observability signals over one search engine.

## Why it matters

Observability means correlating *logs, metrics, and traces* to answer "why is this request slow?" Storing all three in Elasticsearch lets you pivot from a slow trace to the host's metrics to the service's logs by shared IDs — no jumping between tools. APM adds the trace pillar: per-request spans with timing across service boundaries.

## How it works

App agents (or OpenTelemetry SDKs) send spans to an APM Server / [[elastic-agent-fleet|Elastic Agent]] APM integration, which writes trace [[documents|documents]] into [[data-streams|data streams]].

```
service (APM agent / OTel) ──▶ APM Server ──▶ Elasticsearch (traces-apm-*, logs-*, metrics-*)
                                                        │
                                                   Kibana APM UI / dashboards
```

- **Trace model** — a `trace.id` spans services; each `transaction` (a request) holds child `span`s (DB call, HTTP out) with durations; this is a tree per request.
- **ECS correlation** — logs, metrics, and traces share Elastic Common Schema fields (`service.name`, `trace.id`), so a log line links to its trace.
- **Sampling** — head-based (decide at trace start) or tail-based (decide after seeing the whole trace, e.g. keep all errors + 1% of fast traces) caps volume.
- **Retention via ILM** — trace/log/metric data streams age out under [[index-lifecycle-management-ilm|ILM]]; hot for recent, deleted after N days.

| Signal | Answers | Example index |
|---|---|---|
| Logs | What happened | `logs-*` |
| Metrics | How much / how loaded | `metrics-*` |
| Traces | Where the time went | `traces-apm-*` |

## Example

A checkout p99 spikes. In Kibana APM: open the `checkout` service → the slow `POST /pay` transaction shows a 1.8 s child span on `db.query`. Click the linked `trace.id` to jump to the host's [[metric-aggregations|metrics]] (CPU pinned) and the service [[full-text-search|logs]] for that window — root cause in one pivot path.

## Pitfalls

- **No sampling at scale** — full trace capture on a high-QPS service can dwarf your log volume and balloon storage; use tail-based sampling but always keep error traces.
- **Cardinality explosions** — putting unbounded values (user IDs, full URLs with params) into labels blows up [[fields-data-types|field]] cardinality and aggregation cost.
- **Broken correlation** — if `service.name`/`trace.id` aren't propagated consistently (ECS), the logs-to-traces pivot silently fails.
- **Clock skew** — span timings rely on host clocks; unsynchronized clocks across services make trace waterfalls misleading. Keep NTP tight.

## See also

- [[elastic-agent-fleet]]
- [[kibana]]
