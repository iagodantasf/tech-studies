---
title: Music Playback (MIDI/XMI conversion)
track: openclaw
group: Audio
tags: [openclaw, music, xmi]
prerequisites: [sdl-mixer-integration, xmi-audio-format-extraction]
see-also: [sound-effects-channels, rez-archive-resource-packs, asset-extraction-pipeline]
---

# Music Playback (MIDI/XMI conversion)

How OpenClaw plays Captain Claw's level music: the original tracks are stored as **XMI** (Miles/AIL extended MIDI), which must be converted to standard MIDI before SDL_mixer can stream them.

## Why it matters

The 1997 game shipped its soundtrack as XMI inside the [[rez-archive-resource-packs|REZ archives]] — a DOS-era Miles Sound System format that no modern player understands directly. SDL_mixer's music backend speaks **Standard MIDI File (SMF)**, OGG, and MP3, not XMI. So the audio path has two halves: a one-time format conversion ([[xmi-audio-format-extraction]]) and a runtime that loads the converted track as `Mix_Music`. Skip the conversion and every level loads in silence with no error.

## How it works

XMI is structurally a RIFF-style container of one or more MIDI sequences; conversion rewrites it into one or more SMFs.

| XMI trait | SMF equivalent | Conversion action |
|---|---|---|
| `FORM XDIR/XMID` chunks | SMF `MThd`/`MTrk` | re-wrap into SMF |
| fixed 120 ticks/quarter | SMF division field | write division header |
| delta = sum of `0x7F` bytes | SMF variable-length delta | recompute deltas |
| `EVNT` event stream | `MTrk` event stream | copy, remap timing |
| multiple songs per file | one SMF per song | split into N files |

- **Timing is the hard part.** XMI encodes inter-event delay as a run of `0x7F` bytes plus a remainder; SMF uses variable-length quantity deltas. The converter must accumulate the XMI delay and re-emit it as a VLQ, or the tempo drifts.
- **One-time, offline.** Conversion belongs in the [[asset-extraction-pipeline|extraction pipeline]], not the game loop. Tools like `xmi2mid` (or libxmi) produce `.mid` files once; the engine ships/loads those.
- **MIDI needs a synth.** A `.mid` is just notes — SDL_mixer must render it via a backend (Timidity++/FluidSynth with a soundfont, or native OS MIDI). No soundfont configured = silent or wrong instruments. This is why some builds prefer pre-rendering tracks to OGG.
- **Single streamed track.** Unlike [[sound-effects-channels|SFX]], music is one `Mix_Music` on a dedicated channel: `Mix_PlayMusic(mus, loops)`, with `-1` to loop forever.

## Example

Level-music lifecycle around the converted file:

```cpp
// offline (pipeline):  LEVEL1.XMI  --xmi2mid-->  LEVEL1.MID
Mix_Music* mus = Mix_LoadMUS("MUSIC/LEVEL1.MID");
if (!mus) Logger::error(Mix_GetError());      // missing soundfont? bad path?
Mix_VolumeMusic(72);                          // 0..128
Mix_PlayMusic(mus, -1);                       // loop level theme forever
// on level exit:
Mix_HaltMusic();
Mix_FreeMusic(mus);
```

An XMI carrying 3 songs splits into `LEVEL1_0/1/2.MID`; the engine picks the index the [[wwd-level-format|level]] requests. `Mix_PlayMusic(-1)` loops seamlessly because SMF carries the loop length in its track.

## Pitfalls

- **Feeding XMI straight to `Mix_LoadMUS`.** It returns null (unknown format); the conversion is mandatory, not optional.
- **Dropped/garbled tempo.** Mis-summing the `0x7F` delay run yields music that plays too fast or stutters — a classic XMI→SMF bug; validate against a known-good player.
- **No synth backend.** A valid `.mid` plus no soundfont = silence or General-MIDI fallback instruments that sound nothing like the original; document the soundfont dependency.
- **Freeing music mid-play.** `Mix_FreeMusic` while playing can fault; call `Mix_HaltMusic` first, then free on level transition.

## See also

- [[xmi-audio-format-extraction]]
- [[sdl-mixer-integration]]
- [[asset-extraction-pipeline]]
