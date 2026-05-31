---
title: Control Structures
track: datastructures-and-algorithms
group: Language & foundations
tags: [datastructures-and-algorithms, control-flow]
prerequisites: [language-syntax]
see-also: [functions, recursion, two-pointers]
---

# Control Structures

The branching and looping primitives — `if`/`else`, `for`, `while`, `break`/`continue` — that turn a flat list of statements into an algorithm with decisions and repetition.

## Why it matters

Loop structure *is* time complexity: one pass is O(n), a nested pass is O(n^2), halving each step is O(log n). Reading a problem's required complexity tells you the loop shape before you write a line. Most off-by-one and infinite-loop bugs trace back to a loop bound or a missing pointer advance, so disciplined control flow is where correctness lives.

## How it works

The loop you reach for encodes the access pattern:

| Loop form | When | Complexity signal |
|---|---|---|
| `for i in range(n)` | known count, index needed | one pass, O(n) |
| `for x in seq` | iterate values only | O(n), fewer index bugs |
| `while lo < hi` | two pointers converging | O(n), see [[two-pointers]] |
| `while lo <= hi` | binary search on a range | O(log n), see [[searching]] |
| nested `for`/`for` | all pairs | O(n^2) |

- **`break` exits the innermost loop; `continue` skips to its next iteration.** To break out of nested loops, either flag-and-check, refactor the inner loop into a function and `return`, or (Python) use a `for/else` where `else` runs only if no `break` fired.
- **`while True` with an internal `break`** is the clean idiom for "loop until a condition mid-body," e.g. fast/slow pointer cycle detection.
- A `for/else` clause (Python) is a precise way to express "did the search loop find nothing?" without a sentinel boolean.

## Example

Binary search — the bound `lo <= hi` and the `mid + 1`/`mid - 1` updates are the whole correctness argument:

```python
lo, hi = 0, len(a) - 1
while lo <= hi:                 # <= : single-element range still checked
    mid = lo + (hi - lo) // 2  # avoids overflow vs (lo + hi)
    if a[mid] == target: return mid
    if a[mid] < target: lo = mid + 1   # must move past mid
    else:               hi = mid - 1
return -1
```

## Pitfalls

- **Infinite loop from a non-advancing bound.** Writing `lo = mid` (instead of `mid + 1`) when the target is in the upper half never shrinks the range — the classic binary-search hang.
- **`break` only leaves one level.** In nested loops it does not exit the outer loop; many "why did it keep going?" bugs are this.
- **Off-by-one in the terminating comparison.** `<` vs `<=` decides whether the last element is examined; pick it from whether your range is inclusive.
- **Mutating a collection while iterating it** invalidates the loop in most languages — collect changes and apply after, or iterate a copy.

## See also

- [[functions]]
- [[recursion]]
- [[two-pointers]]
