---
title: AVL Trees
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, balanced-trees]
prerequisites: [binary-search-trees, tree-traversal]
see-also: [red-black-trees, 2-3-trees, b-trees]
---

# AVL Trees

A self-balancing [[trees]] that keeps the height of every node's two subtrees within 1, guaranteeing O(log n) search, insert, and delete.

## Why it matters

A plain BST degrades to a linked list (O(n)) on sorted input — exactly the order data often arrives in. AVL was the first balanced BST (Adelson-Velsky and Landis, 1962) and stays the tightest: its height is at most ~1.44·log₂(n), so lookups touch fewer nodes than a [[red-black-trees]]. That makes it the right pick for read-heavy in-memory indexes where lookups vastly outnumber writes.

## How it works

Each node stores a **balance factor** = height(left) − height(right), kept in {−1, 0, +1}. An insert or delete updates heights up the path to the root; the first node where |bf| reaches 2 is rebalanced with a rotation.

| Case | Trigger (bf) | Fix |
|---|---|---|
| Left-Left | +2, left child +1 | one right rotation |
| Right-Right | −2, right child −1 | one left rotation |
| Left-Right | +2, left child −1 | left on child, then right |
| Right-Left | −2, right child +1 | right on child, then left |

- A rotation is O(1) pointer surgery; only the heights of the rotated nodes change.
- **Insert** needs at most **one** rotation (single or double) to restore balance.
- **Delete** may need up to **O(log n)** rotations, since rebalancing can cascade toward the root.

## Example

Insert 1, 2, 3 into an empty tree. After 1 and 2 the tree leans right; inserting 3 gives node 1 a balance factor of −2 (Right-Right):

```
  1               2
   \   --left--> / \
    2           1   3
     \
      3
```

One left rotation about `1` yields a balanced tree of height 1 instead of the height-2 chain a plain BST would build.

## Pitfalls

- **Forgetting to recompute heights after a rotation** — the child heights must be set before the parent's, or balance factors go stale and the next op corrupts the structure.
- **Stopping rebalance too early on delete.** Unlike insert, one rotation may not be enough; you must keep checking ancestors up to the root.
- **More rotations than [[red-black-trees]].** AVL's stricter invariant means write-heavy workloads pay extra rotations — prefer RB trees there.
- Storing full height vs. a 2-bit balance factor wastes memory; the bf alone suffices and updates faster.

## See also

- [[red-black-trees]]
- [[trees]]
- [[b-trees]]
