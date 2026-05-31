---
title: Static & Dynamic Linking
track: openclaw
group: C++ Foundations for Engines
tags: [openclaw, linking]
prerequisites: [build-systems-cmake, computer-architecture]
see-also: [build-systems-cmake, cross-platform-compilation-gcc-clang-msvc, packaging-for-windows-linux-macos]
---

# Static & Dynamic Linking

How the linker resolves symbols and combines object files with libraries like SDL2 into a runnable OpenClaw binary — at build time (static) or at load/run time (dynamic).

## Why it matters

Linking is where "it compiles" turns into "it runs on the player's machine." OpenClaw depends on SDL2, SDL_mixer, and friends; whether you bundle them in the executable or expect them on the system decides binary size, startup, portability, and the dreaded "missing `SDL2.dll`" / "version `GLIBC_2.34' not found" failures. Most ship-day distribution bugs are linking problems, not code problems. See [[packaging-for-windows-linux-macos]].

## How it works

The toolchain is two phases: the **compiler** turns each `.cpp` into an object file with a symbol table (defined + undefined symbols, name-mangled in C++); the **linker** then resolves every undefined symbol to exactly one definition.

| Aspect | Static (`.a` / `.lib`) | Dynamic (`.so` / `.dll` / `.dylib`) |
|---|---|---|
| Resolved at | link time, copied in | load/run time |
| Binary size | larger (code embedded) | smaller (refs only) |
| Update library | recompile/relink | drop-in replace file |
| Missing at runtime | impossible | crashes on launch |
| Memory across procs | duplicated | shared (one copy in RAM) |

- **Static linking** copies the used object code from the archive into the executable. Self-contained, no runtime dependency, but you re-ship to patch the lib, and a bug in the lib needs a relink.
- **Dynamic linking** records a *reference*; the OS loader maps the shared object at launch (or `dlopen`/`LoadLibrary` on demand). One copy of SDL2 in RAM serves every process, and the page cache is shared.
- **Symbol resolution & ODR.** The linker needs each symbol defined exactly once. Duplicate non-inline definitions → "multiple definition"; none → "undefined reference." Order matters with `ld`: a static lib must appear *after* the objects that need it.
- **Runtime search path.** Loaders find `.so`/`.dll` via OS rules — `LD_LIBRARY_PATH`/`RPATH` (Linux), `@rpath` (macOS), the exe directory + `PATH` (Windows). [[build-systems-cmake-make]] sets these via `target_link_libraries` and RPATH options.
- **The C++ runtime itself** (`libstdc++`/`libc++`, `msvcp140.dll`) is also a link choice — `-static-libstdc++` or the MSVC `/MT` vs `/MD` flag.

## Example

Linking OpenClaw against SDL2 two ways on Linux:

```text
# Dynamic: small binary, needs libSDL2-2.0.so.0 on the target
g++ main.o actor.o -o openclaw -lSDL2          # records a reference
ldd openclaw   ->  libSDL2-2.0.so.0 => /usr/lib/...   (resolved at launch)

# Static: bigger, self-contained, no SDL2 runtime needed
g++ main.o actor.o -o openclaw -Wl,-Bstatic -lSDL2 -Wl,-Bdynamic
```

Same code; the dynamic build is a few hundred KB and fails on a machine without SDL2 installed, while the static build is several MB and just runs.

## Pitfalls

- **"Undefined reference" from link order.** With GNU `ld`, libraries are scanned left-to-right; put `-lSDL2` *after* the objects that use it, not before.
- **Declared but never defined** (e.g., a `static` class member or a templated symbol) links fine in one TU and explodes in another — define it in exactly one `.cpp`.
- **ABI / runtime mix.** Linking objects built with mismatched `libstdc++`/MSVC runtimes (or `/MT` vs `/MD`) causes heap-corruption crashes that look random; keep the whole [[compilers-gcc-clang-msvc]] toolchain consistent.
- **Forgetting to ship the DLLs.** Dynamic builds need the SDL2 shared libs alongside the exe (or installed); this is the classic "works on my machine" launch failure.

## See also

- [[build-systems-cmake-make]]
- [[compilers-gcc-clang-msvc]]
- [[packaging-for-windows-linux-macos]]
