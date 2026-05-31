---
title: Elasticsearch SQL
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, sql]
prerequisites: [query-dsl-overview, fields-data-types]
see-also: [aggregations, runtime-fields, kibana]
---

# Elasticsearch SQL

Elasticsearch SQL lets you query indices with ANSI-SQL `SELECT` statements that the engine translates into [[query-dsl-overview|Query DSL]] under the hood, giving analysts a familiar interface without learning JSON queries.

## Why it matters

SQL is the lingua franca of BI tools and analysts; exposing indices through `_sql` and a JDBC/ODBC driver lets Tableau, DBeaver, or a `bin/elasticsearch-sql-cli` session read Elastic data directly. It is also a fast way to *learn* the DSL: the `translate` API shows the exact native query a `SELECT` compiles to, so SQL doubles as a teaching and debugging aid.

## How it works

The `_sql` endpoint parses the statement, plans it, and pushes work down into native search and [[bucket-aggregations|aggregations]] wherever possible.

- **Pushdown** — `WHERE` becomes filter clauses, `GROUP BY` becomes [[bucket-aggregations|bucket aggs]], `COUNT/AVG/...` become [[metric-aggregations|metric aggs]]; what can't push down is computed in a post-processing layer.
- **Cursors, not offsets** — large result sets page via an opaque `cursor` (built on [[pagination-from-size-search-after-scroll|search_after]]); there is **no `OFFSET`**.
- **`fetch_size`** — caps rows per page (default 1000); send the returned cursor back to `_sql` to get the next page, then close it.
- **Functions** — supports a subset: `MATCH()`/`QUERY()` bridge to full-text, plus date/string/math scalars; unsupported SQL raises a parse error rather than degrading.

| SQL | Compiles to |
|---|---|
| `WHERE status = 200` | `term` filter |
| `GROUP BY host` | `terms` aggregation |
| `MATCH(msg,'timeout')` | `match` query |
| `ORDER BY @timestamp` | `sort` |

## Example

```
POST /_sql?format=txt
{ "query": "SELECT host, COUNT(*) c FROM logs WHERE status >= 500 GROUP BY host ORDER BY c DESC", "fetch_size": 100 }

POST /_sql/translate          -- see the native query this produces
{ "query": "SELECT host, COUNT(*) FROM logs GROUP BY host" }
```

The `translate` call returns a `size:0` request with a `terms` agg on `host` — proof the `GROUP BY` pushed down rather than scanning rows.

## Pitfalls

- **No JOINs** — Elasticsearch SQL cannot join indices; model relations at index time or query each index separately. It is single-index analytics, not a relational engine.
- **`GROUP BY` cardinality cap** — grouping on a very high-cardinality field is bounded and can be approximate, inheriting `terms` aggregation limits.
- **Text vs keyword** — `GROUP BY` / `ORDER BY` need `doc_values`, so they target the `keyword` [[multi-fields|sub-field]]; running them on analyzed `text` errors.
- **Cursors expire and cost memory** — an unclosed cursor holds search context; always `DELETE /_sql/close` (or page to the end) like you would a [[pagination-from-size-search-after-scroll|scroll]].

## See also

- [[query-dsl-overview]]
- [[bucket-aggregations]]
