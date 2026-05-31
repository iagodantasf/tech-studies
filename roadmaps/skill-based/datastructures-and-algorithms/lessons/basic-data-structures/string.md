---
title: String
track: datastructures-and-algorithms
group: Basic data structures
tags: [datastructures-and-algorithms, strings]
prerequisites: [array]
see-also: [tries, hash-tables, two-pointers, sliding-window]
---

# String

An immutable, ordered sequence of characters — backed by a contiguous [[arrays-and-dynamic-arrays]] of code units — that is the most common input type in interview and parsing problems.

## Why it matters

Strings carry almost every real-world payload: identifiers, log lines, JSON, DNA, URLs. The hard part is rarely the algorithm and usually the encoding: a `String` is a sequence of *bytes* or *code units*, not human "characters," so length, indexing, and equality all depend on which layer you mean (see [[character-encodings]]). Immutability turns naive concatenation in a loop into a quadratic trap, and most string interview problems reduce to running [[two-pointers]], [[sliding-window]], or [[hash-tables]] over this array.

## How it works

A `String` is a length plus a pointer to a contiguous block of code units. The element size and indexing semantics differ sharply by language:

| Language | Backing unit | `len` counts | Mutable? |
|---|---|---|---|
| Python 3 | code point | code points | no (`str`) |
| Java | UTF-16 code unit | code units | no (`String`) |
| Go | byte (UTF-8) | bytes | no |
| Rust | byte (UTF-8) | bytes (`.len()`) | `String` yes |
| C | byte + NUL | bytes to `\0` | yes |

- **Random access is O(1) only for fixed-width units.** UTF-8 (Go, Rust) needs an O(n) walk to reach the *k*-th code point; byte indexing is O(1) but can split a character.
- **Immutability** means building a result needs a growable buffer — `StringBuilder`, `[]byte`, `list`+`join` — not repeated `s += c`.
- A non-empty **prefix is a slice** `s[0:k]`; a **substring** is contiguous `s[i:j]`; a **subsequence** keeps order but drops positions. Mixing the three is a classic spec error.
- Comparison is **lexicographic** over code-unit values, so `"Z" < "a"` in ASCII and `"10" < "9"`.

## Example

The quadratic concatenation trap and its fix, joining `n` pieces:

```python
# O(n^2): each += copies the whole prefix into a new string
out = ""
for tok in pieces:        # n iterations, growing copy each time
    out += tok            # ~ 1+2+...+n char copies = O(n^2)

# O(n): one buffer, one pass
out = "".join(pieces)     # total work proportional to final length
```

For `n = 50,000` short tokens the loop does ~10⁹ char copies (seconds); `join` does ~5×10⁴ (instant).

## Pitfalls

- **`len` is not character count.** `len("café")` is `5` in Java (UTF-16) and `5` in Go (UTF-8 bytes) but `4` code points — emoji and combining marks make this worse. Decide bytes vs code points vs graphemes explicitly.
- **Concatenation in a loop is O(n²)** in any language with immutable strings; use a builder/buffer.
- **Byte-slicing UTF-8 can corrupt** a multi-byte character; Rust panics, Go yields the replacement rune. Slice on char boundaries.
- **Equality `==` may compare references**, not content (old Java interning, `==` vs `.equals`). Use the value-equality operator and beware `NaN`-style identity traps.

## See also

- [[character-encodings]]
- [[two-pointers]]
- [[tries]]
