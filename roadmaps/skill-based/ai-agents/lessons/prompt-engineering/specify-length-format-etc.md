---
title: Specify Length, Format, etc.
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, structured-output]
prerequisites: [be-specific-in-what-you-want]
see-also: [llm-native-function-calling, max-length-max-tokens]
---

# Specify Length, Format, etc.

Output shaping is constraining the *form* of a response — length, structure, schema, tone — so it can be consumed by code or a human without post-processing.

## Why it matters

In an agent, the model's output is rarely the final answer — it is the *input to the next step*: a tool call, a parser, a UI. If the model wraps JSON in prose or returns 12 bullets when you needed 3, the downstream parser breaks and the loop stalls. Format control turns free text into a reliable interface, which is exactly why provider [[llm-native-function-calling|function-calling]] APIs exist.

## How it works

State the container, the size, and the style — and prefer machine-checkable formats:

| Lever | Weak | Strong |
|---|---|---|
| Length | "be brief" | "max 50 words" / "exactly 3 bullets" |
| Structure | "list them" | "return a JSON array of strings" |
| Schema | "include fields" | "keys: name, age (int), active (bool)" |
| Tone | "be nice" | "formal, second person, no emoji" |

Length asks are *soft* — models count tokens, not words, so "50 words" is approximate; for a hard ceiling combine the instruction with [[max-length-max-tokens|max_tokens]]. For structured data, don't hand-prompt JSON and hope — use the provider's **structured-output / JSON mode**, which constrains decoding to valid syntax, or [[llm-native-function-calling]] with a schema, so the result parses every time. A worked example in the prompt ("return like this: `{...}`") raises format adherence more than any adjective. Put the format spec *last*, nearest the generation point, where it most influences the next token.

## Example

Same task, free-form vs. contract-enforced:

```
Prompt A: "Extract the people mentioned."
→ "I found John (30) and Mary, who seems active..."   # unparseable

Prompt B (JSON mode + schema):
  "Extract people as JSON matching:
   [{name: string, age: int|null, active: bool}]"
→ [{"name":"John","age":30,"active":true},
   {"name":"Mary","age":null,"active":true}]           # json.loads() works
```

B drops straight into code; A needs a regex and a prayer.

## Pitfalls

- **Trusting word counts** — length instructions are approximate; enforce hard limits with `max_tokens`, but know that truncation can cut JSON mid-token.
- **Prompted JSON without a mode** — plain instructions still leak ` ```json ` fences or trailing commentary; use real structured-output APIs.
- **Over-tight token caps** — a low `max_tokens` truncates mid-structure, producing invalid JSON; size it to the expected output plus headroom.
- **Format vs. content conflict** — "one word" on a question needing nuance forces a lossy answer; match the container to the task.

## See also

- [[llm-native-function-calling]]
- [[max-length-max-tokens]]
