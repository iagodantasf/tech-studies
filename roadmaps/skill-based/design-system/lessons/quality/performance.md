---
title: Performance
track: design-system
group: Quality
tags: [design-system, performance]
prerequisites: [component-library]
see-also: [component, defining-design-tokens, component-analytics]
---

# Performance

Keeping the cost a consumer pays for the system — bytes shipped, runtime work, and render churn — low enough that adopting it never makes their product slower.

## Why it matters

A design system sits on the critical path of every product that uses it, so its costs are multiplied, not isolated. A 40 KB icon set that ships *all* glyphs, a `styled-components` runtime that re-parses CSS on each render, or a [[modal]] that mounts on page load instead of on open — each quietly taxes Largest Contentful Paint and Interaction-to-Next-Paint across the whole org. Teams adopt a system to go faster; if it regresses Core Web Vitals, they fork or rip it out.

## How it works

Attack the three costs separately — bundle size, runtime, and render:

- **Tree-shakeable exports** — named ESM exports with `"sideEffects": false` so a consumer importing `Button` doesn't pull the other 80 components. Barrel files (`export * from`) defeat this; verify with a bundle analyzer.
- **Zero-runtime styling** — extract CSS at build (CSS Modules, Vanilla Extract, Tailwind) instead of CSS-in-JS that serializes on render. [[defining-design-tokens]] as CSS custom properties means theming is a variable swap, no re-render.
- **Render discipline** — memoize stable subtrees, virtualize long [[list]]s, lazy-load heavy widgets (`carousel`, rich editors) behind a dynamic import.
- **Ship a budget** — fail CI if a component's gzipped size grows beyond a threshold.

| Lever | Anti-pattern | Fix | Typical win |
|---|---|---|---|
| Bundle | barrel re-exports | per-component entry points | 50–90% less JS |
| Icons | one big sprite/font | per-icon SVG components | ship only used |
| Styling | runtime CSS-in-JS | build-time extraction | no render-time cost |
| Lists | render 10k rows | virtualize viewport | constant DOM |

## Example

A team imports one [[button]] but the barrel `index.js` re-exports everything, so the bundle gains **180 KB** gzipped. Switching consumers to `@ds/button` (a real entry point) and marking the package side-effect-free drops it to **6 KB** — the rest tree-shakes away. A size-limit check in CI then blocks any future regression past the 8 KB budget. Track real-world impact with [[component-analytics]].

## Pitfalls

- **Barrel files** — `export *` from one index makes the whole library one chunk; tree-shaking can't help.
- **Shipping all icons** — a 1,200-glyph icon font for the 12 you use; import per-icon instead.
- **CSS-in-JS on the hot path** — runtime style serialization shows up as INP on low-end phones.
- **Budgets you don't enforce** — a number in a doc is ignored; gate it in CI or it drifts up.

## See also

- [[component-analytics]]
- [[defining-design-tokens]]
