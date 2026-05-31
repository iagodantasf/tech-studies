---
title: Basic Data Structures
track: datastructures-and-algorithms
group: Language & foundations
tags: [datastructures-and-algorithms, data-structures]
prerequisites: [language-syntax]
see-also: [array, hash-tables, stack]
---

# Basic Data Structures

The four built-in collections every DSA solution leans on — dynamic array, hash map, hash set, and the stack/queue pair — and the operation costs that decide which one fits.

## Why it matters

Most interview problems are solved by *picking the right container*, not by inventing an algorithm: "two-sum in O(n)" is just "use a [[hash-tables]]," and "valid parentheses" is just "use a [[stacks-and-queues]]." Knowing each structure's amortized costs and your language's exact API lets you reach for the right one in seconds. Getting these four fluent covers the majority of easy/medium problems before any [[complex-data-structures]] is needed.

## How it works

These map to concrete standard-library types; learn the names and the costs together:

| Structure | Python | C++ | Lookup | Insert | Ordered? |
|---|---|---|---|---|---|
| Dynamic array | `list` | `vector` | O(1) by index | O(1) amortized append | yes (insertion) |
| Hash map | `dict` | `unordered_map` | O(1) average | O(1) average | no |
| Hash set | `set` | `unordered_set` | O(1) average | O(1) average | no |
| Stack (LIFO) | `list` | `stack` | top only | O(1) push/pop | n/a |
| Queue (FIFO) | `collections.deque` | `queue` | front only | O(1) push/pop | n/a |

- **Dynamic arrays** grow by doubling capacity, giving amortized O(1) append; inserting at the front is O(n) because the tail shifts (see [[arrays-and-dynamic-arrays]]).
- **Hash structures** give O(1) average lookup but degrade to O(n) on adversarial collisions, and they impose **no order** — never rely on iteration order for correctness.
- **A queue needs the right type.** Python `list.pop(0)` is O(n) (it shifts every element); use `collections.deque` for O(1) `popleft`. This is a frequent silent O(n^2) in BFS.
- Stacks underpin [[graph-algorithms]] and expression parsing; queues underpin [[graph-algorithms]].

## Example

Two-sum in one pass — a hash map turns an O(n^2) nested scan into O(n):

```python
seen = {}                        # value -> index
for i, x in enumerate(nums):
    if target - x in seen:       # O(1) average membership test
        return [seen[target - x], i]
    seen[x] = i                  # remember where we saw x
return []
```

## Pitfalls

- **`list.pop(0)` is O(n)** in Python — using a `list` as a queue turns BFS into O(n^2). Use `collections.deque`.
- **Hash iteration order is not guaranteed** by the language spec (CPython preserves dict *insertion* order, but `set` does not); never depend on it for correctness.
- **Unhashable keys.** A `list`/`dict` can't be a map key or set member in Python — convert to a `tuple` or `frozenset` first.
- **Hash worst case is O(n).** On crafted collisions, `dict`/`unordered_map` degrade; this matters for anti-hash test cases on competitive judges, where a sorted-map fallback is safer.

## See also

- [[arrays-and-dynamic-arrays]]
- [[hash-tables]]
- [[stacks-and-queues]]
