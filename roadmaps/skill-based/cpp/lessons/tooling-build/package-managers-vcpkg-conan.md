---
title: "Package Managers (vcpkg, Conan)"
track: cpp
group: Tooling & Build
tags: [cpp, package-managers]
prerequisites: [build-systems-cmake-make]
see-also: [build-systems-cmake-make, header-source-separation, static-analysis-clang-tidy-cppcheck]
---

# Package Managers (vcpkg, Conan)

vcpkg and Conan fetch, build, and expose third-party C++ libraries with their transitive dependencies, integrating the result into your CMake/Make build.

## Why it matters

C++ has no built-in dependency manager, so for decades teams vendored sources or hand-compiled libraries — fragile and unportable. vcpkg (Microsoft) and Conan (JFrog) solve "I need fmt, Boost, and gRPC at compatible versions on three platforms" by resolving a dependency graph and producing binaries plus CMake config files. They are now standard for non-trivial projects and pair directly with [[build-systems-cmake-make|CMake]].

## How it works

Both read a manifest listing your direct dependencies, resolve the full graph, build (or download cached) binaries, and emit files CMake's `find_package` consumes.

| Aspect | vcpkg | Conan |
|---|---|---|
| Manifest | `vcpkg.json` | `conanfile.txt`/`.py` |
| Model | ports build from source, one version set | per-package versions + binary cache |
| Versioning | baseline pins whole registry | explicit `lib/1.2.3` requirements |
| CMake hook | toolchain file | generated `*-config.cmake` |
| Binaries | builds locally, optional cache | remote binary caching first-class |

- **vcpkg** uses a *baseline*: a registry commit that pins compatible versions of everything. You build from source by default; a triplet (e.g. `x64-windows`) selects arch/linkage.
- **Conan** treats each package as independently versioned with a `settings`/`options` hash (compiler, build type, `shared=True`) identifying a prebuilt binary in a remote — strong for binary reuse across a team.
- Both expose results through CMake: vcpkg via `-DCMAKE_TOOLCHAIN_FILE=.../vcpkg.cmake`, Conan via a generated toolchain/config you `find_package`.
- ABI matters: a library built with a different compiler, `_GLIBCXX_USE_CXX11_ABI`, or build type can link but crash — the manager's settings hash exists to prevent mixing.

## Example

```jsonc
// vcpkg.json  (manifest mode)
{ "name": "demo", "version": "0.1.0",
  "dependencies": ["fmt", "spdlog"] }
```

```cmake
find_package(fmt CONFIG REQUIRED)        # provided by vcpkg toolchain
target_link_libraries(app PRIVATE fmt::fmt)
```

```bash
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

## Pitfalls

- **Mixed ABI / build type**: linking a `Release` dependency into a `Debug` app (or differing `/MD` vs `/MT`, libc++ vs libstdc++) compiles but crashes at runtime — keep settings consistent.
- **Unpinned versions** make builds non-reproducible; commit the vcpkg baseline or Conan lockfile so CI and laptops match.
- **System vs managed packages collide**: a stray `find_package` may grab an OS-installed copy instead of the managed one; control `CMAKE_PREFIX_PATH`.
- **First build is slow**: building Boost/LLVM from source can take many minutes — enable binary caching (Conan remotes, vcpkg asset/binary cache) in CI.

## See also

- [[build-systems-cmake-make]]
- [[header-source-separation]]
- [[static-analysis-clang-tidy-cppcheck]]
