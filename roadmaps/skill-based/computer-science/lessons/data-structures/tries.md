---
title: Tries
track: computer-science
group: Data structures
tags: [cs, data-structures, tries]
prerequisites: [trees, hash-tables]
see-also: [trees]
---

# Tries

A trie (prefix tree) is a tree where each **edge** represents a character and each **path from the
root** spells a prefix. Strings that share a prefix share the path that spells it.

## Why it matters

When your keys are strings and you care about **prefixes**, a trie beats a [[hash-tables|hash table]]:
autocomplete, spell-checkers, IP routing tables (longest-prefix match), and dictionary lookups all
want "every word starting with `pre`", which a hash table can't answer without scanning everything.

## How it works

Each node has up to *alphabet-size* children and a flag marking the end of a valid word.

```
root
 └─ c ─ a ─ t*        "cat"
        └─ r*         "car"  (shares the "ca" path)
```

- **Insert / search / prefix check** are **O(L)** where L is the key length — crucially,
  *independent of how many keys are stored*. A hash table is also ~O(L) (to hash the key) but offers
  no prefix queries.
- **Space** is the cost: a naive trie allocates a child array per node. Compress it with a
  **radix/Patricia trie** (merge single-child chains) when memory matters.

| Operation | Trie | Hash table |
|---|---|---|
| Insert / lookup | O(L) | O(L) avg |
| Prefix query (all keys with prefix) | O(L + matches) | not supported efficiently |
| Sorted iteration | yes (DFS) | no |

## Example

```
function insert(root, word):
    node ← root
    for ch in word:
        if ch not in node.children:
            node.children[ch] ← new Node()
        node ← node.children[ch]
    node.isWord ← true
```

`startsWith(prefix)` walks the same way, then a DFS from that node yields every completion — the core
of autocomplete.

## Pitfalls

- **Memory blow-up** — large alphabets × many nodes; use a radix trie or map-backed children.
- **Reaching for a trie when you don't need prefixes** — for plain key/value lookups a hash table is
  simpler and usually faster.
- **Unicode** — "one node per char" gets subtle with multi-byte/combining characters; decide your
  unit (byte vs code point) explicitly.

## See also

- [[trees]]
- [[hash-tables]]
