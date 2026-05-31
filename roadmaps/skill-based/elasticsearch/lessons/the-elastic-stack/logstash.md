---
title: Logstash
track: elasticsearch
group: The Elastic Stack
tags: [elasticsearch, logstash]
prerequisites: [the-elastic-stack-elk-elastic]
see-also: [ingest-pipelines, beats-filebeat-metricbeat, elastic-agent-fleet]
---

# Logstash

Logstash is a server-side ETL engine that ingests events from many sources, transforms them through a filter chain, and ships them to one or more destinations.

## Why it matters

When parsing is heavy, multiple inputs/outputs are needed, or you must buffer and fan out, Logstash does what an in-cluster [[ingest-pipelines|ingest pipeline]] cannot. It decouples bursty producers from Elasticsearch via a persistent queue, and routes the same event to several sinks (ES + S3 + Kafka) in one config. The cost is another JVM service to size and run.

## How it works

A pipeline is three stages declared in a `.conf` file; events flow input → filter → output.

```
input  { beats { port => 5044 } }
filter { grok { match => { "message" => "%{COMBINEDAPACHELOG}" } }
         mutate { remove_field => ["message"] } }
output { elasticsearch { hosts => ["es:9200"] index => "logs-%{+yyyy.MM.dd}" } }
```

| Stage | Common plugins |
|---|---|
| input | `beats`, `kafka`, `file`, `http`, `jdbc` |
| filter | `grok`, `dissect`, `mutate`, `date`, `geoip` |
| output | `elasticsearch`, `kafka`, `s3` |

- **Workers and batch** — `pipeline.workers` (default = CPU cores) filter/output in parallel; `pipeline.batch.size` (default 125) is events per worker per flush.
- **Persistent queue** — set `queue.type: persisted` to disk-buffer events across restarts and absorb downstream outages; the default in-memory queue drops on crash.
- **Dead-letter queue** — events Elasticsearch rejects (e.g. a mapping conflict) can be routed to a DLQ instead of silently lost.
- **`date` filter** — parse a real timestamp from the log into `@timestamp`; otherwise events are stamped at *ingest* time, skewing time-series charts.

## Example

Throughput tuning for a 4-core node pushing Apache logs: `pipeline.workers: 4`, `pipeline.batch.size: 2000`, `queue.type: persisted`. Larger batches amortize the [[bulk-api|bulk]] round-trip — a 16x batch increase here can lift sustained EPS several-fold until the Elasticsearch bulk path, not Logstash, becomes the bottleneck.

## Pitfalls

- **Catastrophic grok backtracking** — a loose, unanchored pattern over messy input can pin a CPU on one event; anchor patterns and prefer `dissect` for fixed-delimiter lines.
- **Reflexively deploying Logstash** — for simple parsing an [[ingest-pipelines|ingest pipeline]] inside the cluster is one fewer service; reserve Logstash for heavy/multi-sink work.
- **In-memory queue + crash = data loss** — enable the persistent queue for any pipeline you cannot replay from source.
- **Forgetting the `date` filter** — events land under processing time, not event time, quietly distorting dashboards.

## See also

- [[ingest-pipelines]]
- [[beats-filebeat-metricbeat]]
