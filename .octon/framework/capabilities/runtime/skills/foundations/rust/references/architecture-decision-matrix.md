# Rust Tool Architecture Decision Matrix

## Recommended target shape

| Situation | Target shape | Why |
|---|---|---|
| Tiny one-off utility | single `src/main.rs` | Fastest path, low ceremony |
| Growing but still one binary | `main.rs` plus modules | Organizes without premature library API |
| Serious long-lived CLI/tool | `src/main.rs` + `src/lib.rs` | Enables testable core and integration tests |
| Multiple real executable entrypoints | `src/bin/**` + shared `lib.rs` | Shared logic, separate command names |
| Multiple real packages | workspace | Separate package boundaries and dependency surfaces |
| Stable reusable internal subsystem | internal crate | Real API and independent tests |

## Workspace threshold

Recommend a workspace only when at least two of these are true:

- independent package responsibility
- independent dependency set
- separate release/build/test surface
- reusable API needed by multiple binaries/packages
- compile-time or feature-boundary benefit
- `xtask`/repo automation separation is useful
- test-support crate avoids circular/dependency pollution

Do not recommend a workspace for:

- one messy `main.rs`
- vague desire for professionalism
- modules that are not stable yet
- a `utils` crate
- fake abstraction boundaries

## `lib.rs` threshold

Recommend `lib.rs` when:

- integration tests need core logic
- multiple binaries share logic
- core behavior should be tested independent of CLI
- binary shell is becoming hard to reason about
- user-facing CLI contract should remain stable while internals move

## Multiple binaries threshold

Recommend `src/bin/**` when:

- command names are genuinely separate
- admin/dev/helper binaries have distinct lifecycle
- subcommands are not enough
- shared library exists or should exist

Do not recommend `src/bin/**` for:

- verbose vs quiet
- fast vs slow
- dry-run vs write
- one-off variants better expressed as flags
