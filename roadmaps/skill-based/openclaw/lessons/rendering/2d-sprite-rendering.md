---
title: 2D Sprite Rendering
track: openclaw
group: Rendering
tags: [openclaw, sprites]
prerequisites: [sdl2-setup-window-management, pid-image-format-claw-sprites]
see-also: [texture-atlases-tilesets, animation-system-frames-timing, camera-viewport]
---

# 2D Sprite Rendering

Turning a decoded [[pid-image-format-claw-sprites|PID]] sprite into an `SDL_Texture` and blitting it at the right screen position, with the per-sprite anchor offset and horizontal flip the original game relies on.

## Why it matters

Everything visible in Captain Claw — Claw, enemies, pickups, projectiles — is a sprite. The catch is that PID frames are *not* centered and *not* uniform size: each frame carries its own width, height, and a signed (offsetX, offsetY) that positions it relative to the actor's logical point. Ignore the offset and Claw's sword swings float a dozen pixels off his arm. The `Image` class is the thin wrapper that keeps this correct.

## How it works

OpenClaw's `Image` owns one `SDL_Texture*` plus four ints: `m_Width`, `m_Height`, `m_OffsetX`, `m_OffsetY`. Construction goes PID → `SDL_Surface` → `SDL_CreateTextureFromSurface`.

- **Placement formula.** A frame is drawn so the actor's position maps to the frame's *center* plus its anchor:

| Term | Meaning |
|---|---|
| `pos.x/y` | actor's world position |
| `-W/2, -H/2` | shift so the frame centers on `pos` |
| `+offsetX/Y` | PID anchor (mirrored when flipped) |

  giving `x = pos.x - W/2 + offsetX`, then minus the [[camera-viewport|camera]] origin for screen space.
- **Flipping, not duplicating.** Left-facing art is the right-facing texture drawn with `SDL_RenderCopyEx(..., SDL_FLIP_HORIZONTAL)`; the offset's sign is negated so the anchor mirrors too. This halves texture memory.
- **Color key / alpha.** PCX-backed images use a color key (magenta → transparent); PID frames carry alpha directly. The transparent pixel must be set on the surface *before* the texture is created.
- **Coordinates are logical.** Because the renderer is pre-scaled (see [[sdl2-setup-window-management]]), the blit rect is in 640x480 space and SDL multiplies it.

## Example

```text
// 40x55 frame, anchor (offsetX=-3, offsetY=+8), actor at (200, 120), facing left
x = 200 - 40/2 + (-(-3)) = 200 - 20 + 3 = 183
y = 120 - 55/2 +   8     = 120 - 27 + 8 = 101
SDL_Rect dst = { x - camX, y - camY, 40, 55 };
SDL_RenderCopyEx(r, tex, NULL, &dst, 0, NULL, SDL_FLIP_HORIZONTAL);
```

## Pitfalls

- **Dropping the offset.** Centering on width/height alone makes attached effects (muzzle flash, sword arc) drift; the per-frame anchor is mandatory.
- **Not mirroring the offset on flip.** Flip the texture but keep `+offsetX` and the anchor jumps to the wrong side.
- **`SDL_RenderCopy` for flips.** The non-Ex variant cannot flip; you need `SDL_RenderCopyEx` even for a horizontal mirror.
- **Per-frame texture creation.** Building a texture every draw thrashes the GPU; create once at load and cache in the [[resource-manager-caching|resource manager]].

## See also

- [[pid-image-format-claw-sprites]]
- [[animation-system-frames-timing]]
