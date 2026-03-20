# ADR 057: Portability, Compatibility, Trust, And Provenance Atomic Cutover

- Date: 2026-03-20
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/portability-compatibility-trust-provenance/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-20-portability-compatibility-trust-provenance-cutover/plan.md`
  - `/.octon/framework/cognition/_meta/architecture/inputs/additive/extensions/schemas/extension-pack.schema.json`

## Context

Packet 13 formalizes the final portability and trust contract for the
super-root, but the live repo still enforced only the thinner Packet 8
`pack.yml` compatibility and provenance surface.

That left one final contract gap:

1. pack manifests did not yet expose the full Packet 13 provenance fields,
2. there was no explicit `required_contracts` compatibility gate for pack
   dependencies on current Octon contracts,
3. export and doc surfaces still described the right behavior without fully
   treating the pack contract as the normative machine-checked boundary, and
4. the active Packet 13 proposal had not yet been retired into archival
   evidence.

## Decision

Promote Packet 13 as one atomic clean-break cutover.

Rules:

1. `pack.yml` now uses `octon-extension-pack-v3`.
2. `pack.yml` must carry `compatibility.required_contracts`, even when empty.
3. `pack.yml` provenance must carry `source_id`, `imported_from`,
   `origin_uri`, `digest_sha256`, and `attestation_refs`.
4. `first_party_external` and `third_party` packs must declare at least one
   external provenance locator or digest.
5. Repo trust remains authored only in `instance/extensions.yml`.
6. `repo_snapshot` remains behaviorally complete and requires clean published
   enabled-pack state.
7. `pack_bundle` remains trust-agnostic raw additive transfer.
8. Root and companion manifest schema versions remain unchanged for this
   Packet 13 promotion.
9. The Packet 13 proposal package moves to `.archive/**` with an `implemented`
   disposition.

## Consequences

### Benefits

- Portability and trust semantics are now enforced by the same shared contract
  code that publication and export already depend on.
- Export, publication, and docs now agree on the repo-owned trust versus
  pack-authored provenance boundary.
- Packet 13 now has explicit cutover evidence and no longer remains an active
  temporary authority surface.

### Costs

- One broad sweep across pack manifests, validators, test fixtures, docs,
  generated outputs, and proposal lifecycle state.
- Harness verification in this environment required an escalated rerun of the
  host-projection refresh step during `alignment-check`.

### Follow-on Work

1. Packet 14 can treat the Packet 13 contract as the settled input for
   fail-closed publication and quarantine semantics.
2. Packet 15 can roll the Packet 13 cutover evidence directly into the final
   migration and rollout closeout sequence.
