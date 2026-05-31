---
title: Kruskal's Algorithm
track: datastructures-and-algorithms
group: Graph algorithms
tags: [datastructures-and-algorithms, graphs]
prerequisites: [minimum-spanning-tree, disjoint-set-union-find]
see-also: [minimum-spanning-tree, greedy-algorithms, sorting-algorithms]
---

# Kruskal's Algorithm

A [[greedy-algorithms]] algorithm that builds a [[minimum-spanning-tree|minimum spanning tree]] by sorting all edges and adding the cheapest one that does not form a cycle, until `V-1` edges are chosen.

## Why it matters

Kruskal is the go-to MST method for **sparse graphs given as an edge list** — exactly the shape of network-design, clustering, and "connect everything cheaply" problems. It pairs beautifully with [[disjoint-set-union-find|union-find]]: the only non-trivial question — "would this edge create a cycle?" — becomes an O(α(n)) `find`. The whole algorithm is a clean illustration of why the greedy cut property yields a globally optimal tree.

## How it works

Process edges from lightest to heaviest; accept an edge only if its endpoints are currently in different components.

| Step | Operation | Cost |
|---|---|---|
| 1 | sort all `E` edges by weight | O(E log E) |
| 2 | init union-find over `V` vertices | O(V) |
| 3 | for each edge, `find` both ends; if different, `union` + keep | O(E · α(V)) |
| 4 | stop once `V-1` edges accepted | — |

```text
sort(edges by weight)
mst = []
for (u, v, w) in edges:
    if find(u) != find(v):      # endpoints in different components
        union(u, v)
        mst.append((u, v, w))
        if len(mst) == V - 1: break
```

- Total time is **O(E log E)** — the sort dominates; union-find work is near-linear. Since `E ≤ V²`, `log E ≤ 2 log V`, so it is equivalently O(E log V).
- The cycle test is the heart: an edge whose endpoints share a root would close a loop, so it is discarded.
- If edge weights are small integers, replace the comparison sort with a counting/[[radix-sort|radix sort]] to approach O(E).

## Example

Five vertices `0..4`, edges `(0,1,1) (2,3,2) (0,2,3) (1,3,4) (3,4,5)`. Already sorted. Take `(0,1,1)`→`{0,1}`; take `(2,3,2)`→`{2,3}`; take `(0,2,3)` unions to `{0,1,2,3}`; `(1,3,4)` has `find(1)==find(3)` → **skip** (cycle); take `(3,4,5)`→`{0,1,2,3,4}`. Accepted `4 = V-1` edges, weight `1+2+3+5 = 11`. Done.

## Pitfalls

- **Skipping union-find** and checking cycles by traversal is O(VE) — the classic way to turn an O(E log E) algorithm into a timeout.
- **Comparing labels (`u == v`) instead of roots (`find(u) == find(v)`).** Two distinct vertices can already be connected; only the roots reveal it. See [[disjoint-set-union-find]].
- **Not stopping at `V-1` edges** still gives the right tree but wastes time; on a disconnected graph it instead yields a spanning *forest* — assert the count if you require connectivity.
- **Unstable tie handling** does not hurt correctness (any MST is valid) but makes outputs non-deterministic across runs; sort by `(weight, u, v)` if you need reproducibility.

## See also

- [[minimum-spanning-tree]]
- [[greedy-algorithms]]
- [[sorting]]
