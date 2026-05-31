---
title: Legal Boundaries (code vs original game assets)
track: openclaw
group: Background & Project Context
tags: [openclaw, legal]
prerequisites: [clean-room-vs-asset-dependent-ports]
see-also: [reverse-engineering-mindset-ethics, clean-room-vs-asset-dependent-ports]
---

# Legal Boundaries (code vs original game assets)

The legal line that keeps a re-implementation safe is **new code you may write and license freely** versus **original assets you may neither copy nor redistribute** — the user must own and supply those.

## Why it matters

Get this wrong and the project is dead: bundling copyrighted sprites or music invites a takedown, and copying decompiled code makes the whole codebase a derivative work. Every contributor to OpenClaw must internalize where the line sits, because one tainted commit endangers everyone's work. (Note: this is engineering guidance, not legal advice — laws vary by jurisdiction.)

## How it works

Sort every artifact into one of three buckets:

| Artifact | Copyrightable? | May the project ship it? |
|---|---|---|
| New engine source code | Yes — owned by *you* | Yes, under your chosen licence |
| File-format byte layout | No (interface/fact) | Yes — document and publish freely |
| Sprites, levels, music, story | Yes — Monolith/owner | No — user supplies at runtime |
| Trademarks ("Captain Claw") | Separate (trademark) | Avoid implying endorsement |

Two ideas do the heavy lifting. **Idea/expression** — the *idea* of "a tile-based platformer" is free; Monolith's specific *expression* (its art, its levels) is protected. **Interoperability** — reverse-engineering a format purely to read your own data files is broadly treated as legitimate, which is why a [[wwd-level-format|WWD]] [[writing-format-parsers-in-c|parser]] is fine but the level *bytes* are not yours to ship. See [[clean-room-vs-asset-dependent-ports]].

## Example

OpenClaw's stance, made concrete:

- The repository ships **engine code only**; there is **no `CLAW.REZ`** and no extracted PNG/WAV in releases.
- The README instructs users to provide their **own** retail data file.
- Parsers and format notes are public — describing *structure*, not redistributing *content*.

A contrasting unsafe move: attaching an "asset pack" to a GitHub release "for convenience". That redistributes the copyrighted work regardless of intent.

## Pitfalls

- **CI fixtures with real assets** — a test that needs a real `.PID` must fetch it from the user's install, never from the repo.
- **"It's abandonware, so it's free"** — abandonware has no legal standing; the copyright still holds.
- **Leaking assets through git history** — `git rm` does not erase prior commits; a rip committed once lives on until history is rewritten.
- **Decompiled snippets in issues/PRs** — pasting original disassembly to "explain" logic can taint the discussion and any code derived from it.

## See also

- [[clean-room-vs-asset-dependent-ports]]
- [[reverse-engineering-mindset-ethics]]
