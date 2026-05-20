# Rust Script Migration Stages

## Stage 1: Clean up `main`

Goal:

```rust
fn main() {
    let cli = Cli::parse();
    init_tracing(cli.verbose);

    if let Err(err) = run(cli) {
        eprintln!("error: {err}");
        std::process::exit(1);
    }
}
```

## Stage 2: Extract CLI parsing

Move `Cli` and `Command` to `src/cli.rs`.

Do not put execution behavior in `cli.rs`.

## Stage 3: Extract config parsing

Move defaults, config file loading, env reads, CLI merge, and validation to `src/config.rs`.

## Stage 4: Extract pure logic

Move logic that does not require I/O into `domain/**`.

Target function shape:

```rust
pub fn build_plan(input: ParsedInput, rules: &Rules) -> Result<Plan, PlanError>;
```

## Stage 5: Introduce typed errors

Create `src/error.rs`.

Start with one enum. Split only when necessary.

## Stage 6: Split modules by responsibility

Good:

```text
cli.rs
config.rs
error.rs
app.rs
report.rs
domain/
io/
commands/
```

Bad:

```text
helpers.rs
misc.rs
common.rs
stuff.rs
logic.rs
```

## Stage 7: Add tests

Start with domain unit tests. Then add CLI integration tests.

## Stage 8: Introduce `lib.rs`

Use `lib.rs` when tests or multiple binaries need shared behavior.

## Stage 9: Add multiple binaries if needed

Use `src/bin/**` only for genuinely distinct entrypoints.

## Stage 10: Consider workspace only when justified

Do not workspace-split until package boundaries are real.
