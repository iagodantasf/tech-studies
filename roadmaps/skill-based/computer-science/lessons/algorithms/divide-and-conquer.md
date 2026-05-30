---
title: Divide & conquer
track: computer-science
group: Algorithms
tags: [cs, algorithms, divide-and-conquer]
prerequisites: [recursion, asymptotic-notation]
see-also: [sorting, searching, dynamic-programming]
---

# Divide & conquer

Divide & conquer solves a problem by splitting it into independent subproblems, solving each
[[recursion|recursively]], and combining their answers.

## Why it matters

The pattern turns many `O(n²)` brute-force solutions into `O(n log n)` ones — [[sorting|merge sort]],
[[searching|binary search]], fast multiplication, and closest-pair geometry all flow from it. It's
also the cleanest setting to learn **recurrence analysis**, the math that predicts an algorithm's
runtime.

## How it works

Three steps, applied recursively:

- **Divide** — break the input into smaller subproblems (usually halves).
- **Conquer** — solve each subproblem [[recursion|recursively]]; small ones hit the base case.
- **Combine** — merge the sub-answers into the full answer.

The runtime obeys a recurrence `T(n) = a·T(n/b) + f(n)`, solved by the **Master Theorem**:

| Recurrence | Result | Example |
|---|---|---|
| `T(n) = 2T(n/2) + O(n)` | `O(n log n)` | merge sort |
| `T(n) = 2T(n/2) + O(1)` | `O(n)` | tree traversal |
| `T(n) = T(n/2) + O(1)` | `O(log n)` | binary search |

Unlike [[dynamic-programming|dynamic programming]], the subproblems here are **independent** and
don't overlap — so there's nothing to memoize.

## Example

```
function merge_sort(A):
    if length(A) <= 1: return A          # base case
    mid ← length(A) / 2
    L ← merge_sort(A[0 .. mid])          # divide + conquer
    R ← merge_sort(A[mid .. end])
    return merge(L, R)                   # combine
```

## Pitfalls

- **Combine step dominates** — if merging costs more than the recursion saves, you gain nothing;
  watch `f(n)` in the recurrence.
- **Forgetting the base case** — unsplit trivial inputs recurse forever, same as any
  [[recursion|recursion]].
- **Assuming subproblems are independent** — when they overlap, this becomes wasteful; switch to
  [[dynamic-programming|DP]].

## See also

- [[sorting]]
- [[dynamic-programming]]
