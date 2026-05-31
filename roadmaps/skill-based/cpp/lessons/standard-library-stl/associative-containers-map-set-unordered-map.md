---
title: Associative Containers (map, set, unordered_map)
track: cpp
group: Standard Library (STL)
tags: [cpp, containers]
prerequisites: [containers-vector-array-list-deque, hash-tables, trees]
see-also: [iterators, std-string-std-string-view, utility-types-pair-tuple-optional-variant-any]
---

# Associative Containers (map, set, unordered_map)

Key-indexed containers: ordered variants are balanced [[trees]] giving sorted O(log n) access, unordered variants are [[hash-tables]] giving average O(1) access.

## Why it matters

These are the bread-and-butter lookup structures — symbol tables, caches, dedup sets, frequency counts. The ordered/unordered choice is a real engineering decision: `unordered_map` is typically 2-5x faster for point lookups, but `map` keeps keys sorted (range queries, ordered iteration) and has stable worst-case O(log n) where a hash map degrades to O(n) on collisions or adversarial input.

## How it works

| Container | Backing | Lookup avg / worst | Ordered? | Ref stable on insert? |
|---|---|---|---|---|
| `map` / `set` | red-black tree | O(log n) / O(log n) | yes | yes (node-based) |
| `unordered_map` / `unordered_set` | hash table + buckets | O(1) / O(n) | no | yes; iters invalid on rehash |
| `multimap` / `multiset` | same, dup keys allowed | O(log n) | yes | yes |

- Ordered containers need `operator<` (or a comparator); two keys are *equivalent* when `!(a<b) && !(b<a)` — there is no `operator==` involved.
- Unordered containers need `std::hash<Key>` **and** `operator==`. For custom keys, specialize `std::hash` or pass a hash functor; a weak hash silently turns O(1) into O(n).
- All four are **node-based**: elements live in separate nodes, so references/pointers to values stay valid across inserts/erases. For `unordered_*`, a *rehash* invalidates iterators but not references.
- C++17 adds `try_emplace` (no construction if key exists), `insert_or_assign`, and `extract()`/`merge()` for moving nodes between maps without reallocating.

## Example

```cpp
std::map<std::string,int> m;
m["a"] = 1;                          // operator[] DEFAULT-inserts "a"->0 then assigns
auto [it, inserted] = m.try_emplace("a", 99);  // no overwrite; inserted==false
m.emplace("b", 2);

std::unordered_map<std::string,int> h;
h.reserve(10000);                    // size buckets up front -> avoids rehashes
auto cnt = h["x"]++;                 // word-count idiom: ++ on default-constructed 0
```

Counting words in a 1M-token text: `unordered_map` finishes in roughly half the time of `map`, but emits results in hash order, not alphabetical.

## Pitfalls

- **`operator[]` inserts.** `if (m[k] == ...)` on a missing key silently adds it (value-initialized). Use `.find()` or `.contains()` (C++20) for read-only checks; use `.at()` to throw instead.
- **Custom keys need a *good* hash.** Returning a constant or low-entropy hash collapses everything into one bucket — average O(n). Combine member hashes; don't just XOR them.
- **`unordered_map` rehash invalidates iterators** (and the order); references survive but loop iterators don't. Reserve to bound rehashing.
- **Floating-point or pointer keys** make ordering/hashing surprising (NaN never compares equal; addresses vary per run) — prefer stable, integral, or string keys.

## See also

- [[iterators]]
- [[hash-tables]]
- [[utility-types-pair-tuple-optional-variant-any]]
