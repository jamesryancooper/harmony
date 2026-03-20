# ADR 052: Inputs/Exploratory/Proposals Atomic Cutover

- Date: 2026-03-20
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/architecture/inputs-exploratory-proposals/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-20-inputs-exploratory-proposals-cutover/plan.md`
  - `/.octon/framework/cognition/_meta/architecture/specification.md`

## Context

Packet 9 formalizes the integrated exploratory proposal workspace, but the
live repository still carried one final round of contract drift:

1. architecture proposal packages used numbered directory prefixes even though
   their manifest ids and generic proposal standards assumed
   `<kind>/<proposal_id>/`,
2. proposal standards, validators, templates, registry paths, and workflow
   fixtures did not all enforce the same path and authority model,
3. the archived extension sidecar proposal did not yet carry final archive
   metadata even though the registry already treated it as archived, and
4. the engine runtime launchers could recreate build state under
   `framework/engine/_ops/state/**`, which violated the Packet 3 framework
   boundary while running Packet 9 proposal workflow tests.

That left one final proposal-workspace risk: the repo had the right target
topology on paper, but path naming, validator behavior, archive metadata, and
runtime build-state placement could still drift in incompatible ways.

## Decision

Promote Packet 9 as one atomic clean-break cutover.

Rules:

1. Architecture proposal package directories must match `proposal_id`
   exactly. Numbered packet prefixes are retired.
2. Proposal lifecycle authority order is
   `proposal.yml` > subtype manifest >
   `generated/proposals/registry.yml` > `README.md`.
3. Proposal validators must accept absolute and repo-root-relative package
   paths consistently.
4. The generated proposal registry remains committed discovery only. It does
   not become lifecycle authority.
5. Archived proposal packages must carry final archive metadata, including
   explicit disposition.
6. The engine runtime source-build cache must live under
   `generated/.tmp/engine/build/runtime-crates-target`, never under
   `framework/**/_ops/state/**`.
7. No compatibility aliases, numbered-path shims, or dual old/new proposal
   roots are allowed after promotion.
8. Rollback is full-revert-only for the cutover change set.

## Consequences

### Benefits

- The proposal workspace, registry, validators, templates, and workflow
  runners now enforce one path model.
- Historical and active references agree on the same unnumbered proposal
  roots.
- The framework boundary gate no longer conflicts with normal proposal
  workflow execution.

### Costs

- Large one-shot rename and historical-reference rewrite across proposal
  packages, ADRs, migration evidence, and continuity records.
- Reduced flexibility for partial rollback or transitional naming.

### Follow-on Work

1. Packet 10 can rely on the final generated proposal-registry placement and
   non-authority contract without re-litigating proposal path layout.
2. Packet 14 can treat proposal validation as workflow-local while preserving
   fail-closed runtime isolation from proposal paths.
3. Future proposal authoring can use the generic unnumbered
   `<kind>/<proposal_id>/` model without Packet-series exceptions.
