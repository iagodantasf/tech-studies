---
title: Indexing
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, databases]
prerequisites: [b-trees, hash-tables]
see-also: [b-trees, isam, databases]
---

# Indexing

An auxiliary data structure that maps key values to record locations so lookups avoid scanning every row, trading extra storage and write cost for fast reads.

## Why it matters

A full-table scan over 10⁸ rows reads all 10⁸ rows; a [[b-trees]] index turns the same equality lookup into ~3–4 page reads. Indexing is the single biggest lever in query performance, which is why every serious [[databases]] auto-indexes primary keys and lets you add secondary indexes. The cost is real: each index must be updated on every insert/update/delete and consumes disk, so over-indexing slows writes.

## How it works

An index stores `(key → location)` entries in a structure that supports fast search. The two dominant engines pick different structures by access pattern:

| Index type | Backed by | Good at | Bad at |
|---|---|---|---|
| B⁺-tree | [[b-trees]] | range scans, ordering, prefix | nothing major; the default |
| Hash | [[hash-tables]] | O(1) equality | range/ordering (no order) |

- **Clustered** index: the table rows are physically stored in index order (one per table). Lookups by that key need no extra hop.
- **Non-clustered / secondary** index: a separate structure whose leaves point back to the row, so a match costs an extra lookup to fetch the row.
- **Covering** index: includes every column a query needs, so the engine answers from the index alone and skips the row fetch entirely.
- **Composite** index on `(a, b)` serves predicates on `a` and on `a AND b` (leftmost-prefix rule), but **not** on `b` alone.

## Example

Query `WHERE email = 'x@y.com'` on a 10M-row users table.

| Plan | Work | Reads |
|---|---|---|
| no index | scan every row | ~10,000,000 |
| B⁺-tree on email | descend index, fetch row | ~4 + 1 |

The index turns a million-row scan into a handful of page reads — but it must be maintained on every write to `email`.

## Pitfalls

- **Indexing everything.** Each index taxes every write and consumes space; index the columns queries actually filter or join on, not all of them.
- **Wrong composite order.** An index on `(a, b)` cannot serve a query filtering only on `b` — order columns by which predicate appears alone most often.
- **Non-sargable predicates.** Wrapping the column in a function (`WHERE UPPER(name)=…`) or leading `LIKE '%x'` defeats the index and forces a scan.
- **Low-selectivity columns** (e.g. a boolean flag) rarely benefit — if a value matches half the rows, scanning is cheaper than index hops.

## See also

- [[b-trees]]
- [[isam]]
- [[databases]]
