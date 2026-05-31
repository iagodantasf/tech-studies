---
title: Iterators
track: cpp
group: Standard Library (STL)
tags: [cpp, iterators]
prerequisites: [containers-vector-array-list-deque, pointers, operators]
see-also: [algorithms-algorithm, ranges-c-20, std-span]
---

# Iterators

Iterators are the generalized-pointer abstraction that lets one algorithm walk any container by decoupling *traversal* from *storage*.

## Why it matters

Iterators are the glue between [[containers-vector-array-list-deque]] and [[algorithms-algorithm]]: `std::sort(v.begin(), v.end())` works because both speak the iterator protocol, not because sort knows about `vector`. This is the STL's core design — N containers × M algorithms with O(N+M) code instead of O(N×M). Understanding iterator *categories* tells you instantly which algorithms are even applicable and at what cost.

## How it works

A half-open range `[first, last)` covers `last - first` elements; `last` is one-past-the-end and must never be dereferenced. Categories form a hierarchy, each adding operations:

| Category | Supports | Example source |
|---|---|---|
| input / output | `++`, single-pass read or write | `istream_iterator` |
| forward | multi-pass `++`, read+write | `forward_list` |
| bidirectional | adds `--` | `list`, `map`, `set` |
| random-access | adds `+n`, `-`, `[]`, `<` | `vector`, `array`, `deque` |
| contiguous (C++17) | guarantees `&*it` is a raw pointer | `vector`, `array`, `string` |

- An algorithm's signature *requires* a category: `std::sort` needs random-access (so it rejects `list`, which ships its own `list::sort`); `std::find` needs only input.
- Validity is the catch: mutating a container can **invalidate** iterators (see container rules). A dereferenced invalid iterator is UB, not a thrown exception.
- Adapters add behavior: `std::back_inserter(v)` turns assignment into `push_back`; `reverse_iterator` flips direction; `std::move_iterator` makes a copy a move. See [[operators]].
- C++20 redefines these as *concepts* (`std::random_access_iterator`) and splits the sentinel (`last`) from the iterator type, enabling [[ranges-c-20]].

## Example

```cpp
std::vector<int> v{5,3,8,1};
auto it = std::find(v.begin(), v.end(), 8);   // input iterator suffices
if (it != v.end())                            // ALWAYS compare to end()
    std::cout << *it << " at " << (it - v.begin());  // random-access: it - begin

std::vector<int> out;
std::copy(v.begin(), v.end(), std::back_inserter(out)); // grows out via push_back
```

`it - v.begin()` only compiles because `vector`'s iterator is random-access; the same on a `list` would not.

## Pitfalls

- **Using an invalidated iterator is UB.** A `vector` realloc, a `map::erase` of the pointed-to node, or `unordered_map` rehash leaves dangling iterators that crash unpredictably.
- **Off-by-one / dereferencing `end()`** — `end()` is a sentinel, not the last element; `*v.end()` is UB. Always loop `it != end()`.
- **Mismatched ranges**: passing iterators from two different containers (`a.begin()`, `b.end()`) is UB the compiler can't catch.
- **Mixing iterator and index loops** while erasing — prefer the `it = c.erase(it)` return value or `std::erase_if` (C++20) over manual bookkeeping.

## See also

- [[algorithms-algorithm]]
- [[ranges-c-20]]
- [[containers-vector-array-list-deque]]
