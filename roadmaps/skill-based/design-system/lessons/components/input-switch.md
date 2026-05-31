---
title: Input — Switch
track: design-system
group: Components
tags: [design-system, forms]
prerequisites: [component]
see-also: [input-checkbox, forms, accessibility]
---

# Input — Switch

A toggle for a **single binary setting that takes effect immediately** — on/off — styled as a sliding thumb in a track.

## Why it matters

A switch and a [[input-checkbox]] look interchangeable but carry different promises: a switch implies an *instant* state change (like a physical light switch), while a checkbox implies a selection that's committed later on submit. Using a switch inside a form that needs a Save button — or a checkbox for an instant setting — breaks user expectations. The system must define which is which so settings vs forms stay consistent.

## How it works

A switch is a binary control with immediate side-effects, built on checkbox semantics with a toggle role:

- **Immediate effect** — flipping it applies the change now; no separate submit. If the change can fail (server call), reflect pending/rollback.
- **Two states only** — on / off; no indeterminate (that's a checkbox concern).
- **Label & semantics** — visible label; `role="switch"` with `aria-checked`; the whole label is the target.
- **Clarity** — don't rely on color alone for on/off; thumb position is the primary cue.

| Use a… | When | Commit |
|---|---|---|
| Switch | Instant setting | Immediate |
| Checkbox | Form selection | On submit |
| Radio | Exclusive choice | On submit |

If applying the change is async and may fail, optimistically move the thumb, then roll back with a [[banner]]/toast on error.

## Example

A "Dark mode" switch in settings: flipping it on immediately re-themes the app — no Save. It exposes `role="switch" aria-checked="true"`, a visible label, and a focus ring. For a server-backed "Email notifications" switch, the thumb moves instantly (optimistic), a request fires, and if it 500s the thumb snaps back with an error toast — the UI never lies about the persisted state.

## Pitfalls

- **Switch that needs a Save button** — contradicts the instant-effect promise; use a [[input-checkbox]] in forms.
- **Color-only state** — on/off by hue alone fails colorblind users; thumb position must carry it. See [[accessibility]].
- **No async failure handling** — showing "on" when the save failed misrepresents state; reflect pending and roll back.
- **Missing `role="switch"`** — a plain checkbox is announced as such; set the toggle role for correct semantics.

## See also

- [[input-checkbox]]
- [[forms]]
