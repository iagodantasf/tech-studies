---
title: Official language clients
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, clients]
prerequisites: [rest-api]
see-also: [bulk-api, optimistic-concurrency-control-versioning, nodes-cluster]
---

# Official language clients

Elastic ships maintained client libraries (Java, Python, JS, Go, .NET, Ruby, PHP, Rust) that wrap the [[rest-api|REST API]] with connection pooling, retries, sniffing, and typed responses.

## Why it matters

Raw HTTP works, but production needs node discovery, dead-node failover, request retries, and bulk helpers — re-implementing those per app is error-prone. The official clients track each Elasticsearch version, so calling `client.search(...)` stays correct across upgrades. Picking the right client and configuring its pool well is often the difference between a resilient and a flaky ingest path.

## How it works

A client holds a pool of node connections and routes each request, transparently retrying idempotent calls on a different node when one fails.

- **Sniffing** — the client can poll `_nodes/http` to discover the live topology and add/remove [[nodes-cluster|nodes]] automatically; useful with a fixed seed but a changing cluster.
- **Generations differ** — the *low-level* client (e.g. Python `elasticsearch-py`, JS `@elastic/elasticsearch`) maps 1:1 to REST; the older high-level Java `RestHighLevelClient` is deprecated in favour of the typed `java-client`.
- **Bulk helpers** — `helpers.bulk` (Python) / `BulkIngester` (Java) chunk an iterable into sized [[bulk-api|bulk]] requests, retry `429`s with backoff, and surface per-item errors.
- **Compatibility header** — clients send `Accept: ...compatible-with=N` so a vN client can talk to a v(N+1) server during a [[rolling-upgrades|rolling upgrade]].

| Concern | Setting (typical) |
|---|---|
| Connect timeout | a few seconds |
| Retries | `max_retries=3`, on timeout |
| Pool | one connection per seed node |
| Sniff | off behind a load balancer |

## Example

```python
from elasticsearch import Elasticsearch, helpers
es = Elasticsearch("https://es:9200", api_key="...", max_retries=3, retry_on_timeout=True)

actions = ({"_index": "logs", "_source": doc} for doc in stream)
ok, errors = helpers.bulk(es, actions, chunk_size=2000, raise_on_error=False)
# errors holds only the items that failed -> retry or dead-letter those
```

## Pitfalls

- **Don't sniff behind a proxy/LB** — sniffing returns nodes' *internal* addresses, which the client often can't reach; disable it and point at the balancer.
- **One client per process** — clients are thread-safe and pool internally; creating one per request exhausts sockets. Reuse a singleton.
- **`bulk` doesn't raise per item** — a partial failure still returns `200`; you must inspect each item's status or use `raise_on_error`, or silently lose docs.
- **Version skew** — a client far newer/older than the server can deserialize responses wrong; keep them within one major and send the compatibility header.

## See also

- [[bulk-api]]
- [[rest-api]]
