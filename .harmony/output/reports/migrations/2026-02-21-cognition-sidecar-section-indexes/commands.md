# Commands

## Core Migration Edits

```bash
rm -rf .harmony/cognition/practices/methodology/sections \
  .harmony/cognition/_meta/architecture/sections
```

## Validation Commands

```bash
bash .harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh
bash .harmony/assurance/runtime/_ops/scripts/validate-audit-subsystem-health-alignment.sh
bash .harmony/orchestration/runtime/workflows/_ops/scripts/validate-workflows.sh
bash .harmony/capabilities/runtime/skills/_ops/scripts/validate-skills.sh --strict
bash .harmony/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness,skills,workflows
```
