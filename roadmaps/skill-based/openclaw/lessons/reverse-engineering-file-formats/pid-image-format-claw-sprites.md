---
title: PID Image Format (Claw sprites)
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, sprite-format]
prerequisites: [identifying-proprietary-file-formats, floating-point-representation]
see-also: [wwd-level-format, 2d-sprite-rendering]
---

# PID Image Format (Claw sprites)

Lithtech's palettised, optionally run-length-encoded single-frame sprite format — every Claw, enemy, and pickup image is a PID decoded against a level palette.

## Why it matters

PID is the bottom of the visual stack: [[wwd-level-format|WWD]] references tiles and actors, but the actual pixels live in thousands of PID files inside [[rez-archive-resource-packs|REZ]]. Decoding PID correctly — header fields, RLE, transparency, palette lookup — is what gets anything on screen. The format is 8-bit indexed, so a PID is meaningless without the matching palette, which is the single most common decode mistake.

## How it works

A PID is a small fixed header followed by pixel data:

| Offset | Size | Field |
|---|---|---|
| 0x00 | 4 | flags (bit0 = RLE, bit1 = mirror) |
| 0x04 | 4 | unknown / reserved |
| 0x08 | 4 | width (LE) |
| 0x0C | 4 | height (LE) |
| 0x10 | 4 | offsetX (signed, hotspot) |
| 0x14 | 4 | offsetY (signed, hotspot) |
| 0x18 | ... | pixel data |

Each pixel byte is an **index into a 256-entry palette**, not an RGB value. Index `0` is the transparent colour (skipped when blitting). When flags bit0 is set, rows are **RLE-compressed**: a control byte's sign splits runs — a positive count copies that many literal index bytes, a negative (high-bit) count emits a run of transparent pixels. `offsetX/Y` are the signed hotspot, used to align the sprite to the actor's logical position. The decoded indices are mapped through the palette to RGBA, then uploaded as an SDL texture — see [[2d-sprite-rendering]].

## Example

A 2x2 opaque PID, RLE off, against a palette where index 5 = red, 9 = blue:

```text
header.flags  = 0
header.width  = 2, height = 2
pixels        = 05 09 09 05
-> row0 [red, blue]
-> row1 [blue, red]
```

With RLE on, a control byte `0x03` means "next 3 bytes are literal indices"; `0x82` (high bit set, low bits = 2) means "2 transparent pixels". A fully transparent 32-pixel row thus costs ~1 control byte instead of 32, which is why backgrounds compress so well.

## Pitfalls

- **Forgetting the palette** — raw indices rendered as greyscale look like garbage; you must map through the level's 256-colour table.
- **Wrong transparent index** — index 0 is the colour key; treat it as opaque and sprites get black boxes.
- **Sign-confusion in RLE** — the control byte is signed; mishandling the high bit desyncs the whole row.
- **Ignoring the hotspot** — drop `offsetX/Y` and sprites jitter, because the actor's anchor is not the image's top-left.

## See also

- [[wwd-level-format]]
- [[2d-sprite-rendering]]
