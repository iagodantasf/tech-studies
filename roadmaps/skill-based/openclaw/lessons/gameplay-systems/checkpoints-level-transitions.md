---
title: Checkpoints & Level Transitions
track: openclaw
group: Gameplay Systems
tags: [openclaw, level-flow]
prerequisites: [scene-level-management, pickups-score-health]
see-also: [scene-level-management, pickups-score-health, resource-manager-caching]
---

# Checkpoints & Level Transitions

How Claw saves respawn points mid-stage and how the engine tears down one level and brings up the next without leaking resources or losing the player's progress.

## Why it matters

Checkpoints define the failure granularity — die and you restart from the last flag, not the stage start — so where they live and what state they restore is core to fairness. Level transitions are the riskier engineering problem: switching scenes means unloading one [[wwd-level-format|WWD]] plus its art/audio and loading the next, exactly the moment resource lifetimes and [[scene-level-management|scene]] ownership get stress-tested. A sloppy transition leaks textures, double-frees, or carries stale actors into the new map.

## How it works

A checkpoint is a trigger actor placed in the level; crossing it snapshots a small **respawn record**:

| Restored on death | Persists across level | Reset each level |
|---|---|---|
| player x,y at flag | total score | enemy/pickup state |
| health -> full | lives count | actor list |
| current ammo (often) | inventory flags | camera position |

- **Snapshot, don't deep-copy the world.** Save only the few values needed to respawn (position, hp, ammo) — not the actor graph. On death, reset the player to the record; leave already-collected [[pickups-score-health|pickups]] gone (don't respawn looted treasure) but reset enemies.
- **Transition is a state, not an instant.** A `Loading` step lets you fade out, free the old [[scene-level-management|scene]], build the new one, then fade in — avoids a one-frame stall mid-gameplay.
- **Free old, then load new — in that order.** Drop the outgoing level's resources first so the [[resource-manager-caching|cache]] reclaims memory before the next level's art is paged in; shared assets (HUD, common SFX) stay resident via refcount.
- **Carry the persistent struct across.** Score, lives, and inventory live in a small game-state object that outlives any single scene, so they survive the teardown that destroys everything else.

## Example

Player passes a checkpoint, dies, then completes the stage:

```text
cross flag @ (2400,880) -> respawn = {x:2400, y:880, hp:full, ammo:keep}
death -> reload respawn: pos/hp restored, collected gems stay gone,
         enemies in that section reset, lives -= 1
reach level exit -> state=Loading: fade, free L1 scene,
         load L2 WWD+art, keep {score, lives, inventory}, fade in
```

Restoring only the respawn record (not a world snapshot) is what keeps a checkpoint cheap — a handful of fields, no scene serialization.

## Pitfalls

- **Respawning collected pickups** at the checkpoint lets players farm a coin and a death for infinite score; track per-pickup collected flags.
- **Loading the next level before freeing the current one** spikes peak memory and can OOM on constrained targets; unload first, then load.
- **Leaving stale actors/listeners alive** across a transition leaks or fires callbacks into a dead scene; clear the actor list and event subscriptions on teardown.
- **Storing progress inside the scene** loses score/lives on every transition; keep persistent state in an object that outlives the scene (see [[scene-level-management]]).

## See also

- [[scene-level-management]]
- [[pickups-score-health]]
- [[resource-manager-caching]]
