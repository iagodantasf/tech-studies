---
title: Computer architecture
track: computer-science
group: Systems
tags: [cs, systems, hardware]
prerequisites: [bit-manipulation]
see-also: [arrays-and-dynamic-arrays, operating-systems]
---

# Computer architecture

Computer architecture is how a **CPU**, **memory**, and **I/O** fit together to fetch, decode, and
execute instructions — and why the **memory hierarchy** dominates real-world performance.

## Why it matters

Two algorithms with identical big-O can differ 10x in wall-clock time because one respects the cache
and the other thrashes it. Understanding the hierarchy is what lets you predict that gap, and it
explains why "just add RAM" rarely fixes a latency problem — the bottleneck is usually how far the
CPU has to reach for each byte.

## How it works

A CPU runs a **fetch–decode–execute** cycle, overlapping stages in a **pipeline** so several
instructions are in flight at once. A mispredicted **branch** flushes the pipeline, costing many
cycles — which is why predictable, branch-light loops run faster.

Memory is a **hierarchy**, fast-and-tiny at the top, slow-and-huge at the bottom:

| Level | Typical latency | Size |
|---|---|---|
| Registers | <1 ns | bytes |
| L1 / L2 / L3 cache | ~1–40 ns | KB–MB |
| Main memory (DRAM) | ~100 ns | GB |
| SSD / disk | µs–ms | TB |

Caches load data in **cache lines** (usually 64 bytes), not single bytes. Two principles make them
work:

- **Temporal locality** — recently used data is likely reused soon.
- **Spatial locality** — neighbors of used data are likely used next, so a whole line is fetched.

This is why a contiguous [[arrays-and-dynamic-arrays|array]] scan crushes a pointer-chasing
[[linked-lists|linked list]] walk: the array streams full cache lines, the list takes a cache miss
per node.

## Example

```
# Row-major matrix sum — cache-friendly (stride 1, fills each line)
for i in rows:
    for j in cols:
        total += M[i][j]

# Swap the loops → column-major access → a cache miss almost every step
```

The only change is loop order, yet the second version can be several times slower on a large matrix.

## Pitfalls

- **Ignoring the cache line** — random-access patterns and `struct` padding waste most of every line
  you pay to load.
- **False sharing** — two threads writing different variables that share one cache line force
  constant invalidation; pad hot per-thread data to its own line.
- **Assuming big-O is the whole story** — constant factors from locality routinely dominate at the
  sizes real programs actually run.

## See also

- [[arrays-and-dynamic-arrays]]
- [[operating-systems]]
