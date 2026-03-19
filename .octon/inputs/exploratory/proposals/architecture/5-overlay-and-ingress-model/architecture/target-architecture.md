# Target Architecture

## Decision

Ratify the repo-instance overlay and ingress contract inside the class-first
super-root.

The promoted overlay and ingress contract requires:

- overlay-capable repo-local surfaces to live only under bounded subtrees of
  `instance/**`
- `framework/manifest.yml` to bind
  `framework/overlay-points/registry.yml` as the canonical overlay registry
- `instance/manifest.yml#enabled_overlay_points` to be the canonical repo-side
  enablement surface
- `instance/ingress/AGENTS.md` to remain the canonical internal ingress
  surface
- repo-root `AGENTS.md`, `CLAUDE.md`, and `/.octon/AGENTS.md` to remain thin
  adapters, projections, or scaffolds only
- v1 overlay points to allow only `replace_by_path`, `merge_by_id`, and
  `append_only`
- undeclared, disabled, malformed, or wrong-placement overlay artifacts to
  fail closed
- overlay precedence to remain bounded to declared overlay points only, with no
  blanket shadowing of `framework/**`
- closed framework domains such as `framework/engine/runtime/**` to remain
  non-overlayable

This proposal finishes the repo-instance boundary ratified by Packet 4 by
separating instance-native authority from overlay-capable authority while
locking canonical ingress into `instance/ingress/**`.

## Status

- status: accepted proposal drafted from ratified Packet 5 inputs
- proposal area: repo-instance overlays, canonical internal ingress,
  overlay-point declaration, merge-mode enforcement, host-facing ingress
  adapters, and fail-closed validation
- implementation order: 5 of 15 in the ratified proposal sequence
- dependencies:
  - `super-root-semantics-and-taxonomy`
  - `root-manifest-profiles-and-export-semantics`
  - `framework-core-architecture`
  - `repo-instance-architecture`
- migration role: completes the repo-instance boundary so locality, state,
  extensions, validation, and migration cutovers can depend on explicit
  overlay semantics instead of prose-only conventions

## Why This Proposal Exists

Packet 4 ratified `instance/**` as the canonical repo-owned durable authority
layer. The remaining material gap was that repo-local overlays and internal
ingress were still under-specified at the machine-enforceable contract level.
The live repository already points at the intended solution, but later packets
cannot safely build on it until placement, enablement, precedence, merge
behavior, and adapter rules are made explicit.

The live repository has already moved materially toward this target:

- `.octon/framework/manifest.yml` already binds
  `.octon/framework/overlay-points/registry.yml`.
- `.octon/framework/overlay-points/registry.yml` already declares governance,
  agency, and assurance overlay points with validator paths and merge modes.
- `.octon/instance/manifest.yml` already enables those overlay points through
  `enabled_overlay_points`.
- `.octon/instance/ingress/AGENTS.md` already exists as the canonical internal
  ingress surface.
- `AGENTS.md`, `CLAUDE.md`, and `/.octon/AGENTS.md` already behave as thin
  redirects into canonical internal ingress.
- `.octon/framework/assurance/runtime/_ops/scripts/validate-overlay-points.sh`
  already enforces core overlay registry and enablement rules.

### Current Live Signals This Proposal Must Normalize

| Current live signal | Current live source | Ratified implication |
| --- | --- | --- |
| Framework already binds the overlay registry | `.octon/framework/manifest.yml` | Packet 5 must ratify the registry as the framework-owned declaration surface rather than treating it as optional metadata |
| The registry already declares governance, agency, and assurance instance globs | `.octon/framework/overlay-points/registry.yml` | Packet 5 must list the canonical overlay points, merge modes, validators, and precedence values explicitly |
| The instance manifest already enables overlay points | `.octon/instance/manifest.yml` | Packet 5 must define how `enabled_overlay_points` participates in resolution and fail-closed validation |
| Canonical internal ingress already lives under instance | `.octon/instance/ingress/AGENTS.md` | Packet 5 must ratify internal ingress placement and keep root adapters thin only |
| Root-facing ingress files already forward into instance ingress | `AGENTS.md`, `CLAUDE.md`, `.octon/AGENTS.md` | Packet 5 must define repo-root ingress files as adapters rather than separate authority surfaces |
| Overlay validation already exists in assurance runtime | `.octon/framework/assurance/runtime/_ops/scripts/validate-overlay-points.sh` | Packet 5 must document wrong-placement, merge-mode, and undeclared-enablement failures as fail-closed behavior |

## Problem Statement

Octon needs a final overlay and ingress model that is:

- machine-enforceable
- explicit about canonical ingress location
- explicit about precedence and merge behavior
- safe under framework updates
- compatible with the five-class super-root
- compatible with Git review, CODEOWNERS, and validator-driven enforcement
- small enough to implement without creating a second authority system

Without a ratified Packet 5 contract, teams would continue inferring overlay
legality and ingress authority from file placement alone, which is too weak for
governance, upgrade safety, and deterministic runtime behavior.

## Scope

- define the final placement of overlay-capable repo-instance surfaces
- define the final placement of canonical internal ingress
- distinguish instance-native surfaces from overlay-capable surfaces
- ratify the overlay registry and repo-side enablement model
- define allowed v1 merge modes and precedence semantics
- define adapter rules for repo-root ingress files
- define validator expectations and wrong-placement failure behavior
- provide the machine-enforceable boundary that later packets depend on

## Non-Goals

- re-litigating the five-class super-root
- re-litigating integrated `inputs/**` placement
- creating a blanket shadow-tree model for all of `instance/**`
- designing a general-purpose plugin or user-customization API beyond declared
  overlay points
- replacing framework authority with repo-local governance supremacy
- detailed locality schema work owned by Packet 6
- detailed extension desired/actual/quarantine pipeline work owned by Packet 8
- detailed generated-output schema work owned by Packet 10

## Overlay And Ingress Contract

### Canonical Control Surfaces

| Path | Role | Authority status |
| --- | --- | --- |
| `framework/manifest.yml` | Framework binding for the overlay registry | Authoritative control metadata |
| `framework/overlay-points/registry.yml` | Declares legal repo-instance overlay points, merge modes, validators, and precedence | Authoritative authored |
| `instance/manifest.yml` | Enables the declared overlay points for this repo instance | Authoritative control metadata |
| `instance/ingress/AGENTS.md` | Canonical internal ingress for this repository's harness | Authoritative authored |
| `instance/governance/policies/**` | Repo-specific governance policy overlays | Authoritative only when overlay-bound |
| `instance/governance/contracts/**` | Repo-specific governance contract overlays | Authoritative only when overlay-bound |
| `instance/agency/runtime/**` | Repo-specific agency runtime overlays | Authoritative only when overlay-bound |
| `instance/assurance/runtime/**` | Repo-specific assurance runtime overlays | Authoritative only when overlay-bound |
| `AGENTS.md`, `CLAUDE.md`, `/.octon/AGENTS.md` | Host-facing ingress adapters | Non-canonical adapter surfaces |

### Instance-Native Versus Overlay-Capable Surfaces

#### Instance-Native Surfaces

These repo-owned authoritative surfaces do not rely on framework overlay
semantics:

- `instance/manifest.yml`
- `instance/ingress/**`
- `instance/bootstrap/**`
- `instance/locality/**`
- `instance/cognition/context/**`
- `instance/cognition/decisions/**`
- `instance/capabilities/runtime/**`
- `instance/orchestration/missions/**`
- `instance/extensions.yml`

#### Overlay-Capable Surfaces

These repo-owned authoritative surfaces are legal only when the framework
declares an overlay point and the instance manifest enables it:

- `instance/governance/policies/**`
- `instance/governance/contracts/**`
- `instance/agency/runtime/**`
- `instance/assurance/runtime/**`

Any future overlay-capable surface must be added through the framework overlay
registry first. Teams may not invent new overlay-capable subtrees ad hoc.

### Required Overlay Registry Fields

Each `framework/overlay-points/registry.yml` entry must declare at least:

- `overlay_point_id`
- `owning_domain`
- `instance_glob`
- `merge_mode`
- `validator`
- `precedence`
- optional `artifact_kinds`

### Allowed V1 Merge Modes

Only these merge modes are valid in v1:

- `replace_by_path`
- `merge_by_id`
- `append_only`

Any other merge mode is invalid.

### Ratified V1 Overlay Points

| Overlay point id | Owning domain | Instance glob | Merge mode | Precedence | Artifact kinds |
| --- | --- | --- | --- | ---: | --- |
| `instance-governance-policies` | `governance` | `.octon/instance/governance/policies/**` | `replace_by_path` | 10 | `policy` |
| `instance-governance-contracts` | `governance` | `.octon/instance/governance/contracts/**` | `replace_by_path` | 20 | `contract` |
| `instance-agency-runtime` | `agency` | `.octon/instance/agency/runtime/**` | `merge_by_id` | 30 | `runtime` |
| `instance-assurance-runtime` | `assurance` | `.octon/instance/assurance/runtime/**` | `append_only` | 40 | `runtime` |

### Canonical Internal Ingress And Adapter Rule

Canonical internal ingress lives at:

```text
instance/ingress/AGENTS.md
```

Repo-root and host-facing ingress files may exist, but they are limited to one
or more of:

- link or redirect to canonical internal ingress
- generated projection of canonical internal ingress
- thin tool-host adapter that preserves canonical read order

They may not:

- introduce new runtime or policy authority
- override canonical ingress content
- become the sole source of ingress truth

### Overlay Resolution And Precedence

Overlay resolution is:

1. load `framework/manifest.yml`
2. load `framework/overlay-points/registry.yml`
3. load `instance/manifest.yml`
4. verify `enabled_overlay_points` are a subset of declared overlay points
5. collect instance overlay artifacts only from declared `instance_glob` paths
6. apply the validator and merge mode for each enabled point
7. publish the resolved authoritative overlay result into the active runtime
   view

Within a declared overlay point:

- `replace_by_path`: instance content replaces the framework artifact at that
  overlay point
- `merge_by_id`: instance content merges into keyed framework sets
- `append_only`: instance content appends to the framework register

Outside declared overlay points, framework wins and instance overlay content is
invalid.

### Validation And Fail-Closed Behavior

Validation must enforce all of the following:

- the overlay registry is schema-valid
- every `enabled_overlay_point` exists in the registry
- only allowed merge modes appear in the registry
- overlay artifacts stay inside declared `instance_glob` boundaries
- overlay-capable instance artifacts do not appear outside enabled overlay
  points
- canonical internal ingress exists under `instance/ingress/**`
- repo-root ingress adapters remain non-authoritative adapters only
- no runtime or policy surface depends on raw `inputs/**`
- overlay-capable artifacts do not target forbidden framework domains such as
  `framework/engine/runtime/**`

Failure behavior is fail closed:

- invalid overlay registry: global fail closed
- invalid enabled overlay configuration: fail closed for the affected repo
  instance behavior
- invalid overlay artifact: fail closed for the affected overlay point
- invalid repo-root ingress adapter: block adapter generation or use without
  moving authority away from `instance/ingress/**`

## Portability, Update, And Migration Implications

- `framework/overlay-points/registry.yml` travels with the framework bundle.
- `instance/manifest.yml` and repo overlay artifacts remain repo-specific by
  default.
- Canonical internal ingress under `instance/ingress/**` is repo-specific and
  therefore included in `repo_snapshot`.
- Overlay enablement is preserved across framework updates unless an explicit
  migration contract says otherwise.
- Framework updates may add or remove overlay points only through explicit
  schema, version, and migration handling.
- Repo-root ingress adapters are scaffolds and may be regenerated from
  canonical internal ingress as needed.

## Downstream Contract Impact

This proposal is the dependency boundary that later packets inherit:

- Packet 6 can define locality without reopening ingress authority or overlay
  placement.
- Packet 8 can rely on a stable governance and overlay contract when defining
  desired, actual, quarantine, and compiled extension behavior.
- Packet 14 can treat overlay-point validation as a first-class fail-closed
  rule rather than an implicit convention.
- Packet 15 can remove legacy ingress or mixed overlay paths without risking a
  second authority surface.
