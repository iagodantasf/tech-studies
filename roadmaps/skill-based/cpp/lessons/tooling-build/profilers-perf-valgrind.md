---
title: "Profilers (perf, Valgrind)"
track: cpp
group: Tooling & Build
tags: [cpp, profiling]
prerequisites: [computer-architecture, debuggers-gdb-lldb]
see-also: [debuggers-gdb-lldb, sanitizers-asan-ubsan-tsan, time-and-space-complexity]
---

# Profilers (perf, Valgrind)

Profilers measure where a program spends time or memory at runtime; `perf` samples real hardware counters with near-zero overhead, while Valgrind's tools instrument every instruction in a synthetic CPU.

## Why it matters

Optimization without measurement is guesswork — the bottleneck is almost never where intuition says. `perf` reveals which functions burn cycles and *why* (cache misses, branch mispredicts) on real hardware, guiding the [[time-and-space-complexity|complexity]]-vs-constant-factor tradeoffs that matter in hot loops. Valgrind's memcheck and callgrind catch leaks and produce exact call counts. Together they answer "is this CPU-bound, memory-bound, or leaking?".

## How it works

`perf` (Linux) uses statistical sampling: the CPU's PMU interrupts periodically and records the instruction pointer + call stack, so overhead is ~1-5%. Valgrind runs the program on a software CPU, instrumenting every memory access (memcheck) or instruction (callgrind) — exact but 10-50x slower.

| Tool | Method | Overhead | Best for |
|---|---|---|---|
| `perf record/report` | HW sampling | ~1-5% | CPU hotspots on real hw |
| `perf stat` | counter totals | negligible | cache/branch/IPC summary |
| valgrind `memcheck` | full instrumentation | 10-30x | leaks, invalid reads |
| valgrind `callgrind` | instruction counting | 20-50x | exact call counts, cache sim |

- `perf record -g ./app` captures sampled call graphs; `perf report` (or a **flame graph**) shows the self/cumulative time per function. `-g` + frame pointers (`-fno-omit-frame-pointer`) make stacks readable.
- `perf stat` gives IPC, `cache-misses`, and `branch-misses` in one shot — the fastest way to classify a workload as memory- vs compute-bound; see [[computer-architecture]].
- **Valgrind/memcheck** detects leaks and invalid/uninitialized reads deterministically but slowly; for in-development memory bugs, compiler [[sanitizers-asan-ubsan-tsan|sanitizers]] (ASan) are ~10x faster and now preferred.
- **callgrind** counts instructions exactly (no sampling noise), ideal for comparing two implementations or simulating cache behavior with `--cache-sim=yes` (view in KCachegrind).

## Example

```bash
g++ -O2 -g -fno-omit-frame-pointer app.cpp -o app
perf record -g ./app          # sample
perf report                   # 72% in matmul(), 18% in std::sort
perf stat ./app               # IPC 0.4, 40% cache-miss -> memory-bound

valgrind --leak-check=full ./app
# definitely lost: 1,024 bytes in 1 blocks  <- a real leak
```

`perf stat` showing low IPC and high cache-miss rate means the fix is data layout, not algorithm.

## Pitfalls

- **Profiling unoptimized or non-`-g` builds** misleads: `-O0` inflates trivial functions, while a stripped/`-fomit-frame-pointer` binary gives broken, anonymous stacks.
- **Valgrind serializes threads** onto one core, hiding contention and inflating multithreaded timings — use `perf`/TSan for concurrency.
- **`perf` needs permissions**: `perf_event_paranoid` (often 2-4) or missing kernel headers block sampling; set it lower or run with privileges.
- **Sampling misses short, frequent calls**: a function called millions of times for a few cycles each may underreport — confirm with callgrind's exact counts.

## See also

- [[debuggers-gdb-lldb]]
- [[sanitizers-asan-ubsan-tsan]]
- [[time-and-space-complexity]]
