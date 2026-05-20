# Octon Safety and Authority Notes

This skill package is intentionally non-mutating by default.

## Authority classification

- Skill definitions under `framework/` are portable authored core.
- Repo-specific resources, if added, belong under `instance/`.
- Migration plans under `inputs/exploratory/` are advisory drafts.
- Audit reports and run logs under `state/evidence/` are retained evidence.
- Generated outputs are derived read models and never source of truth.

## Prohibited behavior

The skill must not:

- authorize mutation by itself
- treat generated reports as canonical architecture
- promote raw `inputs/**` into runtime or policy
- create another control plane
- silently rewrite files
- assume silence equals approval
- make broad support claims without evidence

## Proper chain

```text
skill audit -> evidence report -> migration plan -> explicit authorization -> governed implementation -> retained validation evidence
```

## Minimum sufficient correction

The skill should recommend the level of correction necessary for safety, testability, maintainability, and evolvability.

It should not choose the smallest possible patch if the result remains fragile.

It should not overengineer beyond observed needs.
