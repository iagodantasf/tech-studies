---
title: Databases
track: computer-science
group: Systems
tags: [cs, systems, databases]
prerequisites: [operating-systems]
see-also: [trees, hash-tables]
---

# Databases

A database stores, indexes, and queries data durably while guaranteeing that concurrent reads and
writes don't corrupt it — the two big ideas being **indexing** and **transactions**.

## Why it matters

A query that scans a million rows and one that jumps straight to ten can differ by orders of
magnitude, and that difference is almost always an index. Transactions are what let a bank transfer
or an order checkout stay correct under crashes and concurrency — get them wrong and you lose or
duplicate data silently.

## How it works

An **index** is an auxiliary structure that turns a full-table scan into a fast lookup — the same
trade as choosing the right [[trees|tree]] or [[hash-tables|hash table]] in memory:

- **B-tree / B+tree index** — sorted, balanced, shallow; supports `=`, range, and prefix queries and
  ordered iteration. The default for most engines.
- **Hash index** — O(1) equality lookups but no range or ordering. Great for exact-match keys.

Indexes speed reads but cost space and slow writes (every insert updates them), so you index the
columns you actually filter and join on — not all of them.

A **transaction** groups operations into an all-or-nothing unit with **ACID** guarantees:

- **Atomicity** — all of it commits or none does.
- **Consistency** — invariants hold before and after.
- **Isolation** — concurrent transactions don't see each other's partial state.
- **Durability** — once committed, it survives a crash (via a write-ahead log).

**Isolation levels** trade safety for speed; weaker levels permit anomalies like *dirty reads* and
*phantom reads*. Engines enforce isolation with locking or **MVCC** (multi-version concurrency
control), which keeps multiple row versions so readers never block writers.

## Example

```sql
-- Without an index on email, this scans every row: O(n)
SELECT * FROM users WHERE email = 'a@b.com';

CREATE INDEX idx_users_email ON users(email);
-- Now it's a B-tree descent: ~O(log n)

BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;   -- both succeed, or neither does
```

## Pitfalls

- **Over-indexing** — every extra index taxes inserts/updates and bloats storage; index for real
  query patterns.
- **Non-sargable predicates** — wrapping an indexed column in a function (`WHERE lower(email) = …`)
  defeats the index unless you index the expression.
- **Assuming the default isolation level is serializable** — most engines default lower, allowing
  subtle concurrency anomalies you must opt out of.

## See also

- [[trees]]
- [[hash-tables]]
