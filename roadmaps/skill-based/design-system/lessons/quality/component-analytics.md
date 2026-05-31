---
title: Component Analytics
track: design-system
group: Quality
tags: [design-system, analytics]
prerequisites: [component-library]
see-also: [logging, a-b-tests-experiments, governance]
---

# Component Analytics

Measuring which system components are actually used, in what versions, and on which surfaces — the adoption telemetry that tells a system team what's working and what to deprecate.

## Why it matters

Without analytics a system team flies blind: they can't tell a beloved [[button]] from a dead [[carousel]], can't prove adoption to leadership, and can't safely deprecate anything because they don't know who depends on it. Usage data turns [[governance]] from politics into evidence — "12 teams import the old `Dropdown@2`, here's the migration list" — and exposes *non*-consumption (a team rebuilding a [[modal]] you already ship), which is the real ROI leak.

## How it works

Two complementary sources: **static** (what's in the code) and **runtime** (what users touch):

- **Static / build-time** — scan consumer repos' imports and lockfiles for `@ds/*` packages and versions. Tools like the design-system-managers's `react-scanner` produce a per-component, per-version, per-team usage map without shipping any tracking.
- **Runtime instrumentation** — components emit a lightweight render/interaction event (the [[logging]] layer) so you see real impressions and clicks, segmented by surface.
- **Adoption as a ratio** — `system components / total components rendered` per app; a rising ratio is the headline health metric.
- **Version spread** — how traffic distributes across versions tells you whether a deprecation is safe to enforce.

| Metric | Source | Question it answers |
|---|---|---|
| Adoption rate | static scan | how much of the UI is "ours" |
| Component usage count | static scan | what to invest in vs retire |
| Version distribution | lockfiles / runtime | is deprecation safe |
| Interaction rate | runtime events | which variants users prefer |

## Example

A quarterly `react-scanner` run across 60 repos: `Button` imported in 58, `Carousel` in 2, and **34%** of `Dropdown` usage still on the deprecated v2. Action: fast-track the 2 carousel teams to a simpler component and schedule v2 removal once those 34% migrate. Adoption rose from 41% → 67% over three quarters — the number that justified the team's headcount at the next [[governance]] review. Feed the same data into [[a-b-tests-experiments]] to weight rollouts.

## Pitfalls

- **Runtime-only tracking** — misses imported-but-rarely-rendered components and adds telemetry weight; static scans are cheaper and complete.
- **Vanity adoption number** — "67% adopted" hides that the other 33% is one critical checkout flow on a fork; segment it.
- **No version dimension** — you know `Dropdown` is used but not that a third is on a version you want to kill.
- **Counting installs, not renders** — a package in `node_modules` isn't usage; measure actual import/render.

## See also

- [[logging]]
- [[a-b-tests-experiments]]
