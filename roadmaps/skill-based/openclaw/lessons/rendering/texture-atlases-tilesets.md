---
title: Texture Atlases & Tilesets
track: openclaw
group: Rendering
tags: [openclaw, tilesets]
prerequisites: [2d-sprite-rendering]
see-also: [parallax-scrolling-backgrounds, wwd-level-format, resource-manager-caching]
---

# Texture Atlases & Tilesets

Packing many small images into one large texture (or indexing a tileset by id) so the GPU can draw a whole level with far fewer state changes.

## Why it matters

A Captain Claw level plane is a grid of tiles referenced by integer id; the [[wwd-level-format|WWD]] stores those ids, and a parallel image list maps id → tile bitmap. Drawing thousands of 64x64 tiles as thousands of separately-bound textures stalls on per-draw overhead. Whether you keep one texture per tile (OpenClaw's current approach) or true-atlas them into one sheet, the indexing discipline — id to source rectangle — is the same skill, and atlasing is the standard win when overhead bites.

## How it works

The tileset is a flat list; the level is a 2D array of ids into it. OpenClaw resolves a `(row, col)` cell to an image with one multiply:

```text
Image* tile = imageList[ rowIndex * tilesOnAxisX + colIndex ];
```

- **Id is row-major.** The tileset is conceptually `tilesOnAxisX` wide; `index = row * width + col`. This is the same linear-to-2D mapping used by [[arrays-and-dynamic-arrays|flat arrays]].
- **One texture vs an atlas.** Per-tile textures are simplest and let each tile be a distinct `Image`. A true atlas packs them into one big texture and passes a source `SDL_Rect` to `SDL_RenderCopy` to crop the wanted cell — same destination math, one bind for the whole plane.
- **Padding / bleed.** In a real atlas, sampling at a tile edge can pull a neighbor's pixel ("texture bleed"); leave a 1-2 px gutter or clamp UVs. With separate textures this cannot happen, which is one reason OpenClaw keeps them split.
- **Empty cells.** Id `-1` (or a sentinel) means "no tile here"; the renderer skips it rather than drawing a blank, saving draws on sparse [[parallax-scrolling-backgrounds|foreground]] planes.

## Example

A 4x3 tileset (`tilesOnAxisX = 4`) and a level row `[5, 5, 6, -1, 5]`:

| col | id | index math | source |
|---|---|---|---|
| 0 | 5 | `1*4 + 1` | row 1, col 1 |
| 1 | 5 | `1*4 + 1` | row 1, col 1 |
| 2 | 6 | `1*4 + 2` | row 1, col 2 |
| 3 | -1 | — | skipped |
| 4 | 5 | `1*4 + 1` | row 1, col 1 |

Three identical id-5 cells reuse one texture; the GPU binds it once and blits it thrice.

## Pitfalls

- **Wrong stride.** Using level width instead of `tilesOnAxisX` to index the tileset scrambles every tile; the two grids have different widths.
- **Atlas too large.** Some GL backends cap textures at 4096x4096 or 8192; an over-packed sheet silently fails to upload.
- **No gutter in a packed atlas.** Bilinear filtering bleeds neighbor pixels at seams; pad each cell or use nearest-neighbor.
- **Not caching the tileset.** Re-decoding tiles per level reload is wasteful; hold them in the [[resource-manager-caching|cache]] keyed by archive path.

## See also

- [[parallax-scrolling-backgrounds]]
- [[wwd-level-format]]
