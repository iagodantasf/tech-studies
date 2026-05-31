---
title: Camera & Viewport
track: openclaw
group: Rendering
tags: [openclaw, camera]
prerequisites: [2d-sprite-rendering, sdl2-setup-window-management]
see-also: [parallax-scrolling-backgrounds, player-controller-claw-movement, scene-level-management]
---

# Camera & Viewport

The world-to-screen transform that follows Claw, keeps him centered, and exposes a viewport rectangle used for scrolling and off-screen culling.

## Why it matters

Levels are far larger than the 640x480 surface, so something must decide which slice is visible and shift every drawn object accordingly. OpenClaw's `CameraNode` holds a target (Claw), a position, and a cached `SDL_Rect` viewport. That rect feeds three systems: it sets the scroll offset for [[parallax-scrolling-backgrounds|parallax planes]], it bounds which tiles get drawn, and it culls projectiles that leave the screen. Get the centering math wrong and the player walks off the edge of the view.

## How it works

A node renders at `worldPos - cameraRect.origin`; the camera's job is to choose that origin. Following a target centers it:

```text
cameraPos.x = target.x - (width  / 2) / scale.x
cameraPos.y = target.y - (height / 2) / scale.y
CalcCameraRect();   // refresh cached {x, y, w, h}
```

- **Center on target.** Subtracting half the viewport puts Claw in the middle; the divide by `scale` (from [[sdl2-setup-window-management|RenderSetScale]]) converts device pixels back to logical units so centering is correct at any zoom.
- **Cached rect.** The viewport `SDL_Rect` is recomputed only when the camera moves (`CalcCameraRect`), not per query, since dozens of nodes read it each frame.
- **Off-screen culling.** `IntersectsWithPoint(p, scale)` tests a point against the rect grown by `scale`, so a projectile a little past the edge is kept until clearly gone, then destroyed — keeps the [[scene-level-management|scene]] from accumulating dead actors.
- **Camera offset / shake.** A separate `m_CameraOffset` adds to the position without disturbing the follow target — the hook for screen shake or look-ahead.

## Example

Claw at world (1500, 600), viewport 640x480, scale 2.0:

| Axis | formula | value |
|---|---|---|
| camX | `1500 - (640/2)/2.0` | `1500 - 160 = 1340` |
| camY | `600 - (480/2)/2.0` | `600 - 120 = 480` |

A coin at world (1380, 500) draws at screen `(1380-1340, 500-480) = (40, 20)`; a rat at world (900, 600) yields `(-440, 120)` — left of the viewport, so it is culled, not drawn.

## Pitfalls

- **Forgetting the scale divide.** Centering with raw `width/2` ignores `RenderSetScale` and off-centers the player as zoom changes.
- **Recomputing the rect lazily but reading it stale.** If `CalcCameraRect` isn't called after a move, parallax and culling use last frame's origin and the world judders.
- **No clamp at level edges.** Pure target-follow scrolls past the map border, revealing empty space; clamp `cameraPos` to `[0, levelSize - viewport]` if the design wants hard edges.
- **Culling with the un-grown rect.** Testing against the exact viewport pops objects out one pixel before they're truly off-screen.

## See also

- [[parallax-scrolling-backgrounds]]
- [[player-controller-claw-movement]]
