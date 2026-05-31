---
title: Relevance scoring (BM25)
track: elasticsearch
group: Querying (Query DSL)
tags: [elasticsearch, relevance]
prerequisites: [inverted-index, full-text-search]
see-also: [full-text-search, compound-queries, query-vs-filter-context]
---

# Relevance scoring (BM25)

BM25 (Best Match 25) is the default similarity that turns term matches into the `_score` ranking each hit — balancing term frequency, rarity, and document length.

## Why it matters

`_score` decides result order, and BM25 is why a rare query word counts more than a common one, why the 10th repeat of a term barely helps, and why a short matching title beats a long article. Knowing its three factors — TF, IDF, length normalization — lets you debug "why is this doc ranked first?" via `_explain` and tune the `k1`/`b` parameters intentionally.

## How it works

Per term, BM25 multiplies an IDF weight by a saturating term-frequency component.

```
score(t,d) = IDF(t) · ( tf · (k1+1) ) / ( tf + k1·(1 − b + b·(dl/avgdl)) )
IDF(t) = ln( 1 + (N − df + 0.5) / (df + 0.5) )
```

| Symbol | Meaning | Default |
|---|---|---|
| `tf` | term frequency in doc | — |
| `df` | docs containing term | — |
| `N` | total docs in shard | — |
| `dl/avgdl` | doc length vs average | — |
| `k1` | TF saturation | 1.2 |
| `b` | length normalization | 0.75 |

- **IDF** — rare terms (small `df`) score higher; comes free from the [[inverted-index]] postings length.
- **Saturation (`k1`)** — TF rises with diminishing returns; the 20th occurrence adds almost nothing vs the 2nd.
- **Length norm (`b`)** — longer docs are penalized so they don't win just by having more words; `b=0` disables it.
- **Per-shard stats** — `N`/`df` are computed per [[shards-replicas|shard]] by default, so scores can differ slightly across shards.

## Example

Query `match:"elasticsearch"` over a shard of N=1,000,000 docs where `df=500`:

```
IDF = ln(1 + (1e6 − 500 + 0.5)/(500 + 0.5)) ≈ ln(2000) ≈ 7.6
short doc (dl≈avgdl, tf=3): score ≈ 7.6 · (3·2.2)/(3 + 1.2) ≈ 7.6 · 1.57 ≈ 11.9
```

A 5,000-word doc with the same `tf=3` scores lower because `dl/avgdl` inflates the denominator.

## Pitfalls

- **Skewed per-shard IDF** — uneven term distribution across shards perturbs ranking; use `?search_type=dfs_query_then_fetch` to compute global stats (costs an extra round-trip).
- **Comparing scores across queries** — `_score` is not normalized; a score of 12 in one query is meaningless against another.
- **Deleted docs inflate `df`/`N`** — until [[force-merge-refresh-interval|merge]] purges tombstones, stats include deletes, slightly shifting IDF.
- **`b`/`k1` are index-time-ish** — changing them in the `similarity` setting requires the field to be re-queried (and ideally reindexed) to take full effect.

## See also

- [[full-text-search]]
- [[compound-queries]]
