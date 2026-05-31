---
title: Runtime fields
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, runtime-fields]
prerequisites: [mappings, painless-scripting]
see-also: [dynamic-vs-explicit-mapping, reindex-api, metric-aggregations]
---

# Runtime fields

A runtime field is a field whose value is computed by a [[painless-scripting|Painless]] script at query time rather than indexed at ingest, letting you add or override fields without [[reindex-api|reindexing]].

## Why it matters

Schemas drift: you discover you need a derived field (a parsed timestamp, a calculated margin, a grok-extracted code) *after* terabytes are already indexed. Runtime fields let you query, [[sorting|sort]], and [[metric-aggregations|aggregate]] on it immediately, trading query-time CPU for zero index cost and instant schema flexibility — the inverse of the usual index-time/query-time bargain.

## How it works

Runtime fields run their script per matching document via `doc_values` of other fields; nothing extra is stored.

| Defined in | Lifetime | Cost paid |
|---|---|---|
| index mapping `runtime` | persistent, all queries | per-query CPU |
| search request `runtime_mappings` | that request only | per-query CPU |

- **`emit(...)`** — the script outputs the value(s); supported types include `keyword`, `long`, `double`, `boolean`, `date`, `ip`, `geo_point`.
- **Override a field** — define a runtime field with the *same name* as an indexed one to reshape it without a reindex (the runtime version wins for that query).
- **`fields` retrieval** — runtime fields aren't in `_source`; request them via the `fields` parameter.
- **Promote later** — once a runtime field proves useful, index it for the same logic at full index-time speed; queries don't change.

## Example

```
POST /logs/_search { "runtime_mappings": {
    "hour": { "type": "long", "script": {
      "source": "emit(doc['@timestamp'].value.getHour())" } } },
  "aggs": { "by_hour": { "terms": { "field": "hour" } } },
  "fields": ["hour"], "size": 0 }
```

`hour` is derived from `@timestamp` at query time and bucketed — no reindex, but the script runs for every doc the aggregation touches.

## Pitfalls

- **Query-time cost scales** — a runtime field over millions of docs in an [[metric-aggregations|aggregation]] is far slower than an indexed field; fine for ad-hoc, risky for hot dashboards.
- **Needs `doc_values`** — scripts read other fields' doc values; referencing analyzed `text` (no doc values) fails — target a `keyword` instead.
- **Not searchable for free** — a `term` query on a runtime field still executes the script per doc; it can't use the [[inverted-index]].
- **Silent nulls** — if the script throws (missing source field), the field is just absent; guard with `if (doc['x'].size() != 0)`.

## See also

- [[dynamic-vs-explicit-mapping]]
- [[painless-scripting]]
