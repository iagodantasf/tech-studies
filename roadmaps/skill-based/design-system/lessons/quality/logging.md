---
title: Logging
track: design-system
group: Quality
tags: [design-system, telemetry]
prerequisites: [component]
see-also: [component-analytics, a-b-tests-experiments, accessibility]
---

# Logging

The instrumentation layer baked into components — structured events for render, interaction, and error — that feeds [[component-analytics]], experiments, and debugging without each consumer wiring it by hand.

## Why it matters

If logging lives in product code, every team re-implements click tracking on the [[button]] differently, event names drift (`btn_click` vs `button.pressed`), and cross-product analysis becomes impossible. Putting a thin, opt-in logging hook inside the system component standardizes the schema once: every button everywhere emits the same shape. That consistency is the precondition for [[component-analytics]] and [[a-b-tests-experiments]] to mean anything — and it surfaces component-level errors (a [[forms]] field throwing on validation) that product-level monitoring misses.

## How it works

Emit **structured, typed events** through an injected sink so the system never hard-codes a vendor:

- **Decouple via a provider** — components call `track(event)`; the consumer supplies the transport (Segment, Amplitude, console in dev). The system ships the schema, not the pipe.
- **Three event classes** — lifecycle (`render`, `mount`), interaction (`click`, `change`, `open`), and error (`boundary_catch`). Keep names namespaced: `ds.button.click`.
- **Sample the firehose** — render events at 10k/sec will swamp a sink; sample lifecycle events, keep interactions and errors at 100%.
- **Privacy by construction** — never log input *values* or PII; log that a field changed, not what was typed. This is a [[governance]] requirement, not a nicety.

| Event class | Example | Sample rate | Why |
|---|---|---|---|
| Lifecycle | ds.modal.render | 1–10% | high volume, low value |
| Interaction | ds.button.click | 100% | drives analytics |
| Error | ds.form.validate_fail | 100% | debugging signal |

Structured fields (`component`, `version`, `variant`, `surface`) make the data joinable; free-text log lines don't.

## Example

The [[button]] fires `{ event: "ds.button.click", version: "4.2", variant: "primary", surface: "checkout" }` through the injected sink. Because the `version` field is present, analytics can later show that `primary` on checkout drives 60% of clicks and that v3 buttons still emit — flagging laggards to migrate. No product team wrote this; they only registered a sink at app root. The same stream powers the readout for any [[a-b-tests-experiments]] on that button.

## Pitfalls

- **Hard-coding a vendor SDK** — couples the whole system to one analytics tool; inject the sink instead.
- **Logging PII** — capturing input values into [[forms]] is a privacy incident waiting to happen; log events, never values.
- **Unsampled render events** — high-frequency lifecycle logs can degrade [[performance]] and bury the signal; sample them.
- **Unstructured strings** — `console.log("button clicked")` can't be aggregated; emit typed objects with stable field names.

## See also

- [[component-analytics]]
- [[a-b-tests-experiments]]
