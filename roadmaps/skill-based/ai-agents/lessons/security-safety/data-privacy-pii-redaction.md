---
title: Data Privacy / PII Redaction
track: ai-agents
group: Security / Safety
tags: [ai-agents, pii-redaction]
prerequisites: [acting-tool-invocation]
see-also: [prompt-injection-jailbreaks, long-term-memory]
---

# Data Privacy / PII Redaction

Detecting and stripping personally identifiable information before it reaches a third-party model, gets logged, or lands in [[long-term-memory]] — so a chat about a customer doesn't leak that customer's data.

## Why it matters

Every prompt you send to a hosted model leaves your trust boundary, and every trace you keep ([[langfuse|Langfuse]], [[helicone|Helicone]]) is a copy of that data at rest. Sending raw PII risks GDPR/HIPAA violations, vendor retention you can't audit, and PII baked into a vector index forever. Redaction lets you use closed-weight models on regulated data while keeping the actual identifiers inside your perimeter.

## How it works

A redaction layer sits *around* the LLM: scrub on the way in, optionally restore on the way out. The standard trick is **reversible tokenization** so the model still reasons over structure.

- **Detect** — regex for structured PII (email, SSN, card, IBAN) plus NER (Presidio, spaCy) for names, locations, orgs. Combine; neither alone is enough.
- **Tokenize, don't delete** — replace `Jane Doe` → `[PERSON_1]`, keep a request-scoped map, then **rehydrate** placeholders in the final answer. Deleting outright destroys the model's ability to refer back.
- **Redact the whole pipeline** — inputs, *outputs*, logs, traces, and memory writes. A PII-free prompt with a fully-logged response still leaks.
- **Minimize at the source** — don't fetch the SSN column if the task is "summarize the ticket".

| Technique | Reversible | Use when |
|---|---|---|
| Masking (`****1234`) | no | display only |
| Placeholder tokens | yes | send to LLM, restore after |
| Hashing | no (lookup) | join / dedupe keys |
| Format-preserving encryption | yes | keep type, e.g. fake-but-valid card |

## Example

```
in : "Email john@acme.com re invoice; SSN 123-45-6789"
map: {john@acme.com→[EMAIL_1], 123-45-6789→[SSN_1]}
LLM sees: "Email [EMAIL_1] re invoice; SSN [SSN_1]"
LLM out : "I drafted a note to [EMAIL_1] confirming [SSN_1]."
rehydrate → "...to john@acme.com confirming 123-45-6789."
```

The vendor's logs only ever held `[EMAIL_1]`; the real value never crossed the boundary.

## Pitfalls

- **Regex-only detection** misses names, addresses, and free-text PII — pair it with NER and expect a residual miss rate.
- **Forgetting outputs and memory.** The model can echo or infer PII; scrub responses and anything written to [[rag-and-vector-databases|the vector store]], not just inputs.
- **Irreversible redaction breaks tasks** that need the value back (sending the email); use placeholder mapping when round-trip is required.
- **Leaky map storage.** The placeholder→value map *is* the PII — keep it in-process and short-lived, never in the same log you ship to the vendor.

## See also

- [[prompt-injection-jailbreaks]]
- [[long-term-memory]]
