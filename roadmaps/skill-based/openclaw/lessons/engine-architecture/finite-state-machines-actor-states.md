---
title: Finite State Machines (actor states)
track: openclaw
group: Engine Architecture
tags: [openclaw, state-machine]
prerequisites: [automata-and-formal-languages, component-logic-separation]
see-also: [enemy-ai-behaviours, player-controller-claw-movement, animation-system-frames-timing]
---

# Finite State Machines (actor states)

A small set of named, mutually-exclusive states (idle, walk, jump, attack, hurt, dead) with explicit transitions, used to drive both Claw's controller and every enemy's AI.

## Why it matters

"Is Claw allowed to swing his sword right now?" is a state question. Encoding it as a pile of booleans (`isJumping`, `isDucking`, `isHurt`) creates illegal combinations — ducking *and* jumping — and tangled `if` chains that nobody can extend. A finite state machine makes each behaviour exactly one state, makes transitions explicit, and guarantees the actor is always in exactly one. This is the practical face of [[automata-and-formal-languages]] and the logic core of [[player-controller-claw-movement]] and [[enemy-ai-behaviours]].

## How it works

The FSM is an object owned by the actor's logic component (see [[component-logic-separation]]):

- **One current state.** The component holds a `currentState`; each state defines `OnEnter`, `OnUpdate(dt)`, `OnExit`. On a transition: `cur.OnExit()`, swap, `next.OnEnter()` — `OnEnter` is where you kick the [[animation-system-frames-timing|animation]] clip and where one-shot setup belongs.
- **Transitions are guarded edges.** A state's `OnUpdate` evaluates conditions and returns the next state id (or stays). The legal edges *are* the design:

| From | Event/condition | To |
|---|---|---|
| Idle | move pressed | Walk |
| Walk / Idle | jump + grounded | Jump |
| Jump | vy>0 and grounded | Idle |
| any (not Dead) | hp<=0 | Dead |
| Idle / Walk | attack pressed | Attack |

- **Hierarchical states for "any".** "Take damage from any non-dead state" is a super-state edge so you don't duplicate the transition on every leaf. Keeps the table small.
- **Enemy AI reuses the machine.** A rat is `Patrol → Chase → Attack → Retreat`, driven by distance-to-Claw checks in each `OnUpdate` — same FSM engine, different states. See [[enemy-ai-behaviours]].
- **Event-driven entry.** Many transitions fire off events (an `ActorHurtEvent` forces `→ Hurt`) rather than per-frame polling, tying the FSM into the engine's event bus.

## Example

Claw's grounded-attack guard, expressed as a transition rather than scattered flags:

```text
state Walk:
  OnUpdate(dt):
    if !grounded:        return Jump
    if attackPressed:    return Attack    // only reachable while grounded
    if !movePressed:     return Idle
    move(dir); return Walk
state Attack:
  OnEnter: play "SWORD" clip; lock movement
  OnUpdate: if clipFinished: return movePressed ? Walk : Idle
```

Because Attack is only reachable from Walk/Idle, "attacking mid-air" is *structurally impossible* — no boolean can put the actor in an illegal combination.

## Pitfalls

- **Missing `OnExit`.** Forgetting to clear movement-lock or a timer on exit leaks state into the next behaviour (Claw stays frozen after Attack). Pair every `OnEnter` setup with `OnExit` cleanup.
- **Boolean soup beside the FSM.** Keeping `isHurt` *and* a Hurt state lets them disagree; the state is the single source of truth.
- **Animation/state drift.** Driving the clip outside the FSM means the sprite and logic desync; start the clip in `OnEnter` only.
- **Unreachable / dead-end states.** A state with no outgoing edge traps the actor (a Hurt with no path back to Idle freezes it); audit the transition table for sinks.

## See also

- [[enemy-ai-behaviours]]
- [[player-controller-claw-movement]]
- [[animation-system-frames-timing]]
