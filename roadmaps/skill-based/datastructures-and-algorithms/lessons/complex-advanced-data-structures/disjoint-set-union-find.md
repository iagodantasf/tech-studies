---
title: Disjoint Set (Union-Find)
track: datastructures-and-algorithms
group: Complex / advanced data structures
tags: [datastructures-and-algorithms, data-structures]
prerequisites: [array, trees]
see-also: [kruskal-s-algorithm, minimum-spanning-tree, graph-data-structures]
---

# Disjoint Set (Union-Find)

A forest-of-parents structure that tracks a partition of n elements into disjoint sets, supporting `find` (which set?) and `union` (merge two sets) in near-constant amortized time.

## Why it matters

Whenever you must answer "are these two things in the same group?" while groups keep merging, union-find is the answer: dynamic connectivity, [[kruskal-s-algorithm|Kruskal's MST]], cycle detection in an undirected [[graphs]], image-region labeling, and grouping equivalences in compilers. With both optimizations it runs in O(α(n)) amortized — α is the inverse Ackermann function, ≤ 4 for any n that fits in the universe, so effectively O(1).

## How it works

Each element points to a parent; a set is identified by its **root** (an element pointing to itself). Two optimizations make it fast:

| Optimization | What it does | Effect |
|---|---|---|
| Path compression | `find` re-points every node on the path directly to the root | flattens trees |
| Union by rank/size | attach the smaller tree under the larger root | bounds tree height |

```text
find(x):  while parent[x] != x: parent[x] = parent[parent[x]]; x = parent[x]   # path-halving
          return x
union(a,b): ra,rb = find(a),find(b); if ra==rb: return
            if size[ra] < size[rb]: swap(ra,rb)
            parent[rb]=ra; size[ra]+=size[rb]
```

- Either optimization alone gives O(log n); **both together** give O(α(n)) amortized.
- Initialize `parent[i]=i`, `size[i]=1` — O(n) and O(n) space, two flat arrays, no pointers.
- Union-by-rank uses an upper-bound height; union-by-size uses node counts. Either works; do not mix without care.

## Example

Edges arriving for [[kruskal-s-algorithm|Kruskal's]] on 6 nodes: process `(0,1),(2,3),(1,3),(4,5)`. After `(0,1)` and `(2,3)`, sets are `{0,1} {2,3} {4} {5}`. Edge `(1,3)` unions them → `{0,1,2,3}`. Edge `(4,5)` → `{4,5}`. A later query `find(0)==find(2)`? Yes. `find(0)==find(4)`? No — two components remain, so the MST is not yet spanning.

## Pitfalls

- **Forgetting path compression OR union-by-size** drops you to O(log n) or worse — a degenerate chain makes `find` O(n).
- **Comparing `a == b` instead of `find(a) == find(b)`.** Membership is about roots, never raw labels.
- **Counting components by scanning roots naively** is O(n); keep a `count` that decrements on every successful `union`.
- **No rollback by default.** Plain union-find cannot undo a merge; if you need to (e.g., offline/backtracking), use union-by-rank *without* path compression plus an undo stack.

## See also

- [[kruskal-s-algorithm]]
- [[minimum-spanning-tree]]
- [[graphs]]
