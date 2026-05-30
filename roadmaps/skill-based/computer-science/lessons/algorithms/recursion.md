---
title: Recursion
track: computer-science
group: Algorithms
tags: [cs, algorithms, recursion]
prerequisites: [pseudo-code, stacks-and-queues]
see-also: [divide-and-conquer, dynamic-programming, backtracking]
---

# Recursion

Recursion is solving a problem by having a function call itself on smaller inputs until it reaches a
**base case** that's answered directly.

## Why it matters

Recursion is the natural language for anything self-similar — [[trees|trees]], nested structures,
[[divide-and-conquer|divide & conquer]], [[backtracking|backtracking]], and the recurrences behind
[[dynamic-programming|dynamic programming]]. Many problems whose iterative form is a tangle of
explicit stacks collapse into a few clear recursive lines.

## How it works

Every correct recursion needs two parts:

- **Base case** — an input small enough to answer without recursing. Missing or wrong base cases
  cause infinite recursion.
- **Recursive case** — reduce toward the base case and combine sub-results.

Each call gets its own frame on the **call stack** — the same [[stacks-and-queues|stack]] discipline,
managed for you. Depth `d` costs `O(d)` stack space.

```
factorial(n):
    if n <= 1: return 1          # base case
    return n * factorial(n - 1)  # recursive case
```

- **Tail recursion** — the recursive call is the last action; some compilers reuse the frame, making
  it loop-equivalent in space.
- **Tree recursion** — multiple self-calls per level (e.g. naive Fibonacci) can blow up to
  exponential work; **memoization** fixes the overlap and leads into
  [[dynamic-programming|dynamic programming]].

## Example

```
function sum_list(node):
    if node == null: return 0           # base case
    return node.value + sum_list(node.next)
```

This walks a [[linked-lists|linked list]] with one frame per node — clean, but `O(n)` stack depth.

## Pitfalls

- **No reachable base case** — if the argument doesn't strictly shrink toward the base, you recurse
  forever and overflow the stack.
- **Deep recursion blows the stack** — `O(n)` depth on large `n` crashes; convert to iteration or an
  explicit stack.
- **Recomputing overlapping subproblems** — naive tree recursion repeats work exponentially; memoize.

## See also

- [[divide-and-conquer]]
- [[dynamic-programming]]
