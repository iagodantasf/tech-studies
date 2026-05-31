---
title: Segment Trees
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, data-structures]
prerequisites: [array, binary-trees, recursion]
see-also: [fenwick-trees, divide-and-conquer, common-runtimes]
---

# Segment Trees

A binary tree over array index ranges where each node stores an aggregate (sum, min, max, gcd…) of its segment, giving O(log n) range queries *and* range/point updates for any associative operation.

## Why it matters

When both the query and the update span *ranges* — "min on [l, r]", "add 5 to [l, r] then ask the max" — a [[fenwick-trees|Fenwick tree]] strains but a segment tree handles it directly. It generalizes to any associative merge, supports **lazy propagation** for range updates, and underpins range-min-query, interval scheduling, and 2D variants. It is the Swiss-army knife of range problems: more code and ~4n memory than Fenwick, but far more flexible.

## How it works

The root covers `[0, n-1]`; each internal node splits its range in half, so leaves are single elements. A query/update touches O(log n) nodes via [[divide-and-conquer]]:

| Case (query range vs node range) | Action |
|---|---|
| no overlap | return identity (0 / +∞ / −∞) |
| node fully inside query | return node's stored value |
| partial overlap | recurse into both children, merge |

```text
query(node, lo, hi, l, r):
  if r < lo or hi < l: return IDENTITY
  if l <= lo and hi <= r: return val[node]
  m = (lo+hi)/2
  return merge(query(2*node,   lo, m,   l, r),
               query(2*node+1, m+1, hi, l, r))
```

- Store in a flat array of size ~`4n` (children of `i` at `2i`, `2i+1`); build bottom-up in O(n).
- **Lazy propagation**: a range update marks a node "pending +d" and pushes the tag down only when a child is visited, keeping range updates O(log n) instead of O(n).
- The merge must be **associative**; for min/max/gcd there is no inverse, which is exactly why Fenwick cannot do them.

## Example

Array `[1, 3, 5, 7, 9, 11]`, range-min query on `[1, 4]` (values 3,5,7,9 → 3). The recursion splits `[0,5]` → `[0,2]`/`[3,5]`, descends to the nodes covering `[1,2]` and `[3,4]`, returns `min(3, 5)=3` and `min(7,9)=7`, merges to `3` — visiting ~5 nodes, not all 6 leaves. A later `update [2,4] += 10` with lazy tags touches only O(log n) nodes.

## Pitfalls

- **Wrong identity value** silently corrupts results: sum→0, min→+∞, max→−∞, gcd→0. A min query that returns 0 on no-overlap will hide real minima.
- **Forgetting to push lazy tags before recursing** into children returns stale aggregates — the #1 lazy-propagation bug.
- **Undersizing the array.** `2n` is not enough for non-power-of-two `n`; use `4n` (or round `n` up to a power of two).
- **Using it when Fenwick suffices.** For pure prefix-sum + point update, a [[fenwick-trees|Fenwick tree]] is smaller, cache-friendlier, and less bug-prone.

## See also

- [[fenwick-trees]]
- [[divide-and-conquer]]
- [[common-runtimes]]
