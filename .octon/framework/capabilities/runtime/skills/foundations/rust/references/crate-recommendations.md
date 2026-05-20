# Crate Recommendations

Use crates because they match a need, not because the tool wants to look mature.

## Core defaults

```toml
[dependencies]
clap = { version = "4", features = ["derive"] }
serde = { version = "1", features = ["derive"] }
toml = "0.9"
thiserror = "2"
anyhow = "1"
tracing = "0.1"
tracing-subscriber = "0.3"

[dev-dependencies]
assert_cmd = "2"
predicates = "3"
insta = "1"
tempfile = "3"
```

## Add when needed

### Tokio

Use for:

- many network requests
- async APIs
- timers
- cancellation
- graceful shutdown
- concurrent I/O

Do not use only because the code is long-running.

### Rayon

Use for:

- CPU-bound parsing
- data transformations
- independent file analysis
- parallel iterators

### Walkdir

Use for recursive filesystem traversal.

### Camino

Use when the project intentionally wants UTF-8-only paths.

### Xshell

Use for repo automation where shell-like ergonomics are valuable but direct shell execution is undesirable.

### Atomic write crates

Use for important file replacement where partial writes are unacceptable.
