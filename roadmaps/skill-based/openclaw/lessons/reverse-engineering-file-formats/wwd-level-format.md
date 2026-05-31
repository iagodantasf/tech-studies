---
title: WWD Level Format
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, level-format]
prerequisites: [identifying-proprietary-file-formats, pid-image-format-claw-sprites]
see-also: [rez-archive-resource-packs, scene-level-management]
---

# WWD Level Format

The "World" file — Monolith's binary level definition holding the tile-plane layout, per-tile collision flags, and the list of actor (object) instances that make up one Captain Claw stage.

## Why it matters

A stage is not just a picture — it is multiple scrolling [[parallax-scrolling-backgrounds|planes]], a collision grid, and dozens of placed objects (enemies, pickups, checkpoints). All of that is serialised in `*.WWD`, loaded after [[rez-archive-resource-packs|REZ]] is opened. Decoding it is what lets the engine build a playable level instead of a flat backdrop; mis-reading the plane or object tables is the difference between a working stage and one with no floor or no enemies.

## How it works

A WWD has a header, then N **planes**, then per-plane **tile arrays** and a global **object list**:

| Block | Holds |
|---|---|
| Header | magic `WWD`, version, plane count, level name |
| Plane[] | name, pixel size, tile size, scroll rate (X/Y) |
| Tiles | `width*height` array of tile indices (LE) |
| Objects | actor instances: logic name, x, y, z, flags |

Each plane stores a **scroll rate** (e.g. background plane at 50% of the main plane) for [[parallax-scrolling-backgrounds|parallax]]. The **main action plane** carries collision: a tile index keys into a tile-attribute table (`solid`, `ground`, `climb`, `death`). The **object list** is the gameplay layer — each entry names a *logic* (`"AmbientSound"`, `"Officer"`, `"PowerupHealth"`), a position, and flags; the engine maps the logic name to an [[entity-actor-model|Actor]] template and spawns it. WWD references art *indirectly*: tile and image IDs resolve into PID/PCX entries inside REZ at load time. See [[scene-level-management]] for how a loaded WWD becomes the live scene.

## Example

Boot of `LEVEL1.WWD` in pseudocode:

```text
hdr = read_header()        # planes=3, name="The Docks"
for p in hdr.planes:
    plane.scrollX = read_u32()/100.0   # 0.50 -> half-speed bg
    plane.tiles   = read_u32[w*h]      # tile index grid
for obj in object_list:
    spawn_actor(obj.logic, obj.x, obj.y)  # "Officer" @ (1200, 880)
```

Three planes parse as back (0.5x), main (1.0x, collidable), front (1.2x). An object `("PowerupTreasure", 1500, 600)` becomes a coin pickup at that world coordinate.

## Pitfalls

- **Reading planes in the wrong order** — plane records are sequential and variable; a bad size desyncs every later block.
- **Treating all planes as solid** — only the action plane has collision; others are pure visuals.
- **Hardcoding logic names** — there are 100+ object logics; map them via a table, not a giant switch.
- **Assuming pixel == tile coords** — objects are in pixels, tiles in grid cells; mixing units misplaces everything.

## See also

- [[rez-archive-resource-packs]]
- [[scene-level-management]]
