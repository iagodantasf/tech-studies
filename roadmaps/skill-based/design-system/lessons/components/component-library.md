---
title: Component Library
track: design-system
group: Components
tags: [design-system, library]
prerequisites: [component, defining-design-tokens]
see-also: [component-catalog, design-system-vs-component-library, code-style]
---

# Component Library

The coded, versioned, installable package of reusable components — the implementation layer a design system ships to product teams.

## Why it matters

The library is where the system runs in production. It turns tokens and specs into something `npm install`-able, so 40 teams render the same accessible [[button]] from one source instead of 40 forks. It is *part of* a system, not the whole of it — see [[design-system-vs-component-library]]. Its versioning, bundle size, and API stability directly shape whether teams adopt or route around it.

## How it works

A library is a software product with its own contract:

- **Tokens as the base layer** — components consume [[defining-design-tokens]]; the same tokens can feed web, iOS, Android.
- **Distribution** — semver package(s); breaking changes bump major. See [[contribution-guidelines]].
- **Tree-shakeable** — per-component imports so apps pay only for what they use. See [[performance]].
- **Tested** — unit, visual-regression, and [[accessibility-testing]] in CI gate every release.

| Concern | Good practice | Why |
|---|---|---|
| Versioning | Semver, changelog | Predictable upgrades |
| Bundling | ESM, tree-shake | Smaller payload |
| Theming | Tokens via CSS vars | Runtime [[dark-mode]] |
| API | Stable, documented | Trust, low churn |

Single-package vs per-component packages is a real trade: a monopackage is simpler to consume; scoped packages let teams upgrade [[modal]] without touching [[button]]. Keep code conventions enforced — see [[code-style]].

## Example

`@acme/ui@3.4.0` exports 32 components as ESM. An app does `import { Button } from '@acme/ui'`; the bundler tree-shakes the rest, adding ~4 KB gz for that one part. Theming is CSS custom properties, so `:root[data-theme=dark]` re-points tokens and restyles the whole library with no JS. A major bump to `4.0` lands with a codemod and a migration page in the [[component-catalog]].

## Pitfalls

- **No tree-shaking** — one import drags the entire library into the bundle; audit with a size budget. See [[performance]].
- **Breaking changes in a minor** — violates semver and shatters trust; gate with CI and changelogs.
- **Library without tokens** — hardcoded values make theming and rebrands impossible.
- **Equating the library with the system** — skips guidelines, content, and governance. See [[design-system-vs-component-library]].

## See also

- [[component-catalog]]
- [[design-system-vs-component-library]]
