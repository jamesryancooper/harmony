# Rubric: Rust Tool Architecture Audit

Score each category from 0 to 4.

- 0: absent or dangerous
- 1: present but unreliable
- 2: usable but fragile
- 3: good enough for current scale
- 4: strong, scalable, and well-tested

## 1. Project structure

Evaluate whether the current Cargo/source layout matches tool maturity.

### 0
Giant `main.rs`, no modules, no tests, no clear responsibilities.

### 1
Some modules exist but boundaries are accidental or named `utils`, `helpers`, `misc`.

### 2
Modules roughly exist but CLI, config, effects, and domain logic still leak into each other.

### 3
Clear modules or `lib.rs` + binary split; tests can reach core logic.

### 4
Structure matches maturity precisely; no premature workspace; reusable crates only where justified.

## 2. CLI boundary

Look for separation between CLI parsing and application execution.

Strong signs:
- `clap` structs/enums are boundary types
- subcommands map to command modules
- CLI validation happens once
- business logic is not buried in parser code

Weak signs:
- raw `std::env::args()` parsing scattered through code
- flags passed everywhere as loose booleans
- domain behavior embedded in CLI match arms

## 3. Orchestration and domain logic

Strong architecture has:

```text
parse CLI -> resolve config -> orchestrate -> pure domain logic -> effects -> report
```

The core should be testable without real filesystem/process effects.

## 4. Error handling

Score based on:
- contextual errors at I/O/process/config boundaries
- `thiserror` for domain/library errors
- `anyhow` only at appropriate application glue boundaries
- distinct user-facing errors vs internal failures
- no broad string-only error hiding

## 5. Config and inputs

Score based on:
- layered defaults/config/env/CLI
- typed config structs
- validation after merging
- safe handling of secrets
- no scattered env reads

## 6. Logging, tracing, diagnostics

Score based on:
- appropriate `tracing` or `log`
- verbosity flags
- human logs to stderr
- machine output to stdout
- dry-run and explain mode where mutation/decision complexity warrants it
- final audit/output summary

## 7. Testing

Score based on:
- unit tests for pure logic
- integration tests for CLI behavior
- temp-dir/fixture tests for filesystem behavior
- snapshot/golden tests for large output contracts
- error path testing
- dry-run testing
- safe command execution tests

## 8. Async/concurrency

Score based on:
- sync code used where simpler
- Tokio used only where async I/O/concurrency warrants it
- bounded concurrency
- cancellation/timeouts/retries/rate limits for long-running work
- Rayon used for CPU-bound data parallelism when justified

## 9. Filesystem/process safety

Score based on:
- path handling via `Path`/`PathBuf`
- atomic writes for important files
- backups for destructive migrations
- idempotency
- command wrapper
- stdout/stderr capture
- shell injection avoidance
- plan-before-mutate design

## 10. Performance/memory

Score based on:
- streaming large inputs
- buffered I/O
- chunking
- avoiding unnecessary clones
- profiling before optimization
- appropriate parallelism
