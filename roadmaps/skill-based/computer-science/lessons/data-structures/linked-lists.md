---
title: Linked lists
track: computer-science
group: Data structures
tags: [cs, data-structures, linked-lists]
prerequisites: [arrays-and-dynamic-arrays]
see-also: [stacks-and-queues]
---

# Linked lists

A linked list stores elements in **nodes**, each holding a value and a pointer to the next node (and,
in a doubly linked list, the previous one). Unlike an array, the nodes are **not contiguous** in
memory.

## Why it matters

Linked lists are the textbook counterpoint to [[arrays-and-dynamic-arrays|arrays]]: O(1)
insertion/deletion once you hold a node, but no random access. They underpin [[stacks-and-queues]],
adjacency lists in [[graphs]], and the chaining variant of [[hash-tables]]. Understanding them is
mostly understanding **pointer manipulation**.

## How it works

```
Node { value, next }
head → [a|•] → [b|•] → [c|∅]
```

- **Singly linked** — each node points to `next` only. Traverse forward; O(1) prepend.
- **Doubly linked** — nodes also point to `prev`. O(1) delete of a known node; traverse both ways.
- **Circular** — the tail points back to the head; handy for round-robin buffers.

| Operation | Cost |
|---|---|
| Prepend / pop front | O(1) |
| Insert / delete at a known node | O(1) |
| Index / search | O(n) — no random access |
| Append (with tail pointer) | O(1) |

The trade vs an array: you gain cheap structural edits but lose cache locality (every `next` is a
pointer chase) and pay one pointer of memory overhead per element.

## Example

Reverse a singly linked list in place — a classic pointer exercise:

```
function reverse(head):
    prev ← null
    while head ≠ null:
        next ← head.next
        head.next ← prev
        prev ← head
        head ← next
    return prev      # new head
```

## Pitfalls

- **Losing the rest of the list** — always capture `next` *before* you rewrite a node's pointer
  (see the `next ← head.next` line above).
- **Null/edge cases** — empty list, single node, and operations at the head need explicit handling.
- **Reaching for it by default** — in practice a dynamic array usually wins, because cache locality
  beats asymptotics for small/medium n. Use a linked list when you genuinely need O(1) splicing.

## See also

- [[arrays-and-dynamic-arrays]]
- [[stacks-and-queues]]
