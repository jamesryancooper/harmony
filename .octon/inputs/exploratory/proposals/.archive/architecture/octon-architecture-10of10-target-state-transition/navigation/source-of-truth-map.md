# Source of Truth Map

## Proposal-local authority

| Surface | Role | Authority posture |
|---|---|---|
| `proposal.yml` | Shared proposal lifecycle authority | Proposal-local only |
| `architecture-proposal.yml` | Architecture subtype manifest | Proposal-local only |
| `navigation/source-of-truth-map.md` | Manual precedence and boundary map | Proposal-local navigation |
| `architecture/*.md` | Implementation plan and target architecture | Proposal-local implementation aid |
| `resources/*.md` | Evaluation and supporting analysis | Proposal-local evidence and rationale |

## Durable repo authority used by this packet

| Domain | Durable source(s) | Use in this proposal |
|---|---|---|
| Super-root/class roots | `/.octon/README.md`, `/.octon/octon.yml` | Confirms `.octon/` super-root, profile-driven portability, generated commit defaults, runtime-resolution anchors, human-led zones, and execution-governance defaults. |
| Structural topology | `/.octon/framework/cognition/_meta/architecture/contract-registry.yml`, `specification.md` | Defines class roots, path families, delegated registries, doc targets, publication metadata, compatibility posture, and generated/effective rules. |
| Constitutional kernel | `/.octon/framework/constitution/**` | Highest repo-local authority for fail-closed, evidence, precedence, authority, support, and generated-vs-authored rules. |
| Runtime authorization | `/.octon/framework/engine/runtime/spec/execution-authorization-v1.md`, material side-effect inventory, boundary coverage, runtime crates | Governs material side-effect authorization and GrantBundle/receipt requirements. |
| Runtime resolution | `/.octon/instance/governance/runtime-resolution.yml`, `/.octon/generated/effective/runtime/route-bundle.yml`, route-bundle lock | Defines selector and runtime-facing compiled route handle; proposal hardens this path. |
| Support claims | `/.octon/instance/governance/support-targets.yml`, admissions, dossiers, proof bundles, support-card projections | Defines live/stage-only/unadmitted/retired support state; proposal must not widen claims. |
| Capability packs | `/.octon/framework/capabilities/packs/**`, `/.octon/instance/governance/capability-packs/**`, `/.octon/generated/effective/capabilities/pack-routes.effective.yml` | Framework contracts, repo governance intent, and runtime-facing pack route view. |
| Runtime-pack compatibility projection | `/.octon/instance/capabilities/runtime/packs/**` | Retained compatibility projection to freeze/retire. |
| Extensions | `/.octon/inputs/additive/extensions/**`, `/.octon/instance/extensions.yml`, `/.octon/state/control/extensions/{active.yml,quarantine.yml}`, `/.octon/generated/effective/extensions/**` | Raw inputs, desired selection, active/quarantine control state, and published effective outputs. |
| Non-authority surfaces | `/.octon/instance/governance/non-authority-register.yml` | Must expand to runtime-facing generated/effective handles and operator projections. |
| Retirement posture | `/.octon/instance/governance/retirement-register.yml` | Governs retained compatibility surfaces and their successors. |
| Evidence/proof | `/.octon/state/evidence/**`, evidence-store spec, proof bundles, architecture-health validators | Defines retained proof, receipts, run/release disclosure, and closure evidence. |

## Boundary rules

- Generated/effective outputs may be runtime-facing only through freshness-checked resolver handles; they must not become authority.
- Proposal paths must not be runtime, policy, support-claim, or publication inputs after promotion.
- `inputs/additive/extensions/**` remain raw extension inputs until desired selection, active-state materialization, quarantine handling, publication, and freshness validation complete.
- Support admission, pack admission, and extension publication may narrow execution but may not widen live support beyond `support-targets.yml`.
- Operator read models must trace to authored authority, control truth, retained evidence, or continuity state and must remain non-authoritative.
