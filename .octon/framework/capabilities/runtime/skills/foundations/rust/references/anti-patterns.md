# Anti-Patterns for Growing Rust Scripts

## Giant `main.rs`

Problem: everything is coupled to process entry.

Correction: thin shell + app orchestration + modules.

## Business logic mixed with CLI parsing

Problem: user input shape becomes domain model.

Correction: parse CLI into boundary structs, resolve into typed config, pass config into execution.

## Global mutable state

Problem: tests become order-dependent and execution depends on hidden state.

Correction: pass config/context explicitly.

## Overusing traits too early

Problem: accidental abstraction and generic complexity.

Correction: start with concrete structs; extract traits only when substitution is real.

## Making everything async

Problem: runtime, `Send`, cancellation, and testing complexity without benefit.

Correction: sync by default; async when workload demands it.

## Stringly errors

Problem: callers and tests cannot classify failures.

Correction: typed errors for domain/library, `anyhow` at glue edge where appropriate.

## Premature workspace splitting

Problem: unclear boundaries become expensive package boundaries.

Correction: stabilize module boundaries first.

## `utils.rs`

Problem: responsibility-free junk drawer.

Correction: name modules by domain: `paths`, `manifest`, `process`, `report`, `validation`.

## Implicit current working directory

Problem: tool behavior changes depending on invocation location.

Correction: resolve root once and pass explicit paths.

## No tests because “it’s just a script”

Problem: scripts become production infrastructure without confidence.

Correction: unit-test pure logic, integration-test CLI behavior, temp-dir test filesystem mutation.

## Shell injection risks

Problem: `sh -c` with interpolated input can execute unintended commands.

Correction: use `Command::new(program).arg(value)`.
