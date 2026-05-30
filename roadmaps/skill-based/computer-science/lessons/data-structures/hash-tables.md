---
title: Hash tables
track: computer-science
group: Data structures
tags: [cs, data-structures, hashing]
prerequisites: [arrays-and-dynamic-arrays]
see-also: [linked-lists, trees]
---

# Hash tables

A hash table maps **keys → values** by hashing each key to a bucket index in a backing array.
Average **O(1)** insert/lookup/delete; **O(n)** worst case when everything collides. The two design
choices that define one are the **hash function** and the **collision strategy**.

## Why it matters

Hash tables are the workhorse of practical programming — dictionaries, sets, caches, database
indexes, and deduplication all lean on them. "Use a hash map" is the right first answer to a huge
fraction of "make this faster" problems, precisely because it turns O(n) scans into O(1) lookups.

## How it works

`bucket = hash(key) mod capacity`, then store the entry there. Two keys can land in the same bucket
— a **collision** — and the strategy for that is the whole game:

- **Separate chaining** — each bucket holds a list (or tree) of entries. Simple, degrades
  gracefully. Java's `HashMap` upgrades a long chain to a red-black [[trees|tree]].
- **Open addressing** — on collision, probe for another slot in the same array:
  - *Linear probing* (`i+1`) — cache-friendly, but suffers **primary clustering**.
  - *Quadratic probing* (`i+k²`) — reduces clustering.
  - *Double hashing* — a second hash decides the step size; best distribution.

**Load factor** `α = n / buckets` controls the space/time trade-off. Chaining stays usable past
`α = 1`; open addressing must keep `α` well below 1 (resize around 0.7). A **resize** allocates a
bigger table and **rehashes** every entry — amortized O(1) because the table doubles geometrically
(the same argument behind dynamic [[arrays-and-dynamic-arrays|array]] growth).

| Operation | Average | Worst |
|---|---|---|
| Insert / lookup / delete | O(1) | O(n) |

## Example

```
function get(table, key):
    b ← hash(key) mod table.capacity
    for (k, v) in table.buckets[b]:     # separate chaining
        if k == key: return v
    return NOT_FOUND
```

A from-scratch hash map (open addressing vs chaining, then benchmark) is in this track's
*Project ideas*.

## Pitfalls

- **Relying on iteration order** — it's unspecified; never depend on it.
- **HashDoS** — an attacker who can choose keys can force every insert to collide, turning O(1) into
  O(n). Use randomized/seeded hashes for untrusted input.
- **Mutating a key after insertion** — its hash changes and the entry becomes unreachable. Keys must
  be effectively immutable.

## See also

- [[arrays-and-dynamic-arrays]]
- [[trees]]
