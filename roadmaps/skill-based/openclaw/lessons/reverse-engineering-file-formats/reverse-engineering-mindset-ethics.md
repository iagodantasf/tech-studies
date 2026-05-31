---
title: Reverse Engineering Mindset & Ethics
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, ethics]
prerequisites: [legal-boundaries-code-vs-original-game-assets]
see-also: [clean-room-vs-asset-dependent-ports, identifying-proprietary-file-formats]
---

# Reverse Engineering Mindset & Ethics

The disciplined practice of recovering *just enough* structure from a closed binary to re-create its behaviour in new code, without ever copying or shipping the original's protected material.

## Why it matters

Reimplementing Captain Claw means decoding Monolith's undocumented WAP-engine formats ([[pid-image-format-claw-sprites|PID]], [[wwd-level-format|WWD]], [[rez-archive-resource-packs|REZ]]). Get the ethics wrong and the project is a copyright liability instead of a preservation effort; get the *mindset* wrong and you waste weeks guessing instead of observing. The goal is a clean-room engine where the only Monolith bytes that ever exist are in the user's own retail `CLAW.REZ` on their own disk.

## How it works

The working stance is "format archaeology, not theft":

- **Decode formats, never redistribute data** — parsing `CLAW.REZ` is fine; checking a sprite frame into git is not. The line is *code vs assets* — see [[legal-boundaries-code-vs-original-game-assets]].
- **Observe, then hypothesise, then verify** — never assume a field's meaning; confirm it by re-rendering and diffing against the running original.
- **Prefer black-box over disassembly** — watching what `CLAW.EXE` loads (file offsets, palette draws) is cheaper and legally cleaner than [[disassembly-basics-ida-ghidra|disassembling]] it.
- **Clean-room separation** — ideally one person documents the format, another writes the engine from that spec. See [[clean-room-vs-asset-dependent-ports]].

Legal footing differs from facts: in the US, *Sega v. Accolade* (1992) held that intermediate copying to reach unprotectable interfaces can be fair use, and APIs/formats are not themselves copyrightable. That protects re-creating the *engine*; it never licenses shipping the *art*.

The same separation shapes how the repo is built: the parser code is MIT-licensed and public, while the data path expects the user to point the engine at their own retail file. Nothing in the build pipeline ever writes a Monolith byte to disk in the source tree — extraction happens at runtime, on the user's machine, against the user's `CLAW.REZ`.

## Example

You suspect bytes at PID offset `0x20` are a palette index. Workflow: hex-dump the header, note the value, write a parser that maps it through the level palette, render the frame, screenshot the original at the same animation step, diff the two PNGs. Match -> hypothesis confirmed and documented. Mismatch -> revise, never "force" the data to fit.

## Pitfalls

- **Treating a decompiler dump as your own code** — copy-pasted Ghidra output is a derivative work, not clean-room.
- **Committing test assets** — a single extracted `.pid` frame "just for a unit test" poisons the repo's license.
- **Bundling `CLAW.REZ` for convenience** — distributing the data file is the one thing that turns a legal project illegal.
- **Confusing legal with ethical** — even where fair use applies, redistributing someone's art is still wrong and gets projects taken down.

## See also

- [[legal-boundaries-code-vs-original-game-assets]]
- [[clean-room-vs-asset-dependent-ports]]
