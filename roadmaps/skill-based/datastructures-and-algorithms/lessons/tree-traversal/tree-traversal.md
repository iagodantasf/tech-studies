---
title: Tree Traversal
track: datastructures-and-algorithms
group: Tree traversal
tags: [datastructures-and-algorithms, tree-traversal]
prerequisites: [binary-trees, recursion]
see-also: [in-order-traversal, pre-order-traversal, post-order-traversal, breadth-first-search]
---

# Tree Traversal

The family of strategies for visiting every node of a tree exactly once, in a defined order — the substrate under nearly every tree algorithm.

## Why it matters

A tree has no inherent linear order, so "loop over it" is ambiguous: the *order* you choose changes the answer. Printing a [[trees]] [[tree-traversal]] yields sorted output; serializing one [[tree-traversal]] lets you rebuild it; freeing nodes or computing subtree sizes demands [[tree-traversal]] so children finish before the parent. Picking the wrong order is a silent correctness bug, not a slowdown — the work runs, it just runs on the wrong shape.

## How it works

Two axes split the whole space: **depth-first** (go deep before wide, via a stack/recursion) vs **breadth-first** (level by level, via a queue), and for DFS *when* you visit the node relative to its children.

| Order | Frontier | Visit point | Canonical use |
|---|---|---|---|
| Pre-order | stack | node, then children | copy / serialize a tree |
| In-order | stack | left, node, right | sorted output from a BST |
| Post-order | stack | children, then node | delete, subtree aggregates |
| Level-order | queue | by depth, left→right | shortest hops, [[graph-algorithms]] |

- All four are **O(n) time**; you touch each node and edge a constant number of times.
- **Space is the height** for DFS recursion — O(log n) balanced, O(n) on a degenerate chain — and the **max level width** for BFS, up to O(n) for the last row of a full tree.
- The three DFS orders differ by *one line's position*: the recursive call sequence is identical, only where you emit the node moves.
- Recursion uses the call stack implicitly; an explicit stack (or Morris threading for O(1) space) removes the stack-overflow risk on deep trees.

## Example

In-order DFS on a small BST gives the keys in sorted order:

```
      4
    /   \         visit(left), node, visit(right)
   2     6        => 1, 2, 3, 4, 5, 6, 7
  / \   / \
 1   3 5   7

def inorder(n):
    if not n: return
    inorder(n.left)     # left subtree first
    emit(n.val)         # then the node  -> sorted
    inorder(n.right)    # then right subtree
```

Move `emit` above `inorder(n.left)` and the same code becomes pre-order (`4,2,1,3,6,5,7`).

## Pitfalls

- **Null/empty checks at the wrong spot.** Recurse first, *then* test for null inside the call — guarding before each call duplicates the base case and still misses an empty root.
- **Confusing in-order with sorted in general.** In-order only sorts a *BST*; on an arbitrary [[trees]] it returns an arbitrary order.
- **Recursion depth on skewed trees.** A 100k-node chain blows the default stack (~1k–10k frames); switch to an explicit stack or raise the limit deliberately.
- **Using DFS for shortest-path-by-edges.** Fewest *hops* needs level-order [[graph-algorithms]]; DFS may find a longer path first and report it.

## See also

- [[tree-traversal]]
- [[tree-traversal]]
- [[graph-algorithms]]
