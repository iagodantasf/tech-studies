---
title: Island (Matrix) Traversal
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [graph-data-structures, breadth-first-search]
see-also: [depth-first-search, breadth-first-search, disjoint-set-union-find]
---

# Island (Matrix) Traversal

Treat a 2D grid as an implicit graph — each cell a node, adjacent cells edges — and flood-fill connected regions with [[graph-algorithms]] or [[graph-algorithms]] to count, size, or transform "islands".

## Why it matters

A grid is a graph you never have to build: neighbors are just `(r±1, c)` and `(r, c±1)`. This pattern solves number-of-islands, max-area-of-island, flood fill (paint bucket), surrounded-regions, rotting-oranges (multi-source BFS), and shortest-path-in-a-maze. It appears constantly in image processing, game maps, and connected-component labeling. The whole grid is visited once: **O(rows × cols)** time, with each cell pushed and popped a single time.

## How it works

Scan every cell; when you hit an unvisited "land" cell, launch a traversal that claims its entire connected region, marking cells visited so they are never re-counted.

| Choice | DFS | BFS |
|---|---|---|
| Frontier | recursion / explicit stack | queue |
| Memory | O(r·c) worst (deep recursion) | O(min(r,c)) typical frontier |
| Use it for | counting / sizing regions | shortest path, multi-source spread |

```text
for r in rows: for c in cols:
    if grid[r][c] == '1':            # unvisited land
        count += 1
        dfs(r, c)                    # sink the whole island

dfs(r, c):
    if out_of_bounds or grid[r][c] != '1': return
    grid[r][c] = '0'                 # mark visited in place
    for dr, dc in [(1,0),(-1,0),(0,1),(0,-1)]:
        dfs(r+dr, c+dc)
```

- Marking visited (flip to `'0'` or a seen-set) is what makes it O(r·c) instead of looping forever.
- Use the 4 cardinal deltas for edge-adjacency; add the 4 diagonals (8 total) if corners connect.

## Example

Grid below has **3** islands. The scan finds land at `(0,0)` and sinks the top-left 2×2 block; later it finds the lone `1` at `(2,2)`, then the `1`s at the bottom-right, each a fresh `count++`.

```
1 1 0 0 0
1 1 0 0 0
0 0 1 0 0
0 0 0 1 1
```

## Pitfalls

- **No visited-marking → infinite loop**: neighbors point back at each other, so unmarked DFS recurses forever. Mark *before* recursing.
- **Deep recursion stack overflow** on a giant all-land grid (e.g. 10⁶ cells) — switch to an explicit stack or BFS queue.
- **Diagonal vs cardinal connectivity** changes the island count; confirm whether the problem links 4- or 8-neighbors.
- **For "count distinct regions while edges keep arriving"**, a one-shot flood-fill is wrong — use [[disjoint-set-union-find]] to merge components dynamically.

## See also

- [[graph-algorithms]]
- [[graph-algorithms]]
- [[disjoint-set-union-find]]
