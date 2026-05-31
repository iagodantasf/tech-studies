---
title: Entity / Actor Model
track: openclaw
group: Engine Architecture
tags: [openclaw, actor-model]
prerequisites: [hash-tables, smart-pointers-unique-ptr-shared-ptr]
see-also: [component-logic-separation, event-system-input-handling, wwd-level-format]
---

# Entity / Actor Model

The runtime representation of "a thing in the world" — Claw, an enemy, a coin, a moving platform — as a thin `Actor` identified by a stable id and assembled from data-driven components.

## Why it matters

Captain Claw has dozens of object types (officers, rats, powder kegs, ammo, elevators) that share behaviour in overlapping subsets. A class hierarchy (`Enemy : Character : Actor`) collapses under that combinatorics — a "destructible moving platform that drops loot" has no natural parent. OpenClaw instead makes `Actor` an *aggregate*: an id plus a bag of components built from XML, so new object types are authored as data, not C++ subclasses. This is the entity half of the [[component-logic-separation|entity-component]] split.

## How it works

OpenClaw's model (following the "Game Coding Complete" actor design):

- **Actor = id + component map.** An `Actor` holds an `ActorId` (a `uint32_t`) and a `map<ComponentId, StrongActorComponentPtr>`. It has almost no logic of its own — it is a handle that owns components. See [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]].
- **Ownership vs reference.** The `ActorFactory`/level owns `shared_ptr<Actor>` (strong); systems that *refer* to an actor store the bare `ActorId` and resolve it on demand, never a raw `Actor*`. A stale id resolves to null instead of dangling.
- **Id-keyed registry.** Live actors sit in an `unordered_map<ActorId, StrongActorPtr>` in `GameLogic`. Lookup is by id ([[hash-tables]]); component lookup inside an actor is by a compile-time `ComponentId` hash of the component name string.
- **Data-driven creation.** `ActorFactory::CreateActor(xml)` reads a `<Actor>` node, instantiates each `<...Component>` child via a name→creator registry, calls `VInit(xml)` per component, then `VPostInit()` once all siblings exist. Levels come from the [[wwd-level-format]].
- **Destruction is deferred.** Killing an actor queues an `ActorDestroyedEvent` ([[event-system-input-handling]]); the registry erases it *between* frames so you never delete an actor mid-iteration.

## Example

A pickup authored entirely as data — no new C++ type:

```xml
<Actor type="TreasurePowerup">
  <PositionComponent x="640" y="480"/>
  <ActorRenderComponent><Image>GAME/IMAGES/COINS</Image></ActorRenderComponent>
  <TriggerComponent type="aabb"/>          <!-- fires overlap events -->
  <PickupComponent scoreValue="100"/>      <!-- grants score on touch -->
</Actor>
```

`CreateActor` builds four components, wires them under one `ActorId`, and the world now contains a working coin. Adding a gem is a new XML file with `scoreValue="500"` — zero recompilation.

## Pitfalls

- **Storing raw `Actor*` across frames.** The actor can be destroyed; cache the `ActorId` and re-resolve, or the pointer dangles.
- **God-Actor.** Pushing logic into `Actor` itself rebuilds the inheritance mess you escaped; keep `Actor` dumb, put behaviour in components.
- **Id reuse.** Recycling a freed `ActorId` too soon makes a stale reference silently point at a *new* actor; use a monotonic counter or a generation tag.
- **`map` vs `unordered_map`.** A per-actor `std::map<ComponentId,...>` is fine (few entries), but the *world* registry should be `unordered_map` — id lookups happen thousands of times per frame.

## See also

- [[component-logic-separation]]
- [[event-system-input-handling]]
- [[wwd-level-format]]
