---
title: Animation System (frames & timing)
track: openclaw
group: Rendering
tags: [openclaw, animation]
prerequisites: [2d-sprite-rendering, game-loop-fixed-vs-variable-timestep]
see-also: [finite-state-machines-actor-states, sound-effects-channels, player-controller-claw-movement]
---

# Animation System (frames & timing)

Advancing a sprite through an ordered list of timed frames, accumulating elapsed milliseconds so playback stays correct regardless of framerate.

## Why it matters

Claw has dozens of states — idle, run, jump, swipe, climb, hurt — and each is an animation whose frame timing is baked into the [[wwd-level-format|.ANI]] data, not the source code. Tie advancement to frames-per-update instead of elapsed time and the game animates twice as fast on a 120 Hz monitor. The accumulator pattern decouples animation speed from the [[game-loop-fixed-vs-variable-timestep|frame rate]] and lets one slow frame "catch up" without skipping art.

## How it works

OpenClaw models an animation as `vector<AnimationFrame>`, each frame a small struct that names a [[2d-sprite-rendering|sprite]] and how long to hold it:

| Field | Meaning |
|---|---|
| `imageId` | which sprite to show |
| `duration` | how long to hold it (ms) |
| `eventName` | optional sound/event tag |
| `hasEvent` | whether to fire it |

`Animation::Update(msDiff)` runs each tick and drives a millisecond accumulator.

The core of `Update` is a carry accumulator (paraphrased from the repo):

```text
_currentTime += msDiff;
if (_currentTime >= frame.duration) {
    _currentTime -= frame.duration;   // carry remainder, don't zero it
    OnAnimationFrameFinished(frame);  // notify FSM / fire events
    SetNextFrame();
}
```

- **Carry, don't reset.** Subtracting `duration` (rather than setting `_currentTime = 0`) preserves the leftover, so timing never drifts even with jittery `msDiff`.
- **Frame events.** When `hasEvent` is set, entering frame 0 fires `eventName` — this is how a footstep or sword *shing* lands on the exact frame; routed to [[sound-effects-channels|the mixer]].
- **End-of-loop hook.** `IsAtLastAnimFrame()` lets the [[finite-state-machines-actor-states|state machine]] decide: loop a run cycle, or transition out of a one-shot like "hurt".
- **Pause & delay.** A `_delay` countdown holds the first frame (spawn stagger); `_paused` freezes the whole clip.

## Example

A 3-frame swipe `[40 ms, 40 ms, 80 ms]` updated at a steady 16 ms/tick:

| tick | +ms | _currentTime | shown frame |
|---|---|---|---|
| 1 | 16 | 16 | 0 |
| 3 | 16 | 48 → 8 | 1 |
| 5 | 16 | 40 → 0 | 2 |
| 8 | 16 | 80 → 0 | back to 0 |

If one tick is a laggy 50 ms, frame 0's 40 ms is consumed and the extra 10 ms carries into frame 1 — no visual stall.

## Pitfalls

- **Counting frames, not time.** `frame++` every update binds speed to FPS; always accumulate `msDiff`.
- **Zeroing the accumulator.** Resetting to 0 on advance discards remainder and slowly desyncs long animations.
- **Firing events every frame the clip sits on frame 0.** Guard with a "just entered" check or a swipe replays its sound each loop.
- **Updating animation in the render pass.** Advance in the fixed-timestep update, not in draw, or variable render rate corrupts timing.

## See also

- [[finite-state-machines-actor-states]]
- [[sound-effects-channels]]
