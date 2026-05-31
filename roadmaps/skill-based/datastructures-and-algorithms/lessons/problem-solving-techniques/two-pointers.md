---
title: Two Pointers
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [array, sorting-algorithms]
see-also: [sliding-window, fast-and-slow-pointers, binary-search]
---

# Two Pointers

Walk two indices through a sequence — converging from both ends or advancing in tandem — to turn an O(n²) pair search into a single O(n) pass.

## Why it matters

The pattern collapses nested loops whenever the data is **sorted** (or can be) and the answer depends on a relationship between two positions: pair-with-target-sum, container-with-most-water, 3-sum, dedup-in-place, palindrome checks, and merging two sorted runs. It is O(n) time and O(1) extra space, so it beats the [[hash-tables]] approach when memory is tight or the array is already ordered. It is the workhorse behind [[sorting]]'s merge step and partition routines.

## How it works

Two flavors, chosen by how the pointers move:

| Variant | Start positions | Movement rule | Solves |
|---|---|---|---|
| Converging | `lo=0`, `hi=n-1` | shrink the wrong end inward | sorted pair-sum, palindrome, max-area |
| Same-direction | `slow=0`, `fast=0` | `fast` scans, `slow` writes | in-place dedup, partition, move-zeros |

```text
lo, hi = 0, n-1                  # converging, sorted array
while lo < hi:
    s = a[lo] + a[hi]
    if s == target: return (lo, hi)
    elif s < target: lo += 1     # need bigger -> raise low end
    else: hi -= 1                # need smaller -> lower high end
return NONE
```

- Each step moves *exactly one* pointer, so the loop is O(n): the two indices together travel at most n.
- The sorted-array invariant is what justifies the move: if the sum is too small, only raising `lo` can help.

## Example

Sorted `[1, 3, 4, 6, 8, 11]`, target 10. Start `lo=0(1), hi=5(11)` → sum 12 > 10, drop `hi`. `1+8=9 < 10`, raise `lo`. `3+8=11 > 10`, drop `hi`. `3+6=9 < 10`, raise `lo`. `4+6=10` — hit at indices `(2,3)` in 4 steps versus 15 pairs for brute force.

## Pitfalls

- **Forgetting the data must be sorted** for the converging form — applying it to unsorted input gives wrong answers; sort first (adds O(n log n)) or use a hash set instead.
- **Off-by-one at the boundary:** use `while lo < hi` (not `<=`) for pair problems so an element is never matched with itself.
- **Skipping duplicates wrong in 3-sum**: after recording a hit, advance both pointers *past* equal neighbors or you emit duplicate triples.
- **Confusing it with [[sliding-window]].** Two-pointers usually shrinks from both ends on sorted data; a window grows/shrinks one contiguous range on a stream — different invariants.

## See also

- [[sliding-window]]
- [[fast-and-slow-pointers]]
- [[searching]]
