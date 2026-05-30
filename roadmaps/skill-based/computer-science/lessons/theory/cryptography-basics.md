---
title: Cryptography basics
track: computer-science
group: Theory
tags: [cs, theory, cryptography]
prerequisites: [number-theory-basics]
see-also: [bit-manipulation, number-theory-basics]
---

# Cryptography basics

Cryptography is the science of protecting information — keeping it **confidential**, verifying its
**integrity**, and proving its **authenticity** — by relying on math problems that are easy one way and
infeasible to reverse.

## Why it matters

Every login, HTTPS connection, signed software update, and password store depends on it. You rarely
invent cryptography, but you constantly *use* it — and the dangerous failures come from misusing correct
primitives (reused nonces, plaintext passwords, home-grown ciphers), so knowing the building blocks is a
practical safety skill, not just theory.

## How it works

The core primitives:

- **Symmetric encryption** — one shared key encrypts and decrypts (e.g. `AES`). Fast, but both sides must
  already share the secret.
- **Asymmetric encryption** — a public/private key pair (e.g. `RSA`). Anyone encrypts with the public key;
  only the private key decrypts. Its security rests on [[number-theory-basics|number-theory]] hardness —
  factoring large products and modular exponentiation.
- **Hashing** — a one-way digest (e.g. `SHA-256`): same input maps to the same fixed-size output, and the
  input cannot be recovered. Used for integrity and password storage (with a salt).
- **Key exchange** (Diffie-Hellman) lets two parties derive a shared secret over a public channel.

Many constructions combine these: TLS uses asymmetric crypto to exchange a symmetric session key, then
switches to fast symmetric encryption. The humble `XOR` is the atom underneath — `a XOR k XOR k == a`
makes it reversible, the basis of stream ciphers and the one-time pad.

## Example

A one-time pad over a key stream, the simplest perfectly-secret cipher (see [[bit-manipulation]]):

```
encrypt(msg, key):  for i: cipher[i] ← msg[i] XOR key[i]
decrypt(cipher, key): for i: msg[i] ← cipher[i] XOR key[i]
```

It is unbreakable *only* if the key is truly random, as long as the message, and never reused — reuse
leaks `m1 XOR m2` and collapses the secrecy.

## Pitfalls

- **Rolling your own cipher** — use vetted libraries and standard algorithms; novel schemes fail in ways
  experts spot instantly.
- **Reusing nonces / one-time-pad keys** — repetition destroys the security guarantee entirely.
- **Storing passwords with plain or fast hashes** — use a salted, deliberately slow `KDF` (bcrypt,
  Argon2); raw `SHA-256` is trivially brute-forced.

## See also

- [[number-theory-basics]]
- [[bit-manipulation]]
