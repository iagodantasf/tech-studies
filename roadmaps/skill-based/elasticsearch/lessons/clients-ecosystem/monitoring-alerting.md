---
title: Monitoring & alerting
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, monitoring]
prerequisites: [cluster-health-green-yellow-red, nodes-cluster]
see-also: [kibana, index-lifecycle-management-ilm, apm-observability]
---

# Monitoring & alerting

Monitoring collects cluster, node, and index metrics into a metrics store, while alerting (Kibana Alerting / Watcher) evaluates rules against that data — or any index — and fires actions when a condition trips.

## Why it matters

A cluster degrades quietly: heap creeps up, a disk crosses the [[shard-allocation-routing|watermark]], shards go unassigned. Without monitoring you discover this when indexing stalls; with it you see the trend and page before users do. The same alerting engine also powers product use cases — error-rate spikes, SLA breaches, [[percolate-queries|saved-search]] matches — so it is both an ops tool and an application feature.

## How it works

Metricbeat or [[elastic-agent-fleet|Elastic Agent]] scrapes the cluster and writes metrics; rules query them on a schedule and route hits to connectors.

- **Don't self-host metrics on the prod cluster** — ship monitoring data to a *separate* monitoring cluster so an outage doesn't also blind you.
- **Key signals** — JVM heap pressure (sustained >85% triggers GC thrash), [[cluster-health-green-yellow-red|cluster status]] yellow/red, unassigned shards, disk watermarks (85% low / 90% high / 95% flood-stage read-only), bulk/search rejections, search latency.
- **Rules** — a Kibana rule = condition (e.g. `avg(latency) > 500ms over 5m`) + schedule + connector (Slack, email, PagerDuty, webhook, [[index-api|index]]).
- **Watcher** — the older, lower-level alternative: a JSON document with `trigger`, `input` (a query), `condition`, and `actions`, run on an interval.

| Symptom | Likely cause |
|---|---|
| status red | a primary shard unassigned |
| heap >85% sustained | oversharding / huge aggs |
| `429` rejections | bulk/search queue full |
| disk >90% | allocation stops; reclaim space |

## Example

A Watcher that alerts on an error spike, every minute:

```
PUT _watcher/watch/error_spike
{ "trigger": { "schedule": { "interval": "1m" } },
  "input":   { "search": { "request": { "indices": ["logs-*"],
               "body": { "query": { "bool": { "filter": [
                         { "range": { "@timestamp": { "gte": "now-1m" } } },
                         { "term":  { "level": "error" } } ] } } } } } },
  "condition": { "compare": { "ctx.payload.hits.total": { "gt": 100 } } },
  "actions": { "notify": { "slack": { "message": { "text": "errors > 100/min" } } } } }
```

## Pitfalls

- **Alerting on the cluster you're watching** — if alerts live only on the failing cluster, a red cluster also means no alert; keep the monitoring/alerting plane independent.
- **No de-duplication** — naive rules re-fire every interval while the condition holds; use action throttling (`throttle_period`) so one incident isn't 60 pages.
- **Watermarks bite silently** — crossing the 95% flood-stage mark flips indices to read-only and ingest *stops*; alert at 85% to act early.
- **Heap, not CPU, is the killer** — Elasticsearch is memory-bound; watch GC and heap, not just CPU, and never set heap above ~50% of RAM or past ~31GB (compressed oops).

## See also

- [[kibana]]
- [[index-lifecycle-management-ilm]]
