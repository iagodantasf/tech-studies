---
title: OpenClaw
track: openclaw
category: Skill-based
tags: [roadmap, game-dev]
---

# OpenClaw

> roadmap.sh: https://roadmap.sh/openclaw

Suggested path through the **OpenClaw** nodes. Each node links to its lesson when written.

## Nodes

### Background & Project Context
- [[what-is-openclaw-captain-claw-reimplementation]]
- [[the-original-game-monolith-1997]]
- [[goals-of-a-reimplementation-portability-modding-preservation]]
- [[clean-room-vs-asset-dependent-ports]]
- [[legal-boundaries-code-vs-original-game-assets]]
- [[reading-an-existing-c-game-codebase]]

### C++ Foundations for Engines
- [[c-standards-c-11-14-17-20-23]]
- [[raii]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[memory-layout-cache-locality]]
- [[the-stl-in-hot-paths]]
- [[build-systems-cmake-make]]
- [[compilers-gcc-clang-msvc]]
- [[static-dynamic-linking]]
- [[debuggers-gdb-lldb]]

### Reverse Engineering & File Formats
- [[reverse-engineering-mindset-ethics]]
- [[inspecting-binaries-hex-editors-strings]]
- [[disassembly-basics-ida-ghidra]]
- [[identifying-proprietary-file-formats]]
- [[pid-image-format-claw-sprites]]
- [[wwd-level-format]]
- [[rez-archive-resource-packs]]
- [[xmi-audio-format-extraction]]
- [[writing-format-parsers-in-c]]

### Engine Architecture
- [[game-loop-fixed-vs-variable-timestep]]
- [[entity-actor-model]]
- [[component-logic-separation]]
- [[scene-level-management]]
- [[resource-manager-caching]]
- [[event-system-input-handling]]
- [[finite-state-machines-actor-states]]

### Rendering
- [[sdl2-setup-window-management]]
- [[2d-sprite-rendering]]
- [[texture-atlases-tilesets]]
- [[parallax-scrolling-backgrounds]]
- [[animation-system-frames-timing]]
- [[camera-viewport]]
- [[hud-ui-overlay]]

### Audio
- [[sdl-mixer-integration]]
- [[sound-effects-channels]]
- [[music-playback-midi-xmi-conversion]]

### Gameplay Systems
- [[aabb-collision-detection]]
- [[tile-based-physics-gravity]]
- [[player-controller-claw-movement]]
- [[enemy-ai-behaviours]]
- [[pickups-score-health]]
- [[checkpoints-level-transitions]]

### Tooling, Build & Distribution
- [[asset-extraction-pipeline]]
- [[logging-in-game-console]]
- [[profiling-performance-tuning]]
- [[continuous-integration-for-c]]
- [[packaging-for-windows-linux-macos]]
- [[contributing-to-the-openclaw-repo]]

## Resources
See [resources.md](./resources.md).

## Project ideas
- Write a standalone CLI tool in C++ that extracts and converts OpenClaw PID sprites into modern PNG spritesheets.
- Build a minimal SDL2 2D platformer skeleton (game loop + AABB collision + parallax) that mirrors OpenClaw's core architecture.
- Use Ghidra to reverse one Captain Claw level (WWD) format field-by-field and document the byte layout in a spec.
