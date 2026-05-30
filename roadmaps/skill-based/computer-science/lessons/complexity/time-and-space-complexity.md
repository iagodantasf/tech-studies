---
title: Time & space complexity
track: computer-science
group: Complexity
tags: [cs, complexity, analysis]
prerequisites: [asymptotic-notation]
see-also: [complexity-classes, recursion, divide-and-conquer]
---

# Time & space complexity

Time complexity counts how many **basic operations** an algorithm performs as `n` grows; space
complexity counts how much **extra memory** it needs beyond the input.

## Why it matters

Picking an algorithm is a trade between these two budgets. A hash map buys `O(1)` lookups with
`O(n)` space; an in-place sort saves memory at the cost of clarity. Knowing how to *count* both —
including the hidden cost of the **call stack** in [[recursion]] — is what turns
[[asymptotic-notation|Big-O]] from a label into a tool you can apply to your own code.

## How it works

**Time** — count the dominant operation as a function of `n`, then reduce with the asymptotic rules:

- **Sequential** statements add: `O(a) + O(b) = O(max(a, b))`.
- **Nested** loops multiply: a loop of `n` inside a loop of `n` is `O(n^2)`.
- **Halving** the work each step gives `O(log n)`; halving-then-merging gives `O(n log n)`.

**Space** — count memory that scales with the input: auxiliary arrays, hash tables, and the
recursion stack. An algorithm can be `O(n)` time but `O(1)` *auxiliary* space (in-place), or `O(n)`
extra (out-of-place).

**Recurrences** capture [[divide-and-conquer]] cost. `T(n) = 2·T(n/2) + O(n)` (split in two, linear
merge) solves to `O(n log n)` by the **Master Theorem** — the recursion tree has `log n` levels each
doing `O(n)` work.

**Amortized** analysis averages an expensive-but-rare operation over many cheap ones: a dynamic
array's push is `O(n)` only when it resizes, but `O(1)` *amortized* because doublings are geometric.

## Example

```
function sum_pairs(A):          # n = length(A)
    total ← 0                   # O(1) space
    for i in 0 … n-1:           # outer: n
        for j in i+1 … n-1:     # inner: ~n/2 on average
            total ← total + A[i]*A[j]
    return total
# operations ≈ n*(n-1)/2  →  Θ(n^2) time, Θ(1) auxiliary space
```

## Pitfalls

- **Forgetting stack space in recursion.** Depth-`n` recursion costs `O(n)` memory even with no
  explicit array — and can overflow the stack.
- **Counting the input as extra space.** Space complexity is usually *auxiliary*; the input itself
  does not count unless you copy it.
- **Hidden costs in library calls.** Slicing, string concatenation, or `in` on a list may each be
  `O(n)`, silently turning a loop into `O(n^2)`.

## See also

- [[asymptotic-notation]]
- [[complexity-classes]]
- [[recursion]]
- [[divide-and-conquer]]
