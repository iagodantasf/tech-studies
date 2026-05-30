---
title: Graphs
track: computer-science
group: Data structures
tags: [cs, data-structures, graphs]
prerequisites: [linked-lists, hash-tables]
see-also: [trees, stacks-and-queues, heaps-and-priority-queues]
---

# Graphs

A graph is a set of **vertices** (nodes) connected by **edges**. Edges may be **directed** or
**undirected**, and **weighted** or unweighted. A [[trees|tree]] is just a special acyclic, connected
graph — graphs are the general case.

## Why it matters

Graphs model anything relational: social networks, road maps, web links, dependency/build order,
state machines, and network routing. A huge class of real problems reduces to "find a path",
"detect a cycle", or "order these by dependency" on a graph.

## How it works

Two standard representations, with different trade-offs:

- **Adjacency list** — per vertex, a [[linked-lists|list]] of its neighbors (often a
  [[hash-tables|hash map]] of vertex → neighbors). Space O(V + E); best for **sparse** graphs (most
  real ones).
- **Adjacency matrix** — a V×V grid where `M[i][j]` marks an edge. O(1) edge lookup but O(V²) space;
  best for **dense** graphs.

**Traversal** is the foundation of most graph algorithms:

- **BFS** (breadth-first) — explore level by level using a [[stacks-and-queues|queue]]. Finds the
  shortest path in an *unweighted* graph. O(V + E).
- **DFS** (depth-first) — go deep before backtracking, using a stack (or recursion). Powers cycle
  detection, topological sort, and connectivity. O(V + E).

Build on those:

- **Topological sort** — linear ordering of a DAG respecting dependencies (build systems, schedulers).
- **Dijkstra** — shortest path with non-negative weights, using a
  [[heaps-and-priority-queues|priority queue]]. O((V + E) log V).
- **Union-Find, MST (Kruskal/Prim)** — connectivity and minimum spanning trees.

## Example

BFS shortest path (unweighted):

```
function bfs(start):
    queue ← [start]; visited ← {start}; dist[start] ← 0
    while queue not empty:
        u ← queue.dequeue()
        for v in neighbors(u):
            if v not in visited:
                visited.add(v); dist[v] ← dist[u] + 1
                queue.enqueue(v)
    return dist
```

## Pitfalls

- **Forgetting `visited`** — without it, any cycle loops forever.
- **BFS on weighted graphs** — BFS only gives shortest paths when every edge costs the same; use
  Dijkstra otherwise.
- **Wrong representation** — a matrix on a large sparse graph wastes O(V²) memory; a list on a dense
  graph makes edge checks slow.

## See also

- [[trees]]
- [[stacks-and-queues]]
- [[heaps-and-priority-queues]]
