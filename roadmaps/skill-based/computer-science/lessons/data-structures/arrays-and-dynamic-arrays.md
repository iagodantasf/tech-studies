---
title: Arrays & dynamic arrays
track: computer-science
group: Data structures
tags: [cs, data-structures, arrays]
prerequisites: []
see-also: [linked-lists, hash-tables]
---

# Arrays & dynamic arrays

An **array** is a fixed-size, contiguous block of memory holding elements of the same type. A
**dynamic array** (Python `list`, Java `ArrayList`, C++ `vector`, Rust `Vec`) wraps an array and
grows automatically as you append.

## Why it matters

Arrays are the most fundamental data structure — most others (stacks, queues, heaps, hash tables)
are built on top of them. Their contiguous layout makes them extremely **cache-friendly**: walking
an array sequentially is often an order of magnitude faster than chasing pointers, even when the
Big-O is identical.

## How it works

Because elements are contiguous and equal-sized, the address of index `i` is just
`base + i × element_size`. That arithmetic is why **random access is O(1)**.

A dynamic array keeps a `length` (used slots) and a `capacity` (allocated slots). When you append
and `length == capacity`, it:

1. allocates a new, larger block (typically **2× capacity**),
2. copies the existing elements over,
3. frees the old block.

Any single append can therefore be O(n), but because the array *doubles*, those expensive copies
happen geometrically less often — giving **amortized O(1)** append (the same doubling argument that
makes [[hash-tables]] resize cheap).

| Operation | Cost |
|---|---|
| Index / update | O(1) |
| Append (amortized) | O(1) |
| Insert / delete at front or middle | O(n) — shift the tail |
| Search (unsorted) | O(n) |

## Example

```
push_back(arr, x):
    if arr.length == arr.capacity:
        grow(arr, 2 * arr.capacity)   # allocate + copy
    arr.data[arr.length] = x
    arr.length += 1
```

A sorted array supports [[searching]] in O(log n) via binary search — see
`playgrounds/rust/binary-search`.

## Pitfalls

- **Inserting/removing in the middle is O(n)** because every later element shifts. If you do this a
  lot, a [[linked-lists|linked list]] may fit better.
- **Capacity ≠ length** — a dynamic array can hold memory well beyond what you're using; shrink or
  `reserve` deliberately in hot paths.
- **Out-of-bounds access** — in C it's undefined behavior (a security bug); in higher-level languages
  it panics/throws.

## See also

- [[linked-lists]]
- [[hash-tables]]
