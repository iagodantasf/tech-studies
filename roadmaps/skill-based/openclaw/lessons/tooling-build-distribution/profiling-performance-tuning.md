---
title: Profiling & Performance Tuning
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, profiling]
prerequisites: [the-stl-in-hot-paths, time-and-space-complexity]
see-also: [the-stl-in-hot-paths, memory-layout-cache-locality, game-loop-fixed-vs-variable-timestep]
---

# Profiling & Performance Tuning

Measuring where a frame's milliseconds actually go — with sampling and instrumented profilers — and tuning the hot paths instead of guessing.

## Why it matters

A 2D platformer should hold 60 FPS trivially, so when OpenClaw drops frames the cause is almost always one specific stall: a per-frame allocation, a cache-thrashing [[the-stl-in-hot-paths|container]], an unbatched draw call, or a physics blowup. The frame budget is ~16.6 ms; lose it and the [[game-loop-fixed-vs-variable-timestep|fixed-timestep loop]] runs catch-up steps and the game stutters. Profiling replaces "I think it's the renderer" with a flame graph pointing at the real 4 ms offender. Optimising un-profiled code wastes effort on the 95% that was already fast.

## How it works

Two profiler families, used for different questions:

| Tool | Type | Cost | Best for |
|---|---|---|---|
| perf / VTune | sampling | ~1-2% | "where does wall time go?" |
| Tracy / instrumented | scoped zones | per-zone | "how long was *this* span?" |
| valgrind callgrind | simulation | ~20-50x | exact call counts, offline |
| RenderDoc | GPU capture | per-frame | draw calls, overdraw |

- **Sampling first, instrument second.** Run a sampling profiler to find the hot function cheaply, then add scoped timing zones around the suspect to measure it precisely. Don't instrument blind.
- **Measure a release build.** A debug build's [[the-stl-in-hot-paths|STL]] (`_GLIBCXX_DEBUG`, MSVC iterator debugging) can be 10x slower; numbers from a debug config are meaningless.
- **Frame zones.** Bracket Update / Physics / Render / Audio with timer zones; a per-frame breakdown immediately shows which system blew the budget.
- **Watch allocations, not just CPU.** A hidden `new` per actor per frame fragments the heap and stalls on [[memory-layout-cache-locality|cache misses]]; track alloc count per frame — the target is zero in steady state.
- **Counters.** Surface draw-call count, actor count, and frame time in the [[hud-ui-overlay|HUD]] so regressions are visible while you play.

## Example

```text
{ ZoneScoped("Physics"); world.Step(STEP); }   // Tracy zone -> 0.4 ms
{ ZoneScoped("Render");  scene.Draw(); }        //            -> 12.1 ms  <-- offender
// flame graph: Render -> SDL_RenderCopy x 1800  (one call per tile, unbatched)
// fix: batch tiles into a texture atlas -> 1800 calls collapse to ~20
```

Profiling a stuttering scene shows Render eating 12 ms across 1800 individual `SDL_RenderCopy` calls; batching the tilemap into a [[texture-atlases-tilesets|texture atlas]] cuts it to ~20 draws and the frame drops back under budget.

## Pitfalls

- **Profiling the debug build.** Slow-by-design debug allocators and bounds checks point you at the wrong hotspot; always profile `-O2`/Release.
- **Micro-optimising cold code.** A function that's 0.2% of the frame is not worth touching; spend effort where the profiler points.
- **VSync hiding the real number.** With VSync on, frame time pins to ~16.6 ms regardless of headroom; profile with VSync off to see true cost.
- **One-frame samples.** A single frame is noisy (GC, scheduler); average over hundreds of frames before trusting a delta.

## See also

- [[the-stl-in-hot-paths]]
- [[memory-layout-cache-locality]]
- [[game-loop-fixed-vs-variable-timestep]]
