---
title: Graph algorithms (BFS, DFS, Dijkstra)
track: computer-science
group: Algorithms
tags: [cs, algorithms, graphs]
prerequisites: [graphs, stacks-and-queues, heaps-and-priority-queues]
see-also: [searching, greedy-algorithms, dynamic-programming]
---

# Graph algorithms (BFS, DFS, Dijkstra)

Graph algorithms traverse or search a network of nodes and edges; the foundational three are
**breadth-first search (BFS)**, **depth-first search (DFS)**, and **Dijkstra's** shortest path.

## Why it matters

Almost anything with relationships is a [[graphs|graph]] — maps, social networks, dependency trees,
the web — and BFS, DFS, and Dijkstra answer the core questions: what's reachable, what's connected,
and what's the shortest route. They're also the scaffolding for topological sort, cycle detection,
and connected components.

## How it works

BFS and DFS differ only by the data structure holding the frontier:

- **BFS** — a [[stacks-and-queues|queue]] (FIFO). Visits nodes in layers; finds shortest paths in
  **unweighted** graphs. `O(V + E)`.
- **DFS** — a [[stacks-and-queues|stack]] (or [[recursion|recursion]]). Dives deep first; underlies
  topological sort and cycle detection. `O(V + E)`.
- **Dijkstra** — a min-[[heaps-and-priority-queues|priority queue]]. Greedily expands the
  nearest unsettled node; shortest paths on **non-negative weighted** graphs. `O((V + E) log V)`.

A **visited** set is mandatory or cycles loop forever.

| Algorithm | Frontier | Use |
|---|---|---|
| BFS | queue | shortest path, unweighted |
| DFS | stack / recursion | topo sort, cycles |
| Dijkstra | priority queue | shortest path, weighted ≥ 0 |

Dijkstra is a [[greedy-algorithms|greedy]] algorithm; with negative edges it breaks, and you need
Bellman-Ford instead.

## Example

```
function bfs(graph, start):
    queue ← [start]; visited ← {start}
    while queue not empty:
        node ← queue.pop_front()
        for nb in graph.neighbors(node):
            if nb not in visited:
                visited.add(nb)
                queue.push_back(nb)
```

Swap the queue for a stack (or recurse) and the same skeleton becomes DFS.

## Pitfalls

- **No visited set** — any cycle sends BFS/DFS into an infinite loop.
- **Dijkstra with negative weights** — the greedy assumption fails and it returns wrong distances;
  use Bellman-Ford.
- **Using DFS for shortest paths in unweighted graphs** — it finds *a* path, not the shortest; BFS is
  what guarantees minimum hops.

## See also

- [[graphs]]
- [[greedy-algorithms]]
