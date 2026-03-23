# ADR 062: Self-Audit And Release Hardening Atomic Cutover

- Date: 2026-03-23
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/self-audit-and-release-hardening/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-23-self-audit-and-release-hardening-cutover/plan.md`
  - `/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`
  - `/.octon/framework/assurance/runtime/contracts/github-action-pin-policy.yml`
  - `/.octon/framework/engine/runtime/release-targets.yml`

## Context

Octon's class-root architecture, fail-closed publication model, and protected
workflow posture were already stronger than most repositories.
What remained weak was the repo's own self-audit and release hardening chain:

1. `alignment-check.sh` still duplicated profile truth and stale path
   assumptions,
2. `main-push-safety.yml` hid authoritative Markdown changes behind a blanket
   `**/*.md` ignore,
3. automated dependency hygiene stopped at GitHub Actions even though the
   engine runtime has a Cargo workspace,
4. Tier 1 workflows still depended on mutable third-party Action refs, and
5. launchers and release automation did not resolve platform support from one
   machine-readable target matrix.

These gaps all lived on the same trust boundary: if Octon could not
self-validate and publish itself deterministically, the rest of the governance
model was weakened.

## Decision

Promote the self-audit and release hardening proposal as one atomic
clear-break cutover.

Rules:

1. `framework/assurance/runtime/contracts/alignment-profiles.yml` is the
   canonical alignment profile registry for CLI and CI entrypoints.
2. `alignment-check.sh` remains the runner, but profile ids, labels,
   entrypoints, required paths, dry-run eligibility, and consumer scope now
   come from the registry and fail closed through
   `validate-alignment-profile-registry.sh`.
3. `framework/cognition/_meta/architecture/contract-registry.yml` now carries
   machine-readable documentation classes, and only `authoritative-doc`
   changes may trigger the heavy main-push safety workflow.
4. `main-push-safety.yml` now classifies changed files through
   `classify-authoritative-doc-change.sh` before deciding whether the heavy
   safety gate runs.
5. `framework/assurance/runtime/contracts/github-action-pin-policy.yml`
   defines the Tier 1 immutable-ref policy, and
   `validate-github-action-pins.sh` makes mutable third-party Action refs a
   hard failure for that workflow set.
6. Runtime dependency hygiene now includes Cargo scheduling in Dependabot and
   an explicit PR-time `dependency-review.yml` gate.
7. `framework/engine/runtime/release-targets.yml` is the canonical runtime
   target matrix for launcher resolution and release automation.
8. The shipped runtime surface now includes `linux-x64`, `linux-arm64`,
   `windows-x64`, `macos-x64`, and `macos-arm64`, all declared as both
   `local_launchable` and `shippable_release`.
9. `OCTON_RUNTIME_STRICT_PACKAGING=1` disables source fallback for declared
   runtime targets and fails when a packaged binary is missing.
10. The proposal package moves to `.archive/**` in the same change set as the
    durable contracts, validators, workflow updates, runtime target matrix,
    and release hardening docs.

## Consequences

### Benefits

- Alignment profile truth now has one machine-readable source for local and CI
  invocation.
- Authoritative architecture and governance Markdown can no longer bypass the
  main-push safety envelope.
- Tier 1 workflow behavior is now reproducible because third-party Action refs
  are immutable.
- Runtime launcher behavior and release automation now resolve against the
  same target matrix and strict packaging rule.

### Costs

- Assurance runtime gained new contract files, validators, and shell tests.
- The main-push safety and runtime-binaries workflows became more explicit and
  more blocking.
- Runtime release promises expanded immediately to match the launcher-supported
  target set.
- Final harness verification required an elevated rerun to refresh host
  projections under `.codex/**`, `.cursor/**`, and `.claude/**`.

### Follow-on Work

1. Extend immutable-ref enforcement beyond the current Tier 1 workflow set if
   Octon later wants repo-wide workflow pin governance.
2. Treat `release-targets.yml` as the canonical target inventory if future
   release attestation or SBOM publication becomes required.
