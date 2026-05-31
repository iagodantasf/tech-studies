---
title: Goals of a Reimplementation (portability, modding, preservation)
track: openclaw
group: Background & Project Context
tags: [openclaw, project-goals]
prerequisites: []
see-also: [what-is-openclaw-captain-claw-reimplementation, clean-room-vs-asset-dependent-ports]
---

# Goals of a Reimplementation (portability, modding, preservation)

A re-implementation exists to free a game from its dead binary — making it run on modern platforms, become hackable, and survive its original hardware — without rewriting the game *content*.

## Why it matters

The 1997 `.exe` is a 32-bit Win32 program against DirectDraw/DirectSound APIs that modern Windows emulates poorly and Linux/macOS not at all. Each goal solves a concrete failure mode of "just run the old binary": it crashes, it cannot be changed, and it will eventually run nowhere. These three goals shape nearly every OpenClaw design decision.

## How it works

The three goals, and the engineering each forces:

- **Portability** — replace OS-specific DirectX calls with the cross-platform [[sdl2-setup-window-management|SDL2]] layer so one codebase builds on Windows/Linux/macOS via [[build-systems-cmake-make]]. Endianness and 64-bit correctness in the parsers matter here.
- **Modding** — because actors and levels are loaded from decoded XML and external assets, a modder can edit a level or swap a sprite without touching the binary; the data-driven [[entity-actor-model|actor model]] *is* the mod API.
- **Preservation** — the canonical record of the game becomes open source code plus a documented format spec, so it can be rebuilt, audited, and ported indefinitely.

| Goal | Old failure | Re-impl mechanism |
|---|---|---|
| Portability | Win32/DirectX only | SDL2 abstraction |
| Modding | Opaque binary | Data-driven XML actors |
| Preservation | Bit-rotting `.exe` | Open code + format docs |

## Example

Concretely: building on Linux is `cmake -B build && cmake --build build`, then running against the user's `CLAW.REZ`. Adding a new enemy is authoring an actor XML entry plus a [[pid-image-format-claw-sprites|PID]] sprite — recompilation optional. Preserving a level format is publishing the [[wwd-level-format|WWD]] byte layout so any future engine can read it.

## Pitfalls

- **Over-scoping into a remake** — re-implementation reproduces the original; new art, levels, and rebalanced gameplay are a *different* project and dilute preservation.
- **Hard-coding asset paths/counts** — kills modding; keep level/actor data external and discovered, not baked in.
- **Letting parity regress for "nicer" code** — refactors that silently change jump height or enemy timing defeat the preservation goal.

## See also

- [[clean-room-vs-asset-dependent-ports]]
- [[contributing-to-the-openclaw-repo]]
