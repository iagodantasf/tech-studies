---
title: Setting up the Environment
track: cpp
group: Introduction
tags: [cpp, toolchain]
prerequisites: []
see-also: [compilers-gcc-clang-msvc, build-systems-cmake-make]
---

# Setting up the Environment

A working C++ setup is four pieces: a **compiler**, a **build system**, a **debugger**, and an **editor/LSP** — assembled differently on Linux, macOS, and Windows.

## Why it matters

Unlike languages with one blessed toolchain, C++ has no default installer — you choose and wire up each part. A clean setup that produces editor diagnostics matching what the compiler sees (via `compile_commands.json`) saves hours: you catch errors as you type instead of at link time. Getting the toolchain right is the prerequisite for [[running-first-program]].

## How it works

The four roles and the standard picks per platform:

| Role | Linux | macOS | Windows |
|---|---|---|---|
| Compiler | GCC (`build-essential`) | Clang (`xcode-select --install`) | MSVC (VS Build Tools) or MSYS2 GCC |
| Build | Make / CMake | CMake | CMake / MSBuild |
| Debugger | gdb | lldb | Visual Studio / WinDbg |
| Deps | vcpkg / Conan | vcpkg / Homebrew | vcpkg |

- **Editor intelligence** comes from **clangd** (an LSP server), which reads a `compile_commands.json` describing each file's flags. CMake generates it with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`.
- **Verify** the install: `g++ --version`, `cmake --version`, `gdb --version`.
- **Quick alternative**: an online compiler (Compiler Explorer / godbolt.org) needs nothing installed and shows the emitted assembly.

## Example

A minimal Linux bootstrap from a clean machine:

```bash
sudo apt install build-essential cmake gdb clangd   # compiler+make, cmake, debugger, LSP
g++ --version                                        # confirm: g++ (GCC) 13.x
mkdir build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..          # emits compile_commands.json for clangd
cmake --build .
```

Point your editor's clangd at the generated `build/compile_commands.json` and squiggles now match the compiler exactly.

## Pitfalls

- **No `compile_commands.json`** → clangd guesses include paths and floods you with false-positive errors that the real build doesn't have.
- **Multiple compilers on `PATH`** (system Clang vs Homebrew GCC) — the binary you build with may differ from the one your editor indexes with; pin `CC`/`CXX`.
- **MinGW vs MSVC ABI on Windows are incompatible** — libraries built with one won't link against the other; don't mix.
- **Forgetting debug info** (`-g`) — gdb/lldb show only addresses, no source lines.

## See also

- [[compilers-gcc-clang-msvc]]
- [[build-systems-cmake-make]]
