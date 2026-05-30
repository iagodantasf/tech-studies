---
title: Number theory basics
track: computer-science
group: Math & bits
tags: [cs, math]
prerequisites: [bit-manipulation]
see-also: [cryptography-basics]
---

# Number theory basics

Number theory studies the integers and their divisibility, with modular arithmetic, primes, and the
GCD as the workhorses for computing.

## Why it matters

Modular arithmetic underpins hashing, checksums, random number generators, and especially
[[cryptography-basics|cryptography]] — RSA is essentially number theory wearing a security hat.
Knowing primes, GCDs, and modular inverses lets you reason about wrap-around, fairness, and
collision-free schedules instead of treating overflow as a mystery.

## How it works

- **Divisibility and GCD** — the greatest common divisor of `a` and `b` is found by the **Euclidean
  algorithm**: `gcd(a, b) = gcd(b, a mod b)`, terminating when the remainder is `0`. It runs in
  O(log min(a, b)).
- **Modular arithmetic** — work within `0 .. m-1` by taking `mod m` after each operation. Addition
  and multiplication distribute over `mod`, so `(a * b) mod m == ((a mod m) * (b mod m)) mod m`.
- **Primes** — a prime has exactly two divisors. The **Sieve of Eratosthenes** marks multiples to
  list all primes up to `n` in O(n log log n).
- **Modular inverse** — `a` has an inverse mod `m` exactly when `gcd(a, m) == 1`; the extended
  Euclidean algorithm finds it. This is how you "divide" in modular arithmetic.
- **Fast exponentiation** — compute `a^e mod m` in O(log e) by squaring, the heart of public-key
  crypto.

## Example

```
function gcd(a, b):
    while b != 0:
        a, b ← b, a mod b
    return a
```

Euclid's algorithm: each step shrinks the pair fast, so it finishes in logarithmic time.

## Pitfalls

- **Negative modulo** — in C-family languages `-7 mod 3` can be `-1`, not `2`; normalize with
  `((x mod m) + m) mod m` when you need a non-negative result.
- **Overflow before the mod** — `a * b` can overflow the integer type before you reduce it; reduce
  operands first or use a wider type.
- **Inverse of a non-coprime** — there is no modular inverse when `gcd(a, m) != 1`; check first.

## See also

- [[cryptography-basics]]
- [[bit-manipulation]]
