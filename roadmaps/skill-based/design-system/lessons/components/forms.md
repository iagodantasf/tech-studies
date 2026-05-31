---
title: Forms
track: design-system
group: Components
tags: [design-system, forms]
prerequisites: [component, input-text]
see-also: [input-text, button, microcopy-guidelines]
---

# Forms

The pattern for collecting structured input — fields, labels, help text, validation, and submission — that composes the individual input components into a coherent flow.

## Why it matters

Forms are where users do real work and where products lose them: bad validation, ambiguous errors, and lost data on submit drive abandonment. A form is a [[pattern]], not a single [[component]] — it arranges [[input-text]], [[input-checkbox]], [[dropdown]], and a [[button]] under shared rules for labeling, errors, and layout. Standardizing those rules once is the difference between every form feeling the same and every team reinventing validation.

## How it works

A field is the unit; the form is the orchestration:

- **Field anatomy** — label (always visible) + control + help text + error message, vertically stacked. Placeholders are *not* labels.
- **Validation timing** — validate on **blur** and on **submit**, not on every keystroke; clear an error as soon as the user fixes it.
- **Error display** — inline, beside the field, tied via `aria-describedby`; plus a summary at the top that links to the first invalid field.
- **Submission** — disable the submit [[button]] while pending, show a [[loading-indicator]], and never lose entered data on failure.

| Concern | Rule |
|---|---|
| Label | Visible, `for`/`id` linked |
| Required | Marked, not color-only |
| Error | Inline + describedby + summary |
| Timing | Validate on blur/submit |

Group related fields with `<fieldset>`/`<legend>`; keep [[microcopy-guidelines]] for help and error wording.

## Example

A signup form: email and password fields, each with a visible label and help text. The user blurs the email field with "ada@" — an inline error "Enter a valid email" appears, linked by `aria-describedby`, and the top summary lists it. They fix it; the error clears on the next blur. Submit disables and spins; a server rejection re-renders the form with all typed values intact and the password preserved per UX (not cleared).

## Pitfalls

- **Placeholder as label** — it vanishes on focus and fails [[accessibility]]; always show a real label.
- **Validating on every keystroke** — error flicker punishes mid-typing; wait for blur/submit.
- **Clearing the form on error** — re-typing everything causes abandonment; preserve input.
- **Color-only required/error** — pair with text/icon, never hue alone. See [[functional-colors]].

## See also

- [[input-text]]
- [[button]]
