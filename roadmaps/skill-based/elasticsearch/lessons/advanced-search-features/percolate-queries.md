---
title: Percolate queries
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, percolator]
prerequisites: [query-dsl-overview, mappings]
see-also: [term-level-queries, ingest-pipelines, monitoring-alerting]
---

# Percolate queries

Percolation inverts search: instead of running one query over many documents, you store many queries and ask "which of these saved queries would match *this* document?"

## Why it matters

It powers alerting and classification — saved searches, price-drop watches, content tagging, intrusion rules. Without it you'd re-run every stored query against each incoming doc (O(queries) full searches per event); the percolator reduces candidate queries first, so matching one document against thousands of saved queries stays cheap and real-time.

## How it works

Queries are indexed as data into a `percolator` field; at percolate time the incoming document is analyzed and matched against those stored queries.

- **`percolator` field type** — stores a serialized [[query-dsl-overview|Query DSL]] clause; the index must also map the *real* fields those queries reference, so terms are extracted correctly.
- **Candidate pre-filtering** — Elasticsearch extracts the terms each stored query needs and builds a query over them, so only queries that *could* match are actually run against the document — the key to its speed.
- **`percolate` query** — supply the document inline (or by reference); hits are the matching saved queries, with their `_id`.
- **Highlighting** — you can highlight which parts of the document triggered each query.
- **Batch mode** — percolate several documents at once by passing `documents: [...]`.

## Example

```
PUT /alerts { "mappings": { "properties": {
  "query": { "type": "percolator" },
  "message": { "type": "text" } } } }                 // map the real field too

PUT /alerts/_doc/1 { "query": { "match": { "message": "outage" } } }

POST /alerts/_search { "query": { "percolate": {
  "field": "query", "document": { "message": "major outage in us-east" } } } }
```

The incoming message matches saved query `1`, so the alert "outage" fires — flip the alert to a notification downstream.

## Pitfalls

- **Mapping must match** — the percolator index needs the same field [[mappings]]/[[analyzers-standard-language-custom|analyzers]] as where docs really live, or stored queries analyze terms differently and silently miss.
- **Expensive query types** — `wildcard`, `range`, and scripts resist term extraction, so they can't be pre-filtered and run against every percolated doc; keep stored queries [[term-level-queries|term]]-centric.
- **Scale via routing** — millions of saved queries still need [[shards-replicas|shards]]; route by tenant so each percolation touches one shard.
- **Reindexing rewrites** — a major-version upgrade may re-serialize stored queries; percolator queries are version-sensitive, so test after [[rolling-upgrades|upgrades]].

## See also

- [[ingest-pipelines]]
- [[monitoring-alerting]]
