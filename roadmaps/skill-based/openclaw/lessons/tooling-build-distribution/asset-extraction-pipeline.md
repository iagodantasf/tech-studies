---
title: Asset Extraction Pipeline
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, asset-pipeline]
prerequisites: [rez-archive-resource-packs, writing-format-parsers-in-c]
see-also: [rez-archive-resource-packs, resource-manager-caching, xmi-audio-format-extraction]
---

# Asset Extraction Pipeline

The offline tooling that walks the player's `CLAW.REZ`, decodes each proprietary format to an open one, and emits a directory tree the engine can load at runtime.

## Why it matters

OpenClaw ships *no* game data — the user supplies their legally owned `CLAW.REZ`, and the pipeline converts it on first run (see [[legal-boundaries-code-vs-original-game-assets]]). Decoding [[pid-image-format-claw-sprites|PID]] and [[xmi-audio-format-extraction|XMI]] live, every frame, would burn CPU and complicate the [[resource-manager-caching|resource manager]]; converting once to PNG/OGG up front means the runtime loader is a plain file read. The pipeline is the bridge between the 1997 monolith and a modern, debuggable asset tree.

## How it works

A pipeline is a fan-out over the [[rez-archive-resource-packs|REZ]] directory: classify each leaf by its FOURCC type, route to a decoder, write an open equivalent.

| Source (in REZ) | Decoder step | Output | Note |
|---|---|---|---|
| PID + PCX palette | unpack RLE + apply palette | PNG (RGBA) | palette is a separate entry |
| PCX bitmap | RLE decode | PNG | backgrounds, UI |
| WWD level | parse, keep as-is | WWD / XML | logic stays binary-faithful |
| XMI music | XMI -> SMF -> synth | OGG/WAV | needs a soundfont |
| WAV sound | passthrough | WAV | already usable |

- **Path mirroring.** Preserve the REZ virtual path under an output root (`ASSETS/LEVEL1/TILES/ACTION.png`) so the resource manager maps logical names to files with a string swap, not a database.
- **Palette coupling.** A [[pid-image-format-claw-sprites|PID]] is paletted; its colours live in a sibling PCX/PAL entry. Resolve the palette *before* decoding the sprite or every pixel is wrong.
- **Idempotent + cached.** Hash the input REZ; skip extraction if the output tree already matches. A re-run after a code change should not re-decode 70 MB.
- **Manifest.** Emit a small index (path, type, dims, frame count) so the engine validates assets without re-opening every file.

## Example

```text
for entry in walk(rez):
  match entry.type:
    "PID ": pal = load(sibling_palette(entry)); png = decode_pid(entry, pal)
    "PCX ": png = decode_pcx(entry)
    "XMI ": ogg = xmi_to_ogg(entry, soundfont)
    "WAV ": copy(entry)
  write(mirror_path(entry, OUT), result); manifest.add(entry, dims)
```

A full `CLAW.REZ` (~70 MB, tens of thousands of entries) extracts in a handful of seconds and expands to a browsable tree — sprites you can open in an image viewer, music you can scrub.

## Pitfalls

- **Decoding sprites without the palette** — produces correctly shaped but garbage-coloured PNGs; the palette entry must load first.
- **Re-extracting every launch** — skip via an input hash; users notice a multi-second stall on every start.
- **Committing extracted assets** — the output tree is derived from copyrighted data; keep it out of git and generate it locally only.
- **Lossy audio for SFX** — re-encoding short hits to low-bitrate OGG adds artifacts; passthrough WAV or use high quality.

## See also

- [[rez-archive-resource-packs]]
- [[resource-manager-caching]]
- [[xmi-audio-format-extraction]]
