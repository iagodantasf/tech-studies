# playgrounds

Runnable code experiments, organized by **language/tool** (not by roadmap) so each toolchain has one clean root. Link an experiment from the note that motivated it with `[[playgrounds/<lang>/<name>]]`.

> Build artifacts (`target/`, `node_modules/`, `.venv/`, `dist/`) are gitignored. Commit source, not output.

## Per-language setup

### Rust — one Cargo workspace, one crate per experiment
```bash
cd playgrounds/rust            # contains a workspace Cargo.toml
cargo new --bin binary-search  # add member, then list it in [workspace].members
cargo run -p binary-search
```

### Go — one module, one package per experiment
```bash
cd playgrounds/go              # go.mod here (module tech-studies/playgrounds/go)
mkdir worker-pool && cd worker-pool
go mod init . 2>/dev/null; go run .
```

### Python — one env (uv preferred), scripts + notebooks
```bash
cd playgrounds/python
uv venv && source .venv/bin/activate   # or: python -m venv .venv
uv pip install -r requirements.txt 2>/dev/null || true
```

### TypeScript / JS — one pnpm workspace
```bash
cd playgrounds/typescript
pnpm init 2>/dev/null; pnpm dlx tsx scratch.ts
```

Add other languages (`cpp/`, `zig/`, …) the same way: one toolchain root, small named experiments inside.
