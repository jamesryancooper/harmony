# Self-Audit And Release Hardening

This is a temporary, implementation-scoped architecture proposal for `self-audit-and-release-hardening`. It addresses five concrete hardening gaps in Octon's current self-audit and release chain:

1. stale super-root path references in the alignment dispatcher
2. safety-blind Markdown ignore rules
3. dependency update coverage that stops at GitHub Actions
4. mutable GitHub Action refs in high-trust workflows
5. a split truth between launcher expectations and published runtime binaries

It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Realign Octon's self-checks and release chain with the five-class super-root by eliminating validator path drift, classifying authoritative Markdown as safety-significant input, extending dependency/update hygiene beyond GitHub Actions, requiring immutable action pins for high-trust workflows, and making runtime target support explicit and machine-validated.

## Promotion Targets

- `.octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh`
- `.octon/framework/assurance/runtime/_ops/scripts/`
- `.octon/framework/assurance/runtime/_ops/tests/`
- `.octon/framework/assurance/runtime/contracts/`
- `.octon/framework/cognition/_meta/architecture/contract-registry.yml`
- `.github/workflows/main-push-safety.yml`
- `.github/workflows/alignment-check.yml`
- `.github/workflows/harness-self-containment.yml`
- `.github/workflows/ai-review-gate.yml`
- `.github/workflows/release-please.yml`
- `.github/workflows/runtime-binaries.yml`
- `.github/workflows/dependency-review.yml`
- `.github/dependabot.yml`
- `.octon/framework/engine/runtime/run`
- `.octon/framework/engine/runtime/run.cmd`
- `.octon/framework/engine/runtime/release-targets.yml`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/review-findings.md`
4. `navigation/source-of-truth-map.md`
5. `architecture/target-architecture.md`
6. `architecture/acceptance-criteria.md`
7. `architecture/implementation-plan.md`
8. `architecture/validation-plan.md`

## Supporting Resources

- `resources/review-findings.md` records the current gaps this proposal responds to in plain language and names the live files that exhibit each gap.
- `navigation/source-of-truth-map.md` shows the single durable truth surface proposed for each concern so Octon does not solve these issues with one-off edits only.
- `architecture/target-architecture.md` defines the end state and the new control families.
- `architecture/acceptance-criteria.md` defines what must be true before this proposal can be considered landed.
- `architecture/implementation-plan.md` defines the single-promotion atomic cutover plan and points at the authoritative migration plan path.
- `architecture/validation-plan.md` defines the local and CI checks that prove the hardening controls actually work.

## Exit Path

Promote the alignment profile registry, authoritative-document classification, multi-ecosystem dependency hygiene, immutable Action pinning, and runtime target parity validation into durable scripts, workflows, and runtime manifests. Archive this proposal once those controls are live, green, and no longer need proposal-local instructions.

## Registry

Add or update the matching entry in `/.octon/generated/proposals/registry.yml` when this proposal is created, archived, rejected, or materially reclassified. The registry is a committed discovery projection only.
