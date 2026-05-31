---
title: Logging & In-Game Console
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, logging]
prerequisites: [event-system-input-handling, hud-ui-overlay]
see-also: [event-system-input-handling, hud-ui-overlay, debugging-gdb-lldb-visual-studio]
---

# Logging & In-Game Console

A levelled logging facility plus an overlay console — the engine's primary way to surface state, trace events, and run commands without a debugger attached.

## Why it matters

A game spends most of its life running, not paused in a debugger; you cannot breakpoint a frame-rate stutter or a one-in-a-thousand AI glitch. Structured logs with severity levels let you filter the firehose, and an in-game console (drop-down, `~` key) turns the running build into a live tool — toggle hitboxes, warp to [[checkpoints-level-transitions|a level]], dump an [[entity-actor-model|actor's]] state. OpenClaw routes diagnostics through a logger so the same `LOG_WARNING` line can hit a file, stdout, and the overlay at once.

## How it works

Logging is one sink-fanned macro layer; the console is a [[hud-ui-overlay|HUD overlay]] reading the same ring buffer.

| Level | Use | Default in release |
|---|---|---|
| ERROR | unrecoverable / asset missing | on |
| WARNING | recoverable, suspicious | on |
| INFO | lifecycle, level load | on |
| DEBUG | per-system tracing | off |
| TRACE | per-frame / per-actor spam | off |

- **Compile-time gating.** Wrap verbose levels so `LOG_TRACE` compiles to nothing in release (`#if LOG_LEVEL >= TRACE`); a per-frame trace call left in a hot path costs string formatting every frame even when the message is discarded.
- **Sinks, not `printf`.** A log line fans to N sinks (file, console overlay, stderr). Adding the overlay sink is what makes logs visible in-game.
- **Ring buffer for the overlay.** Keep the last ~512 lines in a fixed [[arrays-and-dynamic-arrays|ring buffer]]; the console renders a scrollback window, the oldest line is overwritten — bounded memory, no per-line alloc.
- **Console = command dispatch.** A submitted line is tokenised and matched against a registry of `name -> fn(args)`; commands mutate engine state via the same [[event-system-input-handling|event system]] the game uses.
- **Categories.** Tag lines by subsystem (`[AUDIO]`, `[PHYSICS]`) so you can filter to one system in a noisy log.

## Example

```text
#define LOG_WARNING(fmt, ...) Log::emit(WARNING, __FILE__, __LINE__, fmt, __VA_ARGS__)

LOG_WARNING("[ASSET] missing sprite '%s', using placeholder", name);
// console: register("noclip", [](auto a){ player.collide = false; });
//   user types ~  then  noclip   -> Claw walks through tiles
```

A drop-down console over a 60 FPS scene that prints the last 512 lines and accepts `warp 3`, `noclip`, `fps` turns one build into a debugging cockpit — far faster than recompiling to test a hunch.

## Pitfalls

- **Logging in the inner loop at INFO.** A `LOG_INFO` per actor per frame is thousands of formatted strings/second; demote per-frame detail to TRACE and gate it out of release.
- **Synchronous file flush per line.** `fflush` every line stalls on disk I/O; buffer and flush periodically (and on ERROR).
- **Unbounded scrollback.** Storing every line for a long session leaks memory; the overlay needs a fixed ring buffer.
- **String formatting before the level check.** Build the message *after* confirming the level is enabled, or you pay formatting cost for discarded lines.

## See also

- [[event-system-input-handling]]
- [[hud-ui-overlay]]
- [[debuggers-gdb-lldb]]
