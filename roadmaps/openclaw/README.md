---
title: OpenClaw
roadmap: openclaw
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, game-dev]
---

# OpenClaw

> roadmap.sh: https://roadmap.sh/openclaw

Track for the **OpenClaw** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Background & Project Context
- [ ] What is OpenClaw (Captain Claw reimplementation)
- [ ] The Original Game (Monolith, 1997)
- [ ] Goals of a Reimplementation (portability, modding, preservation)
- [ ] Clean-Room vs Asset-Dependent Ports
- [ ] Legal Boundaries (code vs original game assets)
- [ ] Reading an Existing C++ Game Codebase

### C++ Foundations for Engines
- [ ] Modern C++ (C++11/14/17)
- [ ] RAII & Resource Ownership
- [ ] Smart Pointers (`unique_ptr`, `shared_ptr`)
- [ ] Memory Layout & Cache Locality
- [ ] The STL in Hot Paths
- [ ] Build Systems (CMake)
- [ ] Cross-Platform Compilation (GCC/Clang/MSVC)
- [ ] Static & Dynamic Linking
- [ ] Debugging (gdb / lldb / Visual Studio)

### Reverse Engineering & File Formats
- [ ] Reverse Engineering Mindset & Ethics
- [ ] Inspecting Binaries (hex editors, `strings`)
- [ ] Disassembly Basics (IDA / Ghidra)
- [ ] Identifying Proprietary File Formats
- [ ] PID Image Format (Claw sprites)
- [ ] WWD Level Format
- [ ] REZ Archive / Resource Packs
- [ ] XMI / Audio Format Extraction
- [ ] Writing Format Parsers in C++

### Engine Architecture
- [ ] Game Loop (fixed vs variable timestep)
- [ ] Entity / Actor Model
- [ ] Component & Logic Separation
- [ ] Scene / Level Management
- [ ] Resource Manager & Caching
- [ ] Event System & Input Handling
- [ ] Finite State Machines (actor states)

### Rendering
- [ ] SDL2 Setup & Window Management
- [ ] 2D Sprite Rendering
- [ ] Texture Atlases & Tilesets
- [ ] Parallax Scrolling Backgrounds
- [ ] Animation System (frames & timing)
- [ ] Camera & Viewport
- [ ] HUD & UI Overlay

### Audio
- [ ] SDL_mixer Integration
- [ ] Sound Effects & Channels
- [ ] Music Playback (MIDI/XMI conversion)

### Gameplay Systems
- [ ] AABB Collision Detection
- [ ] Tile-Based Physics & Gravity
- [ ] Player Controller (Claw movement)
- [ ] Enemy AI Behaviours
- [ ] Pickups, Score & Health
- [ ] Checkpoints & Level Transitions

### Tooling, Build & Distribution
- [ ] Asset Extraction Pipeline
- [ ] Logging & In-Game Console
- [ ] Profiling & Performance Tuning
- [ ] Continuous Integration for C++
- [ ] Packaging for Windows / Linux / macOS
- [ ] Contributing to the OpenClaw Repo

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Write a standalone CLI tool in C++ that extracts and converts OpenClaw PID sprites into modern PNG spritesheets.
- Build a minimal SDL2 2D platformer skeleton (game loop + AABB collision + parallax) that mirrors OpenClaw's core architecture.
- Use Ghidra to reverse one Captain Claw level (WWD) format field-by-field and document the byte layout in a spec.
