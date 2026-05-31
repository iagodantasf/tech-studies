---
title: "Function Objects & `std::function`"
track: cpp
group: Standard Library (STL)
tags: [cpp, callables]
prerequisites: [lambda-expressions, operator-overloading, templates-generics]
see-also: [algorithms-algorithm, std-async-futures-promises, ranges-c-20]
---

# Function Objects & `std::function`

A function object (functor) is any type with `operator()`; `std::function<R(Args...)>` is a type-erased owner that can hold *any* callable matching a given signature.

## Why it matters

Functors are how the STL takes behavior as a parameter: a comparator, a predicate, a hash. Because each functor (and each [[lambda-expressions]] lambda) is its own type, the compiler can **inline** the call — that's why `std::sort` with a lambda often beats C's `qsort` with a function pointer. `std::function` then provides the opposite trade: a single concrete type to store heterogeneous callables in a `vector`, a member, or across an ABI boundary, at the cost of an indirect call.

## How it works

| Callable form | Type identity | Inlinable? | Can capture state? |
|---|---|---|---|
| free function | one type | via pointer: rarely | no |
| function pointer | `R(*)(Args)` | usually not | no |
| functor / lambda | unique per definition | yes | yes |
| `std::function<R(Args)>` | one erased type | no (indirect) | yes (stores any) |

- A **stateless** lambda (`[]`) converts to a plain function pointer; a **capturing** lambda does not — it is a unique class with the captures as members.
- `std::function` performs **type erasure**: it stores any compatible callable behind a virtual-like dispatch, may **heap-allocate** if the target exceeds the small-buffer (~16 B, captures included), and calls through a pointer — so it is *not* inlinable.
- For a callback parameter you don't store, prefer a **template parameter** (`template<class F> void each(F f)`) or `std::function_ref`/`std::move_only_function` (C++23) — they keep inlining and avoid allocation.
- Standard functors (`std::less<>`, `std::hash<>`, `std::plus<>`) are the default comparators/operators inside [[associative-containers-map-set-unordered-map]] and [[algorithms-algorithm]].

## Example

```cpp
// Inlinable: F is a distinct type, the lambda body is visible to sort.
std::sort(v.begin(), v.end(),
          [](auto& a, auto& b){ return a.score > b.score; });

// Type-erased: heterogeneous callbacks stored in one container.
std::vector<std::function<int(int)>> ops;
int base = 10;
ops.push_back([](int x){ return x + 1; });
ops.push_back([base](int x){ return x * base; });  // captures -> may allocate
for (auto& f : ops) total += f(5);                 // indirect call each time
```

The `sort` lambda gets inlined to a tight loop; the `std::function` calls cannot be inlined and pay an indirect jump (plus possible allocation for the capturing one).

## Pitfalls

- **`std::function` can allocate and is not inlinable** — using it as the comparator/predicate inside a hot algorithm can be 2-10x slower than passing the lambda directly. Use a template parameter there.
- **An empty `std::function` throws `std::bad_function_call`** when invoked. Check `if (f)` before calling a possibly-default-constructed one.
- **Dangling captures**: a lambda capturing by reference (`[&]`) that outlives the referent — stored in a `std::function`, a thread, or a future — reads freed memory. Capture by value, or by smart pointer, for anything escaping the scope. See [[std-async-futures-promises]].
- **Mutable-state functors break algorithms** that may copy or reorder the predicate; STL predicates must be pure / equality-preserving, or results are unspecified.

## See also

- [[lambda-expressions]]
- [[algorithms-algorithm]]
- [[std-async-futures-promises]]
