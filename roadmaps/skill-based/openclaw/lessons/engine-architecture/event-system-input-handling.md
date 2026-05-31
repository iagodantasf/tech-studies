---
title: Event System & Input Handling
track: openclaw
group: Engine Architecture
tags: [openclaw, event-system]
prerequisites: [stacks-and-queues, hash-tables]
see-also: [entity-actor-model, component-logic-separation, sdl2-setup-window-management]
---

# Event System & Input Handling

The publish/subscribe bus that decouples the producer of a game event (a collision, a key press, an actor death) from its consumers, plus the path that turns raw SDL input into those events.

## Why it matters

In a component world, the [[component-logic-separation|physics component]] must tell audio, score, and animation "Claw was hurt" without holding pointers to any of them. A global event bus solves that: producers `QueueEvent`, the manager fans each event out to every registered listener. OpenClaw uses an `EventManager` with typed events (`EventData` subclasses keyed by a 32-bit type id) — the same design that lets input, gameplay, and UI evolve independently. It is the nervous system tying together the [[entity-actor-model]].

## How it works

OpenClaw's `EventManager` (Game Coding Complete pattern):

- **Typed events.** Each event is an `IEventData` subclass with a static `EventType` (a 32-bit hashed id) and a payload — e.g. `ActorMovedEvent{ActorId, Point}`. Listeners register by `EventType` in an `unordered_map<EventType, list<Delegate>>` ([[hash-tables]]).
- **Queue, don't call.** `VQueueEvent(e)` pushes onto an event *queue*; `VTriggerEvent(e)` dispatches immediately (rare). Queuing decouples timing and avoids reentrancy when a handler raises more events.
- **Double-buffered processing.** `VUpdate(maxMs)` swaps the active queue with a spare, then drains the snapshot — so events queued *by* handlers run next frame, not in an unbounded loop this frame. A time budget caps how long dispatch may run.
- **Input → event pipeline.** SDL fills its event queue; the [[sdl2-setup-window-management|platform layer]] polls it once per frame, maps `SDL_KEYDOWN(SDLK_SPACE)` through a keybind table to an abstract `JumpAction`, and queues that. Gameplay never sees raw scancodes.
- **Focus order.** Input is offered to screens top-down like a stack ([[stacks-and-queues]]): the pause menu consumes Esc before gameplay sees it; only unhandled input falls through to the player controller.

## Example

One key press, three independent reactions, zero direct coupling:

```text
SDL_KEYDOWN SDLK_SPACE
  -> keybind map: JumpActionEvent           (queued)
ControllerComponent (listener): set jump intent
PhysicsComponent: applies impulse next step -> ActorMovedEvent (queued)
  -> AnimationComponent (listener): play "JUMP"
  -> AudioComponent     (listener): play "JUMP.WAV"
```

`PhysicsComponent` never references audio or animation; all three only share the `EventManager` and an `ActorId`.

## Pitfalls

- **Dangling listeners.** A destroyed component that forgot to unregister leaves a stale delegate the manager later invokes → crash. Unregister in the destructor, or store listeners as weak handles keyed by [[entity-actor-model|ActorId]].
- **Synchronous reentrancy.** `VTriggerEvent` inside a handler can recurse or invalidate the listener list mid-iteration; prefer `VQueueEvent` so dispatch stays flat.
- **Unbounded same-frame cascade.** If handlers queue into the *current* buffer, dispatch can loop forever; the double-buffer swap and time budget exist precisely to bound it.
- **Polling input per step, not per frame.** Draining `SDL_PollEvent` inside the fixed-step inner loop double-reads or drops keys; pump SDL exactly once per frame (see the game loop).

## See also

- [[entity-actor-model]]
- [[component-logic-separation]]
- [[sdl2-setup-window-management]]
