---
title: Heaps & priority queues
track: computer-science
group: Data structures
tags: [cs, data-structures, heaps]
prerequisites: [arrays-and-dynamic-arrays, trees]
see-also: [stacks-and-queues, graphs]
---

# Heaps & priority queues

A **priority queue** is an abstract structure that always removes the highest- (or lowest-) priority
element next. A **binary heap** is the usual implementation: a complete binary tree where every
parent dominates its children, stored compactly in an array.

## Why it matters

When you repeatedly need "the smallest/largest remaining item" — without keeping everything fully
sorted — a heap gives you O(log n) insert and O(log n) extract-min, plus O(1) peek. That's the engine
behind Dijkstra's shortest paths and A* (see [[graphs]]), event simulations, task schedulers, and
top-k / streaming-median problems.

## How it works

A **min-heap** invariant: every parent ≤ its children, so the minimum is always at the root. The tree
is *complete* (filled left to right), which lets you store it in a plain
[[arrays-and-dynamic-arrays|array]] with no pointers:

```
parent(i) = (i-1)/2     left(i) = 2i+1     right(i) = 2i+2
```

- **Insert** — append at the end, then **sift up**: swap with the parent while it's smaller. O(log n).
- **Extract-min** — take the root, move the last element to the root, then **sift down**: swap with
  the smaller child while out of order. O(log n).
- **Heapify** — turn an unordered array into a heap bottom-up in **O(n)** (better than n inserts).

| Operation | Cost |
|---|---|
| Peek min/max | O(1) |
| Insert | O(log n) |
| Extract min/max | O(log n) |
| Build from array | O(n) |

Note a heap is only *partially* ordered — siblings have no relationship — so it does **not** support
fast search or sorted iteration. If you need those, use a balanced [[trees|BST]] instead.

## Example

Heapsort: build a heap, then extract-min n times → sorted output, O(n log n), in place.

```
function extract_min(heap):
    min ← heap[0]
    heap[0] ← heap.pop_last()
    sift_down(heap, 0)
    return min
```

## Pitfalls

- **Expecting sorted order** — a heap array is not sorted; only the root is guaranteed extremal.
- **Wrong heap type** — need largest? Use a max-heap (or negate keys in a min-heap).
- **Updating a key** — changing an element's priority needs a *decrease-key* with its index, not a
  search; track positions if your algorithm (e.g. Dijkstra) requires it.

## See also

- [[trees]]
- [[graphs]]
