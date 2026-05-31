---
title: Memory Layout & Cache Locality
track: openclaw
group: C++ Foundations for Engines
tags: [openclaw, performance]
prerequisites: [arrays-and-dynamic-arrays, computer-architecture]
see-also: [the-stl-in-hot-paths, entity-actor-model, profiling-performance-tuning]
---

# Memory Layout & Cache Locality

How C++ objects are arranged in RAM, and why a 64-byte cache line — not big-O — usually decides whether a 2D engine like OpenClaw hits 60 FPS.

## Why it matters

A modern x86 core can issue several instructions per nanosecond but stalls ~100+ ns on a main-memory miss — roughly 300 wasted instructions. OpenClaw updates hundreds of actors and blits thousands of tiles every frame; if each actor's hot fields are scattered across heap nodes, the CPU spends the frame waiting on RAM, not computing. Laying data out for sequential, predictable access is the single highest-leverage optimization in a game loop, and it costs nothing at runtime.

## How it works

The cache hierarchy is the model you optimize against. Approximate latencies on a desktop core:

| Level | Typical size | Latency | Line size |
|---|---|---|---|
| L1d | 32-48 KB | ~4 cycles | 64 B |
| L2 | 256 KB-1 MB | ~12 cycles | 64 B |
| L3 | 8-32 MB shared | ~40 cycles | 64 B |
| DRAM | GBs | ~200+ cycles | n/a |

- **Cache lines, not bytes.** Touching one `int` pulls its whole 64-byte line. Walking a `std::vector<T>` sequentially gets ~`64/sizeof(T)` elements per miss and triggers the hardware prefetcher; pointer-chasing a `std::list` defeats both. See [[arrays-and-dynamic-arrays]] and [[computer-architecture]].
- **`struct` layout & padding.** Members are aligned to their size; the compiler inserts padding so a poorly ordered struct wastes a line. Order members large→small. `alignas(64)` a struct shared across threads to dodge false sharing.
- **AoS vs SoA.** Array-of-Structs (`vector<Actor>`) keeps one actor's fields together — good when you touch most fields. Struct-of-Arrays (separate `vector<Vec2> positions; vector<Vec2> velocities;`) is better when a system reads only positions, packing 16 `Vec2` per line with zero waste. This is the core idea behind the [[entity-actor-model]].
- **Hot/cold splitting.** Keep per-frame fields (position, velocity, animation index) in one struct; move rarely-touched data (debug name, original spawn config) behind a pointer so it never pollutes the line.

## Example

A `vector<Sprite>` of 4096 sprites, summing one `int16_t x` field per frame:

```text
struct Sprite { Vec2 pos; Vec2 vel; uint32_t tex; uint16_t frame; /* 64+ B */ };
AoS: read x  -> stride 64+ B  -> 1 useful line per sprite, prefetch wins
SoA: int16_t xs[4096]         -> 32 x-values per 64 B line  => ~32x less traffic
```

Measured pattern: a tight SoA pass over 1M elements runs ~5-20x faster than the equivalent `std::list` traversal despite identical O(n) — purely cache effects. Confirm with [[profiling-performance-tuning]], not intuition.

## Pitfalls

- **Trusting big-O over locality.** `O(n)` `list` loses badly to `O(n)` contiguous `vector`; the constant *is* the cache.
- **False sharing.** Two threads writing different fields that share a 64-byte line ping-pong the line between cores; pad/align hot per-thread data.
- **`new`-per-object spray.** Allocating each actor individually scatters them across the heap; prefer a pooled `vector` so iteration is sequential.
- **Premature SoA.** SoA hurts readability and update code that needs many fields at once. Default to AoS `vector`, profile, then split only the proven-hot field.

## See also

- [[the-stl-in-hot-paths]]
- [[entity-actor-model]]
- [[profiling-performance-tuning]]
