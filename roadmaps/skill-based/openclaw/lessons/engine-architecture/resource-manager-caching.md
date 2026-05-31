---
title: Resource Manager & Caching
track: openclaw
group: Engine Architecture
tags: [openclaw, resource-management]
prerequisites: [hash-tables, smart-pointers-unique-ptr-shared-ptr]
see-also: [rez-archive-resource-packs, scene-level-management, the-stl-in-hot-paths]
---

# Resource Manager & Caching

The subsystem that loads an asset once from the [[rez-archive-resource-packs|REZ archive]], decodes it into a GPU/RAM-ready form, and hands out shared references so identical assets are never loaded or decoded twice.

## Why it matters

A single Captain Claw level draws one tileset across thousands of tiles and reuses the same enemy sprite for every officer on screen. Loading `OFFICER/IDLE.PID` from disk and re-decoding it per actor would thrash the disk and blow RAM. The resource manager makes asset access *O(1) cache hit* after first touch, owns the lifetime so textures are freed exactly when the last user drops them, and gives [[scene-level-management|level loading]] a single place to preload and flush.

## How it works

OpenClaw's `ResourceCache` (Game Coding Complete pattern):

- **Key = canonical path.** Assets are keyed by their REZ path string (e.g. `LEVEL1/TILES/ACTION/001`). A `unordered_map<string, shared_ptr<ResHandle>>` ([[hash-tables]]) maps key → loaded handle.
- **Load-on-miss.** `GetHandle(key)`: on a hit, return the cached handle; on a miss, pull the raw bytes from the REZ file, run the matching `IResourceLoader` (PID→texture, WAV→chunk, XML→DOM), wrap the decoded result in a `ResHandle`, insert, and return it.
- **Refcount = lifetime.** Handles are `shared_ptr<ResHandle>`; the asset's RAM/texture is freed when the last holder releases. Components hold handles for as long as they need the asset. See [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]].
- **Budgeted LRU eviction.** The cache tracks a byte budget; when an insert would exceed it, it evicts least-recently-used handles whose refcount has dropped to "cache-only". A still-referenced asset is never evicted out from under a live actor.
- **Decoded, not raw.** The cache stores the *post-decode* form (an `SDL_Texture`, a `Mix_Chunk`), so the expensive PID/XMI decode happens once per asset, not once per use.

Cost model for a per-frame draw of N identical sprites:

| Strategy | Disk reads | PID decodes | Texture uploads |
|---|---|---|---|
| Naive (per actor) | N | N | N |
| Cached | 1 | 1 | 1 |

## Example

Twelve officers spawn; each `RenderComponent` requests its sprite:

```text
officer[0]: GetHandle("OFFICER/IDLE") -> MISS -> read REZ, decode PID, upload, insert
officer[1..11]: GetHandle("OFFICER/IDLE") -> HIT (refcount++ on same handle)
```

One disk read, one decode, one `SDL_Texture` shared by all twelve. On level exit, `Flush()` drops the cache's own references; the texture frees once the last officer is destroyed.

## Pitfalls

- **Non-canonical keys.** `Level1/Tiles` and `LEVEL1/TILES` hash to different buckets and double-load the same asset; normalize case/separators before keying.
- **Holding handles forever.** A global that keeps a `shared_ptr<ResHandle>` pins the asset past its level and defeats eviction; scope handles to the owning component.
- **Evicting in-use assets.** LRU must skip handles with external refcount > 1, or you free a texture a live sprite is mid-draw on.
- **Caching raw bytes.** Storing undecoded PID bytes "to save RAM" just moves the decode cost into the hot path — exactly what [[the-stl-in-hot-paths]] warns against; cache the decoded form.

## See also

- [[rez-archive-resource-packs]]
- [[scene-level-management]]
- [[the-stl-in-hot-paths]]
