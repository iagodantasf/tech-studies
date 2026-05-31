---
title: Design Editor
track: design-system
group: Design tokens
tags: [design-system, tooling]
prerequisites: [defining-design-tokens]
see-also: [file-formats, defining-design-tokens, creating-core-components]
---

# Design Editor

The design editor is the visual tool (Figma, Sketch, Penpot) where tokens are authored and applied as **styles/variables**, then exported as the JSON that feeds the code pipeline — the designer-facing end of the token source of truth.

## Why it matters

Tokens only stay honest if designers and engineers reference the *same* values, and the design editor is where designers actually work. If a Figma file uses raw hex fills while code uses `color.action.bg`, the two drift the instant either side changes. Binding the editor's native primitives (Figma Variables, styles) to the token set means a designer picking "Action / Background" and an engineer writing `--color-action-bg` are pointing at one definition — and the editor can export that set as [[file-formats|DTCG JSON]] instead of being a dead end.

## How it works

Modern editors expose token-shaped primitives that mirror the [[defining-design-tokens|three tiers]]:

| Token concept | Figma primitive | Notes |
|---|---|---|
| Primitive color | Variable in a "primitives" collection | `blue/500` |
| Semantic color | Variable aliasing a primitive | `color/action/bg` → `blue/500` |
| Typography | Text style | family + size + weight + line-height |
| Theme (light/dark) | Variable mode | swap a whole layer per mode |
| Effect (shadow) | Effect style | elevation tokens |

The pipeline runs **either direction**. *Editor → code*: a plugin (Tokens Studio, the native Figma Variables REST export) writes `tokens.json`, which Style Dictionary compiles. *Code → editor*: the same plugin imports JSON so a value changed in git appears as an updated variable in Figma. Variable **modes** are the editor's mechanism for [[dark-mode]] and white-label — one component references `color/bg/surface` and the mode decides the literal. Components built in the editor ([[creating-core-components]]) must consume these variables, never detached hex, or the export is meaningless.

## Example

A team uses Figma Variables. Primitives live in a "Core" collection (`grey/50…900`); semantics in a "Theme" collection with **Light** and **Dark** modes, where `color/bg/surface` = `grey/50` in Light and `grey/900` in Dark. A frame switched to Dark mode repaints with zero per-layer edits. Tokens Studio exports the collection to `tokens.json`; CI turns it into CSS/Swift/XML — designer and the three platforms now share `#0A66FF` by reference.

## Pitfalls

- **Detached values** — a layer with a literal `#0A66FF` fill instead of a bound variable silently breaks parity and won't export as a token.
- **Styles vs Variables confusion** — older Figma *styles* can't alias or theme by mode; for semantic, mode-aware tokens use *Variables*, reserving styles for composite type/effects.
- **Editor as the only source** — if JSON is never exported to git, the design tool becomes an un-versioned, un-reviewable source of truth; the committed [[file-formats|JSON]] must remain authoritative.
- **Naming mismatch** — Figma's `/` groups must map 1:1 to the code [[naming]] scheme, or the export produces token names engineers can't predict.

## See also

- [[file-formats]]
- [[defining-design-tokens]]
- [[creating-core-components]]
