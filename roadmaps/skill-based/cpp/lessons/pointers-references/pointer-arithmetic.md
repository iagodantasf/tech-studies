---
title: Pointer Arithmetic
track: cpp
group: Pointers & References
tags: [cpp, pointers]
prerequisites: [pointers, arrays-and-dynamic-arrays]
see-also: [pointers, const-pointers-pointer-to-const, std-span, iterators]
---

# Pointer Arithmetic

Pointer arithmetic moves a pointer across an array in *element* units, scaling integer offsets by `sizeof(T)` so `p + n` lands on the n-th following element.

## Why it matters

It is the mechanical basis of array traversal, the [[iterators]] model (a random-access iterator *is* a generalized pointer), and zero-copy buffer views like [[std-span]]. The contiguity that makes it `O(1)` is also what gives [[arrays-and-dynamic-arrays]] and `std::vector` their cache-friendly performance — see [[time-and-space-complexity]].

## How it works

For `T* p`, the compiler scales every integer operation by `sizeof(T)`:

| Expression | Result | Note |
|---|---|---|
| `p + n` | `T*` | address advances `n * sizeof(T)` bytes |
| `p - n` | `T*` | moves backward |
| `q - p` | `ptrdiff_t` | element count between two pointers |
| `p[n]` | `T&` | identical to `*(p + n)` |
| `++p`, `--p` | `T*` | step one element |

Because `p[n] == *(p + n) == *(n + p) == n[p]`, the obscure `3[arr]` is legal. The valid range for arithmetic is `[arr, arr + N]`: the **one-past-the-end** pointer `arr + N` is a legal value to form and compare, but not to dereference.

```text
int a[4];   sizeof(int) == 4
a ─▶ a+1 ─▶ a+2 ─▶ a+3 ─▶ a+4 (one-past-end, no deref)
+0    +4     +8    +12    +16   bytes
```

## Example

A hand-rolled traversal using the half-open range, the same `[begin, end)` convention the STL uses:

```cpp
int a[] = {10, 20, 30, 40};
int* end = a + 4;                 // one-past-the-end sentinel
long sum = 0;
for (int* p = a; p != end; ++p)   // != end, never < (see pitfalls)
  sum += *p;                      // 100
ptrdiff_t n = end - a;            // 4 elements
```

A function taking `(T* first, T* last)` works on C arrays, `vector` data, and sub-ranges alike — exactly how `std::accumulate` is shaped.

## Pitfalls

- **Out-of-bounds arithmetic is UB**, even *forming* `arr - 1` or `arr + N + 1` — not just dereferencing it. The compiler may assume it never happens.
- **Arithmetic across array boundaries is UB.** Two separately-allocated arrays have no defined ordering; only pointers into the *same* array (or one-past) may be subtracted/compared.
- **Decay surprise:** an array argument decays to a pointer, so `sizeof(param)` is `8`, not the array's byte size — pass the length or use [[std-span]].
- **`void*` and function pointers don't support arithmetic** — the element size is unknown / not an object.

## See also

- [[pointers]]
- [[iterators]]
- [[std-span]]
