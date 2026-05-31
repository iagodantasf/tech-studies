---
title: Code Style
track: design-system
group: Content & guidelines
tags: [design-system, code-style]
prerequisites: [naming]
see-also: [naming, contribution-guidelines, component]
---

# Code Style

Code style is the set of formatting and structural conventions every component in the library follows, enforced by tooling so that any file looks like one author wrote it.

## Why it matters

A design system is read and patched by many hands; consistency is what keeps a 60-component library reviewable. If file layout, prop ordering, and import style differ per component, every diff carries cosmetic noise and review slows. The decisive move is to make style **non-negotiable and automated** — a formatter and linter decide, so [[contribution-guidelines]] reviews argue about behavior, not whitespace. Naming is style too; this node assumes the grammar in [[naming]].

## How it works

Split rules into *mechanical* (tool-owned) and *structural* (convention-owned):

| Concern | Owner | Rule |
|---|---|---|
| Formatting | Prettier / formatter | width, quotes, semicolons — never debated |
| Lint | ESLint + a11y plugin | no inline hex, focus states required |
| File layout | convention | one component per folder, fixed file set |
| Prop API | convention | `variant` over boolean flags |
| Imports | lint rule | tokens from package, never relative hex |

Standing rules:

- **No literals in component code** — a lint rule bans raw `#hex` and bare `px`; values come from tokens. This is the most valuable system-specific rule.
- **Predictable file structure** — `Button/{ index, Button.tsx, Button.css, Button.test, Button.stories }`; the shape is guessable.
- **Format on commit** — a pre-commit hook (or CI gate) runs the formatter so unformatted code can't merge.
- **Small, composable APIs** — mirror the [[component]] rules: few props, composition over flags.

## Example

A `.eslintrc` rule `no-restricted-syntax` flags any `#[0-9a-f]{3,6}` literal in `src/components/**`, so a PR adding `color: #0A66FF` fails CI with "use a token". The author replaces it with `var(--color-action)`. Result: a rebrand stays a token edit, and the rule catches the regression that would otherwise silently reintroduce a hardcoded brand color.

## Pitfalls

- **Style by code review** — humans nitpicking formatting is slow and inconsistent; if a tool can decide it, the tool decides.
- **Lint without a token rule** — a generic config that still permits inline hex misses the one rule unique to design systems.
- **Per-component structure** — every folder laid out differently forces readers to re-learn each one.
- **Style rules nobody runs** — a STYLE.md not wired to CI is a suggestion; gate the merge or it rots.

## See also

- [[naming]]
- [[contribution-guidelines]]
