---
title: Ranges (C++20)
track: cpp
group: Standard Library (STL)
tags: [cpp, ranges]
prerequisites: [iterators, algorithms-algorithm, lambda-expressions]
see-also: [concepts-c-20, std-span, function-objects-std-function]
---

# Ranges (C++20)

Ranges reframe the STL around whole *ranges* instead of iterator pairs, adding composable, lazy **views** that pipe data through transformations with `|`.

## Why it matters

Classic [[algorithms-algorithm]] force you to spell `v.begin(), v.end()` everywhere and to materialize intermediate containers between steps. Ranges fix both: `std::ranges::sort(v)` takes the container directly, and view adaptors (`filter`, `transform`, `take`) compose into a single lazy pipeline that touches each element once with **no intermediate allocation**. The result reads top-to-bottom like a data flow rather than nested loops, and the constraints are enforced by [[concepts-c-20]] for far clearer errors.

## How it works

A *range* is anything with `begin()`/`end()`; a *view* is a cheap, non-owning, lazily-evaluated range you compose with `operator|`.

| Piece | Example | Eager or lazy |
|---|---|---|
| range algorithm | `ranges::sort(v)`, `ranges::find(v, x)` | eager |
| view adaptor | `views::filter(pred)`, `views::transform(f)` | lazy |
| source/generator | `views::iota(0)`, `views::take(n)` | lazy |
| materialize | `ranges::to<vector>()` (C++23) | forces evaluation |

- Views are **lazy**: building the pipeline does *no work*; elements flow only when iterated, each pulled on demand. A `filter | transform` makes one pass, never an intermediate vector.
- Adaptors are **non-owning** over an lvalue range — like [[std-span]], they don't extend lifetime.
- Projections replace many custom lambdas: `ranges::sort(people, {}, &Person::age)` sorts by a member without writing a comparator.
- Range algorithms return richer results (e.g. `borrowed_iterator`, subranges) and are constrained, so misuse is a clean concept error, not a 200-line template dump.

## Example

```cpp
namespace rv = std::views;
std::vector<int> v{1,2,3,4,5,6,7,8,9,10};

auto pipe = v | rv::filter([](int x){ return x % 2 == 0; })  // 2 4 6 8 10
              | rv::transform([](int x){ return x * x; })    // 4 16 36 64 100
              | rv::take(3);                                  // 4 16 36
for (int x : pipe) use(x);          // single pass, evaluated HERE, no temp vector

std::ranges::sort(v, std::greater{});                 // whole-container, descending
auto out = v | rv::take(3) | std::ranges::to<std::vector>();  // C++23 materialize
```

The classic equivalent would allocate two throwaway vectors (filtered, then squared); the view allocates none.

## Pitfalls

- **Dangling views**: piping over a temporary (`getVec() | views::filter(...)` stored in a variable) views a destroyed object. Keep the source alive, or materialize immediately.
- **`filter` re-evaluates its predicate** on each traversal and on `begin()`; an *expensive* or *side-effecting* predicate runs more often than you expect — keep it pure and cheap.
- **Mutating the source** under a live view invalidates it just like an iterator; lazy evaluation makes the timing subtle.
- **Compile time / debug speed**: heavy view pipelines stress the compiler and step slowly in a debugger (deeply nested types). C++20 also lacks `ranges::to`; you must hand-build the target before C++23.

## See also

- [[algorithms-algorithm]]
- [[concepts-c-20]]
- [[iterators]]
