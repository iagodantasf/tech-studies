---
title: Inspecting Binaries (hex editors, `strings`)
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, binary-inspection]
prerequisites: [reverse-engineering-mindset-ethics]
see-also: [identifying-proprietary-file-formats, character-encodings]
---

# Inspecting Binaries (hex editors, `strings`)

Static, non-executing inspection of an unknown file's raw bytes to recover its magic number, structure, embedded text, and byte order before any parser is written.

## Why it matters

Every WAP-engine format ([[rez-archive-resource-packs|REZ]], [[wwd-level-format|WWD]], [[pid-image-format-claw-sprites|PID]]) is undocumented binary. The first hour with `strings`, `xxd`, and a GUI hex editor tells you 80% of the layout for free: signatures, version numbers, internal path tables, and counts. Skipping this and jumping straight to [[disassembly-basics-ida-ghidra|disassembly]] is the classic time-sink.

## How it works

Core toolkit and what each is for:

| Tool | Use |
|---|---|
| `strings -n 6 file` | embedded paths, magic ASCII, format tags |
| `xxd` / `hexdump -C` | byte-level offset view, header layout |
| `file` | guesses type from magic (often "data" for proprietary) |
| ImHex / 010 Editor | GUI, templates, struct overlays, search |

Reading bytes, you watch for: a **magic** at offset 0 (REZ files start with the ASCII tag `LTRES`), **little-endian** 32-bit counts/offsets (x86 origin — least significant byte first), **null-terminated** path strings, and **alignment padding** (runs of `00`). Map endianness early: bytes `2C 01 00 00` are `0x0000012C` = 300, *not* `0x2C010000`. See [[character-encodings]] for how text fields are stored.

## Example

```text
$ strings -n 5 CLAW.REZ | head
LTRES
WAVE
PCX
LEVEL1
CLAW.WWD
$ xxd CLAW.REZ | head -1
00000000: 4c54 5245 5300 0000 0100 0000 ...  LTRES.......
```

`4c 54 52 45 53` = `"LTRES"`, then a null, then `01 00 00 00` = version 1 (LE). The visible paths (`CLAW.WWD`, `LEVEL1`) confirm REZ holds a directory of named, virtual files.

## Pitfalls

- **Assuming big-endian** — these are DOS/Win32 x86 formats; everything multibyte is little-endian.
- **Trusting `file`** — it reports "data" for unknown magics, which means nothing about structure.
- **Default `strings -n 4`** — floods you with 4-char noise; raise to `-n 6` and grep for likely tokens.
- **Editing in place to "test"** — always work on a copy; a one-byte slip corrupts the only data file the user owns.

## See also

- [[identifying-proprietary-file-formats]]
- [[disassembly-basics-ida-ghidra]]
