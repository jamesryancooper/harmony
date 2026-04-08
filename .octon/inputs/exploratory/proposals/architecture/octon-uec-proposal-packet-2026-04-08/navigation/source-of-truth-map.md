# Source of Truth Map

This map classifies every touched artifact family by post-cutover authority status and explicitly prevents proposal packets, generated outputs, summaries, and exploratory surfaces from becoming live authority.

| Artifact / family | Post-cutover status | Governed domain | Derives from | Drift detection | Can gate runtime or policy? |
| --- | --- | --- | --- | --- | --- |
| `/.octon/framework/constitution/**` | authoritative | constitutional kernel, contracts, precedence, obligations | n/a | V-SOT-001 | yes |
| `/.octon/instance/**` | authoritative | repo-specific durable authority | n/a | V-SOT-001 | yes |
| `/.octon/state/control/execution/runs/**` | authoritative operational truth | run control truth | n/a | V-RUN-001 | yes |
| `/.octon/state/evidence/**` | authoritative evidence | retained evidence and disclosure lineage | canonical control + evidence producers | V-EVD-001 / V-DISC-001 | no runtime/policy gating |
| `/.octon/state/evidence/disclosure/runs/**/run-card.yml` | authoritative disclosure | per-run disclosure | run contracts, run manifests, evidence roots | V-DISC-001 | no |
| `/.octon/state/evidence/disclosure/releases/**/harness-card.yml` | authoritative disclosure | release-level support and closure claim | support-targets + proof bundle + closure bundle | V-DISC-002 | no |
| `/.octon/generated/**` | non-authoritative | rebuildable effective views | constitutional + instance authority + state | V-SOT-001 | no |
| `/.octon/inputs/**` | non-authoritative | exploratory/additive inputs | n/a | V-SOT-001 | no |
| `/AGENTS.md`, `/CLAUDE.md`, `/.octon/AGENTS.md` | non-authoritative mirrors | thin ingress adapters | `/.octon/instance/ingress/AGENTS.md` | V-SOT-002 | no |
| `.claude/**`, `.codex/**`, `.cursor/**` | non-authoritative projections | tool-facing overlays | canonical ingress and governance | V-SOT-002 | no unless explicitly promoted |
| GitHub labels/checks/comments | non-authoritative host projection | PR/host projection only | canonical authority artifacts | V-AUTH-001 | no |
| Proposal packet files | non-authoritative | planning and ratification only | n/a | manual + V-SOT-001 | no |

## Drift Detection Rules

- **Ingress mirrors:** byte-for-byte parity or schema-validated projection only; any extra text fails `V-SOT-002`.
- **Generated effective views:** regenerated from canonical sources on every validation pass; second-pass diffs fail `V-CERT-001`.
- **Run disclosure surfaces:** regenerated from run contract + run manifest + evidence roots; mismatches fail `V-DISC-001`.
- **Release disclosure surfaces:** regenerated from support targets + proof bundle + closure bundle; mismatches fail `V-DISC-002`.
- **Host projections:** compared against canonical authority artifacts; mismatches fail `V-AUTH-001`.

## Promotion Rule

No currently non-authoritative artifact may become authoritative unless **all** of the following happen in the same change:

1. the constitutional or instance authority explicitly promotes it;
2. the source-of-truth map is updated;
3. a blocking validator is added or updated to cover the new authority surface;
4. the closure evidence bundle records the promotion;
5. the durable ADR set records the scope and reopening rule.

Absent all five, promotion is invalid and certification fails.

## Explicit Non-Authority Bar

The following must remain permanently non-authoritative after cutover unless explicitly promoted using the rule above:

- proposal packets
- generated indexes and summaries
- exploratory inputs
- root/tool-specific mirrors
- release notes and marketing copy
- host-native status surfaces
- archived compatibility artifacts
