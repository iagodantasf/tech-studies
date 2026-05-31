---
title: Sound Effects & Channels
track: openclaw
group: Audio
tags: [openclaw, sound-effects]
prerequisites: [sdl-mixer-integration, resource-manager-caching]
see-also: [event-system-input-handling, music-playback-midi-xmi-conversion, player-controller-claw-movement]
---

# Sound Effects & Channels

How OpenClaw plays short overlapping sounds — Claw's sword swipe, a coin pickup, an enemy hit — by mapping loaded `Mix_Chunk`s onto a fixed pool of SDL_mixer channels.

## Why it matters

A platformer fires many short sounds at once: footstep + sword + pickup + enemy death can all land in the same frame. SDL_mixer models this as a bank of independent **channels**, each playing one chunk; the mixer sums them into the output stream. Understanding the channel pool is what lets gameplay code say "play this hit" without worrying about what else is sounding. Mismanage it and sounds get cut off, stack into clipping, or silently drop when the pool is exhausted.

## How it works

`Mix_AllocateChannels(N)` (from [[sdl-mixer-integration]]) creates channels `0..N-1`. Play onto the next free one with channel `-1`:

| Call | Meaning |
|---|---|
| `Mix_PlayChannel(-1, c, 0)` | play `c` once on any free channel |
| `Mix_PlayChannel(-1, c, n)` | loop `n+1` times total |
| `Mix_Volume(ch, v)` | per-channel volume, `v` in 0..128 |
| `Mix_HaltChannel(ch)` | stop one channel (or `-1` for all) |
| `Mix_Playing(ch)` | is a channel still sounding |

- **`-1` is "first free channel".** The mixer scans for an idle channel; if all N are busy the call returns `-1` and the sound is *dropped*, not queued. Size the pool (16–32) for the worst-case concurrent burst.
- **Chunks are shared, channels are transient.** One cached `Mix_Chunk` (owned by the [[resource-manager-caching|resource manager]]) can play on many channels simultaneously — the chunk is read-only sample data. Do not free it while any channel still plays it.
- **Volume is two-stage.** Effective output is `chunk_volume * channel_volume / 128`. Set a master SFX level via `Mix_Volume(-1, v)` and leave individual chunks at full unless you want a quiet variant.
- **De-dupe spammy sounds.** Footsteps from the [[player-controller-claw-movement|controller]] can retrigger every few frames; gate by checking `Mix_Playing` or a per-sound cooldown so you don't stack 8 copies into clipping.
- **Gameplay decoupling.** The [[event-system-input-handling|event system]] posts a "play SFX id X" event; an audio handler resolves the chunk and calls `Mix_PlayChannel`, so logic never touches SDL.

## Example

Firing a one-shot hit sound, with pool-exhaustion handled:

```cpp
int ch = Mix_PlayChannel(-1, sfxHit, 0);   // 0 loops = play once
if (ch == -1)                              // all 32 channels busy
    Logger::warn("SFX dropped: pool full");
else
    Mix_Volume(ch, masterSfxVol);          // 0..128
```

With 32 channels a typical scene peaks at ~6–10 simultaneous voices, so `-1` almost always finds a slot; the warn branch fires only on pathological bursts (e.g. a screen-clearing explosion).

## Pitfalls

- **Pool exhaustion is silent.** `Mix_PlayChannel(-1, …)` returning `-1` drops the sound with no error; log it during tuning so you size N correctly.
- **Freeing a playing chunk.** `Mix_FreeChunk` on a chunk still on a live channel is a use-after-free crackle/crash; `Mix_HaltChannel` first, then free.
- **Hardcoding channel numbers.** Playing on a fixed channel id (not `-1`) means a second sound cuts off the first; reserve explicit channels only for a deliberate "one voice" category.
- **Volume range confusion.** SDL_mixer volume is 0–128, not 0–100 or 0.0–1.0; a value of 100 is ~78%, not full.

## See also

- [[sdl-mixer-integration]]
- [[event-system-input-handling]]
- [[music-playback-midi-xmi-conversion]]
