---
title: Player Controller (Claw movement)
track: openclaw
group: Gameplay Systems
tags: [openclaw, player-controller]
prerequisites: [tile-based-physics-gravity, finite-state-machines-actor-states]
see-also: [finite-state-machines-actor-states, event-system-input-handling, animation-system-frames-timing]
---

# Player Controller (Claw movement)

The actor logic that turns raw input into Claw's stand/run/jump/climb/attack behaviour — a state machine sitting on top of the tile physics.

## Why it matters

The player controller is where "game feel" is decided: acceleration curves, jump arc, coyote time, and how attacking interacts with moving. It is also the actor most players will scrutinise frame by frame, so it must be deterministic and readable. Structurally it's the canonical example of [[component-logic-separation]] — input and physics are shared systems; the controller is the actor-specific *logic* that chooses a [[finite-state-machines-actor-states|state]] and the velocities/animation that go with it.

## How it works

Input is sampled (not read raw) via the [[event-system-input-handling|input layer]] into an intent struct, then a [[finite-state-machines-actor-states|FSM]] decides behaviour:

| State | Enter when | Drives |
|---|---|---|
| `Idle` | grounded, no move | idle anim, vx -> 0 |
| `Run` | grounded, move held | accelerate vx, run anim |
| `Jump` | jump pressed + grounded | vy = -impulse |
| `Fall` | airborne, vy > 0 | air control, fall anim |
| `Climb` | on `climb` tile + up/down | vy from input, gravity off |
| `Attack` | attack pressed | swing box, lock facing |

- **Acceleration, not teleport velocity.** `vx += accel*dt` toward a target speed, with higher decel when no key is held, gives weighty starts/stops instead of on/off motion.
- **Jump impulse vs hold.** A fixed upward impulse on press; releasing early cuts `vy` (variable jump height). Gravity from [[tile-based-physics-gravity]] does the rest of the arc.
- **Coyote time + input buffer.** Allow a jump for ~80 ms after leaving a ledge, and buffer a jump press ~100 ms before landing — both hide single-frame timing misses and are the difference between "tight" and "slippery".
- **Facing & attack lock.** `Attack` freezes facing and often horizontal drift so swings read clearly; the attack [[aabb-collision-detection|hitbox]] is enabled only for the active animation frames. The current state selects the clip in the [[animation-system-frames-timing|animation system]].

## Example

Press-jump near a ledge edge with coyote time:

```text
t=0.00  leave ledge, onGround=false, coyote=0.08s
t=0.05  JUMP pressed (still within coyote window)
        -> allowed: vy = -720, state=Jump
release jump at t=0.12 while vy<0
        -> vy = max(vy, -260)  (short hop)
```

Without coyote time that same press 50 ms after the edge would do nothing and feel broken; with it, the jump fires and the early release yields a short hop.

## Pitfalls

- **Reading input directly in the controller** couples it to SDL and breaks rebinding/replay; sample through the [[event-system-input-handling|input layer]] into an intent struct.
- **Setting `vx` to a constant** instead of accelerating makes movement feel robotic and ignores ice/air-control tuning.
- **Driving animation from velocity instead of state** desyncs the sprite (e.g. attack frames cut short when he stops); the FSM should own the clip.
- **No buffering** means jumps "eaten" on the frame before landing; players read it as dropped inputs.

## See also

- [[finite-state-machines-actor-states]]
- [[event-system-input-handling]]
- [[animation-system-frames-timing]]
