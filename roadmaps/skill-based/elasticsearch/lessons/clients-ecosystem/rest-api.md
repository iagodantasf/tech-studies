---
title: REST API
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, rest-api]
prerequisites: [what-is-elasticsearch, documents]
see-also: [official-language-clients, index-api, bulk-api]
---

# REST API

Every Elasticsearch operation — indexing, search, cluster admin — is an HTTP request to a JSON REST API on port 9200, which is the single contract all clients and tools speak.

## Why it matters

There is no binary protocol you must use and no driver lock-in: anything that can do HTTP can drive the cluster, which is why [[official-language-clients|clients]] in every language, [[kibana|Kibana]] Dev Tools, and `curl` all interoperate. Understanding the raw API is essential for debugging, since client libraries are thin wrappers and their errors are just relayed HTTP responses.

## How it works

Requests follow `METHOD /<index>/<endpoint>` with a JSON body; the verb carries intent and the path carries the target.

| Method | Typical use | Example |
|---|---|---|
| `GET` | read / search | `GET /logs/_search` |
| `PUT` | create with a known id | `PUT /logs/_doc/42` |
| `POST` | create with generated id / actions | `POST /logs/_doc` |
| `DELETE` | remove | `DELETE /logs/_doc/42` |
| `HEAD` | existence check (no body) | `HEAD /logs` |

- **`_cat` APIs** — human-readable plain-text tables (`_cat/indices?v`) for operators; everything else returns JSON.
- **Common query params** — `?pretty` indents output, `?format=yaml`, `?filter_path=hits.hits._source` trims the response, `?error_trace=true` expands stack traces.
- **Status codes are real** — `201` created, `200` updated, `404` missing, `409` version [[optimistic-concurrency-control-versioning|conflict]], `429` rejected (queue full), `503` cluster unavailable.
- **Bulk uses NDJSON** — the [[bulk-api]] is not normal JSON: it is newline-delimited with `Content-Type: application/x-ndjson` and a trailing newline.

## Example

```
PUT /products/_doc/1                 -> 201 Created   {"result":"created","_version":1}
{ "name": "Widget", "price": 9.99 }

GET /products/_search?filter_path=hits.total,hits.hits._source
{ "query": { "match": { "name": "widget" } } }
-> 200 { "hits": { "total": {"value":1}, "hits": [ {"_source": {...}} ] } }
```

`filter_path` cut the response to just totals and source — over millions of hits that saves real bandwidth and parse time.

## Pitfalls

- **`GET` with a body** — search uses `GET` *with* a JSON body; some proxies and old HTTP libraries strip it, so clients fall back to `POST /_search` (semantically identical).
- **9200 vs 9300** — 9200 is the REST/HTTP port; 9300 is the internal node-to-node transport. Never point clients or load balancers at 9300.
- **Trailing newline on bulk** — omitting the final `\n` makes the [[bulk-api]] silently drop the last action.
- **No body-size guard by default** — a giant request hits `http.max_content_length` (default 100mb) and returns `413`; chunk large bulk loads instead.

## See also

- [[official-language-clients]]
- [[bulk-api]]
