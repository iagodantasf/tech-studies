---
title: SDL_mixer Integration
track: openclaw
group: Audio
tags: [openclaw, sdl-mixer]
prerequisites: [sdl2-setup-window-management, raii-resource-ownership]
see-also: [sound-effects-channels, music-playback-midi-xmi-conversion, resource-manager-caching]
---

# SDL_mixer Integration

How OpenClaw bootstraps an audio device through SDL_mixer — opening the mixer, choosing format and buffer size, and wrapping `Mix_Chunk`/`Mix_Music` in RAII so the whole subsystem is one owned object.

## Why it matters

Raw SDL only gives you a callback-driven audio stream; you would have to mix every overlapping gunshot, hit, and music track by hand. SDL_mixer sits on top and gives you a channel mixer, format decoding (WAV/OGG), and a separate music track for free. OpenClaw leans on it so the engine can fire dozens of concurrent [[sound-effects-channels|effects]] over one streamed [[music-playback-midi-xmi-conversion|music]] track without writing a DSP. Getting the open parameters wrong here surfaces everywhere downstream as latency, crackle, or silence.

## How it works

Init order matters: `SDL_Init(SDL_INIT_AUDIO)`, then `Mix_OpenAudio`, then optionally `Mix_Init` for codec libs.

| Param | OpenClaw-typical | Effect of changing it |
|---|---|---|
| frequency | 44100 Hz | resample cost vs fidelity |
| format | `AUDIO_S16SYS` | sample depth/endianness |
| channels | 2 (stereo) | mono collapses panning |
| chunksize | 2048 | latency vs underrun risk |

- **One open, one close.** `Mix_OpenAudio` initialises the device; pair it with `Mix_CloseAudio` and `Mix_Quit` exactly once. Wrapping the pair in a class with [[raii]] guarantees teardown even on an exception path.
- **Chunksize sets latency.** Buffer latency is `chunksize / frequency`; 2048 @ 44.1 kHz is ~46 ms. Smaller feels snappier but underruns (crackle) on a busy frame; larger is safe but laggy. 1024–2048 is the usable band for a platformer.
- **Decoded chunks vs streamed music.** `Mix_LoadWAV` fully decodes a short SFX into RAM (`Mix_Chunk`); `Mix_LoadMUS` streams a long track (`Mix_Music`). Cache the former in a [[resource-manager-caching|resource manager]]; never `Mix_LoadWAV` a 3-minute song.
- **Allocate the channel pool once.** `Mix_AllocateChannels(N)` sizes the SFX mixer (see [[sound-effects-channels]]); do it at boot, not per sound.

## Example

A minimal RAII wrapper over the device, the shape OpenClaw uses:

```cpp
struct AudioDevice {
    AudioDevice() {
        if (Mix_OpenAudio(44100, AUDIO_S16SYS, 2, 2048) != 0)
            throw std::runtime_error(Mix_GetError());
        Mix_AllocateChannels(32);          // 32 concurrent SFX
    }
    ~AudioDevice() { Mix_CloseAudio(); Mix_Quit(); }
};
```

Construct one `AudioDevice` at startup; its lifetime is the audio subsystem's lifetime. 44100/2048 yields ~46 ms latency and 32 voices — comfortable for a 60 FPS scene.

## Pitfalls

- **Forgetting `SDL_INIT_AUDIO`.** `Mix_OpenAudio` fails or stays silent if the SDL audio subsystem was never initialised; check the `Mix_OpenAudio` return, not just SDL's.
- **`Mix_Init` flags are codecs, not the device.** `Mix_Init(MIX_INIT_OGG)` only loads decoder libs; it does *not* open audio. Both calls are required.
- **Leaking chunks on level change.** Every `Mix_LoadWAV` needs a matching `Mix_FreeChunk`; freeing a chunk still playing on a channel produces a use-after-free pop. Stop channels first.
- **Re-opening the device.** Calling `Mix_OpenAudio` twice without closing leaks the first device and may silence the second; open exactly once.

## See also

- [[sound-effects-channels]]
- [[music-playback-midi-xmi-conversion]]
- [[resource-manager-caching]]
