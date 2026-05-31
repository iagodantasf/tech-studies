---
title: Cyclic Sort
track: datastructures-and-algorithms
group: Sorting algorithms
tags: [datastructures-and-algorithms, sorting]
prerequisites: [array, two-pointers]
see-also: [two-pointers, selection-sort, common-runtimes]
---

# Cyclic Sort

An in-place O(n) pattern that places each value into its index-determined home by repeated swaps, exploiting the fact that the keys are a bounded range like 1..n.

## Why it matters

It is less a general sort than an **interview pattern** for arrays holding a permutation of `1..n` (or `0..n-1`). Whenever a problem says "n numbers in range [1, n]" and asks for a missing, duplicate, or first-positive value, cyclic sort solves it in O(n) time and O(1) space — beating the sort-then-scan or hash-set approaches. The key insight: value `v` belongs at index `v-1`, so the array can sort itself by following those cycles.

## How it works

Walk index `i`; if `a[i]` is not already at its correct slot, swap it there. Only advance `i` when the current slot is satisfied. Each value reaches home in O(1) amortized swaps.

```text
i = 0
while i < n:
  home = a[i] - 1            # for 1..n; use a[i] for 0..n-1
  if a[i] != a[home]:        # compare by value, not by index
    swap(a[i], a[home])      # send a[i] to its place
  else:
    i += 1                   # in place (or a duplicate) -> move on
```

- **O(n) total swaps:** every swap puts at least one element permanently home, so there are at most n swaps despite the inner loop.
- The guard `a[i] != a[home]` (not `i != home`) is what lets it terminate on **duplicates** instead of swapping forever.
- After sorting, a single scan finds anomalies: the first index where `a[i] != i+1` is the missing number; the value seen at an occupied slot is the duplicate (see [[two-pointers]] for the scan).

## Example

`[3, 1, 5, 4, 2]`, n = 5. i=0: a[0]=3 → swap with index 2 → `[5,1,3,4,2]`; a[0]=5 → swap with index 4 → `[2,1,3,4,5]`; a[0]=2 → swap with index 1 → `[1,2,3,4,5]`; now a[0]=1 is home, advance. The rest are already placed. Result sorted in 3 swaps, O(1) space. With `[3,1,5,4,2,?]` missing one of 1..6, the post-scan flags the first index where `a[i] != i+1`.

## Pitfalls

- **Off-by-one between 1..n and 0..n-1.** Mixing `home = a[i]-1` with a 0-based problem (or vice-versa) corrupts indices; fix the convention first.
- **Guarding on index instead of value** (`while i != home`) infinite-loops on duplicates; always compare `a[i] != a[home]`.
- **Out-of-range values.** Real inputs may contain 0, negatives, or values > n; ignore/skip them or the home index goes out of bounds — central to "first missing positive."
- **Not a comparison sort.** It only works when keys map to indices; arbitrary keys need [[sorting]] or [[sorting]].

## See also

- [[two-pointers]]
- [[sorting]]
- [[common-runtimes]]
