---
title: File Formats
track: design-system
group: Design tokens
tags: [design-system, design-tokens]
prerequisites: [defining-design-tokens]
see-also: [design-editor, naming, defining-design-tokens]
---

# File Formats

The file format is how tokens are stored and shipped — a structured source (usually JSON) that a build step transforms into the per-platform artifacts (CSS, Swift, XML, JS) each consumer actually reads.

## Why it matters

The format decides whether tokens are *one* source of truth or N hand-synced copies. Pick a tool-readable structure and a single `tokens.json` compiles to CSS variables, an iOS Swift enum, and an Android resource file in one build — change the value once, every platform updates. Pick screenshots or a slide deck and you are back to manual transcription and drift. The format also dictates whether aliases (`{blue.500}`) resolve automatically or rot by hand.

## How it works

The emerging standard is the **W3C Design Tokens Community Group (DTCG)** JSON: every token is an object with `$value` and `$type`, references use `{group.token}` braces, and `$` keys avoid clashing with token names.

```json
{ "color": {
    "blue": { "500": { "$value": "#0A66FF", "$type": "color" } },
    "action": { "bg": { "$value": "{color.blue.500}", "$type": "color" } }
} }
```

A transform tool (commonly **Style Dictionary**) reads that source and emits platform outputs:

| Platform | Output format | Token becomes |
|---|---|---|
| Web | CSS custom properties | `--color-action-bg: #0A66FF;` |
| Web | JS/TS module | `colorActionBg = "#0A66FF"` |
| iOS | Swift | `static let colorActionBg = UIColor(...)` |
| Android | XML resources | `<color name="color_action_bg">` |

Source-of-truth options trade authoring comfort against gitability: hand-edited JSON (diff-friendly, dev-owned), a Figma plugin exporting JSON (designer-owned, see [[design-editor]]), or a token-management SaaS (Tokens Studio, Specify) that syncs both. Whatever the editor, the committed artifact should be flat JSON so [[naming]] and value changes review as clean diffs.

## Example

A team keeps `tokens.json` in the design-system repo. A designer bumps `color.action.bg` from `{blue.500}` to `{blue.600}` via a Figma export; the PR diff is one line. CI runs Style Dictionary, regenerates `variables.css`, `Tokens.swift`, and `colors.xml`, and the three platforms pick up `#0A66FF → #0959D9` on next build — no manual edits in any app repo.

## Pitfalls

- **Resolved values committed instead of references** — exporting `action.bg: #0A66FF` instead of `{blue.500}` destroys the alias, so a primitive change no longer cascades.
- **Format lock-in** — a proprietary binary or tool-only store with no JSON export traps tokens; insist on a plain-text, exportable source.
- **Hand-maintained per-platform files** — editing `colors.xml` directly defeats the pipeline; only the source JSON is authored, the rest are build outputs and should be git-ignored or clearly generated.
- **`$type` omitted** — without types, the transform can't know `#0A66FF` is a color vs a string, breaking color-space or unit conversions.

## See also

- [[design-editor]]
- [[defining-design-tokens]]
- [[naming]]
