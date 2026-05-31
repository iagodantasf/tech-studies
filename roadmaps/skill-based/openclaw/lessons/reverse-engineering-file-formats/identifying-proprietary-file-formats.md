---
title: Identifying Proprietary File Formats
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, file-formats]
prerequisites: [inspecting-binaries-hex-editors-strings]
see-also: [rez-archive-resource-packs, writing-format-parsers-in-c]
---

# Identifying Proprietary File Formats

Classifying an unknown extension by its magic number, internal structure, and container relationships so you know *what kind of thing* it is before decoding it.

## Why it matters

Captain Claw ships a handful of cryptic extensions — `.REZ`, `.WWD`, `.PID`, `.ANI`, `.PCX`, `.XMI`. Knowing which are containers, which are images, and which are audio lets you decode them in the right order ([[rez-archive-resource-packs|archive]] first, contents after) instead of flailing. Many are Monolith-specific WAP-engine formats with no public spec; a few are repurposed industry standards in disguise.

## How it works

Identification proceeds magic-first, then structure:

| Ext | Magic / tell | What it is |
|---|---|---|
| REZ | `LTRES` at 0 | Lithtech resource archive (container) |
| WWD | `WWD\0` near start | "World" / level definition |
| PID | width/height header | Lithtech sprite image |
| PCX | `0x0A` byte 0 | ZSoft Paintbrush bitmap |
| XMI | `FORM`...`XDIR` | Miles extended MIDI (audio) |
| WAV | `RIFF`...`WAVE` | standard PCM audio |

Signals to read in order: **magic number** (first 2-8 bytes) is the strongest tell; **container vs leaf** (does it hold a path table, like REZ, or raw pixels, like PID); **standard-in-disguise** (PCX and WAV are public formats Monolith simply embedded). When no magic exists, fall back on **fixed-size headers** — a PID has no signature but a stable width/height/offset layout. Cross-check against a known DB: many magics are catalogued in `file`'s magic database or Gary Kessler's signature list.

## Example

You pull an unnamed blob out of REZ. Byte 0 is `0x0A`, byte 1 is `0x05` (version), byte 2 is `0x01` (RLE encoding) — that is the PCX header signature, so it is a ZSoft bitmap and you can reuse an existing PCX loader rather than reverse-engineering anything. Contrast a PID, which has *no* magic: you identify it positionally, by its consistent 32-byte header inside sprite-bearing REZ entries.

## Pitfalls

- **Trusting the extension** — REZ entries are addressed by internal path; the outer name can lie about contents.
- **Missing embedded standards** — re-deriving PCX or WAV from scratch wastes days; check for known magics first.
- **Assuming one magic per project** — Claw mixes proprietary (PID/WWD) and standard (PCX/WAV/XMI) formats in one archive.
- **Treating headerless formats as corrupt** — PID's lack of a signature is by design, not damage.

## See also

- [[inspecting-binaries-hex-editors-strings]]
- [[rez-archive-resource-packs]]
