---
title: "`std::string` / `std::string_view`"
track: cpp
group: Standard Library (STL)
tags: [cpp, strings]
prerequisites: [containers-vector-array-list-deque, character-encodings, references]
see-also: [std-span, dangling-pointers-memory-leaks, utility-types-pair-tuple-optional-variant-any]
---

# `std::string` / `std::string_view`

`std::string` is an owning, heap-backed, mutable character buffer; `std::string_view` (C++17) is a non-owning `{pointer, length}` window over existing character data.

## Why it matters

`string` replaces `char*` + manual `malloc`/`strlen`/`strcpy`, eliminating buffer overruns and ownership confusion. `string_view` then solves `string`'s overhead: passing a `const std::string&` forces callers holding a `const char*` or a substring to *allocate a whole new string*; a `string_view` parameter accepts literals, `string`s, and slices with **zero copies**. The pair covers nearly all text handling in modern code. See [[character-encodings]].

## How it works

| Type | Owns data? | Allocates? | Null-terminated? | `sizeof` (64-bit) |
|---|---|---|---|---|
| `std::string` | yes | yes (heap, + SSO) | yes (`c_str()`) | ~32 B |
| `std::string_view` | no | never | no guarantee | 16 B (ptr+len) |

- **SSO (small string optimization)**: most implementations store strings up to ~15 chars inline in the object with no heap allocation; `sizeof(string)` is ~32 even though it can hold a megabyte.
- `string_view` is a cheap value (copy = copy two words); pass it **by value**, not by reference. Its `substr` is O(1) — it just adjusts pointer+length, allocating nothing.
- A `string_view` is **not** null-terminated. Passing `sv.data()` to a C API expecting `\0`-termination reads past the end. Use `.c_str()` on a `string`, or copy into one first.
- C++20 adds `starts_with`/`ends_with` on both; `<charconv>` (`from_chars`/`to_chars`) gives allocation-free, locale-independent number parsing far faster than `stoi`/`stringstream`.

## Example

```cpp
// Accepts literals, std::string, and substrings with NO allocation:
size_t count_spaces(std::string_view s) {
    return std::count(s.begin(), s.end(), ' ');
}
count_spaces("a b c");                 // no temporary std::string built
std::string big = load();
count_spaces(std::string_view{big}.substr(0, 100));  // O(1) view of first 100 chars
```

Versus a `const std::string&` parameter, which would heap-allocate a fresh `string` for the literal and for the substring.

## Pitfalls

- **Dangling views**: a `string_view` does not extend lifetime. `std::string_view sv = std::string{"tmp"};` views a destroyed temporary — instant UB. Never return a view of a local, and never store one outlasting its backing buffer. See [[dangling-pointers-memory-leaks]].
- **Not null-terminated**: feeding `sv.data()` to `printf`/`fopen`/C APIs can run off the end; only `string::c_str()` guarantees the `\0`.
- **`operator+` allocates**; building strings in a loop with `+` is O(n²) churn — `reserve()` and `+=`/`append`, or use a single `format`.
- **One `char` ≠ one character.** `.size()` is bytes, not code points; a UTF-8 `"é"` may be 2 bytes. Indexing splits multibyte sequences.

## See also

- [[std-span]]
- [[character-encodings]]
- [[dangling-pointers-memory-leaks]]
