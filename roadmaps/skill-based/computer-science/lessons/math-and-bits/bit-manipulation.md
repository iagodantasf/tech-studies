---
title: Bit manipulation
track: computer-science
group: Math & bits
tags: [cs, bits]
prerequisites: [computer-architecture]
see-also: [computer-architecture]
---

# Bit manipulation

Bit manipulation operates directly on the binary digits of an integer using the bitwise operators
`&`, `|`, `^`, `~`, `<<`, and `>>`.

## Why it matters

Bits are where the machine actually lives. Manipulating them gives you compact flag sets, fast
arithmetic shortcuts, and the building blocks of hashing, compression, and cryptography. Many
"clever" tricks collapse a loop into one branchless instruction, which is why hot paths and embedded
code lean on them heavily. They also sharpen your model of how integers are really stored.

## How it works

The core operators, each acting bit-by-bit on its operands:

- `&` (AND) — 1 only where both bits are 1. Used to **mask** (keep) selected bits.
- `|` (OR) — 1 where either bit is 1. Used to **set** bits.
- `^` (XOR) — 1 where the bits differ. **Toggles** bits; `x ^ x` is `0`.
- `~` (NOT) — flips every bit.
- `<<` / `>>` — shift left/right. A left shift by `k` multiplies by `2^k`; a right shift divides.

Common idioms (assume `i` is a bit index):

- Test a bit: `(x >> i) & 1`.
- Set a bit: `x | (1 << i)`.
- Clear a bit: `x & ~(1 << i)`.
- Toggle a bit: `x ^ (1 << i)`.
- Clear the lowest set bit: `x & (x - 1)` — repeatedly doing this counts set bits.
- Isolate the lowest set bit: `x & (-x)`.
- Check power of two: `x != 0 && (x & (x - 1)) == 0`.

Watch the distinction between **logical** and **arithmetic** right shift: for signed types, `>>`
often sign-extends, copying the top bit instead of feeding in zeros.

## Example

```
function count_set_bits(x):
    count ← 0
    while x != 0:
        x ← x & (x - 1)    # drop the lowest set bit
        count ← count + 1
    return count
```

This runs in O(number of set bits) rather than O(width).

## Pitfalls

- **Shifting by `>=` the type width** — shifting a 32-bit value by 32 is undefined or
  implementation-defined in many languages; do not assume it yields `0`.
- **Signed right shift surprises** — `~`, `>>`, and negative values interact with two's complement;
  use unsigned types when you want pure bit logic.
- **Operator precedence** — `&`, `|`, `^` bind looser than `==` in C-family languages, so
  `x & 1 == 0` parses as `x & (1 == 0)`. Always parenthesize.

## See also

- [[computer-architecture]]
- [[number-theory-basics]]
