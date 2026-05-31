---
title: Ragas
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, rag-eval]
prerequisites: [rag-and-vector-databases]
see-also: [deepeval, embeddings-and-vector-search]
---

# Ragas

An open-source framework for evaluating **RAG pipelines** specifically, scoring retrieval and generation separately so you know *which half* is broken.

## Why it matters

A [[rag-agent|RAG]] answer can be wrong two ways: retrieval pulled the wrong chunks, or generation ignored good chunks and hallucinated. A single end-to-end score can't tell them apart. Ragas splits the diagnosis into **retrieval metrics** (context precision/recall) and **generation metrics** (faithfulness, answer relevancy), so a low score points at the embedder/retriever vs the prompt. Many metrics are **reference-free** — computed from the question, contexts, and answer alone — so you can run them on production traffic without gold labels.

## How it works

Each sample needs up to four fields: `question`, `contexts` (retrieved chunks), `answer`, and optionally `ground_truth`. Metrics map onto the RAG stages.

| Metric | Stage | Needs ground truth? |
|---|---|---|
| Context Precision | retrieval | no (uses answer) |
| Context Recall | retrieval | yes |
| Faithfulness | generation | no |
| Answer Relevancy | generation | no |

- **Faithfulness.** Decompose the answer into claims, check each is supported by `contexts`; score = supported / total — the hallucination detector.
- **Context Precision.** Are the *relevant* chunks ranked high? Penalizes a retriever that buries the right passage under noise.
- **Context Recall (needs ground truth).** Did retrieval fetch everything the reference answer requires? The one metric that needs labels.
- **LLM-powered.** Most metrics call a judge LLM and an [[embeddings-and-vector-search|embedding]] model; configure both, and budget for their cost.

## Example

Scoring a RAG eval set:

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_precision

result = evaluate(dataset,                       # question/contexts/answer rows
    metrics=[faithfulness, answer_relevancy, context_precision])
# faithfulness 0.78  answer_relevancy 0.91  context_precision 0.62
```

Here relevancy is high but **context_precision 0.62** is low: generation is fine — the retriever is the bottleneck, so fix chunking/top-k, not the prompt.

## Pitfalls

- **Misreading the split.** Tuning the prompt when context precision is the low metric wastes effort; let the per-stage scores direct the fix.
- **Judge/embedding cost.** Every metric is LLM/embedding calls; a big set gets slow and expensive — sample or run offline.
- **Recall needs labels.** Context recall silently can't run without `ground_truth`; supply it or rely on the reference-free metrics.
- **Treating scores as absolute.** Use them to compare config A vs B and track trends, not as a universal pass mark.

## See also

- [[deepeval]]
- [[embeddings-and-vector-search]]
