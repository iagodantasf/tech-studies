---
title: Trees (BST, AVL, B-tree)
track: computer-science
group: Data structures
tags: [cs, data-structures, trees]
prerequisites: [linked-lists]
see-also: [heaps-and-priority-queues, graphs, tries]
---

# Trees (BST, AVL, B-tree)

A tree is a hierarchical structure of **nodes** with one **root** and no cycles; each node has
children. A **binary tree** limits each node to two children. The shape encodes order or hierarchy,
which is what makes trees fast.

## Why it matters

Trees give you O(log n) search/insert/delete *when balanced* — a middle ground between the O(1)
unordered lookup of [[hash-tables]] and the O(n) scan of a list, with the bonus that data stays
**sorted**. They model file systems, the DOM, parse/expression trees, and database indexes (B-trees).

## How it works

- **Binary search tree (BST)** — invariant: everything in the left subtree `<` the node `<`
  everything in the right. Search by comparing and descending, halving the search space each step:
  ```
  function find(node, key):
      while node ≠ null and node.key ≠ key:
          node ← key < node.key ? node.left : node.right
      return node
  ```
  Balanced → O(log n). But insert sorted data into a plain BST and it degenerates into a
  [[linked-lists|linked list]] → **O(n)**.

- **Self-balancing trees (AVL, red-black)** — restructure via **rotations** on insert/delete to keep
  height ~log n, guaranteeing O(log n). AVL is more rigidly balanced (faster reads); red-black is
  looser (faster writes) and backs many standard libraries (`std::map`, Java `TreeMap`).

- **B-tree / B+ tree** — a *wide* balanced tree where each node holds many keys and has many
  children. Few levels = few disk/page reads, so they're the standard for **database and filesystem
  indexes**.

**Traversals** (how you visit every node): in-order (sorted output for a BST), pre-order, post-order,
and level-order (BFS, using a [[stacks-and-queues|queue]]).

## Example

In-order traversal prints a BST's keys in sorted order:

```
function inorder(node):
    if node = null: return
    inorder(node.left)
    visit(node.key)
    inorder(node.right)
```

## Pitfalls

- **Forgetting to balance** — a "BST" fed sorted input is just a slow list. Use a self-balancing
  variant unless you control the input.
- **Recursion depth** — deep trees can overflow the call stack; use explicit stacks for very deep
  ones.
- **Picking the wrong tree** — in-memory ordered map → red-black; on-disk index → B-tree; prefix
  lookups → [[tries|trie]]; pure priority access → [[heaps-and-priority-queues|heap]].

## See also

- [[heaps-and-priority-queues]]
- [[tries]]
- [[graphs]]
