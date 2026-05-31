---
title: Tile-Based Physics & Gravity
track: openclaw
group: Gameplay Systems
tags: [openclaw, physics]
prerequisites: [aabb-collision-detection, wwd-level-format]
see-also: [aabb-collision-detection, player-controller-claw-movement, game-loop-fixed-vs-variable-timestep]
---

# Tile-Based Physics & Gravity

How Claw's world resolves movement against a grid of attributed tiles — gravity integration, swept collision, ground/wall/ladder flags — without a general-purpose physics engine.

## Why it matters

A 1997 platformer doesn't need rigid-body dynamics; it needs predictable, frame-perfect movement against static geometry. The level's collision lives in the [[wwd-level-format|WWD]] action plane as per-tile attribute flags, so "physics" here means: apply gravity, propose a move, and clip that move against the handful of tiles the actor would cross. Doing it as a swept query against tiles (not actor-vs-actor) keeps it O(tiles-spanned) and deterministic — the same input always yields the same landing pixel, which platformer feel depends on.

## How it works

Each action-plane tile carries an attribute resolved from its index:

| Flag | Meaning | Blocks |
|---|---|---|
| `solid` | full wall/floor | all 4 sides |
| `ground` | one-way top (clip) | top only |
| `climb` | ladder/rope | none; enables climb |
| `death` | spikes/lava | triggers kill |

The per-frame step, run on a fixed timestep (see [[game-loop-fixed-vs-variable-timestep]]):

- **Integrate gravity.** `vy += g*dt`, clamp to `vyMax` (terminal velocity) so a long fall can't tunnel. Typical: `g ~ 2200 px/s²`, cap `vy ~ 900 px/s`.
- **Sweep, axis-separated.** Move X by `vx*dt`, query the tile cells the [[aabb-collision-detection|AABB]] now spans, clip to the nearest solid edge, zero `vx` on contact. Repeat for Y. Separating axes is what lets you slide along a wall while still falling.
- **Ground check.** After the Y sweep, probe one pixel below the feet: standing on `solid`/`ground` sets `onGround=true`, which re-enables jump and clears `vy`.
- **One-way platforms.** `ground` tiles only clip when moving **down** and the actor's previous bottom was above the tile top — otherwise you can jump up through them.

Cells spanned = `floor(edge / tileSize)`; with 64px tiles a 32x56 actor touches at most 2x2 cells, so each sweep tests ~4 tiles, not the whole map.

## Example

Claw walks off a ledge, `dt = 1/60`:

```text
frame 0: onGround=false, vy=0
vy += 2200*0.0167  -> vy = 36.7 px/s ; y += 0.61
... vy grows each frame, clamped at 900
landing: Y-sweep finds 'solid' tile top at y=896
clip y to 896-56=840, vy=0, onGround=true
```

The clip snaps his feet exactly to the tile top instead of overlapping into it, so he lands flush every time regardless of fall speed.

## Pitfalls

- **Variable timestep into gravity** makes jump height frame-rate-dependent; integrate physics on a fixed step and only interpolate for rendering.
- **No terminal-velocity clamp** lets a deep fall exceed tile size in one frame and tunnel through the floor (see [[aabb-collision-detection]] tunnelling).
- **Querying tiles from world pixels without unit conversion** — WWD objects are in pixels, the grid in cells; forgetting `/tileSize` reads the wrong tile.
- **One-way platforms tested by overlap, not by direction + previous position** — actors get shoved up through them or can't drop down.

## See also

- [[aabb-collision-detection]]
- [[player-controller-claw-movement]]
- [[game-loop-fixed-vs-variable-timestep]]
