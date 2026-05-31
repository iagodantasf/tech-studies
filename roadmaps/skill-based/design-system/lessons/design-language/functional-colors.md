---
title: Functional Colors
track: design-system
group: Design language
tags: [design-system, color]
prerequisites: [color]
see-also: [dark-mode, accessibility, defining-design-tokens]
---

# Functional Colors

Colors assigned to a *meaning* rather than a brand identity — success, danger, warning, info — defined as semantic tokens so the same intent looks identical everywhere.

## Why it matters

Functional color is how the UI communicates state without words: a red field border means "fix this," a green toast means "it worked." If "error red" is a different hex on the form, the toast, and the inline alert, users stop trusting the signal. Defining these as roles (`color.danger`) rather than values (`#E5484D`) means a single token drives every error affordance, and a [[dark-mode]] remap happens once. It's also load-bearing for [[accessibility]]: meaning carried by color alone excludes color-blind users.

## How it works

Each functional role gets its own *mini-ramp*, not a single swatch, because you need a fill, a border, a text color, and a subtle background that all read as "danger":

- **Roles**: `success`, `danger` (a.k.a. error), `warning`, `info`, often `neutral`.
- **Per role, multiple tokens**: `danger.bg`, `danger.border`, `danger.text`, `danger.solid`.
- **Never color-only**: pair with an icon, text, or shape so meaning survives grayscale. See [[monochrome-version]].

| Role | Typical hue | Common UI |
|---|---|---|
| Success | green | confirmation toast, valid field |
| Danger | red | destructive [[button]], form error |
| Warning | amber | non-blocking caution |
| Info | blue | neutral notice |

Watch the **danger/warning clash**: red and amber sit close in hue and are the classic red-green confusion pair, so lean on icon + label, not just the swatch. Map roles to ramp steps from [[color]] and freeze as [[defining-design-tokens]].

## Example

A form field fails validation: border → `color.danger.border`, helper text → `color.danger.text` ("Enter a valid email"), plus a `!` icon. A red-green color-blind user still parses it via the icon and copy. In dark mode, only the four `danger.*` tokens remap; no component changes. Contrast a brittle build where error styling is a hardcoded `#FF0000` border with no message — invisible meaning in grayscale and to ~8% of men.

## Pitfalls

- **Meaning by color alone** — fails ~8% of men (red-green); always add icon/text. A [[monochrome-version]] is the quick test.
- **One swatch per role** — a single red can't serve fill, border, *and* text legibly; define a mini-ramp.
- **Brand color collides with a signal** — if brand *is* red, your danger state needs another distinguishing cue.
- **Warning ≈ danger** — amber-on-red confusion; differentiate with iconography, not just hue.

## See also

- [[dark-mode]]
- [[accessibility]]
