---
title: The Original Game (Monolith, 1997)
track: openclaw
group: Background & Project Context
tags: [openclaw, game-history]
prerequisites: []
see-also: [what-is-openclaw-captain-claw-reimplementation, identifying-proprietary-file-formats]
---

# The Original Game (Monolith, 1997)

Captain Claw is a 1997 DOS/Windows 2D side-scrolling platformer by Monolith Productions, built on Monolith's in-house **WAP (Windows Animation Package)** engine — the same toolchain whose file formats OpenClaw must decode.

## Why it matters

You cannot re-implement an engine you do not understand. Knowing the original's runtime — what a level *is*, how a sprite is stored, where audio lives — directly determines the parsers and systems OpenClaw needs. The 1997 design constraints (limited RAM, fixed-point math, 8-bit palettes) explain quirks you will reproduce or deliberately drop.

## How it works

Captain Claw shipped as a Win32 executable plus a single packed data archive. Everything the player ever sees is inside that archive:

| Artifact | Format | Holds |
|---|---|---|
| `CLAW.REZ` | REZ archive | All assets, as a virtual file tree |
| `*.WWD` | WWD | Level: tile grid, actor placements, planes |
| `*.PID` | PID | Palettized sprite / tile images |
| `*.PAL` | Palette | 256-colour tables for PID images |
| `*.XMI` | XMI/IMA | Music (MIDI-derived) |

The engine is a classic tile + actor platformer: a level is several scrolling **planes** (parallax + a main action plane), the action plane is a grid of tile indices, and gameplay objects are **actors** placed at coordinates. See [[wwd-level-format]] and [[pid-image-format-claw-sprites]].

## Example

Captain Claw's data scale (approximate, retail build): **14 levels** across **4 chapters**, hundreds of `.PID` sprites per level set, music as `.XMI` tracks that must be converted to a modern format ([[xmi-audio-format-extraction]]) because no mainstream library plays XMI directly. A single boss like *Katherine* or *Le Rauxe* is just another actor entry with its own animation `.PID` set.

## Pitfalls

- **Treating PID images as RGB** — they are palette indices; you must pair each with the correct `.PAL` or every sprite renders as garbage colours.
- **Assuming a flat filesystem** — assets live *inside* `CLAW.REZ` with internal paths, not as loose files on disk.
- **Forgetting fixed-point** — 1997 positions/velocities are integers/fixed-point; naive float ports introduce subtle drift.

## See also

- [[what-is-openclaw-captain-claw-reimplementation]]
- [[rez-archive-resource-packs]]
