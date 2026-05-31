---
title: Writing Format Parsers in C++
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, parser]
prerequisites: [modern-c-c-11-14-17, identifying-proprietary-file-formats]
see-also: [rez-archive-resource-packs, raii-resource-ownership]
---

# Writing Format Parsers in C++

Turning a documented byte layout into safe, endian-correct C++ that decodes [[rez-archive-resource-packs|REZ]], [[wwd-level-format|WWD]], and [[pid-image-format-claw-sprites|PID]] from untrusted user files without undefined behaviour.

## Why it matters

Once a format is understood, the engine needs a parser that is *fast* (called for thousands of sprites at load), *safe* (the input is a 70 MB binary you do not control), and *portable* (LE-on-disk, runs on LE and BE hosts). Naive C++ here causes the classic bugs: UB from type-punning structs, silent corruption from host endianness, and out-of-bounds reads on truncated data. This is where [[c-standards-c-11-14-17-20-23]] and [[raii]] pay off.

## How it works

Build a small cursor over a byte span and read explicitly:

- **Read fields, do not `reinterpret_cast` a struct** — `*(Header*)ptr` is UB (alignment + padding + endianness). Read each field with a typed helper.
- **Convert endianness on read** — assemble integers byte-by-byte so the same code is correct on any host:

```cpp
uint32_t read_u32_le(const uint8_t*& p) {
    uint32_t v = p[0] | (p[1]<<8) | (p[2]<<16) | (p[3]<<24);
    p += 4; return v;
}
```

- **Bounds-check every read** — track `end`; if `p + n > end`, throw, do not read. Truncated/hostile files must fail cleanly, not crash.
- **Own buffers with RAII** — `std::vector<uint8_t>` for the file, `std::unique_ptr` for decoded surfaces; no manual `free`. See [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]].
- **Use `std::span`/`string_view`** (C++17/20) for zero-copy views into the REZ blob instead of copying each entry.

Prefer plain reads over the STL in the innermost RLE/pixel loop — see [[the-stl-in-hot-paths]].

## Example

A bounds-checked PID header read, the shape every parser repeats:

```cpp
struct PidHeader { uint32_t flags, _r, w, h; int32_t ox, oy; };
PidHeader parse(const uint8_t* p, const uint8_t* end) {
    if (end - p < 24) throw ParseError("PID truncated");
    PidHeader h;
    h.flags = read_u32_le(p); h._r = read_u32_le(p);
    h.w = read_u32_le(p);     h.h = read_u32_le(p);
    h.ox = (int32_t)read_u32_le(p);
    h.oy = (int32_t)read_u32_le(p);
    return h;            // never *(PidHeader*)p
}
```

## Pitfalls

- **`reinterpret_cast`-ing the buffer to a struct** — breaks on padding, alignment, and big-endian hosts; it is UB.
- **Trusting size fields** — a corrupt `width*height` can demand gigabytes; sanity-clamp against the remaining bytes.
- **Signed/unsigned mix-ups** — PID offsets and RLE counts are signed; reading them unsigned flips behaviour.
- **Leaking on the error path** — RAII so a mid-parse `throw` still frees buffers and file handles.

## See also

- [[rez-archive-resource-packs]]
- [[raii]]
