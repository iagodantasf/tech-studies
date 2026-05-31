---
title: Parallax Scrolling Backgrounds
track: openclaw
group: Rendering
tags: [openclaw, parallax]
prerequisites: [texture-atlases-tilesets, camera-viewport]
see-also: [2d-sprite-rendering, wwd-level-format, scene-level-management]
---

# Parallax Scrolling Backgrounds

Scrolling each background plane at a fraction of the camera's speed so distant layers lag behind near ones, creating a cheap illusion of depth.

## Why it matters

Captain Claw's levels stack several tile planes — far sky, mid scenery, the playfield, and a near foreground. The [[wwd-level-format|WWD]] gives each plane a `movementPercent`: 100 means it locks to the camera (the action plane), 50 means it scrolls half as fast (looks far away), 0 means it never moves (a fixed backdrop). This single per-plane scalar is what sells parallax, and it's a few lines of arithmetic per plane per frame.

## How it works

Each plane computes its own apparent camera position from the real [[camera-viewport|camera]] rect, then renders only the tiles that fall in view:

```text
ratioX  = movementPercentX / 100.0
paraX   = cameraRect.x * ratioX          // this plane's scroll offset
startCol = paraX / tilePixelWidth        // first visible column
tileX    = col * tilePixelWidth - paraX  // on-screen x of that tile
```

- **Fraction of the camera.** A plane at `movementPercent = 40` uses `paraX = cameraRect.x * 0.4`, so when the camera moves 100 px the plane shifts 40 — it appears 2.5x further away.
- **Cull to the viewport.** Only `cameraRect.w / tilePixelWidth + 2` columns are drawn; the `+2` covers the partial tiles at both edges after the float→int truncation of `startCol`.
- **Wrapping planes.** Sky/back planes set `isWrapped` and tile infinitely via modulo: `tileIndex = col % tilesOnAxisX`, so a 16-wide sky repeats forever without storing more data. See the [[texture-atlases-tilesets|tileset]] indexing.
- **Draw order.** Planes render back-to-front by [[scene-level-management|render pass]] (Background → Action → Foreground), so near layers paint over far ones.

## Example

Camera at world x = 1000, three planes, tiles 64 px wide:

| Plane | movementPercent | paraX | first col | feels |
|---|---|---|---|---|
| Sky | 0 | 0 | 0 | fixed backdrop |
| Hills | 40 | 400 | 6 | far |
| Action | 100 | 1000 | 15 | player layer |

The sky never shifts, hills drift slowly, the action plane tracks Claw 1:1 — three depths from one camera value.

## Pitfalls

- **Scrolling sprites by full camera but background by fraction inconsistently.** Mixing the two coordinate spaces makes actors slide relative to the ground; actors live on the 100% plane.
- **Off-by-one cull.** Dropping the `+2` padding leaves a one-tile gap flickering at the screen edge as `startCol` truncates.
- **Wrapping without modulo on the negative side.** Negative `col` can index out of bounds when the camera moves left of origin; guard or wrap both directions.
- **Per-frame full-plane redraw.** Iterating every tile in the level instead of the visible window murders the framerate on large maps.

## See also

- [[camera-viewport]]
- [[texture-atlases-tilesets]]
