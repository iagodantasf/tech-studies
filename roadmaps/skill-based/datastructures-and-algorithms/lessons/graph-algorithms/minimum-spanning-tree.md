---
title: Minimum Spanning Tree
track: datastructures-and-algorithms
group: Graph algorithms
tags: [datastructures-and-algorithms, graphs]
prerequisites: [weighted-graph, greedy-algorithms]
see-also: [kruskal-s-algorithm, disjoint-set-union-find, shortest-path]
---

# Minimum Spanning Tree

A minimum spanning tree (MST) is a subset of edges of a connected, undirected, [[graphs]] that connects all `V` vertices with no cycles and the smallest possible total edge weight.

## Why it matters

Any time you must wire up every node as cheaply as possible — laying fiber between cities, routing a chip's clock net, clustering points, or building a low-latency overlay — you are computing an MST. It also appears as a subroutine: a single-linkage clustering is an MST with its `k-1` heaviest edges cut, and Christofides' TSP approximation starts from one. An MST always has exactly `V-1` edges and is unique iff all edge weights are distinct.

## How it works

Two [[greedy-algorithms]] algorithms dominate, both justified by the **cut property**: for any partition of the vertices, the lightest edge crossing the cut is in some MST.

| Algorithm | Grows by | Core structure | Complexity |
|---|---|---|---|
| Kruskal | adding globally cheapest safe edge | union-find | O(E log E) |
| Prim | extending one tree to its nearest vertex | binary / Fibonacci heap | O(E log V) |

```text
# Cut property (why greedy is safe):
for any cut (S, V\S) with no chosen edge crossing it yet,
the minimum-weight crossing edge can always be added to the MST.
```

- **Kruskal** sorts edges, scans cheapest-first, and keeps an edge only if it joins two different components (cycle check via union-find). Great for sparse graphs and edge lists.
- **Prim** behaves like [[graph-algorithms]] but relaxes on raw edge weight, not path distance. With a heap it is O(E log V); with an adjacency matrix and no heap it is O(V²), which wins on dense graphs.
- A **maximum** spanning tree is just an MST on negated weights.

## Example

Graph on `{A,B,C,D}` with edges `AB=1, BC=2, AC=3, CD=4, BD=5`. Sorted: `1,2,3,4,5`. Take `AB(1)`, `BC(2)`; `AC(3)` would close a cycle `A-B-C-A`, skip it; take `CD(4)`. Now `V-1=3` edges chosen — stop. MST weight `= 1+2+4 = 7`, using edges `{AB, BC, CD}`. Prim from `A` picks the same edges in order `AB, BC, CD` by always extending to the nearest unreached vertex.

## Pitfalls

- **A graph can have several MSTs** when weights repeat — total weight is unique, the edge set is not. Tests comparing the exact tree must allow any valid one.
- **MST ≠ shortest-path tree.** The MST minimizes *total* weight; a [[graph-algorithms]] minimizes each root-to-node distance. They often differ.
- **Disconnected graph has no spanning tree** — you get a *minimum spanning forest* (one tree per component); guard for it instead of looping forever.
- **Negative weights are fine** for MST (unlike some shortest-path methods), since the cut property never assumes non-negativity.

## See also

- [[kruskal-s-algorithm]]
- [[disjoint-set-union-find]]
- [[graph-algorithms]]
