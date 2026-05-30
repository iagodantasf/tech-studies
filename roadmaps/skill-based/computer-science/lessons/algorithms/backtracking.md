---
title: Backtracking
track: computer-science
group: Algorithms
tags: [cs, algorithms, backtracking]
prerequisites: [recursion]
see-also: [dynamic-programming, graph-algorithms]
---

# Backtracking

Backtracking explores candidate solutions [[recursion|recursively]], abandoning ("backtracking" on) a
partial candidate the moment it can't possibly lead to a valid one.

## Why it matters

It's the go-to method for constraint-satisfaction and combinatorial-search problems — permutations,
subsets, Sudoku, N-queens, maze solving, and parsing. Backtracking systematically explores the whole
solution space while **pruning** dead branches, which is what makes an otherwise exponential search
tractable in practice.

## How it works

Picture the search as a tree: each node is a partial solution, each edge a choice. Backtracking is a
depth-first walk of that tree with three moves:

- **Choose** — extend the partial solution with one option.
- **Explore** — recurse to extend it further.
- **Un-choose** — undo the choice and try the next option.

**Pruning** is the whole point: a `is_valid` / bound check that cuts a subtree before exploring it.

```
function backtrack(state):
    if is_complete(state): record(state); return
    for choice in options(state):
        if is_valid(state, choice):
            apply(state, choice)         # choose
            backtrack(state)             # explore
            undo(state, choice)          # un-choose
```

Unlike [[dynamic-programming|DP]], the subproblems here usually don't overlap — you're searching, not
reusing answers.

## Example

**N-queens** — place `N` queens so none attack another. Go row by row; in each row try each column,
skip any column or diagonal already attacked, recurse to the next row, and undo on return.

```
solve(row):
    if row == N: count_solution(); return
    for col in 0 … N-1:
        if safe(row, col):
            place(row, col)
            solve(row + 1)
            remove(row, col)
```

## Pitfalls

- **Forgetting to undo state** — leaving a choice applied corrupts sibling branches; every `choose`
  needs a matching `un-choose`.
- **No pruning** — without an early-validity check you explore the full exponential tree and time
  out.
- **Mutating shared structures without restoring them** — record a *copy* of a complete solution, or
  later undos will mutate it.

## See also

- [[recursion]]
- [[graph-algorithms]]
