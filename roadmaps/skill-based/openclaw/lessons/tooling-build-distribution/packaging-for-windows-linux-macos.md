---
title: Packaging for Windows / Linux / macOS
track: openclaw
group: Tooling, Build & Distribution
tags: [openclaw, packaging]
prerequisites: [static-dynamic-linking, build-systems-cmake]
see-also: [static-dynamic-linking, continuous-integration-for-c, asset-extraction-pipeline]
---

# Packaging for Windows / Linux / macOS

Turning a built OpenClaw binary into something a non-developer can download and run on each OS — bundling shared libraries, fixing search paths, and producing the platform-native artifact.

## Why it matters

A linked binary is not a release; it expects `SDL2.dll` / `libSDL2.so` / the framework to be findable, and on a clean user machine they usually aren't — the classic "missing `SDL2.dll`" or "version `GLIBC_2.34` not found" launch failure (see [[static-dynamic-linking]]). Packaging is where you decide *how* the user gets those libs and assets, per OS. And because OpenClaw ships no game data, the package must also tell the user to point the [[asset-extraction-pipeline|extraction step]] at their own `CLAW.REZ`.

## How it works

Each platform has a native artifact and a different way to satisfy runtime dependencies.

| OS | Artifact | Dependency strategy | Path mechanism |
|---|---|---|---|
| Windows | folder ZIP / installer | copy DLLs next to .exe | exe dir is searched |
| Linux | AppImage / tar | bundle .so or distro pkg | `$ORIGIN` RPATH |
| macOS | `.app` / `.dmg` | embed in `.app/Frameworks` | `@rpath` / `@executable_path` |

- **Windows: ship the DLLs.** Place `SDL2.dll`, `SDL2_mixer.dll`, etc. in the same folder as the `.exe` — the loader searches the exe directory. Also bundle the MSVC runtime (or static-link `/MT`) so users without VC++ Redistributable can launch.
- **Linux: relative RPATH.** Set RPATH to `$ORIGIN` so the binary finds bundled `.so` files next to itself regardless of install location. AppImage packages this plus deps into one self-contained, executable file.
- **macOS: self-contained `.app`.** A bundle is a directory; embed dylibs under `Contents/Frameworks`, then rewrite install names to `@rpath` (`install_name_tool`) so they resolve relative to the app, not `/usr/local`.
- **CMake drives it.** `install(TARGETS ...)` + `CPack` generate ZIP/DMG/DEB; RPATH is a CMake target property, not a manual step.
- **Strip + version.** Strip debug symbols from the shipped binary (keep them separately) and stamp a version so bug reports are traceable.

## Example

```text
# Linux: make the binary find its own bundled SDL2
set_target_properties(openclaw PROPERTIES
    INSTALL_RPATH "$ORIGIN/lib")     # look in ./lib beside the exe
# layout shipped to the user:
#   openclaw/
#     openclaw            (RPATH=$ORIGIN/lib)
#     lib/libSDL2-2.0.so.0
#     README -> "run extract.sh on your CLAW.REZ first"
```

The same binary that needs `LD_LIBRARY_PATH` hacks in a dev tree just runs from the package, because `$ORIGIN/lib` resolves the bundled SDL2 wherever the user unzips it.

## Pitfalls

- **Forgetting transitive DLLs/dylibs.** `SDL2_mixer` pulls in codec libs (`libogg`, `libvorbis`); ship them too or the game launches and then crashes on first sound. Verify with `ldd` / `otool -L` / Dependencies.
- **Absolute RPATH baked in.** An RPATH of `/home/you/build/lib` works for you and no one else; use `$ORIGIN` / `@rpath`.
- **Unsigned macOS app.** Gatekeeper blocks an unsigned `.app` with a scary dialog; codesign + notarize, or document the right-click-open workaround.
- **Bundling the game assets.** Packaging extracted sprites/music redistributes copyrighted data; ship only code and tools, and have the user run extraction locally.

## See also

- [[static-dynamic-linking]]
- [[continuous-integration-for-c]]
- [[asset-extraction-pipeline]]
