---
title: What is Elasticsearch?
track: elasticsearch
group: Introduction
tags: [elasticsearch, fundamentals]
prerequisites: []
see-also: [search-engine-fundamentals, apache-lucene-foundations, the-elastic-stack-elk-elastic]
---

# What is Elasticsearch?

Elasticsearch is a distributed, document-oriented search and analytics engine built on [[apache-lucene-foundations|Apache Lucene]], exposed entirely over a JSON REST API.

## Why it matters

It answers full-text [[query-dsl-overview|queries]] over billions of documents in milliseconds by precomputing an [[inverted-index]] at write time instead of scanning rows at read time. The same engine powers product search, log/[[apm-observability|observability]] backends, and ad-hoc [[bucket-aggregations|analytics]] — which is why it sits behind a huge fraction of "search box" and "log dashboard" features in production.

## How it works

You `PUT` JSON [[documents]] into an [[indices|index]]; each index is split into [[shards-replicas|shards]] (each shard is a self-contained Lucene index) spread across [[nodes-cluster|nodes]] for horizontal scale.

- **Schema-aware** — a [[mappings|mapping]] declares field types; `text` fields are run through [[analyzers-standard-language-custom|analyzers]] to build the inverted index, `keyword`/numeric fields stay exact.
- **Near real-time** — writes are searchable after a [[near-real-time-search|refresh]] (default 1s), not instantly, because Lucene buffers into [[segments]].
- **Distributed by default** — replicas provide HA and read throughput; a [[cluster-health-green-yellow-red|cluster]] coordinates allocation and failover.
- **Relevance-ranked** — results are scored by [[relevance-scoring-bm25|BM25]], not just matched.

| Aspect | Elasticsearch |
|---|---|
| Data model | JSON documents in indices |
| Interface | REST + Query DSL (JSON) |
| Consistency | Near real-time, eventually consistent reads |
| Scaling | Horizontal via shards + replicas |

## Example

```
PUT /products/_doc/1
{ "name": "Wireless Mouse", "price": 24.99, "in_stock": true }

GET /products/_search
{ "query": { "match": { "name": "mouse" } } }
```

The `match` query analyzes `"mouse"` the same way the field was indexed, looks it up in the inverted index, and returns doc 1 with a `_score`.

## Pitfalls

- **Treating it as a system of record** — it has no transactions or joins; keep a source DB and index a denormalized view (see [[elasticsearch-vs-relational-databases]]).
- **Expecting read-after-write** — a doc isn't searchable until the next refresh; `?refresh=true` forces it but hurts throughput.
- **Confusing the products** — "Elasticsearch" is one component of the broader [[the-elastic-stack-elk-elastic|Elastic Stack]] (Kibana, Beats, Logstash).

## See also

- [[search-engine-fundamentals]]
- [[apache-lucene-foundations]]
