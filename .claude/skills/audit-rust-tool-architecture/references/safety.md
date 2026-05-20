# Audit Rust Tool Architecture Safety

## Authority Boundary

The audit report is advisory evidence. It does not authorize implementation,
mutation, release, or support widening. Any correction must route through a
separate governed change path with explicit authorization and rollback posture.

## Read Boundary

Stay within `target_path` except when Cargo workspace membership or command
wrappers are necessary to understand the Rust tool.

## Write Boundary

Write only to registry-declared outputs under validation analysis, validation
audits, and skill run evidence paths. Never edit audited source files.

## Finding Safety

- Do not infer destructive behavior without file-path evidence.
- Do not recommend workspace splitting as an aesthetic cleanup.
- Do not weaken CLI contracts unless the report explicitly marks the change as
  a breaking recommendation requiring implementation approval.
- Separate observed evidence from inference.
