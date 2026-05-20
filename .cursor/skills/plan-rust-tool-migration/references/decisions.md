# Plan Rust Tool Migration Decisions

## Desired Target

- `auto`: choose the smallest sufficient target from observed evidence.
- `main-modules`: keep one binary but organize modules.
- `bin-lib-split`: move reusable and testable behavior into `src/lib.rs`.
- `multiple-binaries`: use `src/bin/**` only for genuinely distinct
  entrypoints.
- `workspace`: use Cargo workspace only for real package boundaries.
- `internal-crates`: use when reusable crates have stable internal APIs.

## Migration Depth

- `minimal`: reduce immediate risk only.
- `sufficient`: correct safety, testability, maintainability, and evolvability
  enough for durable use.
- `comprehensive`: include full target-state migration, tests, docs, examples,
  and optional workspace/internal crate split when justified.

## CLI Contract

When `preserve_cli_contract=true`, keep commands, flags, exit codes, output
formats, and side-effect behavior stable unless a proposed breaking change is
explicitly isolated and justified.

## File Moves

When `include_file_moves=true`, include source path, target path, reason,
stage, and validation for each proposed movement.
