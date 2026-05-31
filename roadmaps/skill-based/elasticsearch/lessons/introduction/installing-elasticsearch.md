---
title: Installing Elasticsearch
track: elasticsearch
group: Introduction
tags: [elasticsearch, installation]
prerequisites: []
see-also: [nodes-cluster, tls-encryption, what-is-elasticsearch]
---

# Installing Elasticsearch

How to stand up a working Elasticsearch node — local Docker for dev, packages for production — and the OS-level settings that bite you before the first query.

## Why it matters

A default Elasticsearch start now ships [[tls-encryption|TLS]] and [[authentication-users|authentication]] enabled, so "it worked in a tutorial without a password" is outdated. Knowing the bootstrap checks, JVM heap rules, and `vm.max_map_count` saves hours: the node refuses to start in production mode if they're wrong.

## How it works

Pick an install method, then satisfy the system prerequisites.

- **Docker (dev)** — fastest for one node; map port `9200` (HTTP) and `9300` (transport/[[discovery-cluster-formation|cluster]]).
- **Packages (prod)** — `.deb`/`.rpm` or tarball; runs as a service, config in `elasticsearch.yml`.
- **[[elastic-cloud-managed-offerings|Elastic Cloud]]** — managed; skip ops entirely.
- **System settings** — `vm.max_map_count ≥ 262144` (mmapfs), disable swap (`bootstrap.memory_lock: true`), raise file descriptors.
- **JVM heap** — set `-Xms` = `-Xmx`, ≤ 50% of RAM and **under ~31 GB** to keep compressed object pointers.

| Setting | Value | Why |
|---|---|---|
| `vm.max_map_count` | `262144` | Lucene mmap files |
| Heap (`Xms`/`Xmx`) | equal, ≤50% RAM, <31 GB | GC + compressed oops |
| `discovery.type` | `single-node` (dev) | Skips quorum bootstrap |
| Security | on by default (8.x+) | TLS + auth |

## Example

A single-node dev container with security disabled for local exploration:

```
docker run -p 9200:9200 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=false" \
  docker.elastic.co/elasticsearch/elasticsearch:8.x

curl localhost:9200      # → cluster name, version, "You Know, for Search"
```

In production you keep security on and use the auto-generated `elastic` password and CA cert printed on first start.

## Pitfalls

- **Heap over 31 GB** — crosses the compressed-oops threshold; a 32 GB heap can hold *less* usable data than 30 GB.
- **Skipping `vm.max_map_count`** — a production-mode node fails its bootstrap check and won't start.
- **Disabling security to "make it work"** — fine on localhost, dangerous on any reachable interface; bind to `0.0.0.0` only with TLS + auth.
- **Mismatched node versions** — a [[nodes-cluster|cluster]] tolerates only one minor version apart during [[rolling-upgrades|upgrades]].

## See also

- [[nodes-cluster]]
- [[tls-encryption]]
