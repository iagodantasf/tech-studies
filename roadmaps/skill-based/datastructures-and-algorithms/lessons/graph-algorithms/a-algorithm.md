---
title: A* Algorithm
track: datastructures-and-algorithms
group: Graph algorithms
tags: [datastructures-and-algorithms, graphs]
prerequisites: [dijkstra-s-algorithm, heap]
see-also: [dijkstra-s-algorithm, shortest-path, breadth-first-search]
---

# A* Algorithm

A* is a best-first [[graph-algorithms]] search that orders the frontier by `f(n) = g(n) + h(n)` — known cost so far plus a heuristic estimate to the goal — making it a goal-directed, far faster relative of [[graph-algorithms]].

## Why it matters

When you need *one* shortest path to a *known* goal — game-map pathfinding, robot motion planning, GPS routing — exploring uniformly like Dijkstra is wasteful. A* steers expansion toward the target using a heuristic, often touching a tiny fraction of the nodes Dijkstra would. It is the default pathfinder in game engines and navigation meshes precisely because a good `h` collapses the search cone while still guaranteeing the optimal path.

## How it works

A* is Dijkstra with the priority key changed from `g(n)` to `f(n) = g(n) + h(n)`, where `h` estimates remaining cost.

| Term | Meaning |
|---|---|
| `g(n)` | actual cheapest cost found from start to `n` |
| `h(n)` | heuristic estimate of cost from `n` to goal |
| `f(n)` | `g(n) + h(n)`, the priority in the min-heap |

```text
open = min-heap by f;  push(start, f=h(start));  g[start]=0
while open:
    n = pop-min(open)
    if n == goal: return reconstruct(n)
    for (m, w) in neighbors(n):
        if g[n] + w < g[m]:
            g[m] = g[n] + w
            push(m, f = g[m] + h(m))   # update parent[m] = n
```

- **Admissible** heuristic (`h` never overestimates true cost) ⇒ A* returns an optimal path.
- **Consistent** heuristic (`h(n) ≤ w(n,m) + h(m)`, the triangle inequality) ⇒ no node is ever re-expanded, so a closed set is safe.
- `h = 0` reduces A* exactly to Dijkstra; an *overestimating* `h` makes it greedy/inadmissible — faster but possibly sub-optimal. Common grid heuristics: Manhattan (4-way), Octile/Chebyshev (8-way), Euclidean (any-angle).

## Example

On an 8×8 grid, start `(0,0)`, goal `(7,7)`, 4-directional moves of cost 1, Manhattan heuristic `h = |Δx|+|Δy|`. At start `h = 14`, `f = 0+14 = 14`. A neighbor `(1,0)` gets `g=1, h=13, f=14`; a step *away* like `(0,1)` toward a wall scores worse and waits in the heap. With an open corridor A* marches almost straight to `(7,7)`, expanding ~15 cells, whereas Dijkstra (`h=0`) would expand most of the 64. Same optimal length 14, far less work.

## Pitfalls

- **Inadmissible heuristic** (overestimates) breaks the optimality guarantee — you may return a longer path. Euclidean distance on a grid that only allows 4-way moves *underestimates*, so it stays safe.
- **Heuristic units must match edge costs.** If edges are travel time but `h` is in meters, `f` is meaningless; scale `h` to the same units.
- **Skipping the stale-entry check.** Lazy heaps need `if popped_f > f[n]: continue`, or you re-process outdated nodes — same gotcha as [[graph-algorithms]].
- **Trusting A* with negative edges.** Like Dijkstra it assumes non-negative weights; use Bellman-Ford-style relaxation instead.

## See also

- [[graph-algorithms]]
- [[graph-algorithms]]
- [[graph-algorithms]]
