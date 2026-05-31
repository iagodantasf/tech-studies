---
title: Pointers
track: cpp
group: Pointers & References
tags: [cpp, pointers]
prerequisites: [variables-and-constants, data-types]
see-also: [references, nullptr, pointer-arithmetic, smart-pointers-unique-ptr-shared-ptr-weak-ptr]
---

# Pointers

A pointer is a variable whose value is the memory address of another object, letting you read or mutate that object indirectly.

## Why it matters

Pointers are how C++ expresses indirection: dynamic data structures ([[linked-lists]], [[trees]], [[graphs]]), polymorphism through a base-class pointer, optional/absent values, and interop with C APIs that traffic in `T*`. They are also the raw material under every smart pointer and container — understanding `T*` is the floor for understanding [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]] and [[raii]].

## How it works

A pointer holds an address; on a 64-bit target `sizeof(T*) == 8` for *every* `T`. Two core operators connect a pointer to its pointee:

- `&x` — **address-of**: yields a `T*` to object `x`.
- `*p` — **dereference**: the lvalue `p` points to. `p->m` is sugar for `(*p).m`.

```cpp
int x = 42;
int* p = &x;   // p holds the address of x
*p = 7;        // writes through p; now x == 7
```

| Declaration | Meaning |
|---|---|
| `int* p` | pointer to mutable `int` |
| `const int* p` | pointer to const int (pointee read-only) |
| `int* const p` | const pointer (target fixed) |
| `void* p` | typeless address; no deref, no arithmetic |

`void*` erases type for generic buffers (`memcpy`, allocators); cast back before use. See [[const-pointers-pointer-to-const]] for the const variants and [[pointer-arithmetic]] for `p + n` on arrays.

## Example

A pointer parameter lets a function mutate the caller's variable and signal "nothing here" with `nullptr`:

```cpp
void increment(int* p) {
  if (p) ++*p;            // guard: p may be null
}
int n = 5;
increment(&n);            // n == 6
increment(nullptr);       // safe no-op
```

Contrast with [[pass-by-value-reference-pointer]]: a reference parameter cannot be null and needs no guard, but cannot rebind.

## Pitfalls

- **Uninitialized pointers** hold garbage; dereferencing is undefined behavior. Initialize to [[nullptr]] or a valid address at declaration.
- **`int* a, b;` declares one pointer and one `int`** — the `*` binds to the declarator, not the type. Declare one per line.
- **Dangling**: a pointer outlives its pointee (freed heap, returned-to local). Reading it is UB — see [[dangling-pointers-memory-leaks]].
- **Prefer owning abstractions.** A raw `T*` should mean "non-owning view"; ownership belongs to a smart pointer or container.

## See also

- [[references]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[nullptr]]
