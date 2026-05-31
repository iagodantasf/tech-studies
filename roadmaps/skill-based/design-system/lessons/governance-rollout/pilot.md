---
title: Pilot
track: design-system
group: Governance & rollout
tags: [design-system, adoption]
prerequisites: [component-library, milestones]
see-also: [milestones, component-analytics, communication-channel]
---

# Pilot

A pilot is the first real adoption of a design system by one carefully chosen product team — a controlled rollout that proves the system works in production before you ask the whole org to migrate.

## Why it matters

A design system validated only by its own demos is untested; the first time it meets a real codebase, deadline, and edge case is the real test. A pilot surfaces the gaps — a missing prop, an un-themed state, a slow [[component]] — while the blast radius is one team, not forty. It also produces the only proof that converts skeptics: a shipped feature built on the system, with a real adoption number behind it. Pilots are the gate at the end of the M1 [[milestones]] step, the bridge between "built" and "adopted".

## How it works

Choose the pilot team deliberately and scope it to a single shippable surface:

| Choose a team that | Avoid a team that |
|---|---|
| ships a real feature this quarter | is mid-crunch on a deadline |
| has a few core component needs | needs 30 components on day one |
| will give honest, fast feedback | is a captive internal tool only |
| is visible enough to be a reference | nobody else watches or trusts |

Run it as a tight loop: pair an engineer from the core team with the pilot team, ship one feature, and instrument adoption from the start via [[component-analytics]]. Keep a fast feedback channel open (see [[communication-channel]]) so a blocker becomes a same-week fix, not a backlog ticket. Define success up front as a number — e.g. *80% of the feature's UI imports the system* — and a short list of must-fix gaps. The pilot's bugs *are* the v1.1 backlog.

## Example

A team shipping a new billing page is picked as pilot for `@acme/ui@1.0`. Week 1: they hit a missing `Input` error state and a [[modal]] that can't stack — both filed and fixed within the sprint. Week 4: the page ships with 82% of its UI imported from the system (measured, not estimated). That single shipped page becomes the reference link every later team is shown, and the three gaps it exposed define the v1.1 backlog. Adoption then spreads team-by-team off that proof, not off a mandate.

## Pitfalls

- **Wrong pilot team** — a team mid-crunch or building a throwaway tool gives noisy, unrepresentative signal.
- **Too broad a scope** — piloting across five teams at once dilutes support and hides which gaps are real.
- **No instrumentation** — a pilot with no adoption metric proves nothing you can show a sponsor.
- **Ignoring the findings** — collecting pilot feedback and not shipping the fixes tells the next team the system won't support them.

## See also

- [[milestones]]
- [[communication-channel]]
