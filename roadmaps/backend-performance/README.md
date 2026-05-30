---
title: Backend Performance
roadmap: backend-performance
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, backend, performance]
---

# Backend Performance

> roadmap.sh: https://roadmap.sh/best-practices/backend-performance

Track for the **Backend Performance** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] Why backend performance matters
- [ ] Latency vs throughput
- [ ] Percentiles (p50 / p95 / p99) over averages
- [ ] Define SLIs, SLOs and SLAs
- [ ] Establish performance budgets
- [ ] The USE method (Utilization, Saturation, Errors)
- [ ] The RED method (Rate, Errors, Duration)

### Measure Before Optimizing
- [ ] Profile before you optimize
- [ ] Identify the bottleneck first
- [ ] CPU profiling
- [ ] Memory profiling
- [ ] Flame graphs
- [ ] Distributed tracing
- [ ] Load testing
- [ ] Stress testing
- [ ] Benchmarking methodology
- [ ] Avoid premature optimization

### Database
- [ ] Add the right indexes
- [ ] Avoid N+1 queries
- [ ] Analyze query plans (EXPLAIN)
- [ ] Select only needed columns
- [ ] Use connection pooling
- [ ] Batch reads and writes
- [ ] Paginate large result sets
- [ ] Denormalize when justified
- [ ] Read replicas for read-heavy loads
- [ ] Partitioning and sharding
- [ ] Tune isolation levels
- [ ] Keep transactions short
- [ ] Use prepared statements

### Caching
- [ ] Cache expensive computations
- [ ] In-memory caching (Redis / Memcached)
- [ ] Application-level caching
- [ ] HTTP caching headers (ETag, Cache-Control)
- [ ] CDN for static and cacheable content
- [ ] Cache invalidation strategy
- [ ] Avoid cache stampede
- [ ] Set sensible TTLs

### Application Layer
- [ ] Use async / non-blocking I/O
- [ ] Offload work to background jobs / queues
- [ ] Reuse connections (HTTP keep-alive)
- [ ] Compress responses (gzip / Brotli)
- [ ] Pick efficient serialization formats
- [ ] Stream large responses
- [ ] Choose efficient algorithms and data structures
- [ ] Avoid blocking the event loop
- [ ] Tune thread / worker pools
- [ ] Mind garbage collection pressure

### Concurrency & Scaling
- [ ] Horizontal vs vertical scaling
- [ ] Load balancing
- [ ] Statelessness for scale-out
- [ ] Rate limiting and throttling
- [ ] Backpressure
- [ ] Apply the circuit breaker pattern
- [ ] Set timeouts and retries with backoff
- [ ] Use bulkheads to isolate failures

### Network & Infrastructure
- [ ] Reduce round trips
- [ ] HTTP/2 and HTTP/3
- [ ] Keep services close to data (locality)
- [ ] Edge computing
- [ ] Right-size compute resources
- [ ] Autoscaling policies

### Observability
- [ ] Metrics collection
- [ ] Centralized logging
- [ ] Tracing across services
- [ ] Dashboards and alerting
- [ ] Continuous performance regression testing

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a load-testing harness with k6 against a sample API and chart p50/p95/p99 latency as you add indexes and caching.
- Take a deliberately N+1-ridden ORM endpoint and refactor it (eager loading, batching, indexes), documenting the EXPLAIN plans before and after.
- Add a Redis caching layer with proper TTLs and stampede protection in front of a slow endpoint, then measure hit rate and tail-latency improvement.
