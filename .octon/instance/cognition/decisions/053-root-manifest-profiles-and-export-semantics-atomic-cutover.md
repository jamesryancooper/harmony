# ADR 053: Root Manifest, Profiles, And Export Semantics Atomic Cutover

- Date: 2026-03-20
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/root-manifest-profiles-and-export-semantics/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-20-root-manifest-profiles-and-export-semantics-cutover/plan.md`
  - `/.octon/octon.yml`

## Context

Packet 2 defines the root manifest and profile contract that the super-root
 depends on, but the live repo lacked one explicit closeout record tying the
 final `octon.yml` profile behavior, companion manifests, and fail-closed
 export rules back to the proposal package.

That left Packet 2 in a completed-but-not-closed state: the contract was live,
 but the proposal had no dedicated archival receipt comparable to the later
 packet cutovers.

## Decision

Record Packet 2 as complete and archive the proposal.

Rules:

1. `/.octon/octon.yml` is the authoritative root manifest.
2. `bootstrap_core`, `repo_snapshot`, `pack_bundle`, and `full_fidelity`
   remain the only v1 profile set.
3. `repo_snapshot` remains behaviorally complete and fail-closed for enabled
   pack closure.
4. Companion manifest expectations for `framework/manifest.yml` and
   `instance/manifest.yml` are treated as part of the landed Packet 2
   contract.
5. The proposal package moves to `.archive/**` with an `implemented`
   disposition.

## Consequences

### Benefits

- Packet 2 now has explicit implementation closeout evidence.
- Proposal lifecycle state now matches the live root-manifest contract.

### Costs

- Adds a retrospective closeout ADR and migration bundle after the durable
  implementation already landed.

### Follow-on Work

1. Future root-manifest revisions should promote directly against the durable
   `octon.yml` and companion manifest surfaces.
2. Packet 13 can refine portability/trust semantics without keeping Packet 2
   active as a temporary authority.
