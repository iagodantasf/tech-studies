---
title: Beats (Filebeat, Metricbeat)
track: elasticsearch
group: The Elastic Stack
tags: [elasticsearch, beats]
prerequisites: [the-elastic-stack-elk-elastic]
see-also: [logstash, elastic-agent-fleet, ingest-pipelines]
---

# Beats (Filebeat, Metricbeat)

Beats are lightweight, single-purpose data shippers written in Go that run on the source host and forward logs or metrics to Elasticsearch or Logstash.

## Why it matters

You need to *collect* data from edge hosts cheaply, with a tiny footprint and at-least-once delivery. A full [[logstash|Logstash]] JVM on every server is wasteful; a Beat is a small static binary tuned for one job. Filebeat tails log files; Metricbeat polls system and service metrics. They are the historic collection layer, now being unified under [[elastic-agent-fleet|Elastic Agent]].

## How it works

Each Beat reads a source, optionally lightly processes, and ships in [[bulk-api|bulk]]; it ships *modules* — prebuilt configs (parsing + dashboards + [[ingest-pipelines|ingest pipeline]]) for common services.

| Beat | Collects | Example modules |
|---|---|---|
| Filebeat | Log files, journald | nginx, system, mysql |
| Metricbeat | Numeric metrics (pull) | system, docker, elasticsearch |
| Packetbeat | Network flows | http, dns |
| Heartbeat | Uptime probes | icmp, http |

- **Filebeat registry** — tracks per-file read offset on disk, so a restart resumes where it left off rather than re-sending the whole file.
- **At-least-once** — Filebeat retries until the output acks; combined with no dedup, this can produce *duplicate* events on crash, not lost ones.
- **Backpressure** — when Elasticsearch is slow, Filebeat stops reading new lines rather than buffering unbounded memory.
- **Metricbeat period** — each module pulls on a `period` (e.g. `10s`); too-short periods multiply document volume and load.

## Example

Filebeat module enablement is one command, not hand-written grok:

```
filebeat modules enable nginx
filebeat setup           # loads index template, ILM policy, ingest pipeline, Kibana dashboards
filebeat -e              # start; tails configured nginx paths and ships to ES
```

The `nginx` module's pipeline parses access logs into ECS fields server-side — no [[logstash|Logstash]] needed.

## Pitfalls

- **Duplicates, not losses** — at-least-once + a crash mid-flush re-sends events; rely on idempotent doc IDs if exact-once matters.
- **Deleting the registry** — wiping Filebeat's `registry` makes it re-ingest every existing file from the top, flooding the index.
- **Inode reuse on log rotation** — aggressive rotation/truncation can confuse file tracking and skip or re-read lines; prefer copy-truncate-aware paths.
- **Metricbeat scope creep** — enabling many modules at short periods can dwarf your log volume in document count; budget metrics cardinality.

## See also

- [[elastic-agent-fleet]]
- [[logstash]]
