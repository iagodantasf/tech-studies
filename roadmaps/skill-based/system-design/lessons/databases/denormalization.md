---
title: Denormalization
track: system-design
group: Databases
tags: [system-design, data-modeling]
prerequisites: [databases]
see-also: [sharding, sql-tuning]
---

# Denormalization

Denormalization trades write cost and redundancy for read speed by storing the same data in more than one place so reads avoid expensive joins.

## Why it matters

Normalized schemas keep each fact in exactly one place, which is great for correctness but forces joins (and many random I/Os) on every read. Once data is [[federation|federated]] or [[sharding|sharded]], those joins may cross machines and become prohibitively slow. Denormalization precomputes the join so a hot read path touches one row or one shard — the standard move in read-heavy systems.

## How it works

Common techniques, all forms of "store it twice so reads are cheap":

- **Redundant columns** — copy a parent attribute onto the child (store `author_name` on `post`, not just `author_id`).
- **Precomputed aggregates** — keep `comment_count` on `post` instead of `COUNT(*)`-ing comments every render.
- **Materialized views** — a query result stored as a table, refreshed on a schedule or on write.
- **Summary / rollup tables** — pre-rolled daily totals for dashboards.

| Schema | Reads | Writes | Risk |
|---|---|---|---|
| Normalized | joins, slower | one write | none (single source) |
| Denormalized | no joins, fast | fan-out writes | data can drift |

The hard part is **keeping copies in sync** on every write — often via application logic, triggers, or an [[event-driven-architecture]] / [[cqrs-event-sourcing]] read model.

## Example

A feed renders 50 posts, each showing author name and comment count.

```sql
-- Normalized: 50 posts × 2 joins each = lots of random reads
SELECT p.*, u.name, COUNT(c.id)
FROM post p JOIN user u ON u.id = p.author_id
LEFT JOIN comment c ON c.post_id = p.id
GROUP BY p.id;

-- Denormalized: author_name and comment_count live on post
SELECT id, body, author_name, comment_count FROM post;  -- one table, no joins
```

When a user renames themselves you now update `author_name` across their posts — accepted because renames are rare and reads are constant.

## Pitfalls

- **Update anomalies.** A renamed author leaves stale copies unless every write path updates them. Make the sync authoritative, not best-effort.
- **Premature denormalization.** Normalize first; denormalize only the proven-hot paths an index (see [[sql-tuning]]) couldn't fix.
- **Aggregate drift.** A missed increment leaves `comment_count` wrong forever; reconcile periodically.
- **Write amplification.** One logical change becomes many physical writes — costly under [[sharding]].

## See also

- [[sharding]]
- [[sql-tuning]]
