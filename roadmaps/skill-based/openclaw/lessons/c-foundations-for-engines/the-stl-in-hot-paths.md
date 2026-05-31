---
title: The STL in Hot Paths
track: openclaw
group: C++ Foundations for Engines
tags: [openclaw, performance]
prerequisites: [memory-layout-cache-locality, arrays-and-dynamic-arrays]
see-also: [memory-layout-cache-locality, profiling-performance-tuning, resource-manager-caching]
---

# The STL in Hot Paths

Which standard-library containers and idioms are safe inside a per-frame game loop, and which ones quietly allocate, copy, or pointer-chase you out of your frame budget.

## Why it matters

At 60 FPS you have ~16.6 ms per frame for *everything* — update, physics, render, audio. A single hidden heap allocation in the per-actor inner loop can cost microseconds and, worse, fragment the heap and stall on cache misses. The STL is excellent, but several containers (`std::map`, `std::list`, `std::unordered_map`) trade locality for guarantees you rarely need in a hot path. Knowing the cost model lets you keep the convenience of the STL where it's cheap and reach for flat structures where it isn't.

## How it works

Per-element cost and allocation behavior of common containers in a tight loop:

| Container | Node alloc per element | Locality | Hot-path verdict |
|---|---|---|---|
| `vector<T>` | no (bulk) | contiguous | default, ideal |
| `array<T,N>` | none (stack) | contiguous | ideal, fixed size |
| `unordered_map` | yes, per insert | poor (buckets) | avoid in inner loop |
| `map` (RB-tree) | yes, per node | poor | avoid in inner loop |
| `list` / `deque` | yes / blockwise | poor / okay | rarely needed |

- **Reserve to kill reallocs.** `vector::push_back` is amortized O(1) but a growth event copies/moves every element and invalidates iterators. Call `reserve(n)` once at level load so the per-frame loop never reallocates. See [[memory-layout-cache-locality]].
- **Lookup by integer id, not by hashing.** OpenClaw actors carry small dense ids; a `vector` indexed by id beats `unordered_map<int,Actor*>` — no hashing, no bucket chase, perfect locality.
- **Erase-remove, not per-element erase.** Removing dead actors with `v.erase(it)` in a loop is O(n²) and invalidates iterators; use `std::erase_if` (C++20) or the erase-remove idiom for one O(n) compaction.
- **`reserve` + clear, don't free.** `vector::clear()` keeps capacity; reuse the same scratch buffer every frame instead of constructing a fresh container (which allocates). Same trick powers a [[resource-manager-caching]] scratch pool.
- **`std::string` and lambdas.** Building debug strings or capturing into `std::function` each frame allocates; hoist them out of the loop.

## Example

Two ways to find an actor by id in the update loop:

```cpp
// Hot path, called per collision pair, thousands/frame:
std::unordered_map<int, Actor*> byId;   // hash + bucket pointer-chase each lookup
Actor* a = byId[id];                    // ~cache miss per call

std::vector<Actor> actors;              // index == id, dense
Actor& a = actors[id];                  // pointer add, usually L1 hit
```

Swapping a map for an id-indexed `vector` in a hot lookup routinely removes a cache miss per call — at thousands of calls/frame that is real milliseconds. Measure with [[profiling-performance-tuning]].

## Pitfalls

- **`operator[]` on a `map`/`unordered_map` inserts.** A missing key silently default-constructs an entry (and may rehash); use `find()` for read-only lookups.
- **Iterator invalidation.** `vector` growth and `unordered_map` rehash invalidate iterators/pointers mid-loop; cache an index or `reserve` first.
- **`std::vector<bool>` is a bit-proxy**, not real bools — `&v[i]` and `auto& b = v[i]` misbehave. Use `vector<char>` for per-actor flags.
- **Debug-build STL is slow.** `_GLIBCXX_DEBUG` / MSVC iterator-debugging can be 10x+ slower; never benchmark a hot path in a debug config.

## See also

- [[memory-layout-cache-locality]]
- [[profiling-performance-tuning]]
- [[resource-manager-caching]]
