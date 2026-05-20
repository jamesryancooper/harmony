# Plan Rust Tool Migration Safety

## Authority Boundary

The migration plan is advisory. It may be used as input to a governed
implementation run, but it does not authorize mutation.

## Write Boundary

Write only to registry-declared planning, validation analysis, and skill run
evidence outputs. Never edit the Rust target while running this skill.

## Planning Safety

- Preserve the CLI contract by default.
- Separate file moves from behavior changes.
- Stage risky refactors behind characterization tests.
- Add rollback notes for each stage that moves files or changes public
  behavior.
- Do not recommend workspace or internal crates without observed boundaries.
