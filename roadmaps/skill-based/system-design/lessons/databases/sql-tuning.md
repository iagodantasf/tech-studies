---
title: SQL tuning
track: system-design
group: Databases
tags: [system-design, performance]
prerequisites: [databases]
see-also: [denormalization, sql-vs-nosql-when-to-use-which]
---

# SQL tuning

SQL tuning is the practice of reshaping queries, indexes, and schema so the database reads the fewest rows possible to answer a request.

## Why it matters

Most "the database is slow" incidents are a handful of queries doing full-table scans or N+1 round-trips, not a hardware limit. Tuning is the highest-leverage [[performance-vs-scalability]] work you can do: a single well-placed index can turn a 2-second query into 2 milliseconds, deferring the need to [[sharding|shard]] or buy bigger boxes. The tools are cheap; the wins are large.

## How it works

Start with the planner. `EXPLAIN ANALYZE` shows whether the engine scans or seeks:

- **Seq Scan** on a large table in a hot query → usually a missing index.
- **Index Scan / Index-Only Scan** → good; an index-only scan never touches the heap.
- Watch **rows estimated vs actual** — a big gap means stale statistics; run `ANALYZE`.

Indexing principles:

| Technique | Use when |
|---|---|
| Single-column index | filter/join on one column |
| Composite index | filter on `(a, b)` — order matters, leftmost-prefix |
| Covering index | include selected columns to skip the heap |
| Partial index | only a hot subset (e.g. `WHERE status='open'`) |

Keep predicates **sargable** — never wrap an indexed column in a function (`WHERE date(ts)=…`); index the expression or rewrite as a range. Fetch only needed columns (avoid `SELECT *`), paginate by keyset not large `OFFSET`, and batch to kill N+1 queries.

## Example

```sql
EXPLAIN ANALYZE
SELECT id, total FROM orders
WHERE user_id = 42 AND status = 'open';
-- Seq Scan on orders ... rows=2,000,000  (slow)

CREATE INDEX idx_orders_user_status ON orders(user_id, status);
-- Index Scan using idx_orders_user_status ... rows=7  (fast)
```

The composite `(user_id, status)` lets the engine seek straight to the 7 matching rows instead of scanning two million.

## Pitfalls

- **Non-sargable predicates.** Functions or leading wildcards (`LIKE '%x'`) disable the index.
- **Wrong composite order.** `(status, user_id)` won't serve a `user_id`-only filter; lead with the most selective, commonly-filtered column.
- **Over-indexing.** Every index taxes writes — see [[denormalization]] for the read/write trade.
- **Tuning on toy data.** Plans flip at scale; profile against production-sized tables with fresh statistics.

## See also

- [[denormalization]]
- [[sql-vs-nosql-when-to-use-which]]
