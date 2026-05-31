---
title: Functions
track: datastructures-and-algorithms
group: Language & foundations
tags: [datastructures-and-algorithms, control-flow]
prerequisites: [control-structures]
see-also: [recursion, space-complexity, backtracking]
---

# Functions

Named, reusable units of logic with parameters and a return value — the building block for decomposition and the mechanism that makes [[recursion]] possible.

## Why it matters

Functions let you name a subproblem, which is exactly how recursive and divide-and-conquer algorithms are expressed: `mergeSort(a)` calls itself on halves. Equally important for interviews is *how arguments are passed* — pass-by-reference versus pass-by-value decides whether your helper mutates the caller's array, the source of countless "my visited set is wrong across calls" bugs. Each call also costs a stack frame, which ties function design directly to [[time-and-space-complexity]].

## How it works

The parameter-passing model determines whether callee mutations are visible to the caller:

| Language | Primitives | Arrays / objects | Effect |
|---|---|---|---|
| Python | by object reference | by object reference | mutating a list inside a fn is visible outside |
| C++ | by value (copy) | by value unless `&` | pass `vector<int>&` to avoid an O(n) copy |
| Java | by value | reference passed by value | object fields mutable; reassigning the param is not |
| Go | by value | slices share backing array | append may or may not be visible |

- **Each call pushes a stack frame** holding parameters and locals; depth-d recursion uses O(d) stack space. Deep recursion (~10^4-10^5 frames) overflows the default stack in C++/Java, where Python caps at ~1000 via `sys.setrecursionlimit`.
- **Helper closures** that capture an outer `visited` array or counter are the standard way to thread state through a recursion without passing it as an argument every call — common in [[backtracking]].
- Returning a value vs mutating an out-parameter is a real design choice: pure-return functions are easier to reason about; in-place mutation saves the O(n) copy on large inputs.

## Example

A recursive helper that captures state via closure — no `result` parameter threaded through:

```python
def subsets(nums):
    res, path = [], []
    def dfs(i):                  # closes over res, path, nums
        if i == len(nums):
            res.append(path[:])  # copy: path is mutated in place
            return
        dfs(i + 1)               # skip nums[i]
        path.append(nums[i])
        dfs(i + 1)               # take nums[i]
        path.pop()               # undo — restore state for the caller
    dfs(0)
    return res
```

## Pitfalls

- **`path[:]` (a copy) vs `path`.** Appending the live list stores a reference; when `path` is later mutated, every stored "result" changes. Copy at the moment of capture.
- **Forgetting to undo a mutation** (`path.pop()`) after a recursive branch corrupts state for sibling branches — the defining backtracking bug.
- **Default mutable arguments** (`def f(acc=[])`) in Python are created once and shared across calls, silently accumulating state.
- **Large value-parameters in C++.** Passing a `vector` by value copies it every call; take it by `const&` (or `&` to mutate) in hot recursion.

## See also

- [[recursion]]
- [[time-and-space-complexity]]
- [[backtracking]]
