---
title: Pickups, Score & Health
track: openclaw
group: Gameplay Systems
tags: [openclaw, gameplay-state]
prerequisites: [entity-actor-model, aabb-collision-detection]
see-also: [aabb-collision-detection, hud-ui-overlay, checkpoints-level-transitions]
---

# Pickups, Score & Health

The collectible actors and the player-state systems they feed — treasure scoring, health/lives, and ammo — plus the trigger overlap that grants them.

## Why it matters

Pickups are the reward loop of Captain Claw: treasure drives score, health and lives gate failure, and ammo gates the pistol/dynamite. Mechanically they're trivial actors, but they sit at the intersection of three subsystems — [[aabb-collision-detection|collision]] (the grab), persistent player state (the counters), and the [[hud-ui-overlay|HUD]] (the display) — so they're a clean test of whether your event/state plumbing is sound. They also interact with [[checkpoints-level-transitions|checkpoints]]: what carries across a death has to be decided here.

## How it works

A pickup is a non-solid [[entity-actor-model|actor]] placed by the [[wwd-level-format|WWD]] object list with a *trigger* box instead of a collision box:

| Pickup | Effect | Notes |
|---|---|---|
| Treasure (gem/coin/cross) | += score | value by gem color |
| Health (food/potion) | += hp, clamp to max | overheal wasted |
| Life (extra Claw) | += 1 life | also at score thresholds |
| Ammo (pistol/magic/dynamite) | += rounds | separate counters |

- **Grant on trigger overlap.** Each frame, test the player rect against pickup trigger rects (AABB); on overlap, apply the effect, play SFX, despawn the pickup. No physics resolution — it's a sensor, not a wall.
- **Clamp and threshold.** Health clamps to `maxHp` (overheal is lost); score crossing a threshold (e.g. every 100,000) grants a life — a single comparison after each add.
- **Score is the save-relevant number.** Lives/health reset on respawn, but score persists; the HUD subscribes to a change [[event-system-input-handling|event]] rather than polling so it only redraws on change.
- **Treasure value table, not per-actor.** A gem's points come from a type->value table keyed by the WWD logic name, mirroring how enemies are parameterised (see [[enemy-ai-behaviours]]).

## Example

Claw runs through three coins and a health potion:

```text
overlap(player, coin)  x3 -> score += 100 each -> 6300 -> 6600
overlap(player, potion) -> hp = min(hp+20, 100): 90 -> 100 (10 wasted)
score crosses 100000 later -> lives += 1, play 1-up jingle
HUD redraws only on these change events, not every frame
```

The `min(hp+20, 100)` clamp is what stops the potion from pushing health past max and lets the UI cap the bar cleanly.

## Pitfalls

- **Resolving pickups as solids** stops the player dead on contact; pickups must be triggers (overlap only, no push-out).
- **Granting before despawn / no debounce** double-counts a pickup across two frames of overlap — apply effect and remove (or flag) in the same step.
- **Polling the HUD every frame** wastes draw calls; push a change event so the [[hud-ui-overlay|overlay]] redraws only when a counter moves.
- **Unclamped health/score** overflows the bar or a fixed-width counter; clamp hp to max and watch integer width on score (see [[bit-manipulation]]).

## See also

- [[aabb-collision-detection]]
- [[hud-ui-overlay]]
- [[checkpoints-level-transitions]]
