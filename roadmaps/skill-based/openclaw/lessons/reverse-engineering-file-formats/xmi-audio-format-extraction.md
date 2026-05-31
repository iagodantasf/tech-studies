---
title: XMI / Audio Format Extraction
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, audio-format]
prerequisites: [identifying-proprietary-file-formats]
see-also: [music-playback-midi-xmi-conversion, sdl-mixer-integration]
---

# XMI / Audio Format Extraction

Decoding Miles Sound System's `.XMI` extended-MIDI music and the standard `.WAV` sound effects that Captain Claw packs inside [[rez-archive-resource-packs|REZ]].

## Why it matters

Claw's music is not MP3 or even plain MIDI — it is XMI (XMIDI), a 1990s Miles Sound System format that no modern player or SDL_mixer build understands directly. To get music out, you must either convert XMI to Standard MIDI (`.mid`) at extraction time or teach the engine to parse it. Sound *effects*, by contrast, are ordinary RIFF WAV and play as-is. Knowing which is which avoids writing a decoder you do not need. See [[music-playback-midi-xmi-conversion]].

## How it works

XMI is a **RIFF/IFF-style chunked** container; the differences from Standard MIDI matter:

| Aspect | Standard MIDI (SMF) | XMI (XMIDI) |
|---|---|---|
| Container | `MThd`/`MTrk` chunks | `FORM`/`XDIR`/`CAT`/`EVNT` |
| Multiple songs | one per file | many, in one `CAT` |
| Delta time | variable-length, between events | fixed interval count |
| Note duration | separate note-on/note-off | duration packed into note-on |

Conversion to SMF means walking `EVNT`, splitting each note's packed duration back into a note-on plus a delayed note-off, and rewriting XMI's interval timing as SMF variable-length delta times. The freely available `xmi2mid` tool (and the routines in scummvm/munt) does exactly this. WAV needs none of it — `RIFF....WAVE` is a public format; pull the bytes out of REZ and hand them straight to [[sdl-mixer-integration|SDL_mixer]]. Playback of the converted MIDI still needs a synth (a SoundFont via FluidSynth, or hardware/OS MIDI).

## Example

Extraction split inside the asset pipeline:

```text
for entry in rez:
    if entry.type == "XMI":
        smf = xmi_to_smf(entry.bytes)   # repack EVNT -> MThd/MTrk
        write(entry.name + ".mid", smf)
    elif entry.type == "WAV":
        write(entry.name, entry.bytes)  # already RIFF, copy as-is
```

One XMI `CAT` may yield several `.mid` files (the menu theme, each level's track). A 3-minute level tune is a few KB of MIDI events, versus megabytes if it were streamed audio — which is why a 1997 game shipped sequenced music.

## Pitfalls

- **Feeding XMI to SDL_mixer directly** — it is not SMF; `Mix_LoadMUS` rejects or mis-plays it. Convert first.
- **Dropping packed note durations** — XMI encodes length in the note-on; ignore it and every note rings forever.
- **No synth on the target** — converted MIDI is silent without a SoundFont/synth; bundle FluidSynth + an SF2.
- **Over-engineering WAV** — effects are plain RIFF; do not route them through the XMI path.

## See also

- [[music-playback-midi-xmi-conversion]]
- [[sdl-mixer-integration]]
