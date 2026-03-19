# Packet 5 — Overlay and Ingress Model

**Proposal design packet for ratifying, normalizing, and machine-enforcing repo-instance overlay-capable surfaces and canonical internal ingress inside Octon's five-class Super-Root architecture.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Repo-instance overlays, canonical internal ingress, overlay-point declaration, merge-mode enforcement, and host-facing ingress adapters
- **Implementation order:** 5 of 15 in the ratified proposal sequence
- **Primary outcome:** Make overlay-capable repo-instance surfaces explicit, machine-enforceable, and operationally safe while fixing the under-specification identified during independent architectural review
- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture
- **Migration role:** Finish the repo-instance boundary by separating instance-native authority from overlay-capable authority before locality, state, extensions, generated outputs, and migration cutover proceed
- **Current repo delta:** The live repo already contains `framework/overlay-points/registry.yml`, `instance/manifest.yml`, and `instance/ingress/AGENTS.md`; this packet ratifies and hardens that direction rather than inventing a new one

> **Packet intent:** define the final contract for overlay-capable repo-instance surfaces and canonical internal ingress so Octon can preserve framework authority, allow governed repo-local overrides where explicitly intended, and stop relying on ad hoc placement or undocumented shadowing behavior.

## 1. Why this proposal exists

Packet 4 ratified `instance/**` as Octon's repo-specific durable authoritative layer. The independent architectural assessment then identified one remaining material gap: the blueprint described overlay-capable behavior, but did not make repo-local overlay placement and enforcement explicit enough for governance, agency, assurance, and canonical ingress/governance artifacts.

That gap matters because Octon already depends on repo-local ingress and policy surfaces. The current repo now exposes a canonical internal ingress at `/.octon/instance/ingress/AGENTS.md`, a framework overlay registry at `/.octon/framework/overlay-points/registry.yml`, and an instance companion manifest that enables specific overlay points. Those are strong implementation signals, but until this packet is ratified, teams still lack a final machine-enforceable answer to these questions:

- Which repo-owned surfaces are **instance-native** and do not depend on framework overlay semantics?
- Which repo-owned surfaces are **overlay-capable**, and only valid when the framework declares an overlay point?
- Where do repo-local governance, agency, and assurance overlays live?
- Where does canonical internal ingress live, and what exactly are repo-root ingress files allowed to do?
- How are overlay points declared, enabled, validated, and merged?
- What happens when a repo invents a would-be overlay path that the framework never declared?

This packet exists to close those questions before implementation proceeds.

## 2. Problem statement

Octon needs a final overlay and ingress model that is:

- **machine-enforceable**
- **compatible with the five-class Super-Root**
- **safe under framework upgrades**
- **explicit about precedence and merge behavior**
- **clear about canonical ingress location**
- **compatible with Git review, CODEOWNERS, and validator-driven enforcement**
- **small enough to implement without creating a second authority system**

The live repo already moved toward this design. The overlay registry currently declares overlay points for governance policies, governance contracts, agency runtime, and assurance runtime. The live instance manifest already enables those overlay points. Canonical internal ingress is already rooted under `instance/ingress/AGENTS.md`. Those facts mean Packet 5 is not speculative architecture. It is the ratification layer that turns current directional implementation into a durable contract.

### Current baseline signals that trigger this proposal

| Current baseline signal | Observed current-state source | Ratification implication |
|---|---|---|
| The live repo now exposes `framework/overlay-points/registry.yml` | `/.octon/framework/overlay-points/registry.yml` | Overlay-capable instance paths are already being declared and must now become canonical |
| The live overlay registry already defines governance, agency, and assurance instance globs | same registry | Packet 5 must ratify those paths and their merge modes rather than leaving them implicit |
| `instance/manifest.yml` already enables specific overlay points | `/.octon/instance/manifest.yml` | Packet 5 must define how enabled overlay points are interpreted and enforced |
| Canonical internal ingress already exists under `instance/ingress/AGENTS.md` | `/.octon/instance/ingress/AGENTS.md` | Packet 5 must ratify internal ingress placement and thin-adapter rules for repo-root ingress files |
| Current root README already calls `instance/**` the canonical repo-owned authority layer | `/.octon/README.md` | Packet 5 must distinguish instance-native authority from overlay-capable authority without weakening class boundaries |

## 3. Final target-state decision summary

- Overlay-capable repo-local surfaces live under `instance/**`, not under `framework/**`, `state/**`, `generated/**`, or `inputs/**`.
- Overlay-capable placement is legal **only** when a framework-declared overlay point exists and the instance manifest enables it.
- The canonical framework overlay registry is `framework/overlay-points/registry.yml`.
- The canonical repo-side enablement surface is `instance/manifest.yml` via `enabled_overlay_points`.
- The canonical internal ingress surface is `instance/ingress/AGENTS.md`.
- Repo-root ingress files may exist, but they are adapters, projections, or scaffolds only. They must not introduce a second authority surface.
- Overlay-capable surfaces are a bounded subset of `instance/**`; the rest of `instance/**` is repo-owned durable authority that does not rely on overlay semantics.
- v1 allows only three merge modes for overlay points: `replace_by_path`, `merge_by_id`, and `append_only`.
- Any would-be overlay artifact outside a declared enabled overlay point is invalid and must fail closed.

## 4. Scope

- Define the final placement of overlay-capable repo-instance surfaces.
- Define the final placement of canonical internal ingress.
- Distinguish instance-native surfaces from overlay-capable surfaces.
- Ratify the overlay registry and enablement model.
- Define allowed v1 merge modes and precedence semantics.
- Define adapter rules for repo-root ingress files.
- Define validator expectations and wrong-placement failure behavior.
- Provide the machine-enforceable boundary that later packets depend on.

## 5. Non-goals

- Re-litigating the five-class Super-Root.
- Re-litigating whether proposals and extensions are internalized under `inputs/**`.
- Creating a blanket shadow-tree model for all of `instance/**`.
- Designing a general-purpose user-customization or plugin API beyond the explicit overlay points.
- Replacing the framework authority model with repo-local governance supremacy.
- Detailed locality schema (Packet 6).
- Detailed extension desired/actual/quarantine pipeline (Packet 8).
- Detailed generated-output schemas (Packet 10).

## 6. Canonical paths and artifact classes

| Canonical path | Class | Authority status | Purpose |
|---|---|---|---|
| `framework/overlay-points/registry.yml` | Framework | Authoritative authored | Declares all legal repo-instance overlay points, merge modes, validators, and precedence |
| `instance/manifest.yml` | Instance | Authoritative control metadata | Enables allowed overlay points for this repo instance |
| `instance/ingress/AGENTS.md` | Instance | Authoritative authored | Canonical internal ingress for this repository's harness |
| `instance/governance/policies/**` | Instance | Authoritative only when overlay-bound | Repo-specific governance policy overlays |
| `instance/governance/contracts/**` | Instance | Authoritative only when overlay-bound | Repo-specific governance contract overlays |
| `instance/agency/runtime/**` | Instance | Authoritative only when overlay-bound | Repo-specific agency runtime overlays |
| `instance/assurance/runtime/**` | Instance | Authoritative only when overlay-bound | Repo-specific assurance runtime overlays |
| repo-root `AGENTS.md` or tool-facing ingress files | Adapter surface | Non-canonical adapter | Thin adapter/projection into canonical internal ingress |

## 7. Authority and boundary implications

- `framework/**` remains the base authored authority.
- `instance/**` remains the repo-owned durable authority layer.
- Overlay-capable instance surfaces do **not** create a second authority system. They are legal only at framework-declared overlay points.
- `state/**` remains mutable operational truth and retained evidence only.
- `generated/**` remains rebuildable and non-authoritative.
- `inputs/**` remains raw non-authoritative input only.
- Canonical ingress belongs under `instance/ingress/**`, not at repo root.
- Repo-root ingress files are projections/adapters only and must not introduce new policy or runtime semantics.
- Overlay points are opt-in and bounded. There is no blanket shadowing of `framework/**` by `instance/**`.

## 8. Ratified overlay and ingress model

### 8.1 Instance-native versus overlay-capable surfaces

#### Instance-native surfaces

These are repo-owned authoritative surfaces that do **not** rely on framework overlay semantics:

- `instance/manifest.yml`
- `instance/ingress/**`
- `instance/bootstrap/**`
- `instance/locality/**`
- `instance/cognition/context/**`
- `instance/cognition/decisions/**`
- `instance/capabilities/runtime/**`
- `instance/orchestration/missions/**`
- `instance/extensions.yml`

#### Overlay-capable surfaces

These are repo-owned authoritative surfaces that are legal only when backed by a declared overlay point:

- `instance/governance/policies/**`
- `instance/governance/contracts/**`
- `instance/agency/runtime/**`
- `instance/assurance/runtime/**`

Any future overlay-capable surface must be added through the framework overlay registry first. Teams may not invent additional overlay-capable subtrees ad hoc.

### 8.2 Canonical overlay registry

Canonical registry location:

```text
framework/overlay-points/registry.yml
```

Each registry entry must declare at least:

- `overlay_point_id`
- `owning_domain`
- `instance_glob`
- `merge_mode`
- `validator`
- `precedence`
- optional `artifact_kinds`

### 8.3 Allowed v1 merge modes

Only these merge modes are valid in v1:

- `replace_by_path`
- `merge_by_id`
- `append_only`

Any other merge mode is invalid.

### 8.4 Ratified v1 overlay points

| Overlay point id | Owning domain | Instance glob | Merge mode | Precedence | Artifact kinds |
|---|---|---|---|---:|---|
| `instance-governance-policies` | governance | `.octon/instance/governance/policies/**` | `replace_by_path` | 10 | `policy` |
| `instance-governance-contracts` | governance | `.octon/instance/governance/contracts/**` | `replace_by_path` | 20 | `contract` |
| `instance-agency-runtime` | agency | `.octon/instance/agency/runtime/**` | `merge_by_id` | 30 | `runtime` |
| `instance-assurance-runtime` | assurance | `.octon/instance/assurance/runtime/**` | `append_only` | 40 | `runtime` |

### 8.5 Repo-side enablement

Repo-side enablement lives in:

```text
instance/manifest.yml
```

Required field:

- `enabled_overlay_points`

Only overlay points listed there may participate in resolution for this repo instance.

### 8.6 Canonical internal ingress and adapter rule

Canonical internal ingress lives at:

```text
instance/ingress/AGENTS.md
```

Repo-root adapter files such as repo-root `AGENTS.md` may exist, but they are limited to one or more of:

- link/redirect to canonical internal ingress
- generated projection of canonical internal ingress
- thin tool-host adapter that preserves canonical read order

They may **not**:

- introduce new runtime or policy authority
- override canonical ingress content
- become the sole source of ingress truth

## 9. Overlay resolution and enforcement model

Overlay resolution is:

1. load `framework/manifest.yml`
2. load `framework/overlay-points/registry.yml`
3. load `instance/manifest.yml`
4. verify `enabled_overlay_points` are a subset of declared overlay points
5. collect instance overlay artifacts only from declared `instance_glob` paths
6. apply validator and merge mode for each enabled point
7. publish the resolved authoritative overlay result into the active runtime view

### Wrong-placement rule

If an overlay-looking artifact exists in an overlay-capable subtree but:

- no matching overlay point exists, or
- the point exists but is not enabled, or
- the merge mode is invalid, or
- the validator fails,

then the artifact is invalid and must fail closed.

## 10. Validation, assurance, and fail-closed implications

Validation must enforce all of the following:

- `framework/overlay-points/registry.yml` is schema-valid
- every `enabled_overlay_point` in `instance/manifest.yml` exists in the registry
- only allowed merge modes appear in the registry
- overlay artifacts stay inside declared `instance_glob` boundaries
- overlay-capable instance artifacts do not appear outside enabled overlay points
- canonical internal ingress exists under `instance/ingress/**`
- repo-root ingress adapters remain non-authoritative adapters only
- no runtime or policy surface depends on raw `inputs/**`
- overlay-capable artifacts do not target forbidden framework domains such as `framework/engine/runtime/**`

Failure behavior:

- invalid overlay registry: global fail-closed
- invalid enabled overlay configuration: fail closed for the affected repo instance behavior
- invalid overlay artifact: fail closed for the affected overlay point
- invalid repo-root ingress adapter: block adapter generation/use, but do not move canonical ingress authority away from `instance/ingress/**`

## 11. Portability, compatibility, and update implications

- `framework/overlay-points/registry.yml` is portable with the framework bundle.
- `instance/manifest.yml` and overlay-capable repo artifacts are repo-specific by default.
- Canonical internal ingress under `instance/ingress/**` is repo-specific and included in `repo_snapshot`.
- Overlay enablement is preserved across framework updates unless an explicit migration contract says otherwise.
- Framework updates may change available overlay points only through explicit schema/version/migration handling.
- Repo-root ingress adapters are scaffolds/adapters and may be regenerated as needed from canonical internal ingress.

## 12. Migration and rollout implications

### Migration work authorized by this packet

- ratify `framework/overlay-points/registry.yml` as the canonical overlay registry
- ratify `instance/manifest.yml#enabled_overlay_points` as the repo-side overlay enablement list
- move or alias canonical ingress into `instance/ingress/**`
- move repo-local governance, agency, and assurance overlays into canonical instance overlay-capable paths
- remove ad hoc or legacy overlay-like paths not covered by the registry
- convert repo-root ingress artifacts into thin adapters if they are not already thin adapters
- prepare later packets to rely on machine-enforced overlay semantics instead of prose-only conventions

### Important sequencing rules

Packet 5 must land before:

- Packet 6 locality and scope ratification can rely on stable repo-owned ingress and overlay boundaries
- Packet 8 extension desired/actual/quarantine ratification can rely on the final overlay/governance contract
- Packet 14 validation/fail-closed ratification can treat overlay-point enforcement as a first-class rule
- Packet 15 migration and rollout can remove legacy ingress or overlay-like mixed paths safely

## 13. Dependencies and suggested implementation order

- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture
- **Suggested implementation order:** 5
- **Blocks:** locality finalization, extension/control-plane enforcement, validation/quarantine finalization, and migration cleanup of legacy ingress or overlay paths

## 14. Acceptance criteria

- Overlay-capable instance surfaces are explicitly distinguished from instance-native surfaces.
- `framework/overlay-points/registry.yml` is ratified as the canonical overlay registry.
- `instance/manifest.yml#enabled_overlay_points` is ratified as the repo-side enablement contract.
- The canonical v1 overlay points, instance globs, merge modes, and precedence values are explicitly listed.
- The allowed v1 merge modes are explicitly bounded to `replace_by_path`, `merge_by_id`, and `append_only`.
- Canonical internal ingress is explicitly located under `instance/ingress/**`.
- Repo-root ingress files are explicitly defined as thin adapters only.
- Undeclared overlay artifacts fail closed.
- Overlay-capable instance artifacts cannot target forbidden framework surfaces.
- Teams no longer need to infer where repo-local governance/agency/assurance overlays belong.

## 15. Supporting evidence to reference

- Current `/.octon/README.md` — class-first Super-Root contract and canonical ingress references
- Current `/.octon/framework/overlay-points/registry.yml` — live overlay registry entries and merge modes
- Current `/.octon/instance/manifest.yml` — live instance-side overlay enablement
- Current `/.octon/instance/ingress/AGENTS.md` — canonical internal ingress
- Current `/.octon/octon.yml` — class roots, profiles, release/API version keys
- Ratified Super-Root blueprint — sections on instance architecture, overlay and ingress model, portability, and validation

Reference URLs:

- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/README.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/octon.yml>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/overlay-points/registry.yml>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/manifest.yml>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/ingress/AGENTS.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/extensions.yml>

## 16. Settled decisions that must not be re-litigated

- The Super-Root remains five-class.
- `framework/**` and `instance/**` remain the authored authority classes.
- Raw packs and raw proposals do not belong in `instance/**`.
- Overlay-capable instance surfaces are legal only at declared framework overlay points.
- There is no blanket shadow-tree model for `instance/**`.
- Canonical internal ingress lives under `instance/ingress/**`.
- Repo-root ingress files are adapters only.
- Descendant-local `.octon/` roots remain rejected.
- Raw `inputs/**` paths remain forbidden as direct runtime or policy dependencies.

## 17. Remaining narrow open questions

None. This packet is ratified for proposal drafting and ready to move into formal architecture proposal authoring.
