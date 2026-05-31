---
title: SDL2 Setup & Window Management
track: openclaw
group: Rendering
tags: [openclaw, sdl2]
prerequisites: [build-systems-cmake]
see-also: [2d-sprite-rendering, camera-viewport, game-loop-fixed-vs-variable-timestep]
---

# SDL2 Setup & Window Management

Bringing up the SDL2 window, an accelerated renderer, and the logical-resolution scaling that lets OpenClaw present a 640x480 game on any modern display.

## Why it matters

SDL2 is OpenClaw's portability layer: one API for window, input, timing, and GPU-backed 2D across Windows, Linux, and macOS. Captain Claw was authored for a fixed 640x480 surface; without a scaling strategy the game would render postage-stamp-sized in a corner of a 1080p monitor. Getting `SDL_Init`, `SDL_CreateWindow`, `SDL_CreateRenderer`, and `SDL_RenderSetScale` right is the first thing that must work before a single sprite appears.

## How it works

Boot order in `BaseGameApp` (real sequence from the repo):

| Step | Call | Notes |
|---|---|---|
| 1 | `SDL_Init(SDL_INIT_VIDEO\|SDL_INIT_AUDIO)` | also timer subsystem |
| 2 | `SDL_CreateWindow(...)` | `SDL_WINDOW_SHOWN`, optional fullscreen |
| 3 | `SDL_CreateRenderer(win, -1, flags)` | `-1` = first driver that fits |
| 4 | `SDL_RenderSetScale(r, s, s)` | global zoom, `s = width / 640` |

- **Renderer flags.** OpenClaw ORs `SDL_RENDERER_ACCELERATED` (GPU path) with `SDL_RENDERER_PRESENTVSYNC` only when vsync is enabled; vsync caps the present rate to the monitor and removes tearing, but couples your frame pacing to refresh, so the [[game-loop-fixed-vs-variable-timestep|fixed-timestep loop]] still drives logic.
- **Logical scaling.** Rather than `SDL_RenderSetLogicalSize`, the engine computes `scale = realWidth / 640.0` and calls `SDL_RenderSetScale`, so every later `SDL_RenderCopy` is multiplied transparently — game code keeps thinking in 640x480 coordinates. The [[camera-viewport|camera]] divides its half-extents by this scale to re-center correctly.
- **Window events.** The event pump watches `SDL_WINDOWEVENT_SIZE_CHANGED`, `MINIMIZED`, and `RESTORED` to recompute scale and pause rendering when hidden.
- **Teardown.** Destroy in reverse: texture(s), renderer, window, then `SDL_Quit` — see [[raii]] for wrapping these handles.

## Example

```text
flags = SDL_RENDERER_ACCELERATED;
if (useVerticalSync) flags |= SDL_RENDERER_PRESENTVSYNC;
window   = SDL_CreateWindow("Captain Claw", ..., 1280, 960, SDL_WINDOW_SHOWN);
renderer = SDL_CreateRenderer(window, -1, flags);
SDL_RenderSetScale(renderer, 1280/640.0, 960/480.0);   // scale = 2.0
// a 64x64 sprite blitted at logical (100,100) lands at device (200,200), 128x128
```

## Pitfalls

- **Forgetting `-1` driver index.** Hard-coding a renderer index breaks on machines without that backend; `-1` lets SDL pick.
- **No vsync and no frame cap.** An uncapped accelerated renderer will spin at 2000+ FPS, pegging a core and the GPU for nothing.
- **Mixing logical-size and manual scale.** `SDL_RenderSetLogicalSize` and `SDL_RenderSetScale` both transform coordinates; using both double-applies and misplaces everything.
- **Leaking the window on early-return.** Each init step can fail; bail-outs must still destroy what was already created or you leak the GL context.

## See also

- [[2d-sprite-rendering]]
- [[camera-viewport]]
