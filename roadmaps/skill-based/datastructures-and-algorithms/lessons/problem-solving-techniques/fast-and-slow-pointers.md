---
title: Fast and Slow Pointers
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [linked-lists, two-pointers]
see-also: [two-pointers, linked-lists, sliding-window]
---

# Fast and Slow Pointers

Two pointers advancing at different speeds — one by 1, one by 2 — so the gap between them encodes cycle length, list midpoint, or position-from-end in a single O(n) pass with O(1) memory.

## Why it matters

Also called **Floyd's tortoise and hare**, it answers questions that otherwise need a [[hash-tables]] of visited nodes: detect a cycle in a [[linked-lists]], find the cycle's entry point, locate the middle node, or test if a number's digit-square chain reaches 1 (happy number). The win is space: O(1) instead of O(n) for the visited-set approach, which matters on huge or memory-constrained lists where you cannot store every node.

## How it works

`slow` moves one step, `fast` two. If a cycle exists they must eventually meet inside it (the gap shrinks by 1 each tick); on a finite acyclic list `fast` falls off the end.

| Goal | Setup | Read-off |
|---|---|---|
| Detect cycle | both at head, 1× / 2× | they meet ⇒ cycle exists |
| Find cycle start | after meet, reset `slow` to head, both 1× | next meeting node = entry |
| Find middle | both at head, 1× / 2× | `slow` is mid when `fast` ends |
| Nth from end | advance `fast` n steps first, then both 1× | `slow` lands on target |

```text
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
    if slow is fast: return CYCLE     # references equal, not values
return NO_CYCLE
```

- Meeting is guaranteed because in a cycle of length C the relative speed is 1, so they collide within C steps.
- Entry point works by a distance identity: head-to-entry equals meeting-point-to-entry along the loop.

## Example

List `3 → 2 → 0 → -4 → (back to 2)`. `slow/fast` start at 3. Tick 1: slow=2, fast=0. Tick 2: slow=0, fast=2 (looped). Tick 3: slow=-4, fast=-4 — meet, cycle confirmed. Reset `slow` to head 3, step both by 1: they next meet at node 2, the cycle's entry.

## Pitfalls

- **Null-deref on even-length lists:** test `fast and fast.next` *before* `fast.next.next`, or you crash at the tail.
- **Comparing values instead of node identity** — duplicate values are common; compare references (`is`/`==` on pointers), never payloads.
- **Wrong midpoint parity:** for even length, `slow` lands on the *second* middle; start `fast` at `head.next` if you want the first.
- **Assuming meeting point is the cycle start** — it is not; you must do the second reset-and-walk phase to find the entry.

## See also

- [[two-pointers]]
- [[linked-lists]]
- [[sliding-window]]
