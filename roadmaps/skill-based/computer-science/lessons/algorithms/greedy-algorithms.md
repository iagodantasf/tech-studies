---
title: Greedy algorithms
track: computer-science
group: Algorithms
tags: [cs, algorithms, greedy]
prerequisites: [sorting, asymptotic-notation]
see-also: [dynamic-programming, graph-algorithms]
---

# Greedy algorithms

A greedy algorithm builds a solution one step at a time, always taking the choice that looks best
right now and never reconsidering it.

## Why it matters

When it works, greedy is the simplest and fastest tool there is — often just a [[sorting|sort]] plus
a linear pass. Interval scheduling, Huffman coding, and the minimum-spanning-tree and shortest-path
[[graph-algorithms|graph algorithms]] (Prim, Kruskal, [[graph-algorithms|Dijkstra]]) are all greedy.
The hard part is knowing *when* greedy is actually correct.

## How it works

A greedy strategy is provably optimal only when the problem has:

- **Greedy choice property** — a locally optimal choice is part of some globally optimal solution.
- **Optimal substructure** — an optimal solution contains optimal solutions to subproblems.

If a problem has overlapping subproblems but **no** greedy choice property, greedy fails and you need
[[dynamic-programming|dynamic programming]] instead.

```
function activity_selection(intervals):
    sort intervals by finish time
    last_end ← -∞; chosen ← []
    for (start, end) in intervals:
        if start >= last_end:        # greedy: take earliest-finishing compatible
            chosen.append((start, end))
            last_end ← end
    return chosen
```

| Problem | Greedy works? |
|---|---|
| Activity selection | yes (earliest finish) |
| Huffman coding | yes (merge two smallest) |
| 0/1 knapsack | no — use [[dynamic-programming]] |

## Example

**Coin change, canonical system** `{25, 10, 5, 1}`: to make 30, take the largest coin `≤ 30` (25),
then largest `≤ 5` (5) — two coins. Greedy is optimal here, but on a system like `{1, 3, 4}` making 6
greedily gives `4+1+1` (three coins) when `3+3` (two) is better — proof that greedy needs the right
structure.

## Pitfalls

- **Assuming greedy is optimal without proof** — it's right surprisingly often and wrong just as
  silently; verify the greedy-choice property or find a counterexample.
- **Sorting by the wrong key** — activity selection by *start* time or shortest duration both fail;
  earliest *finish* time is what's provably correct.
- **No backtracking** — greedy never undoes a choice, so one wrong early commit dooms the result.

## See also

- [[dynamic-programming]]
- [[graph-algorithms]]
