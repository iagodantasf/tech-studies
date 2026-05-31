---
title: Reading an Existing C++ Game Codebase
track: openclaw
group: Background & Project Context
tags: [openclaw, code-reading]
prerequisites: []
see-also: [what-is-openclaw-captain-claw-reimplementation, entity-actor-model]
---

# Reading an Existing C++ Game Codebase

Before changing a large game engine you must *map* it — finding the entry point, the main loop, and the actor/resource subsystems — so you can place any feature on a mental architecture before editing.

## Why it matters

OpenClaw is tens of thousands of lines of C++ spread across many translation units; diving in to "add a feature" without a map produces breakage and wasted hours. Reading code is the dominant activity in real engine work — you read far more than you write — and a deliberate strategy turns an opaque repo into a navigable system.

## How it works

A top-down reading pass, in order:

- **Find `main()`** — it sets up the window and kicks off the engine; trace it until you hit the [[game-loop-fixed-vs-variable-timestep|game loop]]. In OpenClaw look for the application/`Game` bootstrap.
- **Locate the loop** — the per-frame `input -> update -> render` cycle is the spine; every system is called from here.
- **Identify subsystems** — `EventMgr`, `HumanView`, `ActorFactory`, resource cache. OpenClaw uses an [[entity-actor-model|actor + component]] design wired by an [[event-system-input-handling|event system]].
- **Follow the data, not just the code** — see how `CLAW.REZ` -> WWD -> actors flows; data flow reveals intent faster than class hierarchies.

Tooling that pays off immediately:

| Tool | Use |
|---|---|
| `grep`/ripgrep | Find a symbol's definition and call sites |
| clangd / IDE "go to definition" | Jump declaration -> implementation |
| gdb / lldb breakpoints | Watch the loop and event order at runtime |
| Git blame / log | Learn *why* a tricky block exists |

## Example

Onboarding to OpenClaw to add a pickup sound: set a [[debuggers-gdb-lldb]] breakpoint in the main loop, step into the update phase, follow an [[event-system-input-handling|event]] from collision to the [[sdl-mixer-integration|audio]] handler, *then* edit. You have located the seam before writing a line — the change is now surgical, not speculative.

## Pitfalls

- **Reading every file linearly** — you will drown; follow one *vertical slice* (e.g. a single key-press to its effect) instead.
- **Trusting names over behaviour** — set breakpoints and confirm; a `Manager` may not do what its name suggests.
- **Ignoring the build system** — what actually compiles and links lives in [[build-systems-cmake-make]]; dead files in the tree can mislead you.
- **Skipping a local build first** — make it compile and run *before* changing anything, so later breakage is unambiguously yours.

## See also

- [[what-is-openclaw-captain-claw-reimplementation]]
- [[entity-actor-model]]
