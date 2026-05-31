---
title: B-Trees
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, disk-structures]
prerequisites: [binary-search-trees, 2-3-trees]
see-also: [indexing, isam, databases]
---

# B-Trees

A balanced, multi-way search tree where every node holds many keys and children, designed to minimize disk/SSD reads by matching node size to a storage block.

## Why it matters

On disk, the cost is the **number of block reads**, not comparisons. A binary tree over 10⁹ keys is ~30 levels deep — 30 random I/Os per lookup. A B-tree with ~1000 keys per node is only 3–4 levels deep, so the same lookup is 3–4 I/Os. This is why B-trees (and the B⁺-tree variant) back nearly every relational [[databases]] index and many filesystems (NTFS, ext4 htree).

## How it works

A B-tree of **order m** keeps each node between ⌈m/2⌉−1 and m−1 keys, all leaves at the same depth. Keys in a node are sorted; the c+1 child pointers separate the k key ranges.

| Property | Rule |
|---|---|
| Keys per node | ⌈m/2⌉−1 to m−1 (root: 1 to m−1) |
| Children per internal node | one more than its key count |
| Height | O(log_m n) |
| Leaf depth | all leaves equidistant from root |

- **Search** descends, binary-searching within each node's key array.
- **Insert** adds to a leaf; if it overflows (m keys), **split** at the median, pushing the median up — splits propagate toward the root, growing height only when the root itself splits.
- **Delete** can underflow a node; fix by **borrowing** a key from a sibling or **merging** two siblings, possibly cascading up.

The **B⁺-tree** variant stores all values in the leaves and links leaves in a list, making range scans a sequential walk.

## Example

Order-4 tree (max 3 keys/node), insert `1,2,3` then `4`. The leaf `[1,2,3]` is full; adding 4 splits at median 2:

```
[1 2 3]  + 4  -->     [2]
                      /   \
                  [1]     [3 4]
```

The median `2` rises to become a new root; height grows from 0 to 1 only because the root split.

## Pitfalls

- **Choosing m by intuition.** Set node size ≈ one storage block (e.g. 4–16 KB) so each node read is one I/O; an oversized node wastes a read, an undersized one adds levels.
- **Confusing B-tree with B⁺-tree.** Only B⁺ keeps data solely in leaves and links them — required for efficient range queries; plain B-trees scatter values internally.
- **Forgetting the root's relaxed minimum** (it may hold a single key) leads to bogus underflow handling at the top.
- Treating it like a binary tree: rebalancing is split/merge, not rotation — see [[2-3-trees]] for the smallest case.

## See also

- [[indexing]]
- [[2-3-trees]]
- [[databases]]
