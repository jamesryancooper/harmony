# Source of Truth Map

## Canonical authority hierarchy used by this packet

| Layer | Role | Current source(s) | Why it matters here |
|---|---|---|---|
| Constitutional kernel | Supreme repo-local governance regime | `/.octon/framework/constitution/**` | Prevents frontier-era simplification from weakening authority, fail-closed, evidence, disclosure, support-target, and runtime obligations. |
| Super-root topology | Class-root separation and proposal workspace rules | `/.octon/README.md`, `/.octon/octon.yml` | Establishes `framework` and `instance` as authored authority, `state` as control/evidence, `generated` as rebuildable, and `inputs` as non-authoritative. |
| Cross-subsystem placement | Structural SSOT and root invariants | `/.octon/framework/cognition/_meta/architecture/specification.md` | Determines where new context-pack, risk/materiality, runtime, assurance, and generated surfaces legally belong. |
| Proposal system | Temporary proposal contract | `/.octon/inputs/exploratory/proposals/README.md`, `/.octon/framework/scaffolding/governance/patterns/proposal-standard.md`, `architecture-proposal-standard.md` | Confirms this packet is proposal-local and not canonical after promotion. |
| Execution authorization | Engine-owned material-action boundary | `/.octon/framework/engine/runtime/spec/execution-authorization-v1.md`, execution request/grant/receipt schemas | Requires material actions to pass through `authorize_execution` and emit grants/receipts before side effects. |
| Run lifecycle | Atomic consequential execution unit | `/.octon/framework/engine/runtime/README.md`, `/.octon/octon.yml#runtime_inputs` | Keeps missions as continuity containers and runs as the executable, evidenced unit. |
| State/control/evidence | Mutable operational truth and retained proof | `/.octon/state/control/**`, `/.octon/state/evidence/**`, `/.octon/state/continuity/**` | Determines where approvals, leases, revocations, receipts, traces, replay pointers, rollback, and mission continuity must land. |
| Capability governance | Bounded tool/service surfaces | `/.octon/framework/capabilities/**`, packs, services, deny-by-default policy | Distinguishes tool-use enablement from bounded permissioning and capability admission. |
| Support claims | Bounded support universe | `/.octon/instance/governance/support-targets.yml`, `/.octon/framework/constitution/support-targets.schema.json` | Support must be tuple-admitted, proof-backed, and schema-valid. Current drift is a priority fix. |
| Agency | Actor taxonomy and delegation boundaries | `/.octon/framework/agency/_meta/architecture/specification.md`, `runtime/agents/registry.yml` | Establishes one accountable orchestrator, optional verifier, assistants, and teams as composition artifacts. |
| Orchestration | Workflow/run/mission contracts | `/.octon/framework/orchestration/**`, workflow manifest, mission surfaces | Separates governance/evidence workflows from token-era reasoning choreography. |
| Cognition/generated | Derived read models only | `/.octon/generated/cognition/**`, cognition umbrella spec | Ensures summaries, projections, and graph datasets never become memory, policy, or authority. |
| Assurance/lab/observability | Proof production and behavioral testing | `/.octon/framework/assurance/**`, `/.octon/framework/lab/**`, `/.octon/framework/observability/**` | Must evolve from taxonomy to automated support, run, replay, rollback, and benchmark proof. |

## Proposal-local authorities

| Packet file | Authority inside this packet | Boundary |
|---|---|---|
| `proposal.yml` | Lifecycle, scope, promotion target, non-goal, closure authority for this proposal | Not runtime/policy authority. |
| `architecture-proposal.yml` | Architecture subtype decision manifest | Not durable architecture until promoted. |
| `navigation/source-of-truth-map.md` | Manual precedence and boundary map for packet interpretation | Cannot override repo authority. |
| `architecture/target-architecture.md` | Proposed end-state design | Must be promoted into durable surfaces before becoming active. |
| `architecture/acceptance-criteria.md` | Proposal closeout criteria | Must be converted into validators/evidence in durable targets. |

## Derived projections and generated surfaces

Generated outputs remain rebuildable and non-authoritative. The packet may propose generated read-model refinements, but durable authority must live in `framework/**`, `instance/**`, or retained `state/**` control/evidence as appropriate. `/.octon/generated/proposals/registry.yml` remains discovery-only and cannot outrank `proposal.yml`.

## Retained evidence surfaces

Retained proof for implementation must land under `/.octon/state/evidence/**`, including run evidence, validation receipts, control-plane evidence, lab evidence, benchmark evidence, RunCards, HarnessCards, replay pointers, trace pointers, and disclosure artifacts.

## Explicitly excluded as authority

- This proposal packet after promotion.
- Raw `inputs/**` except as non-authoritative source material.
- `generated/**` outputs as policy, approval, runtime, or support authority.
- Host UI labels, comments, checks, browser state, or chat transcripts.
- Model memory, provider defaults, or frontier-model priors.
