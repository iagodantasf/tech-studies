---
title: Class Templates
track: cpp
group: Templates & Generics
tags: [cpp, templates]
prerequisites: [classes-objects, function-templates, constructors-destructors]
see-also: [template-specialization, containers-vector-array-list-deque, variadic-templates]
---

# Class Templates

A class template parameterizes a type (and/or values) into a class definition; instantiating it with concrete arguments produces an ordinary class.

## Why it matters

Every STL container — `std::vector<T>`, `std::map<K,V>`, `std::array<T,N>` — is a class template, as is every smart pointer and `std::optional`. They let one data-structure implementation serve all element types with no boxing and no per-element virtual calls. Knowing the instantiation rules explains why `vector<bool>` is weird, why member functions only compile when *called*, and why deduction guides exist.

## How it works

`template<typename T, std::size_t N> struct Array { T data[N]; };`. Parameters can be types, non-type values (NTTP), or templates.

| Parameter kind | Syntax | Example arg |
|---|---|---|
| type | `typename T` | `int`, `std::string` |
| non-type (NTTP) | `std::size_t N` | `16`, a `constexpr` |
| template-template | `template<class> class C` | `std::vector` |

- **Lazy instantiation**: a member function is only instantiated when *used* for that specialization. A `vector<NoCopy>` is fine until you call a member that copies — then it fails.
- **CTAD** (Class Template Argument Deduction, C++17) lets you write `std::vector v{1,2,3};` and deduce `<int>`; you can steer it with explicit *deduction guides*.
- NTTPs must be compile-time constants of a structural type (integral, enum, pointer/ref; in C++20 also literal class types).
- Inside the template, the bare name `Array` is the *injected class name* meaning `Array<T,N>`; you need `Array<U,M>` for a different instantiation.

## Example

```cpp
template<typename T, std::size_t N>
struct Stack {
  T buf[N]; std::size_t n = 0;
  void push(const T& x) { buf[n++] = x; }   // compiled only if push() is used
  T pop() { return buf[--n]; }
};
Stack<int, 8> s;            // fixed-capacity, all on the stack, zero heap
s.push(42);
```

`Stack<int,8>` and `Stack<int,16>` are **distinct, unrelated types** — different `N` means different class, no implicit conversion between them.

## Pitfalls

- **`Stack<int,8>` ≠ `Stack<int,16>`**: each NTTP value is a separate type, so they don't interoperate and each adds a full instantiation to the binary.
- **Member function errors hide until called** thanks to lazy instantiation — a buggy member in a never-used path ships silently.
- **`typename`/`template` disambiguators**: a dependent `T::value_type` needs `typename`; a dependent member template needs `.template`. Omitting them is a hard error.
- **CTAD ignores explicitly written args** and can pick a surprising guide; for `std::array` you still must spell `std::array<int,3>` or use the aggregate form. See [[template-specialization]] for tailoring per type.

## See also

- [[template-specialization]]
- [[containers-vector-array-list-deque]]
- [[variadic-templates]]
