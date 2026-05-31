---
title: Loops (for / while / do-while)
track: cpp
group: Basics / Syntax
tags: [cpp, control-flow]
prerequisites: [conditionals-if-switch]
see-also: [range-based-for-loop, algorithms-algorithm]
---

# Loops (for / while / do-while)

C++ has three counted/conditional loop forms — `for`, `while`, `do-while` — plus `break`/`continue` to alter flow; they differ only in *where* the condition is tested.

## Why it matters

The loop is where programs spend their time, so its shape drives performance: a tight `for` over contiguous memory is what auto-vectorizers and the cache love (see [[time-and-space-complexity]]). The pre- vs post-test distinction is a real correctness choice — `do-while` guarantees one execution (retry loops, menus), while `while` may run zero times. Knowing when a hand loop should instead be a [[algorithms-algorithm|standard algorithm]] is a senior judgment call.

## How it works

- **`for (init; cond; step)`** — pre-tested; the canonical counted loop. All three clauses are optional (`for(;;)` is an idiomatic infinite loop).
- **`while (cond)`** — pre-tested; runs zero or more times.
- **`do { } while (cond)`** — post-tested; runs *at least once*.
- **`break`** exits the nearest loop; **`continue`** jumps to the next iteration (the `step` clause still runs in a `for`).

| Form | Test timing | Min iterations | Best for |
|---|---|---|---|
| `for` | before | 0 | known count / index |
| `while` | before | 0 | condition-driven |
| `do-while` | after | 1 | run-then-check |

Prefer the [[range-based-for-loop]] when you just iterate a container, and a named algorithm when intent is `find`/`accumulate`/`transform`.

## Example

```cpp
for (std::size_t i = 0; i < n; ++i) sum += a[i];   // counted, vectorizable

int tries = 0;
do {                                  // runs at least once
    result = attempt();
} while (!result && ++tries < 3);     // retry up to 3x

while (auto* node = next()) process(node);   // condition with side effect
```

## Pitfalls

- **Signedness in the bound**: `for (int i = 0; i < vec.size(); ++i)` compares signed `int` to unsigned `size_t` (`-Wsign-compare`); use `std::size_t`.
- **Iterator invalidation**: erasing from a `std::vector` inside a loop invalidates iterators/indices past the point — use the erase-return idiom or `std::erase_if`.
- **Off-by-one** from `<=` vs `<` on `n` elements walks one past the end — UB.
- **`continue` in a `while`** skips your manual increment, causing an infinite loop; `for`'s step still runs.

## See also

- [[range-based-for-loop]]
- [[algorithms-algorithm]]
