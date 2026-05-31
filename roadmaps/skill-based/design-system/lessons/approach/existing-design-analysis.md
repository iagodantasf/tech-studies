---
title: Existing Design Analysis
track: design-system
group: Approach
tags: [design-system, audit]
prerequisites: [making-it-from-existing-design]
see-also: [performing-a-visual-audit, identify-existing-design-process, defining-design-tokens]
---

# Existing Design Analysis

The diagnostic phase of an extraction: systematically reading a shipped product's UI and source to inventory what visual decisions actually exist before deciding which to keep.

## Why it matters

You cannot converge what you haven't counted. Analysis turns "our UI feels inconsistent" into hard numbers — *17 font sizes, 23 greys, 9 button paddings* — which is what unlocks both buy-in and a concrete reduction target. It also separates **drift** (accidental near-duplicates) from **intent** (a deliberately different error state), so convergence later doesn't destroy meaning. This is the input to [[making-it-from-existing-design]].

## How it works

Two complementary lenses, run together:

- **Rendered analysis** — what users see. The [[performing-a-visual-audit]] captures screens and extracts computed values.
- **Source analysis** — what the code says. Grep the stylesheets for the raw vocabulary:

| Dimension | What to extract | Tool |
|---|---|---|
| Color | every hex/rgba, sorted by frequency | CSS scan + dedupe |
| Type | font-size / weight / line-height combos | computed-style dump |
| Spacing | margin/padding/gap values | linter or AST scan |
| Radius / shadow | corner + elevation values | regex over CSS |
| Components | repeated markup shapes | DOM clustering |

Quantify with a **distinct-values** count per dimension and a frequency histogram — the long tail (values used once or twice) is almost always drift to collapse; the head is your real palette. Pair each finding with a screenshot so reviewers see the variant in context, not just a hex code.

## Example

A scan of one app's `*.css`: `grep -oE '#[0-9a-f]{6}' | sort | uniq -c | sort -rn` returns 41 unique hex colors, but the top 8 cover 85% of usages — the other 33 are the drift. Font sizes: 17 distinct, of which `13/14/16` account for most text; `15px` and `17px` appear under 5 times each and are clear accidents. Output is a spreadsheet: dimension, value, count, screenshot, keep/merge/drop.

## Pitfalls

- **Counting source without rendering** — a token defined in CSS may be dead code, or overridden inline; analyze what actually paints, not just what's declared.
- **Ignoring frequency** — treating a once-used `#3b3b3b` as equal to the brand grey inflates the problem and the system.
- **Missing dynamic states** — hover/focus/disabled/error styles hide in pseudo-classes and JS; audit them or the system ships incomplete.
- **No keep/merge/drop column** — an inventory that doesn't drive a decision is just a list; every row needs a verdict.

## See also

- [[performing-a-visual-audit]]
- [[identify-existing-design-process]]
- [[defining-design-tokens]]
