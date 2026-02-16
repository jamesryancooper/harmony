# Filesystem Graph Service

Native-first service for filesystem operations, deterministic snapshot artifacts,
knowledge-graph traversal, and progressive discovery.

## Purpose

- Provide a unified operation surface for files, snapshots, graph traversal, and discovery.
- Keep files as source-of-truth while exposing derived graph intelligence.
- Preserve provider-agnostic contracts and fail-closed governance behavior.

## Core Artifacts

- `SERVICE.md` - service metadata contract.
- `contract.md` - normative service behavior.
- `schema/*.json` - operation and artifact schemas.
- `rules/rules.yml` - policy and contract checks.
- `contracts/invariants.md` - non-negotiable invariants.
- `contracts/errors.yml` - typed error semantics.
- `service.json` / `service.wasm` - runtime-native service package.
- `rust/` - Rust/WASM implementation.
- `impl/generated.manifest.json` - implementation generation metadata.
