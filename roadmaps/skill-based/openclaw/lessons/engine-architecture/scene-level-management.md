---
title: Scene / Level Management
track: openclaw
group: Engine Architecture
tags: [openclaw, scene-management]
prerequisites: [stacks-and-queues, entity-actor-model]
see-also: [resource-manager-caching, wwd-level-format, checkpoints-level-transitions]
---

# Scene / Level Management

The layer that owns the set of live actors for the current level, drives the boot/play/transition flow, and tears one level down before building the next.

## Why it matters

Captain Claw is 14 retail levels plus menus, a title card, and a map screen. Each is a distinct world with its own [[wwd-level-format|WWD]] geometry, tileset, music, and actor population. Without a scene layer you leak actors and textures between levels, the menu and gameplay fight over input, and a level transition becomes ad-hoc teardown code. OpenClaw centralizes this in `GameLogic` (the world/actor owner) plus a `HumanView` (the presentation/UI layer), with a `ProcessMgr` running timed transitions.

## How it works

- **Logic / view split.** `BaseGameLogic` owns the authoritative actor registry, physics world, and game rules; `HumanView` owns the screen, UI screens, and input. Multiple views can attach to one logic (gameplay + debug overlay). This mirrors the [[entity-actor-model]] ownership rules.
- **State as a stack-ish flow.** Menu → Loading → Running → Paused → LevelComplete behaves like a screen stack: pushing Paused freezes Running underneath, popping resumes it. Modeled with [[stacks-and-queues]] semantics (the active screen consumes input first).
- **Load = build the registry.** Entering a level: change state to `Loading`, parse the WWD, ask the [[resource-manager-caching|resource manager]] to preload that level's tileset/sprites/audio, then `ActorFactory::CreateActor` for every WWD object into the registry.
- **Teardown is explicit and ordered.** On exit: destroy all actors (which releases their component handles), flush the physics world, then `Flush()` the resource cache for assets unique to that level. Order matters — destroy actors *before* freeing the textures they reference.
- **Transitions run as processes.** A fade-out → swap → fade-in is a chain of `Process` objects on the `ProcessMgr`; gameplay is suspended while the transition process is alive. Checkpoints and exits go through [[checkpoints-level-transitions]].

## Example

Player touches the level-exit warp:

```text
1. ExitTriggerComponent queues LevelCompletedEvent(nextLevelId)
2. GameLogic: state = Transitioning; push FadeOutProcess (0.5 s)
3. on fade done: DestroyAllActors(); physicsWorld.Clear()
4. ResourceMgr.Flush(currentLevel)            // drop old tileset/audio
5. LoadLevel(nextLevelId): parse WWD -> preload -> create actors
6. push FadeInProcess; state = Running
```

Steps 3-4 in that order guarantee no actor still holds a texture id the cache is about to free.

## Pitfalls

- **Freeing assets before actors.** Flushing the cache while actors still reference a texture leaves dangling handles; destroy actors first, then flush.
- **Updating a paused level.** If `Paused` is pushed but `GameLogic::Update` still ticks the world, enemies move behind the pause menu; the active screen must gate the update.
- **Carrying actor ids across levels.** A saved `ActorId` from the previous level is meaningless after teardown; persist *game* state (score, lives), not actor handles. See [[checkpoints-level-transitions]].
- **Loading on the main thread without a screen.** A multi-second WWD+asset load with no `Loading` view looks like a hang; show the screen *before* the blocking load begins.

## See also

- [[resource-manager-caching]]
- [[wwd-level-format]]
- [[checkpoints-level-transitions]]
