---
title: HUD & UI Overlay
track: openclaw
group: Rendering
tags: [openclaw, hud]
prerequisites: [2d-sprite-rendering, camera-viewport]
see-also: [pickups-score-health, scene-level-management, logging-in-game-console]
---

# HUD & UI Overlay

The screen-space layer — health, score, ammo, lives — drawn after the world in a fixed position that ignores the camera and anchors to the window edges.

## Why it matters

Claw's status readouts must stay glued to the corners while the level scrolls beneath them. That means the HUD lives in a different coordinate space from actors: it is *not* offset by the [[camera-viewport|camera]], and it anchors to viewport edges so it sits correctly whether the window is 640x480 or 1280x960. OpenClaw renders it as the last [[scene-level-management|render pass]] (`RenderPass_HUD`), painting over everything else.

## How it works

`HUDSceneNode` reuses the sprite path ([[2d-sprite-rendering|Image]] + `SDL_RenderCopyEx`) but computes its destination from window dimensions, not world position:

```text
x = pos.x - W/2 + offsetX;
if (anchoredRight)  x += cameraWidth  / scale.x;   // glue to right edge
if (anchoredBottom) y += cameraHeight / scale.y;   // glue to bottom edge
```

- **Anchors, not world coords.** A bottom-right ammo counter sets `anchoredRight` and `anchoredBottom`; its position becomes "edge minus a margin," so it tracks the window corner across resolutions. The divide by `scale` keeps the margin in logical units.
- **No camera subtraction.** Unlike actors, HUD nodes skip the `- cameraRect.origin` step — they are screen-space by construction, which is why a scrolling level slides under a stationary health bar.
- **Mirror / invert reuse.** The same `SDL_FLIP_HORIZONTAL` and offset-negation from sprites apply, so a UI element can face either way without duplicate art.
- **Drawn last.** Painting in `RenderPass_HUD` after Background/Action/Foreground guarantees the overlay is never occluded by foreground tiles.

## Example

A lives icon anchored bottom-right, image 52x14 with offset (0,0), window 1280x960 (scale 2.0), at logical margin pos (−10, −6):

| Term | value |
|---|---|
| base x | `-10 - 52/2 + 0 = -36` |
| `+ cameraWidth/scale` | `-36 + 1280/2.0 = 604` |
| base y | `-6 - 14/2 = -13` |
| `+ cameraHeight/scale` | `-13 + 960/2.0 = 467` |

The icon lands at logical (604, 467) — hugging the bottom-right of the 640x480 logical surface regardless of the real window size.

## Pitfalls

- **Offsetting the HUD by the camera.** Subtracting the camera origin makes the health bar scroll away with the level; HUD is screen-space only.
- **Pixel anchors instead of edge-relative.** Hard-coding "x = 600" breaks the moment the resolution changes; anchor to `cameraWidth/scale`.
- **Drawing the HUD before the world.** Render it in an earlier pass and foreground tiles paint over your score.
- **Forgetting the scale divide on the anchor.** Adding raw `cameraWidth` (device px) double-counts the zoom and shoves UI off-screen.

## See also

- [[pickups-score-health]]
- [[scene-level-management]]
