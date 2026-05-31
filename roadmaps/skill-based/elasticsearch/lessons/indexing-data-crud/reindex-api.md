---
title: Reindex API
track: elasticsearch
group: Indexing Data (CRUD)
tags: [elasticsearch, reindex]
prerequisites: [index-api, indices]
see-also: [update-by-query-delete-by-query, ingest-pipelines, index-templates]
---

# Reindex API

Reindex copies documents from one or more source indices into a destination index, optionally transforming them on the way — the standard tool for mapping changes and shard-count migrations.

## Why it matters

Many [[mappings|mapping]] and settings are immutable: you cannot change a field's type, an [[analyzers-standard-language-custom|analyzer]], or `number_of_shards` in place. The fix is to create a correctly-mapped [[indices|index]] and reindex into it, then swap an alias. Reindex also subsets data, merges indices, and remodels documents through a [[ingest-pipelines|pipeline]] or script.

## How it works

```
POST /_reindex
{ "source": { "index": "products-v1",
              "query": { "term": { "active": true } } },
  "dest":   { "index": "products-v2", "op_type": "create" },
  "script": { "source": "ctx._source.price *= 1.1" } }
```

- **Internally a scroll + bulk loop** — it reads the source with [[pagination-from-size-search-after-scroll|scroll]] and writes via the [[bulk-api|Bulk API]] under the hood; it is not magic, just batched.
- **Async + throttled** — pass `?wait_for_completion=false` to get a task id, poll `_tasks`; set `requests_per_second` to cap write load on a live cluster.
- **`op_type:create`** skips/conflicts on existing dest ids (good for resumable merges); default overwrites.
- **Remote reindex** — `source.remote` pulls from another cluster over HTTP for cross-cluster migrations.

## Example

Zero-downtime mapping change using an alias:

```
1. PUT /products-v2  { correct mappings }
2. POST /_reindex    products-v1 → products-v2  (async, throttled)
3. POST /_aliases    move alias "products" v1 → v2 atomically
4. DELETE /products-v1
```

Readers query `products` throughout and never see the cutover.

## Pitfalls

- **Not a live sync** — reindex is a point-in-time snapshot via scroll; writes to the source *after* it starts are missed. Dual-write or replay the gap before the alias swap.
- **Refresh + merge pressure** — set `dest` `refresh_interval:-1` and `number_of_replicas:0` during load, restore after, then [[force-merge-refresh-interval|force-merge]] — often 2–3× faster.
- **No mapping inheritance** — the dest must already have the right mapping (via [[index-templates|template]] or explicit `PUT`); a fresh dest gets dynamic mapping and may guess types wrong.
- **Version conflicts abort** — by default the whole job stops on conflict; set `conflicts:"proceed"` to skip and continue.

## See also

- [[update-by-query-delete-by-query]]
- [[ingest-pipelines]]
