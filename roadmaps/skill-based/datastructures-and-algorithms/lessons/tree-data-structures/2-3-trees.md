---
title: 2-3 Trees
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, balanced-trees]
prerequisites: [binary-search-trees]
see-also: [b-trees, red-black-trees, avl-trees]
---

# 2-3 Trees

A balanced search tree where every internal node has either 2 children and 1 key or 3 children and 2 keys, and all leaves sit at the same depth.

## Why it matters

The 2-3 tree is the conceptual seed of every balanced tree that follows. It is the order-3 special case of a [[b-trees]], and a [[red-black-trees]] is exactly a 2-3 tree (or 2-3-4 tree) encoded with color bits in a binary structure. Learning it makes the "split and push up" rebalancing of the whole B-tree family obvious, with the minimal number of moving parts.

## How it works

Two node shapes, both keeping keys sorted left-to-right:

| Node | Keys | Children | Ordering |
|---|---|---|---|
| 2-node | 1 (a) | 2 | left < a < right |
| 3-node | 2 (a,b) | 3 | left < a < mid < b < right |

- **Search** compares against 1 or 2 keys per node and descends the matching range.
- **Insert** always lands at a leaf. Adding to a 2-node makes it a 3-node (done). Adding to a 3-node makes a temporary **4-node** (3 keys) — split it: the middle key moves up to the parent, and the two outer keys become 2-nodes.
- **Balance is automatic:** because growth happens by pushing a key *up*, every leaf stays at the same depth. Height is between log₃(n) and log₂(n), so all operations are O(log n).

## Example

Insert `1, 2, 3` into an empty tree. `[1]` → `[1 2]` (a 3-node) → adding 3 overflows to a 4-node `[1 2 3]`, which splits:

```
[1 2 3]  split -->   [2]
                     /   \
                  [1]     [3]
```

The middle key `2` becomes the new root; both leaves are 2-nodes at equal depth. Contrast a plain BST, which would build the height-2 chain `1→2→3`.

## Pitfalls

- **The 4-node is transient.** It exists only mid-insert; a correct implementation never leaves a node with 3 keys after an operation settles.
- **Splitting the root is the only way height grows** — handle the "parent is full too" case by recursing the split upward, or you lose the equal-depth invariant.
- **Direct pointer code is fiddly** (two node arities, multiple cases), which is precisely why production code uses the [[red-black-trees]] encoding instead.
- Confusing it with a binary tree: a 3-node has three children, so naive in-order logic that assumes left/right only will skip the middle subtree.

## See also

- [[b-trees]]
- [[red-black-trees]]
- [[avl-trees]]
