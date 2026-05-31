---
title: REZ Archive / Resource Packs
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, archive-format]
prerequisites: [identifying-proprietary-file-formats]
see-also: [resource-manager-caching, asset-extraction-pipeline]
---

# REZ Archive / Resource Packs

Lithtech's `LTRES` container — a single `CLAW.REZ` file that bundles every level, sprite, sound, and palette behind a tree of virtual paths, like an uncompressed ZIP for the WAP engine.

## Why it matters

`CLAW.REZ` is the *one* file the user must legally own, and the root of OpenClaw's whole asset pipeline — open it and you can reach [[wwd-level-format|WWD]] levels, [[pid-image-format-claw-sprites|PID]] sprites, PCX bitmaps, and [[xmi-audio-format-extraction|XMI]] music by name. The engine's [[resource-manager-caching|resource manager]] is essentially a REZ reader with a cache on top. Getting the directory walk right is the prerequisite for decoding everything else.

## How it works

REZ stores files contiguously and keeps a separate directory tree describing where each lives:

- **Header** — magic `LTRES`, version, and a pointer (offset + size) to the **root directory block**.
- **Directory entries** — each is either a *sub-directory* (recurse) or a *resource* (a leaf file).
- **Resource entry** — holds the data `offset`, `size`, a 4-char **type** (space-padded, e.g. `PID`, `WAV`), the timestamp, and a null-terminated name.
- **Type tags** are stored *reversed* (FOURCC quirk): the on-disk bytes for type `"WAV"` read back-to-front — read 4 bytes and reverse them.

All multibyte fields are little-endian 32-bit. Lookup is path-based: split `"LEVEL1/TILES/ACTION.PID"` on `/`, descend the directory tree matching each component, then `seek(offset)` and `read(size)` the leaf. Data is *stored, not compressed* — the offset/size point straight at usable bytes, so extraction is a plain copy. Contrast a real ZIP, which would need per-entry inflate.

## Example

```text
hdr = read(); seek(hdr.dirOffset)
dir = read_dir_block(hdr.dirSize)
entry = find(dir, "CLAW.WWD")     # walk tree by name
seek(entry.offset)
wwd_bytes = read(entry.size)      # raw, no decompress
parse_wwd(wwd_bytes)
```

A typical `CLAW.REZ` is ~70 MB holding tens of thousands of entries. Because access is by virtual path and data is uncompressed, you can `seek` directly to one 4 KB sprite without touching the rest of the archive.

## Pitfalls

- **Forgetting to reverse the type FOURCC** — comparing raw against `"PID "` never matches; the on-disk bytes are reversed.
- **Assuming compression** — REZ is stored, not deflated; running inflate over it yields garbage.
- **Loading the whole file into RAM** — at 70 MB you `seek`/`read` per entry; do not slurp it.
- **Case-sensitive path matching** — internal paths came from DOS/Win32; match case-insensitively or lookups fail on some builds.

## See also

- [[resource-manager-caching]]
- [[asset-extraction-pipeline]]
