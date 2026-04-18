# Repository Baseline Audit

## Audit scope

This baseline summarizes repository evidence used by the packet. It is not a substitute for running the repository's validators. It records the visible live public repository posture at packet authoring time.

## Proposal system evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/inputs/exploratory/proposals/README.md` | Proposals are non-canonical implementation aids; active proposals live under `/.octon/inputs/exploratory/proposals/<kind>/<proposal_id>/`; required files include `proposal.yml`, one subtype manifest, `README.md`, navigation files, and optional support. | Packet path and file set follow this convention. |
| `.octon/framework/scaffolding/governance/patterns/proposal-standard.md` | Defines proposal manifest contract, lifecycle, required files, promotion target rules, registry contract, and non-canonical rule. | `proposal.yml` uses `proposal-v1`, `architecture`, `octon-internal`, active `draft`, temporary lifecycle, and `.octon/**` promotion targets. |
| `.octon/framework/scaffolding/governance/patterns/architecture-proposal-standard.md` | Requires `architecture-proposal.yml`, `architecture/target-architecture.md`, `architecture/acceptance-criteria.md`, and `architecture/implementation-plan.md`. | Packet includes these required files and additional architecture/resource artifacts. |

## Super-root and authority evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/README.md` | Defines `.octon` as single authoritative super-root; only `framework/**` and `instance/**` are authored authority; `inputs/**` is non-authoritative; `state/**` is continuity/evidence/control; `generated/**` is rebuildable. | Target architecture preserves class-root separation. |
| `.octon/octon.yml` | Root manifest with profiles, fail-closed policies, runtime input roots, adapter roots, capability roots, evidence roots, and execution governance. | Promotion targets include root manifest only for hooks needed by accepted new surfaces. |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Structural SSOT; generated outputs are never source of truth; material execution resolves through engine authorization; runtime evidence belongs under `state/evidence/**`. | Context/cognition model must keep generated outputs derived only. |

## Execution/runtime evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/engine/runtime/README.md` | Runtime exposes run-first CLI surfaces and binds run control/evidence roots before side effects. | Run remains atomic execution unit. |
| `.octon/framework/engine/runtime/spec/execution-authorization-v1.md` | Material execution must pass through `authorize_execution`; no material side effect before grant; receipt emission mandatory. | Engine-owned authorization is strengthened, not removed. |
| `execution-request-v2.schema.json`, `execution-grant-v1.schema.json`, `execution-receipt-v2.schema.json` | Request/grant/receipt schemas already include risk, side effects, workflow mode, autonomy context, decision, capabilities, rollback/compensation handles, and evidence links. | Extend these with context-pack, materiality, rollback, browser/API, egress, and benchmark references. |

## Agency evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/agency/_meta/architecture/specification.md` | Defines agents, assistants, teams; removes `subagents` as first-class artifact; teams are composition, not runtime actor. | Actor simplification aligns with existing direction. |
| `.octon/framework/agency/runtime/agents/registry.yml` | Default orchestrator plus optional verifier. | Target actor model uses one accountable orchestrator plus optional bounded specialists/verifier. |

## Capability evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/capabilities/README.md` | Defines commands, skills, tools, services; browser/API packs fail closed until repo-local admission. | Keep governance but simplify conceptual model. |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Active services listed as filesystem snapshot/discovery/watch, KV, and execution flow. | Browser/API services are not active in manifest and should not be live claims until implemented/proved. |
| `.octon/framework/capabilities/packs/browser/manifest.yml` | Requires authority decision, replay, runtime event ledger, RunCard, support target, DOM/screenshot/session topology. | Browser pack has strong design, needs runtime proof. |
| `.octon/framework/capabilities/packs/api/manifest.yml` | Requires egress, replay, disclosure, request/response trace pointers, compensation. | API pack has strong design, needs egress/connector/runtime proof. |

## Support/adapter evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/instance/governance/support-targets.yml` | Declares support modes, support universe, tuple admissions, host/model adapters, conformance criteria, support dossiers. Uses `bounded-admitted-live-universe`. | P0 drift with schema; admitted tuples should be operational support truth. |
| `.octon/framework/constitution/support-targets.schema.json` | Allows `bounded-admitted-finite` and `global-complete-finite`. | Schema/live file mismatch must be reconciled. |
| `.octon/framework/engine/runtime/adapters/model/experimental-external.yml` | Experimental model adapter with experimental tier hints. | Should be quarantined or stage-only, not active support. |

## Overlay evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/overlay-points/registry.yml` | Lists overlay points including policies, contracts, adoption, retirement, exclusions, capability-packs, decisions, agency runtime, assurance runtime. | README overlay list must match registry/manifest or registry should be narrowed. |
| `.octon/instance/manifest.yml` | Enables the overlay points listed in registry. | Instance manifest must remain aligned with registry and docs. |

## Governance policy evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/instance/governance/policies/network-egress.yml` | Allows local LangGraph HTTP runner only. | Insufficient for governed API/browser egress. Add connector leases or keep API stage-only. |
| `.octon/instance/governance/policies/execution-budgets.yml` | Applies cost guardrails to OpenAI/Anthropic workflow stages. | Expand to run/mission/tool/browser/API/model budgets. |

## Baseline limitations

- This packet generation did not run Octon's local validators or build runtime crates.
- Some repository files are minified single-line YAML/JSON in raw view; judgments use visible content and prior review evidence.
- Implementation must re-run repository-local validation before promotion.
