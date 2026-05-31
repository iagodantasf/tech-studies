---
title: Fenwick Trees
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, data-structures]
prerequisites: [array, bit-manipulation]
see-also: [segment-trees, fast-and-slow-pointers, common-runtimes]
---

# Fenwick Trees

A Fenwick tree (binary indexed tree, BIT) is a flat array that answers prefix-sum queries and point updates in O(log n) using the binary representation of indices — a [[segment-trees|segment tree]] with ~10× less code and constant factor.

## Why it matters

The classic need is a **running prefix sum that keeps changing**: a static prefix array gives O(1) sums but O(n) updates; a Fenwick tree balances both at O(log n). It powers order-statistics (count elements ≤ x), inversion counting during [[sorting]] analysis, and 2D range counts in computational geometry. When the operation is invertible and associative (sum, xor, count), Fenwick is the lightest tool that works.

## How it works

Index `i` is responsible for a range of length `lowbit(i) = i & -i` (its lowest set bit), ending at `i`. That single trick drives both operations:

| Operation | Move | Index step |
|---|---|---|
| `update(i, +delta)` | climb to parents | `i += i & -i` |
| `prefix(i)` (sum 1..i) | walk to ancestors | `i -= i & -i` |

```text
update(i, d): while i <= n: tree[i] += d; i += i & -i
prefix(i):    s = 0; while i > 0: s += tree[i]; i -= i & -i; return s
range(l, r):  return prefix(r) - prefix(l - 1)
```

- Use **1-based indexing** — `i & -i` of 0 is 0, which would loop forever.
- Each loop runs once per set bit, so ≤ ⌈log₂ n⌉ iterations — see [[bit-manipulation]].
- Build in O(n): set each `tree[i]`, then push it to `i + (i & -i)`; the naive n updates is O(n log n).

## Example

Array `[3,2,-1,6,5]`, 1-based. `prefix(4)` visits index 4 then 0: with the tree built, returns `3+2-1+6 = 10`. Now `update(3, +4)` (element 3 goes -1 → 3): walk indices 3 → 4 → ... adding 4. A re-query `range(2,4) = prefix(4) - prefix(1)` now reflects the change, all in ~3 array touches instead of rescanning 5 elements.

## Pitfalls

- **0-based indexing hangs the loop.** `i & -i == 0` for `i = 0`, so `prefix` never decrements — always shift to 1-based internally.
- **Non-invertible ops break range queries.** Fenwick gives `range(l,r) = prefix(r) - prefix(l-1)`, which needs subtraction; for min/max use a [[segment-trees|segment tree]] instead.
- **Range *update* needs a second BIT** (difference array trick) or a different structure; the plain version only does point updates cleanly.
- **Overflow.** Summing many large values needs 64-bit accumulators; the index math is fine but the stored sums are not.

## See also

- [[segment-trees]]
- [[bit-manipulation]]
- [[common-runtimes]]
