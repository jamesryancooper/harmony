---
title: RA/ACP Promotion Inputs Matrix
description: Canonical promotion-input requirements by ACP level for reversible autonomy.
status: Active
---

# RA/ACP Promotion Inputs Matrix

Canonical source for ACP promotion input minimums.  
Policy source of truth: `.harmony/capabilities/_ops/policy/deny-by-default.v2.yml` (`acp`, `reversibility`, `budgets`, `quorum`, `attestations`, `receipts`).
Terminology source: [RA/ACP Glossary](./ra-acp-glossary.md).

## Enforcement Boundary

- Capability attempt authority: `Deny by Default`.
- Promotion/contraction authority: `Autonomous Control Points`.
- Receipt fields are canonical; PR artifacts are optional projections when PR context exists.

## Risk Tier Mapping (Canonical)

Risk tier to ACP mapping is defined only in policy:  
`.harmony/capabilities/_ops/policy/deny-by-default.v2.yml#acp.risk_tier_mapping`

| Risk tier | ACP level |
|---|---|
| low | ACP-1 |
| medium | ACP-2 |
| high | ACP-3 |

## Promotion Input Minimums by ACP Level

| ACP | Minimum evidence bundle | Reversibility minimum | Quorum minimum | Budgets / breakers | Receipt minimum fields | Optional projection |
|---|---|---|---|---|---|---|
| ACP-0 | n/a (observe/read-only) | n/a | n/a | n/a | no promotion receipt required | PR note if present |
| ACP-1 | `diff`, docs-gate evidence: `docs.spec`, `docs.adr`, `docs.runbook` | reversible primitive + rollback handle | none | required budget set + circuit breaker set | `run_id`, `operation`, `phase`, `effective_acp`, `decision`, `reason_codes`, `evidence`, `rollback_handle`, `budgets`, `counters` | PR may reference `receipt_id` + summary |
| ACP-2 | ACP-1 + class-specific tests/CI/canary/plan as policy requires | ACP-1 + rollback proof where rule requires | `quorum.acp2` + required attestation fields | required budget set + circuit breaker set | ACP-1 fields + `attestations` + `recovery_window` | PR may embed trace links and receipt digest |
| ACP-3 | ACP-2 + destructive-adjacent evidence as policy requires | ACP-2 + recovery window | `quorum.acp3` | stricter budgets + destructive breakers | ACP-2 fields, fully populated for recovery | PR may reference staged/final receipts |
| ACP-4 | break-glass only; out-of-band | irreversible by exception only | policy-specific | policy-specific | audited denial/escalation and break-glass receipt path | no routine PR projection |

## Docs-Gate Outcomes (Canonical)

Docs-gate is enforced at ACP evaluator runtime via policy:

- Missing `docs.spec` / `docs.adr` / `docs.runbook` adds reason code `ACP_DOCS_EVIDENCE_MISSING`.
- Outcome by ACP level is policy-defined at `acp.docs_gate.missing_action_by_acp`.

## Owner Attestation Outcomes (Canonical)

Owner attestation behavior is policy-defined at `attestations.owner_attestation`.

- Sources: `codeowners`, `ownership_registry`, `boundaries_manifest`.
- Missing required owner attestation: bounded `STAGE_ONLY` with reason code.
- Exhausted retry/timeout window: optional `ESCALATE` when configured.

## Provenance Schema Pointer

Required receipt/provenance fields for promote decisions:  
`.harmony/capabilities/_ops/policy/acp-provenance-fields.schema.json`
