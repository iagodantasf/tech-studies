---
title: RAG and Vector Databases
track: ai-agents
group: Memory
tags: [ai-agents, rag]
prerequisites: [embeddings-and-vector-search]
see-also: [long-term-memory, context-windows]
---

# RAG and Vector Databases

Retrieval-Augmented Generation (RAG) grounds an LLM by fetching relevant chunks from an external corpus at query time and pasting them into the prompt; a vector database is the index that makes that fetch fast.

## Why it matters

It is the dominant way to give an agent knowledge it wasn't trained on — your docs, a user's history, last week's tickets — without [[fine-tuning-vs-prompt-engineering|fine-tuning]]. RAG slashes hallucination by forcing answers to cite retrieved text, sidesteps the [[context-windows|window]] limit by sending only the relevant slice, and keeps knowledge fresh (re-index, don't re-train). It is the retrieval engine behind agent [[long-term-memory]].

## How it works

Two phases: an offline **index** build and an online **retrieve-then-generate** loop, both built on [[embeddings-and-vector-search]].

- **Index (offline).** Chunk docs (~200–500 tokens, with overlap) → embed each → store `vector + text + metadata` in the vector DB.
- **Retrieve (online).** Embed the query with the *same* model → ANN top-k (HNSW/IVF) → optionally re-rank with a cross-encoder.
- **Generate.** Stuff the top chunks into the prompt with an instruction to answer *only* from them and cite sources.
- **Hybrid + filter.** Fuse vector with BM25 keyword search, and pre-filter by metadata (`user_id`, `date`) so retrieval stays scoped.

| Vector DB | Note |
|---|---|
| pgvector | Postgres extension, SQL + vectors together |
| Qdrant / Weaviate | dedicated, rich metadata filtering |
| FAISS | in-process library, no server |
| Pinecone | managed, serverless |

## Example

Answering from a 50K-chunk knowledge base:

```
Q: "what's our refund window?"
  embed Q → ANN top-3 (filter: doc_type=policy)
    0.88  "Refunds accepted within 30 days of purchase…"
    0.81  "Exceptions for digital goods…"
  prompt: "Answer ONLY from context. <chunks> Q: …"
  → "Refunds are accepted within 30 days." [cites chunk 1]
```

The model never memorized the policy; it reads it from the retrieved chunk and cites it, so the answer is verifiable.

## Pitfalls

- **Bad chunking.** Chunks too big dilute the vector; too small lose context — the single biggest RAG quality lever.
- **No re-ranking / threshold.** Top-k always returns *something*; without a score floor you feed confident garbage to the model.
- **Model mismatch.** Indexing and querying with different embedding models silently destroys recall — pin one version.
- **Stale index.** Vectors don't auto-update; re-embed when source docs change or answers drift from current reality.

## See also

- [[long-term-memory]]
- [[context-windows]]
