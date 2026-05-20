# Plan Rust Tool Migration Validation

## Plan Acceptance

The migration plan is complete when it includes:

- target summary
- current constraints
- desired target shape and non-goals
- migration stages
- file/module movement map when requested
- API boundary changes
- error, config, and logging changes
- testing additions
- filesystem/process safety corrections
- validation commands
- rollback notes
- done gate

## Done Gate

The planned implementation is done only when:

- validation commands pass
- CLI contract preservation is verified or documented as intentionally changed
- tests cover extracted library behavior
- file moves leave no stale references
- rollback notes are executable enough for an implementer to reverse each stage

When `post_remediation=true`, format the plan as verification-oriented and
state which acceptance criteria have already been satisfied.
