# Acceptance Criteria

This proposal is considered landed only when every criterion below is true.

## A. Alignment And Topology

### AC-1 — Super-root-correct dispatcher

- No alignment profile or related CI entrypoint references retired top-level roots such as:
  - `.octon/agency`
  - `.octon/orchestration`
  - `.octon/capabilities`
  - `.octon/assurance`
- `alignment-check.sh` and any CI workflow that invokes alignment profiles use the same profile ids and the same declared profile source.
- A regression test fails if a profile points at a missing path or a retired root.

### AC-2 — One profile declaration surface

- Adding or removing a profile requires one durable declaration change plus tests.
- CLI help and CI usage remain consistent because both reflect the same profile registry.

## B. Authoritative Markdown Coverage

### AC-3 — Safety-sensitive Markdown changes are visible

- A blanket `**/*.md` ignore rule no longer hides authoritative docs from safety workflows.
- Changes to declared authoritative Markdown trigger `main-push-safety.yml` or an equivalent safety gate.
- Narrative Markdown can remain cheap if its class is explicitly non-authoritative.

### AC-4 — Doc classification is machine-readable

- The authoritative-doc classification lives in a durable machine-readable surface.
- A validator fails if a workflow ignores a declared authoritative-doc path class.

## C. Dependency And Workflow Trust

### AC-5 — Runtime dependency hygiene includes Cargo

- `.github/dependabot.yml` includes Cargo coverage for the runtime crate workspace.
- Dependency manifest or lockfile changes receive an explicit dependency-review workflow.

### AC-6 — Tier 1 workflows use immutable action refs

- Tier 1 workflows pin all third-party actions to full commit SHAs.
- Mutable refs such as `@v*`, `@stable`, `@main`, and `@master` fail validation for Tier 1 workflows.
- Human-readable comments may preserve the semantic version label beside the SHA.

## D. Runtime Target Parity

### AC-7 — One canonical target matrix exists

- The runtime has one declared target matrix.
- `run`, `run.cmd`, and `runtime-binaries.yml` either consume that matrix or are validated against it.
- Local-launchable targets and shippable-release targets are distinguished explicitly.

### AC-8 — Packaging failures cannot hide behind source fallback

- Strict packaging mode exists for CI and release validation.
- A declared shippable target that lacks its packaged artifact causes failure.
- Local source fallback remains available for development unless strict packaging mode is enabled.

## E. Proposal Exit

### AC-9 — Proposal can retire cleanly

- The new truth surfaces, validators, and workflows are promoted into durable locations.
- The proposal no longer provides unique implementation guidance after promotion.
- `/.octon/generated/proposals/registry.yml` is updated to reflect the proposal lifecycle state.
