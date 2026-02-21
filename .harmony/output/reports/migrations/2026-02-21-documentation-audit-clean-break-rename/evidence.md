# Documentation Audit Clean-Break Rename Evidence (2026-02-21)

## Scope

Clean-break rename of the documentation release-check workflow from
`documentation-quality-gate` to `documentation-audit` across workflow runtime,
contracts, and active references.

Legacy removed:

- Workflow id: `documentation-quality-gate`
- Workflow command: `/documentation-quality-gate`
- Workflow runtime path:
  - `/.harmony/orchestration/runtime/workflows/audit/documentation-quality-gate/`

Canonical replacement:

- Workflow id: `documentation-audit`
- Workflow command: `/documentation-audit`
- Workflow runtime path:
  - `/.harmony/orchestration/runtime/workflows/audit/documentation-audit/`

## Static Verification

### Legacy identifier sweep (active surfaces)

Command:

```bash
rg -n "documentation-quality-gate|/documentation-quality-gate" .harmony \
  --glob '!.harmony/output/**' \
  --glob '!.harmony/ideation/**' \
  --glob '!.harmony/cognition/runtime/migrations/**' \
  --glob '!.harmony/cognition/runtime/decisions/**' \
  --glob '!.harmony/cognition/runtime/context/decisions.md' \
  --glob '!.harmony/orchestration/runtime/workflows/_ops/scripts/validate-workflows.sh' \
  --glob '!.harmony/orchestration/runtime/workflows/audit/documentation-audit/WORKFLOW.md'
```

Result:

- Passed (`no matches`)

### Legacy path sweep (active non-guardrail surfaces)

Command:

```bash
rg -n "orchestration/runtime/workflows/audit/documentation-quality-gate/|\.harmony/orchestration/runtime/workflows/audit/documentation-quality-gate/" .harmony \
  --glob '!.harmony/output/**' \
  --glob '!.harmony/ideation/**' \
  --glob '!.harmony/cognition/runtime/migrations/**' \
  --glob '!.harmony/cognition/runtime/decisions/**' \
  --glob '!.harmony/cognition/runtime/context/decisions.md' \
  --glob '!.harmony/orchestration/runtime/workflows/_ops/scripts/validate-workflows.sh' \
  --glob '!.harmony/cognition/practices/methodology/migrations/legacy-banlist.md'
```

Result:

- Passed (`no matches`)

### Legacy directory removal

Command:

```bash
test ! -e .harmony/orchestration/runtime/workflows/audit/documentation-quality-gate \
  && echo "PASS: .harmony/orchestration/runtime/workflows/audit/documentation-quality-gate removed"
```

Result:

- Passed
  - `PASS: .harmony/orchestration/runtime/workflows/audit/documentation-quality-gate removed`

## Runtime / Contract Verification

### Workflow contract validation

Command:

```bash
bash .harmony/orchestration/runtime/workflows/_ops/scripts/validate-workflows.sh
```

Result:

- Passed (`Validation summary: errors=0 warnings=0`)
- Confirms:
  - `documentation-audit` manifest path resolves
  - deprecated path enforcement includes
    `/.harmony/orchestration/runtime/workflows/audit/documentation-quality-gate`

### Skills contract validation (strict)

Command:

```bash
bash .harmony/capabilities/runtime/skills/_ops/scripts/validate-skills.sh --strict
```

Result:

- Passed (`All checks passed!`)

### Audit subsystem alignment validation

Command:

```bash
bash .harmony/assurance/runtime/_ops/scripts/validate-audit-subsystem-health-alignment.sh
```

Result:

- Passed (`Validation summary: errors=0 warnings=0`)
- Confirms watched architecture changes include audit-subsystem-health updates
  and version bump `1.0.5 -> 1.0.7`.

### Alignment profile validation (skills, workflows, harness)

Command:

```bash
bash .harmony/assurance/runtime/_ops/scripts/alignment-check.sh --profile skills,workflows,harness
```

Result:

- Passed (`Alignment check summary: errors=0`)

## CI / Guardrail Verification

Guardrails updated to block legacy reintroduction:

- Workflow validator deprecated-path check:
  - `/.harmony/orchestration/runtime/workflows/_ops/scripts/validate-workflows.sh`
- Legacy banlist entries:
  - `/.harmony/cognition/practices/methodology/migrations/legacy-banlist.md`

## Migration Artifacts

- Plan:
  - `/.harmony/cognition/runtime/migrations/2026-02-21-documentation-audit-clean-break-rename/plan.md`
- ADR:
  - `/.harmony/cognition/runtime/decisions/030-documentation-audit-clean-break-rename.md`
- Decision context addendum:
  - `/.harmony/cognition/runtime/context/decisions.md`
- Evidence report:
  - `/.harmony/output/reports/migrations/2026-02-21-documentation-audit-clean-break-rename/evidence.md`
