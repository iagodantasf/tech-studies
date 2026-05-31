---
title: Load balancers — L4 vs L7, algorithms, active-passive/active-active
track: system-design
group: Networking & delivery
tags: [system-design, load-balancing]
prerequisites: []
see-also: [reverse-proxy-vs-load-balancer, horizontal-vs-vertical-scaling, availability-patterns-failover-replication]
---

# Load balancers — L4 vs L7, algorithms, active-passive/active-active

A load balancer spreads incoming traffic across a pool of backends, removing any single server as a bottleneck or point of failure.

## Why it matters

The moment you run more than one instance — the whole point of [[horizontal-vs-vertical-scaling|horizontal scaling]] — something has to decide which instance gets each request. A load balancer does that while **health-checking** backends and pulling dead ones out of rotation, which is also the backbone of [[availability-patterns-failover-replication]]. It is the seam where you add capacity, do zero-downtime deploys, and terminate TLS.

## How it works

The headline choice is the OSI layer it operates at:

| | L4 (transport) | L7 (application) |
|---|---|---|
| Sees | IP + port, TCP/UDP | full HTTP: path, headers, cookies |
| Routing | by connection | by URL, host, content |
| Cost | very fast, cheap | more CPU (parses requests) |
| TLS | passes through | can terminate, inspect |

**L4** forwards packets/connections blind to content — fast and protocol-agnostic. **L7** understands HTTP, so it can route `/api` and `/static` to different pools, terminate TLS, and retry idempotent requests. Backend selection uses an **algorithm**:

- **Round robin** — next server in order; even, ignores load.
- **Least connections** — fewest active conns; good for long-lived/uneven requests.
- **Weighted** — bigger boxes get a larger share.
- **IP hash** — same client → same server (poor man's [[caching-strategies-cache-aside-write-through-write-behind-refresh-ahead|stickiness]]).

For the LB's own redundancy: **active-passive** keeps a standby that takes a shared/virtual IP only when the primary fails (simple, half the hardware idle); **active-active** runs all nodes serving traffic at once (more capacity, no idle waste, but state/health must be coordinated).

## Example

L7 routing two paths, least-connections within each pool:

```
GET /api/orders  →  api-pool   (least-conn) → api-3   [TLS terminated at LB]
GET /static/x.js →  static-pool(round-robin)→ cdn-edge-1
health: every 2s GET /healthz; 3 fails → eject; 2 OK → re-add
```

## Pitfalls

- **The LB becomes the SPOF.** A single load balancer just moves the failure point — run it active-passive or active-active.
- **Sticky sessions hide state in memory.** They pin users to one box, breaking even balancing and losing sessions on failover. Externalize session state instead.
- **Stale or shallow health checks.** A TCP-connect check passes while the app returns 500s; health-check a real endpoint.
- **No connection draining.** Killing a backend mid-deploy drops in-flight requests; drain before removing.

## See also

- [[reverse-proxy-vs-load-balancer]]
- [[horizontal-vs-vertical-scaling]]
