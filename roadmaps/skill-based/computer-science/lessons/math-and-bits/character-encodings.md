---
title: Character encodings (ASCII, Unicode)
track: computer-science
group: Math & bits
tags: [cs, encoding]
prerequisites: [bit-manipulation]
see-also: [tries]
---

# Character encodings (ASCII, Unicode)

A character encoding is the mapping between human-readable characters and the byte sequences a
computer stores, with ASCII and Unicode being the two that matter.

## Why it matters

Text is bytes, and getting the mapping wrong gives you the mojibake garbage everyone has seen.
Encoding bugs cause silent data corruption, security holes, and broken string length math. In a world
of emoji, accents, and non-Latin scripts, "just ASCII" stopped being enough decades ago, and knowing
the difference between a byte, a code point, and a glyph is basic literacy.

## How it works

- **ASCII** — a 7-bit code (0..127) covering English letters, digits, punctuation, and control
  characters. `A` is `65` (`0x41`), `a` is `97`; the difference is exactly bit `0x20`, so flipping
  it with `^ 0x20` swaps case.
- **Unicode** — a universal catalog assigning every character a **code point** like `U+1F600`. It
  defines the characters, not the bytes; an **encoding** does that.
- **UTF-8** — the dominant encoding. ASCII stays one byte; other code points use 2 to 4 bytes, with
  the high bits of the leading byte signaling the length. It is backward-compatible with ASCII and
  self-synchronizing.
- **UTF-16** — uses 2 or 4 bytes (surrogate pairs for code points above `U+FFFF`) and needs a byte
  order mark or convention to pick endianness.

A key distinction: **bytes** vs **code points** vs **grapheme clusters** (what a user sees as one
character). An emoji with a skin-tone modifier is one grapheme but several code points and many
bytes.

## Example

```
"€" (U+20AC) in UTF-8  →  E2 82 AC        # three bytes
"A" (U+0041) in UTF-8  →  41              # one byte, same as ASCII
```

Counting bytes is not counting characters once you leave ASCII.

## Pitfalls

- **Assuming one byte per character** — slicing a UTF-8 string by byte offset can split a multi-byte
  code point and corrupt it.
- **Mismatched encodings** — reading UTF-8 bytes as Latin-1 (or vice versa) produces mojibake; always
  declare and agree on the encoding.
- **Length confusion** — string "length" may mean bytes, code points, or graphemes depending on the
  language; know which one your API returns.

## See also

- [[tries]]
- [[bit-manipulation]]
