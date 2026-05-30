---
title: Hash Tables
roadmap: computer-science
node: "Data Structures"
status: done
confidence: 3
tags: [cs, data-structures, hashing]
created: 2026-05-30
updated: 2026-05-30
sources:
  - https://roadmap.sh/computer-science
---

# Hash Tables

## TL;DR
A hash table maps keys → values by hashing the key to a bucket index. Average **O(1)** insert/lookup/delete; **O(n)** worst case when everything collides. The two big design choices are the **hash function** and the **collision strategy**.

## Notes

### Collision strategies
- **Separate chaining** — each bucket holds a list (or tree) of entries. Simple; degrades gracefully. Java's `HashMap` upgrades long chains to red-black trees.
- **Open addressing** — on collision, probe for another slot:
  - *Linear probing* (`i+1`) — cache-friendly, but **primary clustering**.
  - *Quadratic probing* (`i+k²`) — reduces clustering.
  - *Double hashing* — second hash decides the step; best distribution.

### Load factor (α = n / buckets)
- Controls the space/time trade-off. Chaining stays usable past α=1; open addressing must keep α well below 1 (resize ~0.7).
- **Resize** = allocate a bigger table and **rehash** everything. Amortized O(1) because doublings are geometric.

### Gotchas
- Hash table iteration order is unspecified — never rely on it.
- A bad/attacker-chosen hash function turns O(1) into O(n) (HashDoS) → use randomized seeds for untrusted input.
- Keys must have stable hashes; mutating a key after insertion corrupts the table.

## Try it
- [[binary-search]] is the sibling "searching" note; a from-scratch hash map is in this track's *Project ideas*.

## Open questions
- When does Robin Hood hashing beat double hashing in practice?

## See also
- [[binary-search]]
