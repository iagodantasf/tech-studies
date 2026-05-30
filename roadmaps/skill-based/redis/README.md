---
title: Redis
track: redis
category: Skill-based
tags: [roadmap, redis, databases]
---

# Redis

> roadmap.sh: https://roadmap.sh/redis

Suggested path through the **Redis** nodes. Each node links to its lesson when written.

## Nodes

### Introduction
- What is Redis?
- In-memory vs On-disk databases
- Redis vs Memcached
- Use cases for Redis
- Installing Redis
- redis-cli basics
- RESP protocol

### Data Types
- Strings
- Lists
- Sets
- Sorted Sets
- Hashes
- Bitmaps
- HyperLogLog
- Geospatial indexes
- Streams
- Bitfields
- JSON (RedisJSON)

### Core Commands & Concepts
- Key naming conventions
- Key expiration (TTL)
- SCAN vs KEYS
- Pipelining
- Transactions (MULTI / EXEC / WATCH)
- Lua scripting (EVAL)
- Functions
- Pub/Sub
- Keyspace notifications

### Memory Management
- Maxmemory directive
- Eviction policies (LRU / LFU / TTL)
- Memory optimization & encoding
- Memory analysis (MEMORY USAGE / redis-cli --bigkeys)
- Object encoding internals

### Persistence
- RDB snapshots
- AOF (Append Only File)
- AOF rewrite
- RDB + AOF hybrid persistence
- Backup & restore strategies

### Replication & High Availability
- Master-replica replication
- Replication internals (PSYNC)
- Redis Sentinel
- Automatic failover
- Read scaling with replicas

### Scaling
- Redis Cluster
- Hash slots & sharding
- Cluster resharding
- Client-side partitioning
- Proxy-based partitioning (Twemproxy / Envoy)

### Performance & Benchmarking
- redis-benchmark
- Latency monitoring (LATENCY / SLOWLOG)
- Connection pooling
- Avoiding blocking commands
- Hot key & big key mitigation

### Security
- Authentication (requirepass / AUTH)
- ACLs (Access Control Lists)
- TLS / SSL encryption
- Protected mode & network binding
- Command renaming / disabling

### Common Use Cases
- Caching (cache-aside, write-through)
- Session store
- Rate limiting
- Leaderboards
- Message queues
- Distributed locks (Redlock)
- Real-time analytics

### Administration & Observability
- Configuration (redis.conf)
- INFO command & metrics
- Monitoring (Prometheus / RedisInsight)
- Logging
- Upgrading Redis
- Running Redis in Docker / Kubernetes

### Client Libraries & Ecosystem
- Client libraries (redis-py, ioredis, Jedis, Lettuce)
- Redis Stack
- RediSearch
- RedisTimeSeries
- RedisBloom
- Managed Redis (ElastiCache, Redis Cloud)

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a cache-aside layer in front of a SQL database and measure the latency / hit-ratio improvement under load.
- Implement a sliding-window rate limiter using sorted sets and expose it as middleware for a small REST API.
- Stand up a 3-node Redis Cluster in Docker, write a script that triggers resharding, and verify zero key loss during the migration.
