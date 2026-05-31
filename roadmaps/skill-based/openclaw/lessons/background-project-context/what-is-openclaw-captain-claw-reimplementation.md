---
title: What is OpenClaw (Captain Claw reimplementation)
track: openclaw
group: Background & Project Context
tags: [openclaw, project-overview]
prerequisites: []
see-also: [the-original-game-monolith-1997, reading-an-existing-c-game-codebase]
---

# What is OpenClaw (Captain Claw reimplementation)

OpenClaw (`pjasicek/OpenClaw` on GitHub) is a from-scratch C++/SDL2 re-creation of the *engine* of Monolith's 1997 platformer Captain Claw, which loads the player's own retail data file rather than shipping any assets.

## Why it matters

The original game is a closed-source Win32 binary that will not run cleanly on a 64-bit OS, modern GPU, or anything non-Windows. OpenClaw is the canonical study case for "preserve a dead game by re-creating its code" — a pattern shared with OpenRA, OpenMW, devilutionX, and OpenTTD. It demonstrates how far you can get by reverse-engineering only the *data formats* while writing 100% new logic.

## How it works

OpenClaw is a clean-room *engine*, not a decompilation. It pairs a new C++ codebase with the original asset blob:

- **Code (new, MIT-licensed)** — game loop, rendering, audio, actor logic, physics — all hand-written. See [[reading-an-existing-c-game-codebase]].
- **Assets (yours, never redistributed)** — supplied by the user's legally-owned `CLAW.REZ` archive.

Library stack (real dependencies of the repo):

| Concern | Library |
|---|---|
| Window / input / timing | SDL2 |
| 2D textures, sound mixing | SDL2 + SDL_mixer |
| Rigid-body physics | Box2D |
| XML actor/level definitions | TinyXML2 |
| Build | CMake |

Architecture is **actor + component**: each entity (Claw, an enemy, a checkpoint) is an `Actor` assembled from components defined in XML, decoded out of the [[rez-archive-resource-packs|REZ archive]] at load time.

## Example

A typical boot sequence: `main()` -> init SDL2 window -> open `CLAW.REZ` -> read `GAME.WWD` (the [[wwd-level-format|level]]) -> instantiate actors from XML -> enter the [[game-loop-fixed-vs-variable-timestep|fixed-timestep loop]]. No bytes of Monolith's `.exe` are linked, copied, or disassembled into the build.

## Pitfalls

- **Expecting a standalone download** — you must own Captain Claw; OpenClaw without `CLAW.REZ` will not start.
- **Confusing it with a decompiler** — it is a *reimplementation*; behaviour is observed and re-coded, not byte-for-byte ported.
- **Assuming pixel-perfect parity** — physics run on Box2D, so movement is *close*, not identical to the 1997 fixed-point math.

## See also

- [[the-original-game-monolith-1997]]
- [[clean-room-vs-asset-dependent-ports]]
