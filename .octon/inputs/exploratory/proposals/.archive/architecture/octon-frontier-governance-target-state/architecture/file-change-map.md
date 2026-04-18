# File- and Surface-Level Change Map

## Legend

- **Keep**: retain as-is or with editorial clarification only.
- **Modify**: edit existing durable surface.
- **Replace**: swap semantics or schema with a new compatible surface.
- **Relocate**: move to a safer/non-live/non-authoritative location.
- **Deprecate**: mark as transitional with retirement criteria.
- **Remove**: delete after safe replacement or when no governance value remains.
- **Add**: new durable surface.

## Concrete change map

| Current / proposed path | Action | Reason | Promotion / closure requirement | Priority |
|---|---|---|---|---|
| `.octon/README.md` | Modify | Overlay list and support wording must match registry/manifest and target-state generated contract. | README regenerated/updated from canonical registry; no conflict with overlay-points registry. | P0 |
| `.octon/octon.yml` | Modify | Add runtime input hooks for context-pack root, benchmark evidence, browser/API records if accepted. | Schema-compatible root manifest update; portability profiles exclude proposal and state/generated as appropriate. | P1 |
| `.octon/framework/constitution/CHARTER.md` | Modify | Clarify frontier-governance purpose and support-claim vocabulary without weakening current charter. | Charter and support schema terms align. | P0 |
| `.octon/framework/constitution/charter.yml` | Modify | Align support-universe language with schema/live file. | Validator passes against support-target vocabulary. | P0 |
| `.octon/framework/constitution/support-targets.schema.json` | Modify | Current enum does not include live file's `bounded-admitted-live-universe`. | Either schema admits chosen term or live file uses existing enum; tuple-admitted mode documented. | P0 |
| `.octon/instance/governance/support-targets.yml` | Modify | Live file must be schema-valid and tuple admissions must be operational truth. | Support validator passes; unsupported broad claims fail closed. | P0 |
| `.octon/framework/overlay-points/registry.yml` | Modify | Make overlay registry canonical and align docs/instance manifest. | Overlay drift validator passes. | P0 |
| `.octon/instance/manifest.yml` | Modify | Enabled overlay points must agree with registry and docs. | Validator confirms every enabled overlay point is declared and documented. | P0 |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Modify | Add context-pack placement, generated cognition guardrails, and drift rule. | Context pack and generated read-model rules explicit. | P1 |
| `.octon/framework/cognition/runtime/index.yml` | Modify or replace | Current runtime index must not over-declare unimplemented cognition/memory surfaces. | Index matches actual implemented runtime surfaces or surfaces are implemented. | P0 |
| `.octon/generated/cognition/**` | Keep with guardrails | Useful derived summaries/projections; never source of truth. | Freshness/generation-lock validation and context-pack provenance. | P1 |
| `.octon/framework/constitution/contracts/authority/risk-materiality-v1.schema.json` | Add | First-class materiality classification needed for frontier actions. | Schema added, referenced by execution request/grant and policy. | P1 |
| `.octon/instance/governance/policies/risk-materiality.yml` | Add | Repo-specific thresholds for materiality, approvals, evidence, rollback, and support. | Policy validated and applied before grants. | P1 |
| `.octon/framework/constitution/contracts/runtime/context-pack-v1.schema.json` | Add | Deterministic context assembly contract. | Context-pack receipts required for consequential runs. | P1 |
| `.octon/framework/constitution/contracts/runtime/rollback-plan-v1.schema.json` | Add | Pre-action rollback/compensation posture. | Material actions fail closed without matching rollback posture when required. | P1 |
| `.octon/framework/constitution/contracts/runtime/browser-ui-execution-record-v1.schema.json` | Add | Browser/UI governed action evidence. | Required before browser pack live support. | P2 |
| `.octon/framework/constitution/contracts/runtime/api-egress-record-v1.schema.json` | Add | Governed API/connector evidence and egress trace. | Required before API pack live support. | P2 |
| `.octon/framework/constitution/contracts/assurance/benchmark-suite-v1.schema.json` | Add | Comparative frontier benchmark contract. | Benchmark suite produces raw/thin-wrapper/Octon evidence. | P2 |
| `.octon/framework/constitution/contracts/assurance/run-card-v2.schema.json` | Add | Evidence-generated run certification. | RunCards generated from retained evidence. | P2 |
| `.octon/framework/constitution/contracts/assurance/harness-card-v1.schema.json` | Add | Evidence-generated support certification. | HarnessCards generated from support/lab evidence. | P2 |
| `.octon/framework/engine/runtime/spec/execution-authorization-v1.md` | Modify | Include context-pack, risk/materiality, browser/API, rollback prerequisites. | No bypass paths for new material actions. | P1 |
| `.octon/framework/engine/runtime/spec/execution-request-v2.schema.json` | Modify | Add context_pack_ref, risk_materiality_ref/classification, requested_pack_ids, egress/rollback refs. | Backward-compatible additional properties or v3 migration. | P1 |
| `.octon/framework/engine/runtime/spec/execution-grant-v1.schema.json` | Modify | Add granted pack ids, context-pack digest, egress/rollback obligations, evidence obligations. | Grants are sufficient to validate receipts. | P1 |
| `.octon/framework/engine/runtime/spec/execution-receipt-v2.schema.json` | Modify | Add context-pack digest, rollback-plan ref, egress/browser record refs, evidence completeness status. | Receipts close material paths. | P1 |
| `.octon/framework/engine/runtime/spec/mission-control-lease-v1.schema.json` | Modify/strengthen | Existing lease semantics should participate in long-running operation. | Lease lifecycle tested in recovery/intervention suite. | P2 |
| `.octon/framework/engine/runtime/spec/control-directive-v1.schema.json` | Modify/strengthen | Directives must pause/narrow/revoke/safing live runs. | Directive tests and evidence receipts exist. | P2 |
| `.octon/framework/engine/runtime/spec/circuit-breaker-v1.schema.json` | Modify/strengthen | Circuit breakers must be executable and resettable with evidence. | Breaker drills pass. | P2 |
| `.octon/framework/capabilities/README.md` | Modify | Simplify capability conceptual model without removing governance surfaces. | Docs distinguish instruction contracts vs invocation contracts. | P1 |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Modify | Active services must match live claims. | Browser/API services only added when implemented and support-dossier-backed. | P1/P2 |
| `.octon/framework/capabilities/runtime/services/browser-session/contract.yml` | Add or implement | Browser pack references this contract. | Contract, service manifest entry, tests, replay/evidence required before live support. | P2 |
| `.octon/framework/capabilities/runtime/services/api-client/contract.yml` | Add or implement | API pack references this contract. | Contract, service manifest entry, egress leases, tests, evidence required before live support. | P2 |
| `.octon/framework/capabilities/packs/browser/manifest.yml` | Modify | Keep pack but mark stage-only until runtime/evidence proof exists. | Support target and runtime manifest agree. | P1 |
| `.octon/framework/capabilities/packs/api/manifest.yml` | Modify | Keep pack but mark stage-only until runtime/evidence proof exists. | Egress policy and connector leases exist. | P1 |
| `.octon/instance/governance/policies/network-egress.yml` | Modify/replace | Current policy only allows local LangGraph runner. | Add connector leases, allowlists, redaction, idempotency, compensation, trace pointers. | P1 |
| `.octon/instance/governance/policies/execution-budgets.yml` | Modify | Current budgets are workflow-stage/provider-focused. | Add run/mission/model/tool/browser/API budgets and long-context thresholds. | P1 |
| `.octon/framework/engine/runtime/adapters/model/experimental-external.yml` | Relocate or stage-only | Experimental adapter should not imply live support. | Quarantine or validator-enforced stage-only with no support claim. | P0 |
| `.octon/framework/agency/_meta/architecture/specification.md` | Modify | Make one-orchestrator/bounded-specialist/verifier model explicit frontier default. | Actor validation passes; team remains composition only. | P1 |
| `.octon/framework/agency/runtime/agents/registry.yml` | Modify | Clarify optional verifier activation and specialist boundary. | Exactly one default orchestrator; no swarm defaults. | P1 |
| `.octon/framework/orchestration/runtime/workflows/manifest.yml` | Modify | Audit workflow catalog for governance value. | Workflows classified: core, optional pack, deprecated, removed. | P1 |
| `.octon/framework/orchestration/_meta/architecture/specification.md` | Modify | Encode mission/run/objective boundaries for frontier-native execution. | Run-first lifecycle remains atomic; missions remain continuity. | P1 |
| `.octon/framework/lab/**` | Modify/add | Add benchmark, recovery, browser/API, context-pack, intervention scenarios. | Lab evidence generated under state/evidence/lab. | P2 |
| `.octon/framework/assurance/**` | Modify/add | Add validators and RunCard/HarnessCard automation. | Blocking conformance workflows include target-state validators. | P2 |
| `.octon/framework/observability/**` | Modify/add | Add run/replay/intervention/rollback/benchmark metrics. | Observability outputs feed retained evidence and cards. | P2 |
| `.octon/generated/effective/capabilities/**` | Modify generated projection | May include normalized capability routes after authority changes. | Generated only, freshness-checked, not authority. | P2 |
| `.octon/generated/proposals/registry.yml` | Regenerate | New proposal must appear as active discovery projection. | Registry generated from manifests; non-authoritative. | P0 |
