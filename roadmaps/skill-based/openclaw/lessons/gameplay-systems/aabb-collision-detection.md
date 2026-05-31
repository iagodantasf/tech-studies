---
title: AABB Collision Detection
track: openclaw
group: Gameplay Systems
tags: [openclaw, collision]
prerequisites: [tile-based-physics-gravity, entity-actor-model]
see-also: [tile-based-physics-gravity, player-controller-claw-movement, enemy-ai-behaviours]
---

# AABB Collision Detection

Axis-aligned bounding-box overlap testing — the cheap rectangle-vs-rectangle check that drives Claw's floors, walls, hitboxes, and pickup triggers.

## Why it matters

Captain Claw is a 2D platformer: every actor's footprint is well approximated by an upright rectangle, so a full polygon collision system would be wasted complexity. AABB tests are branch-light and integer-friendly, and they answer the two questions the gameplay needs constantly: *does the player rect overlap a solid tile?* (movement) and *does the sword/claw rect overlap an enemy rect?* (combat). Get the overlap test or the resolution order wrong and you get the classic platformer bugs: sticking to walls, falling through floors at speed, or hits that don't register.

## How it works

An AABB is `{x, y, w, h}` (top-left origin, +y down, as in [[2d-sprite-rendering]]). Two boxes overlap iff they overlap on **both** axes:

```cpp
bool overlap(const Rect& a, const Rect& b) {
    return a.x < b.x + b.w && a.x + a.w > b.x &&
           a.y < b.y + b.h && a.y + a.h > b.y;
}
```

- **Separating-axis shortcut.** The four-term test is the 2D special case of SAT: if a gap exists on either axis, no collision — strict `<` so touching edges don't count as overlap.
- **Penetration / MTV.** For resolution you need *how much* they overlap, not just *if*. Compute overlap on each axis and push out along the axis of **least** penetration; that single-axis push is what stops a wall from also cancelling vertical motion. See [[tile-based-physics-gravity]] for the swept tile version.
- **Broad vs narrow phase.** Don't test every actor against every actor (O(n²)). Claw is tile-based, so the broad phase is "which tile cells does this rect span?" — index the grid, then narrow-phase only the few candidates. See [[memory-layout-cache-locality]].
- **Hitbox != sprite.** Combat uses a separate, usually tighter rect than the visual frame; the player's *body* box (vs tiles) and *attack* box (vs enemies) are distinct rects on the same [[entity-actor-model|actor]].

## Example

Claw (32x56 at x=100) moving right into a wall at x=120:

```text
overlapX = (100+32) - 120 = 12    overlapY large (vertical aligned)
least-penetration axis = X (12px)
resolve: claw.x -= 12  -> claw.x = 88, vx = 0
```

Pushing out 12 px on X (not Y) leaves him standing flush against the wall, still able to fall or jump — exactly the platformer feel.

## Pitfalls

- **Resolving both axes at once** snaps the actor to a corner and causes wall-sticking; resolve one axis (least penetration) or sweep X then Y separately.
- **`<=` instead of `<`** makes flush-adjacent boxes "collide", so an actor standing *on* a floor reads as overlapping it every frame and jitters.
- **Tunnelling at high speed** — a fast actor steps past a thin tile between frames; a static overlap test never sees it. Need a swept test or sub-stepping (see [[game-loop-fixed-vs-variable-timestep]]).
- **Float drift in the box origin** accumulates sub-pixel gaps; snap render coords to integers even if physics is float (see [[floating-point-representation]]).

## See also

- [[tile-based-physics-gravity]]
- [[player-controller-claw-movement]]
- [[enemy-ai-behaviours]]
