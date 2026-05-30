---
title: Sorting (merge, quick, heap)
track: computer-science
group: Algorithms
tags: [cs, algorithms, sorting]
prerequisites: [arrays-and-dynamic-arrays, asymptotic-notation]
see-also: [searching, divide-and-conquer, heaps-and-priority-queues]
---

# Sorting (merge, quick, heap)

Sorting arranges elements into a defined order; the three comparison-based workhorses are **merge
sort**, **quicksort**, and **heapsort**, all running in `O(n log n)` on average.

## Why it matters

Sorted data unlocks [[searching|binary search]], deduplication, range queries, and countless greedy
strategies — so much downstream work assumes order that sorting is one of the most-called routines in
any system. The three classic algorithms also teach the core trade-offs (stability, in-place,
worst-case) that recur throughout algorithm design.

## How it works

All three beat the `O(n²)` of bubble/insertion sort by structure, but trade differently:

- **Merge sort** — [[divide-and-conquer|divide]] in half, sort each half, **merge** the two sorted
  runs. Stable, predictable `O(n log n)` worst case, but needs `O(n)` extra space.
- **Quicksort** — pick a **pivot**, partition into `< pivot` and `> pivot`, recurse. In-place and
  cache-friendly, but degrades to `O(n²)` on bad pivots. Randomize or use median-of-three.
- **Heapsort** — build a [[heaps-and-priority-queues|heap]], repeatedly extract the max. In-place,
  guaranteed `O(n log n)`, but not stable and poor cache behavior.

| Algorithm | Average | Worst | Space | Stable |
|---|---|---|---|---|
| Merge | `O(n log n)` | `O(n log n)` | `O(n)` | yes |
| Quick | `O(n log n)` | `O(n²)` | `O(log n)` | no |
| Heap | `O(n log n)` | `O(n log n)` | `O(1)` | no |

Comparison sorts cannot beat `O(n log n)`; non-comparison sorts (counting, radix) can hit `O(n)` when
keys are bounded integers.

## Example

```
function quicksort(A, lo, hi):
    if lo >= hi: return
    p ← partition(A, lo, hi)     # pivot lands at its final index p
    quicksort(A, lo, p - 1)
    quicksort(A, p + 1, hi)
```

## Pitfalls

- **Quicksort on sorted input with a naive pivot** — first/last-element pivots hit the `O(n²)` worst
  case exactly on already-sorted data. Randomize the pivot.
- **Assuming stability** — quicksort and heapsort reorder equal keys; use merge sort when ties must
  keep their original order.
- **Ignoring extra space** — merge sort's `O(n)` buffer matters on huge or memory-tight inputs.

## See also

- [[divide-and-conquer]]
- [[heaps-and-priority-queues]]
