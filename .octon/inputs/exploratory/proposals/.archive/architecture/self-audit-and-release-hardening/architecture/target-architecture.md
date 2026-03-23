# Target Architecture

## Decision

Ratify a self-audit and release hardening layer that introduces four durable control families:

1. **topology-correct alignment dispatch**
2. **authority-aware Markdown trigger classification**
3. **multi-ecosystem dependency and workflow trust hardening**
4. **runtime target parity with strict packaging mode**

The guiding rule is simple: each concern gets one declared truth surface, executable adapters read from it or validate against it, and drift fails closed.

## Why This Proposal Exists

Octon already has stronger governance than most harnesses. The problem is not that the repo lacks checks. The problem is that several checks still rely on local assumptions that are looser than Octon's own architecture model.

A one-off edit to each affected file would fix today's symptoms but not tomorrow's regressions. This proposal therefore adds durable truth surfaces and validators instead of only patching individual files.

## Design Goals

- keep the five-class super-root as the only live topology vocabulary
- make safety-sensitive Markdown changes visible to safety workflows
- bring runtime dependency hygiene up to the same baseline as workflow dependency hygiene
- make high-trust workflows reproducible and auditable
- make runtime packaging expectations explicit, machine-readable, and impossible to hide behind local source fallback
- preserve local developer ergonomics where possible

## Non-Goals

This proposal does **not**:

- redesign every GitHub workflow
- remove source fallback from local development entirely
- require full SBOM, provenance, or attestation rollout in the same change
- make proposal-local content authoritative after promotion

## Current Live Signals This Proposal Responds To

| Signal | Current live shape | Required architectural response |
| --- | --- | --- |
| Alignment CLI drift | `alignment-check.sh` still encodes old top-level path assumptions in some profiles | move profile truth into one registry and fail closed on stale paths |
| Contract docs hidden by extension ignore | `main-push-safety.yml` ignores all Markdown | classify docs by authority instead of by extension only |
| Runtime dependency hygiene gap | Dependabot is configured for GitHub Actions only | extend the dependency hygiene model to Cargo and PR dependency review |
| Mutable workflow refs | high-trust workflows still use moving action refs | pin by immutable SHA and validate the policy |
| Runtime target ambiguity | launcher expectations and release artifacts are not governed by one target matrix | declare one target matrix and validate every adapter against it |

## Proposed Architecture

### 1. Topology-Correct Alignment Dispatch

Add one machine-owned alignment profile registry, for example:

`/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`

This registry should declare:

- profile id
- human label
- command or script entrypoint
- expected path class roots
- whether the profile is safe for local dry-run
- whether the profile is consumed by CI, local validation, or both

`alignment-check.sh` then becomes a thin runner over this registry instead of a second hidden path authority.

#### Required behavior

- any profile that references a non-existent path fails before execution
- any profile that references a retired top-level root such as `.octon/agency` fails
- CI and local entrypoints use the same profile ids and same command registry
- adding a new profile changes one registry plus tests, not multiple hardcoded command lists

#### Why this is better than a one-line path fix

A one-line fix repairs the current file. A registry plus validator prevents the same drift from being reintroduced in a future profile or workflow.

### 2. Authority-Aware Markdown Trigger Classification

Extend the machine-readable architecture contract surface so Markdown can be classified by authority instead of treated as cheap by extension. The cleanest place is the existing architecture contract registry, either directly or through a companion fragment that the contract registry points to.

Suggested classes:

- `authoritative-doc`
- `operational-guide`
- `narrative-doc`

`main-push-safety.yml` must stop using `paths-ignore: "**/*.md"` as a blanket rule. Instead, it should classify changed files and trigger safety checks when an `authoritative-doc` or other declared high-impact doc class changes.

#### Expected examples

Files that should be eligible for safety-sensitive handling include:

- architecture specifications
- governance charters and contract docs
- bootstrap docs that define required operator behavior
- PR templates that define governance receipts or required review semantics

Narrative material can remain cheaper to process. The point is not to make all Markdown expensive. The point is to stop hiding authority behind a file extension.

### 3. Multi-Ecosystem Dependency And Workflow Trust Hardening

This control family has three parts.

#### 3.1 Dependabot coverage aligns with the real dependency graph

Extend `.github/dependabot.yml` so it covers:

- `github-actions`
- `cargo` for the runtime crate workspace

This brings the runtime's actual dependencies into the same scheduled review loop.

#### 3.2 PR-time dependency review becomes explicit

Add a dedicated dependency review workflow so dependency manifest and lockfile changes receive a consistent, named review surface instead of relying only on ad hoc human reading.

This proposal does not require a full security platform rollout. It requires one explicit review gate for dependency changes.

#### 3.3 High-trust workflows use immutable action refs

Introduce a repo-owned validator, for example:

`/.octon/framework/assurance/runtime/_ops/scripts/validate-github-action-pins.sh`

Tier 1 workflows should be pinned first:

- `ai-review-gate.yml`
- `harness-self-containment.yml`
- `main-push-safety.yml`
- `release-please.yml`
- `runtime-binaries.yml`
- `pr-autonomy-policy.yml`
- `main-pr-first-guard.yml`

Policy:

- third-party actions use full commit SHAs
- human-readable version comments may remain beside the pin
- mutable refs such as `@v4`, `@v3`, `@main`, `@master`, and `@stable` fail validation in Tier 1

Repo-wide expansion can follow after Tier 1 is stable.

### 4. Runtime Target Parity And Strict Packaging Mode

Add one declared runtime target matrix, for example:

`/.octon/framework/engine/runtime/release-targets.yml`

This matrix should separate at least two concepts:

- `local_launchable`: the launcher may try this target locally
- `shippable_release`: release automation must produce and publish this target

That distinction matters because some targets may be valid for local source-first development without yet being valid release promises.

#### Suggested target record shape

```yaml
schema_version: runtime-release-targets-v1
targets:
  - id: linux-x64
    os: linux
    arch: x86_64
    binary_name: octon-linux-x64
    local_launchable: true
    shippable_release: true
  - id: linux-arm64
    os: linux
    arch: arm64
    binary_name: octon-linux-arm64
    local_launchable: true
    shippable_release: false
```

The exact schema can change. The important part is the architecture rule: launcher scripts, release workflows, and validation must stop inventing platform support independently.

#### Strict packaging mode

Keep source fallback for local development, but add a strict mode for CI and release validation. Example behaviors:

- if `shippable_release=true`, a missing packaged binary is a hard failure
- if strict packaging mode is enabled, local source fallback does not mask a missing packaged binary
- if a target is local-only, that status is declared in the matrix, not implied by omission

## Rollout Order

1. alignment profile truth
2. authoritative Markdown classification
3. dependency review plus Action pinning
4. runtime target parity and strict packaging mode

This order fixes trust in the repo's own self-checks before tightening release behavior.

## Tradeoffs

### More declared metadata

The repo will gain one or more small registry files. That is intentional. The current problem is that too much important behavior is hiding in shell and workflow glue.

### More blocking validation

Some new validators will fail changes that used to pass. That is also intentional. These issues are trust gaps, not purely cosmetic drift.

### Slightly more maintenance for workflow updates

SHA pinning is less convenient than moving tags. The trade is worth it for high-trust workflows because it makes CI behavior reproducible and reviewable.

## Future Follow-Ons

These are aligned with the proposal but not required to close it:

- SBOM generation
- artifact attestation and provenance
- repo-variable or secret preflight capture
- repo-wide pinning across every workflow, not just Tier 1
