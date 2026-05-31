---
title: Disassembly Basics (IDA / Ghidra)
track: openclaw
group: Reverse Engineering & File Formats
tags: [openclaw, disassembly]
prerequisites: [inspecting-binaries-hex-editors-strings, computer-architecture]
see-also: [reverse-engineering-mindset-ethics, writing-format-parsers-in-c]
---

# Disassembly Basics (IDA / Ghidra)

Turning the original game's machine code back into readable assembly (and, with a decompiler, pseudo-C) to recover the *algorithm* behind a format when static byte-inspection alone leaves gaps.

## Why it matters

`strings` and a hex editor reveal a format's layout, but not its *logic* — how PID frames are RLE-decoded, how WWD tile flags are unpacked. When the structure is ambiguous, watching `CLAW.EXE`'s loader code resolves it definitively. Used carefully, this stays clean-room: you read the algorithm to *document* it, then someone re-implements from the doc — you never paste the output. See [[reverse-engineering-mindset-ethics]].

## How it works

Two tools dominate: **Ghidra** (free, NSA, excellent decompiler) and **IDA** (commercial, the disassembly standard). Workflow on a 32-bit Win32 PE like `CLAW.EXE`:

- **Find the format reader** — search [[inspecting-binaries-hex-editors-strings|strings]] for `"CLAW.WWD"`, follow the cross-reference (xref) to the function that opens it.
- **Read the decompiler view** — Ghidra's pseudo-C shows `fread` sizes and struct field offsets directly; a `read(buf, 0x20)` confirms a 32-byte header.
- **Trace the loop** — RLE/decode loops show up as a `while` reading a count byte then copying/skipping N pixels.

Recognise x86 calling conventions: arguments are pushed right-to-left, return value is in `EAX`. A `cmp`/`jz` chain after a 4-byte load is almost always a magic-number check. See [[computer-architecture]] for register and stack basics.

## Example

Decompiling the PID loader, Ghidra emits roughly:

```c
hdr.flags  = read_u32(f);    // +0x00
hdr.width  = read_u32(f);    // +0x08
hdr.height = read_u32(f);    // +0x0C
if (hdr.flags & 1) decode_rle(f, out);   // compressed
else               fread(out, 1, w*h, f); // raw
```

That single `if (flags & 1)` answers a question hex-staring could not: bit 0 of the header flags toggles RLE compression. You write that fact in the spec and implement it in [[writing-format-parsers-in-c|new code]].

## Pitfalls

- **Pasting decompiler output as your engine** — that is a derivative work; document the *behaviour*, write fresh code.
- **Trusting auto-named locals** — `iVar3`, `puVar7` are guesses; rename only once you understand them.
- **Ignoring struct padding** — the compiler may align fields; a "missing" 2 bytes is often padding, not a field.
- **Disassembling when you do not need to** — if re-rendering already matches, the loop logic is settled; do not burn hours in IDA.

## See also

- [[inspecting-binaries-hex-editors-strings]]
- [[writing-format-parsers-in-c]]
