# Implementation Plan

This proposal does not invent a second authority system. It ratifies and
hardens the overlay and ingress direction already present in the live
repository so later packets can build on bounded, machine-enforceable rules.

## Workstream 1: Lock The Framework Overlay Declaration Surface

- Keep `.octon/framework/manifest.yml` bound to
  `.octon/framework/overlay-points/registry.yml`.
- Normalize the overlay registry schema so every point declares the required
  fields and only supported merge modes.
- Keep overlay precedence explicit in the registry rather than inferred from
  file order or placement.
- Reject any attempt to declare overlay points outside repo-instance space or
  inside forbidden framework domains.

## Workstream 2: Lock Repo-Side Enablement And Placement

- Keep `instance/manifest.yml#enabled_overlay_points` as the only repo-side
  enablement list.
- Normalize the four v1 overlay-capable instance paths:
  `instance/governance/policies/**`,
  `instance/governance/contracts/**`,
  `instance/agency/runtime/**`, and
  `instance/assurance/runtime/**`.
- Remove or quarantine any ad hoc overlay-like path not covered by the
  framework registry.
- Keep the remainder of `instance/**` instance-native and outside overlay
  semantics.

## Workstream 3: Lock Canonical Internal Ingress And Root Adapters

- Keep canonical authored ingress under `instance/ingress/AGENTS.md`.
- Preserve `AGENTS.md`, `CLAUDE.md`, and `/.octon/AGENTS.md` as thin adapters
  that redirect or project canonical ingress only.
- Remove any root-ingress behavior that introduces new policy or runtime
  authority.
- Ensure tool-host read order continues to resolve through canonical internal
  ingress.

## Workstream 4: Enforce Resolution And Fail-Closed Validation

- Keep overlay resolution deterministic: framework manifest, overlay registry,
  instance manifest, enabled point verification, artifact collection,
  validation, merge, and publication.
- Extend assurance so invalid registry schema, undeclared enablement,
  unsupported merge modes, wrong-placement artifacts, and forbidden overlay
  domains fail closed.
- Keep overlay validation wired into `alignment-check.sh`.
- Keep repo-instance boundary validation aware of enabled overlay roots and
  canonical ingress placement.

## Workstream 5: Align Docs, Portability, And Update Semantics

- Rewrite `.octon/README.md`,
  `.octon/framework/cognition/_meta/architecture/specification.md`, and
  `.octon/framework/cognition/_meta/architecture/shared-foundation.md` so they
  all describe the same overlay and ingress model.
- Keep `repo_snapshot` behavior aligned to the rule that canonical internal
  ingress and enabled overlay artifacts travel with `instance/**`.
- Keep framework update and migration flows from silently dropping
  `enabled_overlay_points` or canonical ingress.
- Document that repo-root adapters are scaffolds that can be regenerated from
  canonical ingress without changing authority.

## Workstream 6: Prepare Downstream Packet Work

- Give Packet 6 a stable ingress and overlay boundary before locality expands.
- Give Packet 8 a stable governance and assurance overlay contract before
  extension control-plane rules land.
- Give Packet 14 a concrete validator-owned overlay fail-closed model.
- Give Packet 15 explicit migration and cleanup rules for legacy ingress or
  overlay-like mixed paths.

## Downstream Dependency Impact

This proposal is a prerequisite for:

- locality and scope registry
- inputs/additive/extensions architecture
- unified validation, fail-closed, quarantine, and staleness semantics
- migration and rollout cleanup of legacy ingress and overlay-like paths

## Exit Condition

This proposal is complete only when the durable `.octon/` control plane,
ingress adapters, validators, and architecture references all agree that
overlay-capable repo authority is legal only at declared enabled overlay points
and that canonical ingress authority lives under `instance/ingress/**`.
