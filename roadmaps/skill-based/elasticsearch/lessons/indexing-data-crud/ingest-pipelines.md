---
title: Ingest pipelines
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, ingest]
prerequisites: [index-api, mappings]
see-also: [bulk-api, reindex-api, logstash]
---

# Ingest pipelines

An ingest pipeline is an ordered chain of *processors* that transform a [[documents|document]] in Elasticsearch — on a node with the `ingest` role — just before it is indexed.

## Why it matters

Lots of enrichment (parse a log line, lowercase an email, drop a PII field, set a timestamp, geo-locate an IP) doesn't need a separate ETL box. Pipelines push that work into the cluster, so the [[index-api|Index]]/[[bulk-api|Bulk]] write path itself does the shaping. They are a lighter alternative to [[logstash|Logstash]] for in-cluster transforms and pair naturally with [[data-streams|data streams]].

## How it works

```
PUT /_ingest/pipeline/web-logs
{ "processors": [
    { "grok":   { "field": "message", "patterns": ["%{COMBINEDAPACHELOG}"] } },
    { "lowercase": { "field": "url.original" } },
    { "geoip":  { "field": "source.ip", "target_field": "source.geo" } },
    { "remove": { "field": "message" } }
] }
```

| Common processor | Does |
|---|---|
| `grok` / `dissect` | parse unstructured text into fields |
| `set` / `rename` / `remove` | reshape fields |
| `geoip` / `user_agent` | enrich from bundled databases |
| `script` | arbitrary Painless scripting logic |

- **Attach it** by name: `POST /logs/_doc?pipeline=web-logs`, or as the index's `default_pipeline` so every write runs it transparently.
- **Failure handling** — a failed processor aborts the doc unless you set `on_failure` (per-processor or pipeline-wide) to route to a dead-letter field/index.
- **Runs on ingest nodes** — heavy `grok` or [[painless-scripting|Painless `script`]] pipelines burn CPU there; isolate the [[node-roles-master-data-ingest-coordinating|ingest role]] under load.

## Example

Reshape legacy docs during a migration — no external tool:

```
POST /_reindex
{ "source": { "index": "old" }, "dest": { "index": "new", "pipeline": "web-logs" } }
```

[[reindex-api|Reindex]] streams every doc through the pipeline, so old data lands in the new shape.

## Pitfalls

- **Catastrophic grok backtracking** — a loose pattern over messy input can blow up CPU per doc; anchor patterns and prefer `dissect` for fixed-delimiter lines.
- **Silent drops** — an `on_failure` that quietly removes fields (or an explicit `drop` processor) can discard docs you needed; log failures to a dead-letter index.
- **Pipeline ≠ mapping** — a processor can produce a field whose type clashes with the [[mappings|mapping]] (e.g. a string where a `date` is expected), failing the index step *after* transformation.
- **`default_pipeline` is invisible** — debugging "where did this field come from?" means checking index settings, not just the request. Use `_simulate` to test before deploying.

## See also

- [[bulk-api]]
- [[logstash]]
