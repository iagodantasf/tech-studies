---
title: Component & Logic Separation
track: openclaw
group: Engine Architecture
tags: [openclaw, component-system]
prerequisites: [entity-actor-model, programming-paradigms]
see-also: [finite-state-machines-actor-states, event-system-input-handling, memory-layout-cache-locality]
---

# Component & Logic Separation

Splitting an actor's behaviour into independent components — render, physics, controller, AI, pickup — so capabilities compose by aggregation instead of inheritance.

## Why it matters

The reason the [[entity-actor-model|Actor]] is a dumb bag of parts is that *behaviour* lives in components. A `PowderKegComponent` (explodes when shot) and a `KinematicComponent` (rides a path) can be bolted onto the same actor without a class that inherits both. OpenClaw uses this to express Claw, every enemy, projectiles, and level gizmos through ~30 reusable `ActorComponent` subclasses, each owning one slice of state and one slice of logic. It is composition-over-inheritance applied at engine scale — see [[programming-paradigms]].

## How it works

OpenClaw's `ActorComponent` contract and how components talk:

- **Lifecycle hooks.** Each component overrides `VInit(xml)` (parse its own config), `VPostInit()` (grab sibling pointers, now that all exist), `VUpdate(dt)` (per-step logic), and `VOnChanged()`. The actor calls these in order on every child.
- **Components are siblings, not callers.** A controller does not call the renderer directly. It mutates *shared state* (position) or raises an event; the renderer reads that state next frame. Decoupling goes through the [[event-system-input-handling]].
- **Find-by-id, not by `dynamic_cast`.** `actor->GetComponent<PhysicsComponent>(PhysicsComponent::g_Name)` looks the sibling up by `ComponentId` and returns a `weak_ptr`; a missing component yields an expired weak_ptr rather than a crash.
- **One concern per component.** Typical split for Claw:

| Component | Owns state | Owns logic |
|---|---|---|
| `PositionComponent` | x, y | none (pure data) |
| `PhysicsComponent` | Box2D body | gravity, collision response |
| `ControllerComponent` | input intent | maps keys to actions |
| `AnimationComponent` | frame, timer | advances frames |
| `RenderComponent` | texture, z | submits a draw call |

- **State machines live in a component.** Walk/jump/duck/death is an FSM owned by the actor's logic component — see [[finite-state-machines-actor-states]].

## Example

Claw takes damage. No component reaches into another's internals:

```text
HealthComponent::VUpdate: hp -= dmg
   -> if hp <= 0: queue ActorDestroyedEvent
   -> else:       queue ActorHurtEvent(actorId)
AnimationComponent (subscribed): play "DAMAGE" clip
ControllerComponent (subscribed): lock input for 400 ms
```

Each component reacts to the event in isolation; none holds a pointer into another's fields, so any one can be edited or removed without touching the rest.

## Pitfalls

- **Hidden ordering dependency.** If `RenderComponent::VUpdate` must run after physics, but the component map iterates in id order, you read last frame's position. Resolve sibling pointers in `VPostInit`, and update systems in a defined phase order, not whatever the map yields.
- **Cross-component pointers in `VInit`.** A sibling may not be constructed yet during `VInit`; only cache sibling refs in `VPostInit`.
- **Fat components.** A `PlayerComponent` that does input *and* physics *and* animation is the inheritance blob in disguise; keep one concern each.
- **`map<ComponentId,...>` iteration cost.** Pointer-chasing a per-actor `map` every step hurts locality at hundreds of actors; the cost model is in [[memory-layout-cache-locality]].

## See also

- [[finite-state-machines-actor-states]]
- [[event-system-input-handling]]
- [[memory-layout-cache-locality]]
