# Source Of Truth Map

## Canonical Authority

| Concern | Source of truth | Notes |
| --- | --- | --- |
| Framework binding for overlay governance | `.octon/framework/manifest.yml` | `overlay_registry` binds the framework manifest to the canonical overlay registry |
| Declared overlay points, instance globs, merge modes, validators, and precedence | `.octon/framework/overlay-points/registry.yml` | Canonical framework-authored registry for all legal repo-instance overlay points |
| Repo-side overlay enablement | `.octon/instance/manifest.yml` | `enabled_overlay_points` is the repo-owned allowlist for active overlay points |
| Canonical internal ingress | `.octon/instance/ingress/AGENTS.md` | Canonical authored ingress for this repository's harness |
| Thin host-facing ingress adapters | `AGENTS.md`, `CLAUDE.md`, `.octon/AGENTS.md` | Adapter surfaces may redirect or project canonical ingress but may not become separate authority |
| Repo-specific governance policy overlays | `.octon/instance/governance/policies/**` | Valid only when covered by a declared enabled overlay point |
| Repo-specific governance contract overlays | `.octon/instance/governance/contracts/**` | Valid only when covered by a declared enabled overlay point |
| Repo-specific agency runtime overlays | `.octon/instance/agency/runtime/**` | Valid only when covered by a declared enabled overlay point |
| Repo-specific assurance runtime overlays | `.octon/instance/assurance/runtime/**` | Valid only when covered by a declared enabled overlay point |
| Super-root authority order and portability semantics | `.octon/octon.yml` and `.octon/README.md` | Class-root authority and repo snapshot behavior constrain overlay portability and ingress placement |
| Cross-subsystem overlay and ingress contract after promotion | `.octon/framework/cognition/_meta/architecture/specification.md` and `.octon/framework/cognition/_meta/architecture/shared-foundation.md` | Durable architecture references that must converge on the same overlay model |

## Derived Or Enforced Projections

| Concern | Derived path or enforcement surface | Notes |
| --- | --- | --- |
| Overlay-point validation | `.octon/framework/assurance/runtime/_ops/scripts/validate-overlay-points.sh` | Fails closed on invalid registry schema, undeclared enablement, unsupported merge modes, or forbidden domains |
| Repo-instance boundary validation | `.octon/framework/assurance/runtime/_ops/scripts/validate-repo-instance-boundary.sh` | Enforces canonical instance structure, enabled overlay roots, and wrong-class placement rules |
| Aggregated alignment execution | `.octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh` | Runs overlay validation as part of the harness alignment profile |
| Update and migration orchestration | `.octon/framework/orchestration/runtime/workflows/**` | Framework update flows must preserve repo-side enablement and canonical ingress unless an explicit migration contract says otherwise |
| Proposal discovery for this temporary package | `.octon/generated/proposals/registry.yml` | Derived non-authoritative registry that should list this proposal package while it is active |

## Boundary Rules

- `framework/**` remains the base authored authority.
- `instance/**` remains the repo-owned durable authority layer.
- Overlay-capable instance content is legal only when the framework registry
  declares the overlay point and the instance manifest enables it.
- There is no blanket shadow-tree model for `instance/**`.
- Canonical authored ingress lives under `instance/ingress/**`.
- `AGENTS.md`, `CLAUDE.md`, and `/.octon/AGENTS.md` are thin adapters only.
- Raw `inputs/**` paths must never become direct runtime or policy
  dependencies.
- `state/**` and `generated/**` are never valid overlay targets.
- Forbidden framework surfaces such as `framework/engine/runtime/**` remain
  closed to repo-instance overlays.
