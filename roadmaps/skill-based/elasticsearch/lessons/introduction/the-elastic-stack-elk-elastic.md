---
title: The Elastic Stack (ELK / Elastic)
track: elasticsearch
group: Introduction
tags: [elasticsearch, elastic-stack]
prerequisites: []
see-also: [what-is-elasticsearch, kibana, beats-filebeat-metricbeat]
---

# The Elastic Stack (ELK / Elastic)

The family of products around Elasticsearch — historically **ELK** (Elasticsearch, Logstash, Kibana), now just "Elastic Stack" after Beats and Elastic Agent joined.

## Why it matters

You rarely run Elasticsearch alone. Real deployments need a way to *collect* data (Beats/Agent), optionally *transform* it ([[logstash|Logstash]] or [[ingest-pipelines|ingest pipelines]]), *store and search* it (Elasticsearch), and *visualize* it ([[kibana|Kibana]]). Knowing each component's job stops you from, e.g., building a heavy Logstash cluster when a lightweight Beat would do.

## How it works

Data flows from edge collectors through optional processing into the store, then out to dashboards.

- **[[beats-filebeat-metricbeat|Beats]]** — single-purpose lightweight shippers (Filebeat for logs, Metricbeat for metrics) running on the source host.
- **[[elastic-agent-fleet|Elastic Agent]]** — one unified agent replacing multiple Beats, managed centrally via Fleet.
- **[[logstash|Logstash]]** — heavyweight ETL (parse, enrich, route) when ingest pipelines aren't enough; can buffer and fan out.
- **Elasticsearch** — the storage, [[query-dsl-overview|search]], and [[bucket-aggregations|aggregation]] engine.
- **[[kibana|Kibana]]** — the UI for dashboards, [[query-dsl-overview|Dev Tools]], and stack management.

| Component | Role | Runs where |
|---|---|---|
| Beats / Agent | Collect | Edge / source hosts |
| Logstash | Transform (optional) | Mid-tier nodes |
| Elasticsearch | Store + search | Cluster |
| Kibana | Visualize + admin | Alongside cluster |

## Example

A classic logging pipeline:

```
app logs ──Filebeat──▶ Logstash (grok parse) ──▶ Elasticsearch ──▶ Kibana dashboard
```

Lighter variant: `Elastic Agent ──ingest pipeline──▶ Elasticsearch`, dropping Logstash entirely when parsing is simple.

## Pitfalls

- **Adding Logstash reflexively** — for simple parsing, an [[ingest-pipelines|ingest pipeline]] inside Elasticsearch is simpler and one fewer service to operate.
- **Running many Beats per host** — modern stacks consolidate on Elastic Agent + Fleet for central config.
- **Version skew** — Kibana must match the Elasticsearch minor version; mismatches break the UI. Plan [[rolling-upgrades]] together.

## See also

- [[kibana]]
- [[beats-filebeat-metricbeat]]
