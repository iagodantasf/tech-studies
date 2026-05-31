---
title: Algorithms (`<algorithm>`)
track: cpp
group: Standard Library (STL)
tags: [cpp, algorithms]
prerequisites: [iterators, lambda-expressions, function-objects-std-function]
see-also: [ranges-c-20, containers-vector-array-list-deque, sorting]
---

# Algorithms (`<algorithm>`)

`<algorithm>` is a library of ~115 generic function templates that operate on iterator ranges, letting you express *what* to compute instead of hand-rolling loops.

## Why it matters

"No raw loops" is a core modern-C++ guideline: a named algorithm states intent (`std::any_of` vs a `for` with a flag), is correct by construction, and is often faster — implementations vectorize, and C++17 added `std::execution::par` for parallel/SIMD variants with one extra argument. Bugs like off-by-one, wrong comparators, or forgetting a `break` mostly vanish.

## How it works

Algorithms take `[first, last)` ranges plus optional predicates/[[lambda-expressions]] and return iterators or values. Key families:

| Family | Examples | Mutates range? |
|---|---|---|
| non-modifying | `find`, `count`, `all_of`, `accumulate*` | no |
| modifying | `copy`, `transform`, `fill`, `replace` | yes (or to output) |
| partition/sort | `sort`, `stable_sort`, `nth_element`, `partition` | yes |
| binary search | `lower_bound`, `upper_bound`, `binary_search` | needs sorted input |
| set/heap | `set_union`, `make_heap`, `push_heap` | varies |

- **The erase-remove idiom**: `remove`/`unique` only *reorder* elements and return a new logical end — they cannot shrink the container (they have no access to it). You must follow with `erase`: `v.erase(std::remove(v.begin(),v.end(),x), v.end());`.
- Predicates must be **pure and consistent**: a sort comparator must be a strict weak ordering (irreflexive, `cmp(a,a)==false`); violating it is UB, not a wrong answer.
- `std::accumulate` lives in `<numeric>`, not `<algorithm>`; so do `iota`, `reduce`, `inner_product`.
- Parallel overloads (C++17): `std::sort(std::execution::par, ...)` — no synchronization is added for you, so the element op must be safe to run concurrently.

## Example

```cpp
std::vector<int> v{4,1,3,1,5,9,2,6};

std::sort(v.begin(), v.end());                       // 1 1 2 3 4 5 6 9
v.erase(std::unique(v.begin(), v.end()), v.end());   // dedup ADJACENT dups -> needs sort first

auto n = std::count_if(v.begin(), v.end(),
                       [](int x){ return x % 2 == 0; });   // even count
std::transform(v.begin(), v.end(), v.begin(),
               [](int x){ return x*x; });            // in-place square
```

`unique` without the preceding `sort` only removes *consecutive* duplicates, a classic source of "dedup didn't work" bugs.

## Pitfalls

- **`remove`/`unique` don't erase.** They return the new end; skipping the `erase` leaves stale tail elements and a wrong `size()`.
- **`unique` only collapses adjacent equal runs** — sort (or otherwise group) first for a full dedup.
- **Bad comparators are UB.** Using `<=` instead of `<`, or an inconsistent ordering, can crash or loop inside `std::sort`, especially in debug-checked builds.
- **Half-open confusion**: many algorithms return `last` to mean "not found" — always test the result against `end()` before dereferencing. See [[iterators]].

## See also

- [[ranges-c-20]]
- [[sorting]]
- [[lambda-expressions]]
