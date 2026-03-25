# Implementation Plan

This proposal should land as one big-bang, clear-break, atomic promotion.
The remaining gaps all sit on the same trust boundary: proposal manifests,
proposal standards and schemas, the canonical registry writer, the live archive
corpus, and the ADR/evidence surfaces that claim those pieces are coherent.
Allowing the old and new models to coexist would preserve the exact ambiguity
this proposal is trying to eliminate.

The authoritative execution record for this cutover belongs in:

`/.octon/instance/cognition/context/shared/migrations/2026-03-24-proposal-system-integrity-and-archive-normalization-cutover/plan.md`

This proposal-local plan mirrors that atomic shape so the package remains
self-contained until promotion and archive.

## Profile Selection Receipt

- Date: 2026-03-24
- Version source(s): `/.octon/octon.yml`
- Current version: `0.6.0`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because this is a
    repo-local harness governance and validation change
  - external consumer coordination ability: not required; affected surfaces are
    internal standards, schemas, validators, workflow packages, workflow
    runners, committed proposal discovery, and proposal archive packets
  - data migration/backfill needs: bounded repo-local manifest rewrites,
    archive metadata repair, deterministic registry rebuild, and proposal
    closeout records only
  - rollback mechanism: full revert of the cutover change set plus registry
    regeneration from the reverted manifests
  - blast radius and uncertainty: medium-high; docs, schemas, shell
    validators, workflow runners, kernel workflow execution, archive packets,
    and the committed projection all change together
  - compliance/policy constraints: no dual registry writers, no mixed
    authoritative-versus-generated lifecycle model, no broken archive packets
    in the main projection, and no "complete" claim until the final-state gate
    is green
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no external migration coordination requirement
  - no large data backfill requirement beyond bounded archive normalization and
    registry regeneration
- Tie-break status: `atomic` selected without exception

## Atomic Execution Model

- land the full proposal-system convergence set on one integration branch and
  merge only after the final-state validators are green
- do not ship advisory-only registry checks, dual registry writers, mixed
  manual-versus-generated discovery behavior, or partial archive cleanup
- update durable docs, machine-readable contracts, executable validators,
  workflow packages, workflow runners, archive packets, and closeout records in
  the same promotion window
- keep the active proposal package in the active workspace during branch work
  and archive it only in the final closeout transaction
- use rollback only as a full revert of the cutover change set; no supported
  partial rollback keeps the new registry contract with the old archive or
  schema model

## Workstream 1: Ratify The Durable Proposal-System Contract

- update `/.octon/framework/scaffolding/governance/patterns/proposal-standard.md`
  so the shared contract reflects generated artifact inventory, manual
  source-of-truth maps, deterministic registry projection, and archive
  semantics without transitional wording
- update subtype standards:
  - `/.octon/framework/scaffolding/governance/patterns/architecture-proposal-standard.md`
  - `/.octon/framework/scaffolding/governance/patterns/migration-proposal-standard.md`
  - `/.octon/framework/scaffolding/governance/patterns/policy-proposal-standard.md`
- update operator-facing and architecture-facing guidance:
  - `/.octon/inputs/exploratory/proposals/README.md`
  - `/.octon/instance/bootstrap/START.md`
  - `/.octon/framework/cognition/_meta/architecture/specification.md`
  - `/.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md`
  - `/.octon/framework/cognition/_meta/architecture/generated/proposals/README.md`
- strengthen proposal template guidance so `navigation/source-of-truth-map.md`
  consistently describes external authorities, proposal-local precedence,
  derived projections, evidence roots, and boundary rules
- keep the promoted contract conservative: no new proposal kinds, no new active
  lifecycle states, no new long-lived proposal-local authorities

### Exit condition

Durable docs and standards describe one final proposal model with no staged or
competing interpretation of registry authority, archive semantics, or proposal
navigation.

## Workstream 2: Converge Schemas, Templates, And Validators

- update machine-readable schemas:
  - `/.octon/framework/scaffolding/runtime/templates/proposal.schema.json`
  - `/.octon/framework/scaffolding/runtime/templates/architecture-proposal.schema.json`
  - `/.octon/framework/scaffolding/runtime/templates/migration-proposal.schema.json`
  - `/.octon/framework/scaffolding/runtime/templates/policy-proposal.schema.json`
- update template manifests and generated navigation inputs so scaffolding emits
  the same field contract that validators and schemas accept:
  - `/.octon/framework/scaffolding/runtime/templates/proposal-core/**`
  - `/.octon/framework/scaffolding/runtime/templates/proposal-architecture-core/**`
  - `/.octon/framework/scaffolding/runtime/templates/proposal-migration-core/**`
  - `/.octon/framework/scaffolding/runtime/templates/proposal-policy-core/**`
- align shell validators and workflow validators with the promoted schema and
  template contract:
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-architecture-proposal.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-migration-proposal.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-policy-proposal.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-validate-proposal-workflow.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-promote-proposal-workflow.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-archive-proposal-workflow.sh`
- remove stale required keys and contract mismatches in one cut:
  - `architecture_kind`
  - `validation.plan_template_path` as the required migration contract
  - `policy_kind`
  - omission of `archive.disposition: superseded`

### Exit condition

Standards, scaffolding, schemas, and validators accept the same manifest shape
for base, architecture, migration, and policy proposals, with no machine
contract lagging the live template-plus-validator contract.

## Workstream 3: Make The Generator And Workflow Runners The Only Operational Path

- keep `/.octon/framework/assurance/runtime/_ops/scripts/generate-proposal-registry.sh`
  as the only canonical writer for
  `/.octon/generated/proposals/registry.yml`
- remove any remaining direct registry-mutation behavior from workflow runner
  logic and route proposal operations through deterministic regeneration:
  - `/.octon/framework/engine/runtime/crates/kernel/src/workflow.rs`
  - `/.octon/framework/engine/runtime/crates/kernel/src/pipeline.rs`
- tighten canonical workflow packages and stage docs so they all describe the
  same fail-closed execution model:
  - `/.octon/framework/orchestration/runtime/workflows/meta/validate-proposal/**`
  - `/.octon/framework/orchestration/runtime/workflows/meta/promote-proposal/**`
  - `/.octon/framework/orchestration/runtime/workflows/meta/archive-proposal/**`
  - `/.octon/framework/orchestration/runtime/workflows/meta/create-*-proposal/**`
  - `/.octon/framework/orchestration/runtime/workflows/manifest.yml`
  - `/.octon/framework/orchestration/runtime/workflows/registry.yml`
- ensure create, validate, promote, and archive operations all converge on the
  same operational guarantees:
  - validate proposal and subtype contract
  - validate or rebuild the committed registry projection
  - write retained workflow bundles under `state/evidence/runs/workflows/**`
  - reject promotion when proposal-path dependencies remain in durable targets
  - reject archive completion when archive metadata, archive path, or registry
    state is incoherent

### Exit condition

No supported workflow path writes proposal discovery except through the
canonical generator, and every proposal operation produces the same final-state
evidence shape and fail-closed behavior.

## Workstream 4: Normalize The Main Archive And Rebuild The Registry

- repair or exclude the bounded archive inventory in
  `resources/archive-normalization-inventory.md`
- close the audit-identified historical cases in the same branch:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/mission-scoped-reversible-autonomy/**`
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/self-audit-and-release-hardening/**`
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/harness-integrity-tightening/**`
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/capability-routing-host-integration/**`
- normalize or exclude archived design imports with `legacy-unknown` lineage so
  the main registry projects only standard-conformant packets
- regenerate `/.octon/generated/proposals/registry.yml` from manifests and
  commit only the generator-produced result
- ensure the final committed registry:
  - includes the archived
    `proposal-system-integrity-and-archive-normalization` packet when it
    qualifies for projection
  - excludes entries the canonical generator intentionally omits
  - contains no impossible lifecycle lineage values
  - resolves every projected entry to exactly one visible, validator-clean
    package
- if any historical packet cannot be normalized within the bounded branch
  scope, remove it from the main projection rather than shipping mixed steady
  state

### Exit condition

The main proposal archive is trustworthy enough to support fail-closed
projection, and the committed registry matches the canonical generator exactly.

## Workstream 5: Promote, Verify, And Close Out In One Transaction

- run the full final-state validation suite only after all contract, runner,
  archive, and registry changes are in place
- do not merge by weakening ADR or evidence language to fit incomplete repo
  state; finish the cleanup so the promoted claims become true
- update the authoritative migration plan and final closeout receipts only when
  the repo is generator-clean and validator-clean
- archive the active proposal package in the same closeout change set that
  lands the durable contract surfaces and rebuilt registry
- refresh proposal discovery after closeout so the archived implementing
  proposal appears in the same cutover that retires the active workspace copy

### Exit condition

Durable surfaces no longer depend on proposal-local guidance, the active
proposal package is retired, and the committed registry and archive corpus
reflect the same final state claimed by the cutover records.

## Cutover Sequence

1. Update durable standards, docs, and template guidance to the final proposal
   model.
2. Update schemas, scaffolding templates, and shell validators to the same
   contract.
3. Rewire workflow packages and kernel workflow runners to the generator-only
   operational path.
4. Repair the bounded archive inventory in working tree form.
5. Rebuild the committed proposal registry and clear reverse-drift findings.
6. Run the full final-state validation suite and fix any remaining mismatch on
   the same branch.
7. Record migration closeout, archive the implementing proposal package, and
   regenerate the registry one final time.
8. Merge or do not merge; there is no supported partial promotion state.

## Final-State Verification Gate

- `cargo check --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-proposal-standard.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-generate-proposal-registry.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-proposal-operation-workflows.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-proposal-operation-workflow-runners.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-validate-proposal-workflow.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-promote-proposal-workflow.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-archive-proposal-workflow.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --all-standard-proposals`
- `bash .octon/framework/assurance/runtime/_ops/scripts/generate-proposal-registry.sh --check`

The merge gate is simple: no merge until all of the above are green against the
same final tree.

## Impact Map (Code, Tests, Docs, Contracts)

### Code

- proposal generator, validators, and workflow-validation scripts
- workflow packages and workflow registry metadata
- kernel workflow runner and pipeline handling for proposal operations
- archived proposal packet manifests and navigation artifacts
- committed proposal registry and proposal closeout records

### Tests

- proposal standard validation regression suite
- registry-generation regression suite
- proposal-operation workflow validation suite
- proposal-operation workflow runner suite
- kernel compile check covering workflow-runner changes
- full-tree standard proposal validation at final state

### Docs

- proposal workspace README and subtype standards
- proposal scaffolding README files and source-of-truth templates
- bootstrap and umbrella architecture docs
- generated-proposals architecture docs
- proposal-local implementation and acceptance docs
- durable migration plan and final cutover records

### Contracts

- base proposal schema and archive semantics
- architecture, migration, and policy subtype schemas
- proposal template manifests and generated navigation contract
- deterministic proposal-registry projection contract
- archive lineage and promotion-evidence requirements

## Rollback Guidance

- rollback by reverting the full cutover change set
- regenerate `/.octon/generated/proposals/registry.yml` from the reverted
  manifests immediately after the revert
- restore the active proposal package only if the rollback also restores the
  pre-cutover durable contract surfaces
- do not keep a partially normalized archive, generator-only registry, or
  updated schema contract while reverting the rest of the model
