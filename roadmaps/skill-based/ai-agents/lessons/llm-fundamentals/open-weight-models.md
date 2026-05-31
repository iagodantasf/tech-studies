---
title: Open-Weight Models
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, self-hosting]
prerequisites: [api-requests]
see-also: [closed-weight-models, fine-tuning-vs-prompt-engineering]
---

# Open-Weight Models

An open-weight model ships its trained parameters publicly (Llama 3, Mistral, Qwen, Gemma) so you can download, run, fine-tune, and quantize it on your own hardware.

## Why it matters

Open weights give an agent three things hosted APIs can't: data stays in your VPC, the model can't be deprecated out from under you, and marginal cost is GPU-hours not per-token — decisive at high volume or under strict privacy. The trade is that you own the serving stack, the quality ceiling is usually a step behind the frontier [[closed-weight-models]], and "open weights" rarely means open data or a truly free license.

## How it works

You pull a checkpoint (often from Hugging Face) and serve it behind an OpenAI-compatible endpoint with an inference engine like vLLM, TGI, or llama.cpp.

- **Quantization** shrinks weights from fp16 → 8/4-bit so a model fits a given GPU; a 70B model needs ~140 GB at fp16 but ~40 GB at 4-bit, at a small quality cost.
- **Serving throughput** comes from batching and paged-KV-cache (vLLM); a single A100 can serve an 8B model to many concurrent agents.
- **Customization** you fully control: LoRA/QLoRA fine-tunes (see [[fine-tuning-vs-prompt-engineering]]), custom tool grammars, logit bias, and forced-grammar JSON.

| Size class | fp16 VRAM | 4-bit VRAM | Typical use |
|---|---|---|---|
| 7–8B | ~16 GB | ~6 GB | fast tool-calling agents |
| 13B | ~26 GB | ~10 GB | better reasoning |
| 70B | ~140 GB | ~40 GB | near-frontier, multi-GPU |

## Example

Serve Llama-3-8B and call it like OpenAI:

```
vllm serve meta-llama/Meta-Llama-3-8B-Instruct --port 8000
POST http://localhost:8000/v1/chat/completions
body: { model:"...8B-Instruct", messages:[...] }
→ runs entirely in your VPC; no per-token bill, just GPU time
```

Swapping a hosted endpoint for this is a base-URL change when the server is OpenAI-compatible.

## Pitfalls

- **License ≠ open source.** Llama's license restricts some commercial use and forbids training competitors; read it before shipping.
- **Quantize too aggressively.** 3-bit can quietly wreck tool-call formatting and math; benchmark your own evals, not just perplexity.
- **Underestimating ops.** GPUs, autoscaling, KV-cache OOMs, and upgrades are now your problem — a 429 becomes a 3am page.
- **Weaker native function calling.** Many open models need a server-enforced JSON grammar to match hosted tool-use reliability.

## See also

- [[closed-weight-models]]
- [[fine-tuning-vs-prompt-engineering]]
