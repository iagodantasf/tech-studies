---
title: Floating-point representation
track: computer-science
group: Math & bits
tags: [cs, floats]
prerequisites: [bit-manipulation]
see-also: [computer-architecture]
---

# Floating-point representation

Floating point stores real numbers as `sign x mantissa x 2^exponent`, trading exactness for a huge
dynamic range in a fixed number of bits.

## Why it matters

Almost every fractional number a program touches is a float, and almost every float is an
approximation. Understanding the format explains why `0.1 + 0.2 != 0.3`, why money should never be a
`double`, and why "the same" calculation can differ across machines. It is the difference between
trusting a number and knowing its error bars.

## How it works

The **IEEE 754** standard lays out the bits. A 64-bit `double` uses:

- **1 sign bit** — `0` positive, `1` negative.
- **11 exponent bits** — stored with a bias of `1023`, so the actual exponent is `stored - 1023`.
- **52 mantissa (fraction) bits** — with an implicit leading `1` for normalized numbers, giving 53
  bits of precision.

The value is `(-1)^sign x 1.fraction x 2^(exponent - 1023)`. Because the mantissa is binary, only
fractions whose denominator is a power of two are exact; `0.1` is a repeating binary fraction and so
gets rounded.

Special bit patterns are reserved:

- **Zero** — all exponent and fraction bits `0` (and a signed `-0.0`).
- **Infinity** — max exponent, zero fraction; produced by overflow or `1.0 / 0.0`.
- **NaN** — max exponent, non-zero fraction; from `0.0 / 0.0` and similar. `NaN != NaN`.
- **Subnormals** — exponent all `0`, allowing gradual underflow near zero.

## Example

```
0.1 in double  ≈ 0.1000000000000000055511151231257827...
0.1 + 0.2      ≈ 0.30000000000000004    # not exactly 0.3
```

The tiny excess is the rounding error from storing decimals in binary.

## Pitfalls

- **Equality comparison** — never test floats with `==`; compare with a tolerance (epsilon).
- **Catastrophic cancellation** — subtracting two nearly equal floats wipes out significant digits.
- **Money in floats** — use integer cents or a decimal type; rounding errors accumulate into real
  accounting bugs.

## See also

- [[computer-architecture]]
- [[bit-manipulation]]
