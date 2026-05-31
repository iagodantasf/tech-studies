---
title: Game Loop (fixed vs variable timestep)
track: openclaw
group: Engine Architecture
tags: [openclaw, game-loop]
prerequisites: [time-and-space-complexity, floating-point-representation]
see-also: [tile-based-physics-gravity, animation-system-frames-timing, event-system-input-handling]
---

# Game Loop (fixed vs variable timestep)

The top-level loop that pumps input, advances simulation, and presents a frame — and the timestep policy that decides whether physics runs on a fixed clock or follows wall-clock frame deltas.

## Why it matters

Captain Claw's movement and jump arcs only feel right if gravity is integrated at a constant rate. If you step physics by a raw frame `dt`, a 144 Hz monitor and a 30 Hz potato produce *different jump heights* and Box2D can tunnel Claw through a tile when a frame hitches to 200 ms. A fixed-timestep loop with a render interpolation makes the simulation deterministic and framerate-independent while still drawing as smoothly as the display allows — the standard "fix your timestep" pattern OpenClaw follows in `GameApp::MainLoop`.

## How it works

Three loop styles, only the third is acceptable for physics:

| Style | Update step | Determinism | Failure mode |
|---|---|---|---|
| Variable | raw `dt` each frame | none | jump height varies with FPS |
| Fixed, no interp | constant `dt` | yes | visual stutter / jitter |
| Fixed + interpolation | constant sim, lerp render | yes | none (the goal) |

- **Accumulator pattern.** Keep `accumulator += frameDt`; while `accumulator >= STEP` run one `Update(STEP)` and subtract `STEP`. STEP is the fixed slice (OpenClaw uses ~16.6 ms / 60 Hz). Render once per frame after draining.
- **Spiral of death.** If a single update costs more than STEP, the accumulator only grows and you update forever. Clamp `frameDt` (e.g. cap at 250 ms) so a debugger pause or disk stall can't lock the loop.
- **Render interpolation.** After the while-loop, `alpha = accumulator / STEP`; draw each actor at `lerp(prevPos, curPos, alpha)` so motion is smooth between the two most recent sim states. Feeds [[animation-system-frames-timing]].
- **Input first.** Pump the SDL event queue at the top of every *frame*, not every *step*, then dispatch through the [[event-system-input-handling]]; physics runs on [[tile-based-physics-gravity]].

## Example

```text
const double STEP = 1.0/60.0;        // fixed sim slice
double acc = 0, prev = now();
while (running) {
  double cur = now(); double frame = cur - prev; prev = cur;
  if (frame > 0.25) frame = 0.25;    // clamp -> kill spiral of death
  PumpInput();                       // once per frame
  acc += frame;
  while (acc >= STEP) { Update(STEP); acc -= STEP; }
  Render(acc / STEP);                // alpha for interpolation
}
```

At 144 FPS one frame (~6.9 ms) usually drains zero steps; every ~2-3 frames the accumulator crosses STEP and runs exactly one update — sim stays 60 Hz, draw stays 144 Hz.

## Pitfalls

- **Using `dt` for gravity.** `vy += g * dt` with variable `dt` desyncs jump arcs across machines; integrate on the fixed STEP only.
- **No clamp.** Alt-tab or a breakpoint produces a giant `frameDt`, the accumulator explodes, and the game appears to freeze while it runs thousands of catch-up steps.
- **`float` time accumulation.** Summing a tiny `float` dt drifts after minutes of play; accumulate in `double`. See [[floating-point-representation]].
- **VSync double-counting.** With VSync on, `SDL_GL_SwapWindow` already blocks ~16 ms; adding your own sleep stacks two waits and halves the framerate.

## See also

- [[tile-based-physics-gravity]]
- [[animation-system-frames-timing]]
- [[event-system-input-handling]]
