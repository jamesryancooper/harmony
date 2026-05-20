# Audit Rust Tool Architecture Phases

## Phase 1: Resolve Scope

- Confirm `target_path` exists or report an explicit target error.
- Treat `target_path` as the audit boundary unless nearby Cargo workspace
  files are required to understand package membership.
- Record `mode`, `evidence_depth`, `severity_threshold`,
  `include_workspace_advice`, `post_remediation`, `convergence_k`, and
  `seed_list`.

## Phase 2: Collect Evidence

Inspect relevant files in this order:

1. `Cargo.toml` and `Cargo.lock`
2. `src/main.rs`, `src/lib.rs`, and `src/bin/**`
3. `crates/**`, `xtask/**`, `tests/**`, and `examples/**`
4. CLI parsing, config sources, error handling, logging/tracing, and output
   formats
5. filesystem, process, network, and mutation effects
6. concurrency, async runtime, performance, and memory-sensitive paths

Exclude `target/**`, `.git/**`, generated build artifacts, and unrelated
vendored code.

## Phase 3: Classify Architecture

Classify the target as one of: single `main.rs`, `main.rs` plus internal
modules, `bin` plus `lib` split, multiple binaries under `src/bin`,
workspace-based architecture, or reusable internal crates.

## Phase 4: Evaluate Findings

Check project structure, CLI boundary, config and inputs, error handling,
filesystem/process effects, logging/tracing, async/concurrency, performance,
memory, and testing. Use stable finding IDs and the severity model in
`validation.md`.

## Phase 5: Recommend Corrections

Recommend the smallest sufficient architecture that makes the tool safe,
testable, maintainable, and evolvable. Include workspace advice only when
package boundaries are evidenced.

## Phase 6: Emit Outputs

Write the human report, summary JSON, bounded audit bundle, run log, and log
indexes to registry-declared outputs. Include a determinism receipt with scope,
parameter hash, seed policy, coverage summary, and findings hash when possible.
