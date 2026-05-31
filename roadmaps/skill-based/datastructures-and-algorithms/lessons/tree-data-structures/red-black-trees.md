---
title: Red-Black Trees
track: datastructures-and-algorithms
group: Tree data structures
tags: [datastructures-and-algorithms, balanced-trees]
prerequisites: [binary-search-trees, 2-3-trees]
see-also: [avl-trees, b-trees, 2-3-trees]
---

# Red-Black Trees

A self-balancing [[trees]] that colors each node red or black and enforces color rules so the longest root-to-leaf path is at most twice the shortest, giving O(log n) operations.

## Why it matters

Red-black trees are the workhorse balanced tree of standard libraries: C++ `std::map`/`std::set`, Java `TreeMap`/`TreeSet`, and the Linux kernel's process scheduler and virtual-memory areas all use them. They win over [[avl-trees]] for write-heavy code because they rebalance with **O(1) rotations** per insert/delete (only recoloring may walk up), trading slightly taller trees for cheaper mutations.

## How it works

The structure is a [[trees]] plus five invariants:

| # | Invariant |
|---|---|
| 1 | every node is red or black |
| 2 | the root is black |
| 3 | every leaf (NIL sentinel) is black |
| 4 | a red node's children are both black (no two reds in a row) |
| 5 | every root→leaf path has the same number of black nodes (black-height) |

- Invariants 4 and 5 together bound height at **2·log₂(n+1)**.
- A new node is inserted **red** (so it cannot break invariant 5), then fixed by recoloring and rotations if it creates a red-red violation with a red parent.
- It is exactly a [[2-3-trees]] / 2-3-4 tree in disguise: a black node plus its red children encode a single multi-key node, and a rotation here mirrors a split/merge there.

## Example

Insert into an empty tree. The new root `10` is forced **black** (invariant 2). Insert `20`: it is red, parent black — fine. Insert `30`: red child of red `20` violates invariant 4 with `20`'s red status, so rotate `10` left and recolor:

```
10(B)                  20(B)
   \      fixup -->    /    \
   20(R)            10(R)   30(R)
      \
      30(R)
```

One left rotation plus a recolor restores all five rules — the same Right-Right shape AVL fixes, but here the cost is bounded rotations regardless of depth.

## Pitfalls

- **Treating NIL as null instead of a black sentinel.** Invariants 3 and 5 are stated over NIL leaves; a single shared black NIL node makes the fixup cases uniform.
- **Skipping the final root recolor.** After fixup the root must be reset to black (invariant 2); forgetting it silently breaks the next insert's reasoning.
- **Mixing up the cases** — the uncle's color decides recolor-only vs. rotate; getting the uncle wrong (especially across left/right symmetry) is the classic bug.
- Expecting AVL-tight lookups: RB trees can be ~2× taller, so for read-mostly data prefer [[avl-trees]].

## See also

- [[avl-trees]]
- [[2-3-trees]]
- [[b-trees]]
