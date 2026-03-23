# Implementation Plan

This proposal should land as one big-bang, clear-break, atomic promotion.
The five gaps it addresses all sit on the same trust boundary: the repo's own
self-audit, protected CI workflows, and runtime release surface.
Allowing old and new models to coexist would create false-green paths and
undercut the point of the hardening work.

The authoritative execution record for this cutover belongs in:

`/.octon/instance/cognition/context/shared/migrations/2026-03-23-self-audit-and-release-hardening-cutover/plan.md`

This proposal-local plan mirrors that atomic shape so the package remains
self-contained until archive.

## Profile Selection Receipt

- Date: 2026-03-23
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.5`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because this is an
    internal harness control-plane hardening change
  - external consumer coordination ability: not required; affected surfaces
    are repo-local validators, workflows, launcher scripts, manifests, and
    docs
  - data migration/backfill needs: none beyond writing the new truth surfaces,
    tests, and proposal closeout records
  - rollback mechanism: full revert of the cutover change set
  - blast radius and uncertainty: medium-high; alignment dispatch, safety
    gating, dependency hygiene, workflow trust refs, runtime packaging, tests,
    docs, and proposal lifecycle state all change together
  - compliance/policy constraints: fail closed on retired root references,
    authoritative-doc blind spots, missing Cargo review coverage, mutable
    third-party Action refs in high-trust workflows, or runtime target drift
    masked by source fallback
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no data backfill requirement
- Tie-break status: `atomic` selected without exception

## Atomic Execution Model

- land the full hardening set in one branch and promote only after the
  final-state validators are green
- do not stage advisory-only validators, duplicate truth surfaces, or mixed
  pinned/unpinned workflow policy
- update durable truth surfaces, executable adapters, tests, docs, and proposal
  closeout records in the same promotion window
- use rollback only as a full revert of the cutover change set

## Workstream 1: Declare The Durable Truth Surfaces

- add `/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`
- extend `/.octon/framework/cognition/_meta/architecture/contract-registry.yml`
  with authority-aware Markdown classification and safety-trigger classes
- add `/.octon/framework/assurance/runtime/contracts/github-action-pin-policy.yml`
- add `/.octon/framework/engine/runtime/release-targets.yml`
- keep each executable consumer as an adapter to these surfaces, not a second
  declaration point

## Workstream 2: Rewire Self-Audit And Safety Entry Points

- make `/.octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh`
  a thin registry-backed runner with shared CLI/profile discovery for local and
  CI use
- update `.github/workflows/alignment-check.yml` and local validation docs to
  consume the same profile ids and fail when the registry is invalid
- replace the blanket Markdown ignore in
  `.github/workflows/main-push-safety.yml` with change classification driven by
  the doc-authority contract
- keep narrative-only Markdown cheap, but ensure authoritative architecture,
  governance, bootstrap, and receipt-defining docs enter the safety envelope

## Workstream 3: Harden Dependency And Workflow Trust Surfaces

- extend `.github/dependabot.yml` to cover `cargo` for
  `/.octon/framework/engine/runtime/crates`
- add `.github/workflows/dependency-review.yml` so manifest and lockfile
  changes have a named gate
- pin all third-party actions in the high-trust workflow set to full commit
  SHAs:
  - `.github/workflows/ai-review-gate.yml`
  - `.github/workflows/harness-self-containment.yml`
  - `.github/workflows/main-push-safety.yml`
  - `.github/workflows/release-please.yml`
  - `.github/workflows/runtime-binaries.yml`
  - `.github/workflows/pr-autonomy-policy.yml`
  - `.github/workflows/main-pr-first-guard.yml`
- treat the pin policy as blocking in the same promotion that rewrites the
  workflow refs

## Workstream 4: Unify Runtime Target Truth And Strict Packaging

- add `/.octon/framework/engine/runtime/release-targets.yml` with explicit
  `local_launchable` and `shippable_release` fields
- update `/.octon/framework/engine/runtime/run`,
  `/.octon/framework/engine/runtime/run.cmd`, and
  `.github/workflows/runtime-binaries.yml` to consume or validate against the
  same target ids, binary names, and packaging expectations
- add strict packaging mode for CI and release paths so missing packaged
  artifacts fail before source fallback
- keep local source fallback only where the target matrix explicitly allows it
  and strict mode is off

## Workstream 5: Add Blocking Validators And Final-State Regressions

- add
  `/.octon/framework/assurance/runtime/_ops/scripts/validate-alignment-profile-registry.sh`
- add
  `/.octon/framework/assurance/runtime/_ops/scripts/classify-authoritative-doc-change.sh`
- add
  `/.octon/framework/assurance/runtime/_ops/scripts/validate-authoritative-doc-triggers.sh`
- add
  `/.octon/framework/assurance/runtime/_ops/scripts/validate-github-action-pins.sh`
- add
  `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-target-parity.sh`
- add focused shell regressions for each new validator family plus an
  end-to-end harness alignment run
- wire the validators into harness, self-containment, and workflow gates as
  blocking checks on first promotion
- do not use an advisory-first stage; existing drift should be corrected on the
  same branch before merge

## Cutover Sequence

1. Add the new contract files and validator/test scaffolding.
2. Rewrite the existing shell and workflow consumers to the new contract
   surfaces.
3. Repair all live drift: stale roots, blanket Markdown ignore, missing Cargo
   hygiene, mutable workflow refs, and launcher/release target mismatch.
4. Make the new validators blocking in the same branch and prove the final
   state passes.
5. Update durable docs, record migration/ADR evidence, archive the proposal,
   and refresh `/.octon/generated/proposals/registry.yml`.

## Impact Map (Code, Tests, Docs, Contracts)

### Code

- assurance runtime contract registries and validator scripts
- GitHub workflow triggers, dependency review, immutable action refs, and
  release automation
- runtime launcher scripts and release target matrix
- proposal registry and proposal lifecycle records at closeout

### Tests

- `test-alignment-profile-registry.sh`
- `test-validate-authoritative-doc-triggers.sh`
- `test-validate-github-action-pins.sh`
- `test-validate-runtime-target-parity.sh`
- `alignment-check.sh --profile harness`
- targeted workflow/path-filter and dependency-hygiene smoke coverage as needed

### Docs

- proposal README plus implementation and validation plans
- local validation guidance that names alignment profile ids
- runtime/release docs touched by the target matrix and strict packaging mode
- ADR and migration evidence bundle

### Contracts

- alignment profile registry contract
- architecture contract registry doc-authority extension
- GitHub Action pin policy contract
- runtime release target matrix contract

## Rollback Guidance

- rollback by reverting the full cutover change set
- do not keep the new blocking validators while restoring the old dispersed
  truth model
- do not reintroduce retired roots, blanket Markdown ignores, mutable
  third-party Action refs, or split runtime target truth as a partial rollback
