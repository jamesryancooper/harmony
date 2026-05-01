---
title: Alignment Check
description: Run profile-based harness alignment validations through a single command.
access: agent
argument-hint: "--profile <aspect>[,<aspect>...] [--dry-run] [--list-profiles]"
---

# Alignment Check `/alignment-check`

Run repeatable alignment checks by profile.
Profile ids are registry-backed by
`.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`.

## Usage

```text
/alignment-check --list-profiles
/alignment-check --profile commit-pr
/alignment-check --profile default-work-unit
/alignment-check --profile skills,workflows
/alignment-check --profile proposal-lifecycle
/alignment-check --profile all
```

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `--profile` | Yes* | Comma-separated profile list to run. |
| `--list-profiles` | No | Print available profiles and exit. |
| `--dry-run` | No | Print planned checks without executing them. |

\* `--profile` is required unless `--list-profiles` is used.

## Implementation

Run:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile <aspect[,aspect...]> [--dry-run]
```

List profiles:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --list-profiles
```

## Output

- Profile-by-profile pass/fail status for each validator step
- Final summary with total error count

## References

- **Runner:** `.octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh`
- **Contract governance validator:** `.octon/framework/assurance/runtime/_ops/scripts/validate-contract-governance.sh`
- **Commit/PR validator:** `.octon/framework/assurance/runtime/_ops/scripts/validate-commit-pr-alignment.sh`
- **Default work unit validator:** `.octon/framework/assurance/runtime/_ops/scripts/validate-default-work-unit-alignment.sh`
- **Change closeout lifecycle validator:** `.octon/framework/assurance/runtime/_ops/scripts/validate-change-closeout-lifecycle-alignment.sh`
- **Proposal lifecycle readiness validator:** `.octon/framework/assurance/runtime/_ops/scripts/validate-proposal-implementation-readiness.sh`
- **Proposal lifecycle workflow validators:** `.octon/framework/assurance/runtime/_ops/scripts/validate-create-*-proposal-workflow.sh`,
  `.octon/framework/assurance/runtime/_ops/scripts/validate-audit-*-proposal-workflow.sh`
- **Quality baseline:** `.octon/framework/assurance/README.md`
