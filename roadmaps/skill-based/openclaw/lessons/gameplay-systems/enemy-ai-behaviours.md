---
title: Enemy AI Behaviours
track: openclaw
group: Gameplay Systems
tags: [openclaw, ai]
prerequisites: [finite-state-machines-actor-states, aabb-collision-detection]
see-also: [finite-state-machines-actor-states, player-controller-claw-movement, pickups-score-health]
---

# Enemy AI Behaviours

The per-actor decision logic for Claw's officers, rats, and soldiers — small state machines that patrol, detect the player, attack, and die, driven entirely off the same tile physics.

## Why it matters

Captain Claw's enemies are not pathfinding agents; they are dozens of instances of a few simple behaviours placed by the [[wwd-level-format|level]]. The challenge is *authoring at scale*: 100+ object logics share a handful of patterns, so the AI must be data-driven and cheap (hundreds of actors, only a few near the camera active). This is a textbook use of [[finite-state-machines-actor-states|FSMs]] plus sensing built on [[aabb-collision-detection|AABB]] overlap — no neural anything, just readable, debuggable transitions.

## How it works

Most ground enemies share this FSM, parameterised by data (speed, sight range, attack box):

| State | Transition trigger | Behaviour |
|---|---|---|
| `Patrol` | default | walk to edge/wall, turn around |
| `Alert` | player in sight cone | face player, brief telegraph |
| `Chase` | alert + in range | move toward player x |
| `Attack` | player within attack box | enable hit box, play swing |
| `Hurt` | took damage | knockback, i-frames |
| `Dead` | health <= 0 | death anim, spawn loot |

- **Sensing is a rectangle, not a raycast.** "Can I see Claw?" is an AABB sight box in front of the enemy plus a facing check — cheap and good enough for a side-scroller. Hearing/aggro can be a wider box.
- **Patrol uses ledge probes.** Same `solid`/`ground` query as [[tile-based-physics-gravity|physics]]: if there's no ground one tile ahead, turn around — that's why guards pace platforms without falling off.
- **Update only what's near.** Actors far off-camera are dormant (no AI tick); they activate when the [[camera-viewport|viewport]] approaches, keeping the per-frame cost bounded. See [[the-stl-in-hot-paths]].
- **Death drops loot via data.** `Dead` spawns the actor's configured [[pickups-score-health|pickup]] (coins/health) rather than hard-coding rewards per enemy type.
- **Behaviour as components.** Shared steering/sensing live in reusable logic; the specific enemy is mostly a parameter set — see [[component-logic-separation]].

## Example

An Officer patrolling a 5-tile ledge, Claw enters from the right:

```text
Patrol: walk +x until ledge-probe finds no ground -> turn -x
sight box (front, 6 tiles) overlaps Claw  -> Alert (0.3s telegraph)
Claw within 1.5 tiles -> Attack: enable hitbox for frames 3-5
Claw leaves range -> back to Patrol after recovery
```

The 0.3 s telegraph in `Alert` is deliberate: it gives the player a readable window to react, which is what makes the encounter fair rather than a frame-trap.

## Pitfalls

- **One giant `switch(enemyType)`** instead of a shared FSM + data table — unmaintainable across 100+ logics; map logic name -> behaviour params (as the WWD loader does).
- **Ticking every actor every frame** tanks performance on big levels; gate AI by proximity to the camera.
- **Attack hitbox active for the whole animation** lets enemies hit on wind-up; enable it only on the active frames (mirror of [[player-controller-claw-movement]]).
- **Patrol without ledge probes** walks guards off platforms; always test the tile ahead, not just walls.

## See also

- [[finite-state-machines-actor-states]]
- [[player-controller-claw-movement]]
- [[pickups-score-health]]
