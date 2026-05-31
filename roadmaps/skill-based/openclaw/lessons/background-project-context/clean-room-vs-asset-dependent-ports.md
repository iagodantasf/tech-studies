---
title: Clean-Room vs Asset-Dependent Ports
track: openclaw
group: Background & Project Context
tags: [openclaw, clean-room]
prerequisites: []
see-also: [legal-boundaries-code-vs-original-game-assets, reverse-engineering-mindset-ethics]
---

# Clean-Room vs Asset-Dependent Ports

A **clean-room** re-implementation writes 100% new *code* from observed behaviour and format specs, while remaining **asset-dependent** — it refuses to ship the original's copyrighted *content* and instead loads the user's own copy.

## Why it matters

This split is what keeps projects like OpenClaw, OpenMW, and devilutionX legally durable and accepted upstream. Mixing the two — copying decompiled code, or bundling ripped sprites — is exactly what gets a project DMCA'd. Understanding the boundary tells you what you may write, read, and distribute, and what you must leave on the user's disk. See [[legal-boundaries-code-vs-original-game-assets]].

## How it works

Two independent axes, often confused:

| Axis | Clean-room (good) | Tainted / bundled (risky) |
|---|---|---|
| **Code origin** | New code from black-box behaviour + format docs | Copy-pasted decompiler output |
| **Asset source** | User supplies original data file at runtime | Assets shipped in the repo/release |

A defensible project is **clean-room code + asset-dependent runtime**. The clean-room discipline (the classic Phoenix BIOS pattern): people who *observe* the original behaviour and write the *spec* are separated from those who *implement* against the spec, so no copyrighted expression leaks into the new source. OpenClaw decodes [[identifying-proprietary-file-formats|proprietary formats]] this way — documenting bytes, then writing fresh [[writing-format-parsers-in-c|parsers]].

## Example

OpenClaw in practice:

- **Clean-room code** — its [[wwd-level-format|WWD]] and [[pid-image-format-claw-sprites|PID]] parsers are hand-written from reverse-engineered layouts; no Monolith source is linked.
- **Asset-dependent** — the build contains *no* sprites, levels, or music; the player points it at their `CLAW.REZ`, which the engine reads at runtime.

Contrast: a naive "port" that runs a decompiled `.exe` through a translator and bundles extracted PNGs is *neither* clean-room *nor* asset-dependent — and is the unsafe path.

## Pitfalls

- **"I'll just peek at the disassembly to copy the algorithm"** — that taints the code; document the *behaviour*, then re-derive the implementation.
- **Committing a test asset "temporarily"** — a single ripped sprite in git history makes the whole repo redistributable infringement.
- **Conflating format *spec* with copyrighted *content*** — the byte layout of WWD is fact/interface; the level data filling it is the copyrighted work.

## See also

- [[legal-boundaries-code-vs-original-game-assets]]
- [[reverse-engineering-mindset-ethics]]
