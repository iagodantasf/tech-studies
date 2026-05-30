---
title: Dynamic programming
track: computer-science
group: Algorithms
tags: [cs, algorithms, dynamic-programming]
prerequisites: [recursion, asymptotic-notation]
see-also: [divide-and-conquer, greedy-algorithms, graph-algorithms]
---

# Dynamic programming

Dynamic programming (DP) solves a problem by breaking it into overlapping subproblems and storing
each subproblem's answer so it's computed only once.

## Why it matters

DP turns exponential brute-force recursions into polynomial-time algorithms, and it's the technique
behind edit distance, longest-common-subsequence, knapsack, and shortest-path relaxation. It's also
the most-feared interview topic precisely because spotting the recurrence is a skill worth drilling.

## How it works

DP applies when a problem has both:

- **Overlapping subproblems** — the same sub-answer is needed many times (unlike
  [[divide-and-conquer|divide & conquer]], where subproblems are independent).
- **Optimal substructure** — an optimal solution is built from optimal sub-solutions (shared with
  [[greedy-algorithms|greedy]], but here a local choice isn't enough).

Two implementation styles:

- **Top-down (memoization)** — write the natural [[recursion|recursion]], cache results in a
  [[hash-tables|hash table]] or array.
- **Bottom-up (tabulation)** — fill a table from base cases upward; often saves stack space and
  enables space optimization.

```
fib(n):                  # top-down memoized
    if n <= 1: return n
    if memo[n] defined: return memo[n]
    memo[n] ← fib(n-1) + fib(n-2)
    return memo[n]
```

Runtime is roughly `(number of states) × (work per state)`.

## Example

**0/1 knapsack** — `dp[i][w]` = best value using the first `i` items within capacity `w`:

```
dp[i][w] = max(
    dp[i-1][w],                          # skip item i
    dp[i-1][w - wt[i]] + val[i]          # take item i, if it fits
)
```

This is `O(n·W)` — pseudo-polynomial — versus the `O(2ⁿ)` of trying every subset.

## Pitfalls

- **Wrong state definition** — if your state doesn't capture everything that affects the answer, the
  recurrence is incorrect; missing dimensions is the classic bug.
- **Reaching for DP when greedy suffices** — if a [[greedy-algorithms|greedy]] choice is provably
  optimal, DP is overkill.
- **Iteration order in tabulation** — a cell must be filled before any cell that depends on it, or
  you read stale values.

## See also

- [[recursion]]
- [[greedy-algorithms]]
