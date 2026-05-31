---
title: Microcopy Guidelines
track: design-system
group: Content & guidelines
tags: [design-system, content]
prerequisites: [guidelines]
see-also: [naming, forms, accessibility]
---

# Microcopy Guidelines

Microcopy guidelines are the rules for the small in-product text a design system owns — button labels, field hints, empty states, error messages — so that voice and wording stay consistent across teams.

## Why it matters

The same product can say "Log in", "Sign in", and "Login" on three screens; each looks fine in isolation and incoherent together. Microcopy is UI, and a system that tokenizes color but lets every team freestyle its error text ships an inconsistent product. Good error copy also measurably reduces support tickets and form abandonment — the words *are* the UX. This is the content-quality counterpart to visual [[guidelines]].

## How it works

Codify a small set of rules and standard strings:

| Element | Rule | Good | Bad |
|---|---|---|---|
| Buttons | verb, action it does | `Save changes` | `Submit`, `OK` |
| Errors | cause + fix, no blame | `Enter a valid email` | `Invalid input` |
| Empty states | what + next action | `No invoices yet — create one` | `Empty` |
| Casing | sentence case | `Forgot password?` | `Forgot Password?` |

Standing rules:

- **Voice in a sentence** — "clear, calm, never cute"; pick adjectives and show on/off-voice examples.
- **Second person, active** — "Choose a plan", not "The user should choose a plan".
- **Errors: cause, then remedy** — say what happened and the next step; never "An error occurred".
- **Numbers and units** — fix date, currency, and pluralization formats once (`1 item` / `2 items`).
- **Ties to [[naming]]** — UI labels and code identifiers should agree; if the button says "Archive", the prop isn't `delete`.

## Example

A field rejects a weak password. Bad: *"Error: invalid."* Good: *"Use at least 8 characters, including a number."* — cause and fix, sentence case, no blame, [[accessibility]]-friendly because it pairs with `aria-describedby`. Captured as a reusable string `validation.password.length` so all [[forms]] read identical text, the way components read a shared token.

## Pitfalls

- **Cleverness over clarity** — jokey empty states that confuse first-time users; charm fades, friction stays.
- **Generic errors** — "Something went wrong" with no cause or action is the single most common copy failure.
- **Title Case everywhere** — inconsistent casing reads sloppy; pick one (usually sentence case) and lint for it.
- **Copy that blocks localization** — concatenated fragments ("You have " + n + " items") break in other languages; use full templated strings.

## See also

- [[naming]]
- [[forms]]
