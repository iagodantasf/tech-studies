---
title: ISAM
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, disk-structures]
prerequisites: [indexing, b-trees]
see-also: [b-trees, indexing, databases]
---

# ISAM

Indexed Sequential Access Method: a disk file organization with a static, sorted multi-level index over data pages, where later inserts spill into overflow chains.

## Why it matters

ISAM (IBM, 1960s) is the historical predecessor of the [[b-trees]] and explains why modern [[databases]] chose dynamic trees instead. Its index is built **once** over the sorted data and never rebalances, so it is fast and lock-free for read-mostly, append-rarely data — but it degrades as updates accumulate. The pattern survives in append-optimized and static-index systems (e.g. read-only data marts, some LSM sorted runs).

## How it works

The file is laid out in three layers, built bottom-up at load time over sorted records:

| Layer | Contents | Role |
|---|---|---|
| Data pages | the actual sorted records | leaf level, scanned in key order |
| Index pages | highest key per lower page | static, multi-level funnel |
| Overflow pages | records inserted after build | chained off the home data page |

- **Lookup** walks the fixed index top-down (a few I/Os) to the home data page, then scans it and its overflow chain.
- **Sequential access** is cheap: data pages are physically sorted and contiguous, so a range scan is a sequential read.
- **Insert** finds the home page; if full, the record goes to an overflow page linked to that page. The index is *never* updated.
- Performance is restored only by an offline **reorganization** that rebuilds the file and folds overflow back into sorted pages.

## Example

Index over keys `10, 20, 30, …` points each entry to a home page. Inserting `25` lands on the page whose range covers it; if that page is full, `25` goes to an overflow page chained behind it:

```
index: [..|30|..] --> home page [21..29 full]
                                     |
                                 overflow -> [25]
```

After many such inserts, a lookup for `25` must read the home page *and* walk the overflow chain — read cost drifts from O(log n) toward O(chain length) until reorg.

## Pitfalls

- **Overflow-chain rot.** Because the index is static, heavy inserting builds long unsorted overflow chains and read performance collapses; schedule periodic reorganization.
- **Mistaking it for a B-tree.** ISAM does not split, merge, or rebalance — that absence is the whole point, and the whole weakness. Use a [[b-trees]] when writes are frequent.
- **Reorg is offline / disruptive** — it rewrites the file; plan it as maintenance, not a transparent background op.
- Allocating too little free space per page at load time makes overflow happen sooner; leave fill-factor slack for expected inserts.

## See also

- [[b-trees]]
- [[indexing]]
- [[databases]]
