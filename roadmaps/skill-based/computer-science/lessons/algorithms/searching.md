---
title: Searching (linear, binary)
track: computer-science
group: Algorithms
tags: [cs, algorithms, searching]
prerequisites: [arrays-and-dynamic-arrays]
see-also: [hash-tables]
---

# Searching (linear, binary)

Searching is finding an element (or deciding it's absent) in a collection. The two foundational
algorithms are **linear search** — scan every element — and **binary search** — repeatedly halve a
*sorted* range.

## Why it matters

Search is everywhere, and the jump from O(n) to O(log n) is the cleanest illustration of why
algorithmic thinking pays off: on a billion sorted items, linear search may touch a billion elements
while binary search touches ~30. Binary search also generalizes far beyond arrays into "search on the
answer", a technique that cracks a whole category of problems.

## How it works

**Linear search** — O(n), works on any (even unsorted) sequence:
```
for i in 0 … n-1:
    if A[i] == target: return i
return NOT_FOUND
```

**Binary search** — O(log n) time, O(1) space, but requires a **sorted**
[[arrays-and-dynamic-arrays|array]]:

- **Invariant**: the target, if present, is always within `[lo, hi]`. Each step shrinks that range by
  half.
- Compute the midpoint as `lo + (hi - lo) / 2`, **not** `(lo + hi) / 2` — the latter can overflow in
  fixed-width integers.
- Two common shapes:
  - *Inclusive* `[lo, hi]` with `while lo <= hi`.
  - *Half-open* `[lo, hi)` with `while lo < hi` — fewer off-by-ones, and ideal for **lower-bound /
    first-true** problems.

```
function binary_search(A, target):
    lo ← 0; hi ← length(A) - 1
    while lo <= hi:
        mid ← lo + (hi - lo) / 2
        if A[mid] == target: return mid
        else if A[mid] < target: lo ← mid + 1
        else: hi ← mid - 1
    return NOT_FOUND
```

**Binary search on the answer** — any monotonic predicate `f(x)` (false…false, true…true) can be
searched for its first `true`. This turns "find the minimum capacity that works" style optimization
problems into a log-factor search.

When you need *unordered* O(1) lookup instead of sorted O(log n), reach for a [[hash-tables|hash
table]] — the trade is losing order and prefix/range queries.

## Example

Runnable Rust implementation with tests:
`playgrounds/rust/binary-search` → `cargo run -p binary-search` / `cargo test -p binary-search`.

## Pitfalls

- **Searching unsorted data with binary search** — it silently returns wrong answers; the sorted
  precondition is mandatory.
- **Off-by-one in the bounds update** — mixing `mid` vs `mid ± 1` with the loop condition is the
  classic bug. Pick one shape (inclusive or half-open) and stay consistent.
- **Midpoint overflow** — `(lo + hi)` can exceed the integer max on large arrays in C/Java; use
  `lo + (hi - lo) / 2`.

## See also

- [[arrays-and-dynamic-arrays]]
- [[hash-tables]]
