---
title: Database Queries
track: ai-agents
group: Tools an Agent Can Use
tags: [ai-agents, databases]
prerequisites: [databases, acting-tool-invocation]
see-also: [code-execution-repl, rag-and-vector-databases]
---

# Database Queries

A tool that lets an agent read (and sometimes write) structured data by issuing queries — typically text-to-SQL — against a real database.

## Why it matters

Most business truth lives in relational tables, not documents. An agent that can query a DB answers "what was Q3 revenue by region?" with *exact* numbers instead of a guess. This is the backbone of analytics copilots and operational agents. Unlike [[rag-and-vector-databases]] (fuzzy, semantic), SQL is *precise and aggregatable* — the right tool when the answer is a computed fact, not a relevant passage. See [[databases]].

## How it works

The model is given the **schema** (tables, columns, types, a few example rows), generates SQL, the tool executes it, and rows return as the observation. The schema is the single most important input — without it the model invents column names.

- **Schema injection** — put `CREATE TABLE` statements or a compact column list in the prompt. For big schemas, retrieve only the relevant tables first.
- **Read-only by default** — connect as a role with `SELECT`-only grants. Let the database, not a regex, enforce safety.
- **Guardrails** — auto-append `LIMIT`, set a statement timeout, block `DROP`/`DELETE`/`UPDATE` unless explicitly enabled with confirmation ([[human-in-the-loop-evaluation]]).
- **Parameterize** — never string-concat user values into SQL; the model writing SQL is fine, but injected *parameters* must be bound. See [[databases]].
- **Self-correction** — return DB errors verbatim so the model fixes a typo'd column or bad `JOIN` and retries.

| Risk | Mitigation |
|---|---|
| Destructive write | read-only DB role |
| Full-table scan | forced `LIMIT` + timeout |
| Wrong column/JOIN | schema in prompt + error feedback |
| Huge result set | cap rows, summarize |

## Example

```
schema: orders(id, region, amount, created_at)
user: "total revenue per region in Q3 2025"
model → SELECT region, SUM(amount) AS rev
        FROM orders
        WHERE created_at >= '2025-07-01' AND created_at < '2025-10-01'
        GROUP BY region ORDER BY rev DESC;
rows  → [("EMEA", 412000), ("AMER", 388500), ...]
```

Exact aggregates a vector store could never produce.

## Pitfalls

- **Hallucinated columns** when the schema is missing or stale — the query 500s or, worse, silently returns wrong data.
- **Returning thousands of rows** floods [[context-windows]]; aggregate or paginate, and prefer `COUNT`/`SUM` over dumping rows.
- **Semantic-not-syntactic errors** — valid SQL with the wrong `JOIN` gives a confidently wrong number; validate against known totals.
- **Trusting "read-only" prompts** — only a restricted DB grant truly prevents writes; never rely on instructions alone.

## See also

- [[code-execution-repl]]
- [[rag-and-vector-databases]]
