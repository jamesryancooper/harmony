# Example: Single `main.rs` to `lib.rs` + Binary Split

## Before

```text
my-tool/
├── Cargo.toml
└── src/
    └── main.rs
```

Symptoms:

- CLI parsing, config, file walking, planning, writing, and reporting all in `main.rs`
- Hard to test without running the binary
- Error handling uses strings
- Dry-run logic mixed with write logic

## After

```text
my-tool/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── cli.rs
│   ├── config.rs
│   ├── app.rs
│   ├── error.rs
│   ├── report.rs
│   ├── domain/
│   │   ├── mod.rs
│   │   └── planner.rs
│   └── io/
│       ├── mod.rs
│       ├── files.rs
│       └── process.rs
└── tests/
    └── cli.rs
```

## Key move

`main.rs` becomes:

```rust
use clap::Parser;
use std::process::ExitCode;

fn main() -> ExitCode {
    let cli = my_tool::cli::Cli::parse();

    match my_tool::run(cli) {
        Ok(report) => {
            report.print();
            ExitCode::SUCCESS
        }
        Err(err) => {
            eprintln!("error: {err}");
            ExitCode::FAILURE
        }
    }
}
```

## Done when

- Core planning logic is unit-testable
- CLI behavior has integration tests
- Dry-run proves no mutation
- I/O boundaries add path context to errors
