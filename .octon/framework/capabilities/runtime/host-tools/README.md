# Host Tools

`host-tools/` defines the canonical framework contract family for external
host-scoped tools that Octon commands, workflows, and validators may require.

These contracts are not repo-local actual state and they do not store
third-party binaries under `/.octon/**`.

## Purpose

Use this family when Octon needs a machine-local tool such as:

- `shellcheck`
- `cargo-machete`
- `cargo-udeps`

The family defines:

- tool ids and contract refs;
- supported OS and architecture envelopes;
- installer kinds such as `system-adopt`, `archive-download`, and
  `cargo-install`;
- version verification semantics;
- runtime entrypoint and resolution posture;
- prerequisite host commands such as `cargo` or `rustup`.

## Boundary Model

This family follows the same desired-versus-actual discipline used by
extension governance, but with one critical difference:

- desired requirements remain repo-local under `instance/**`;
- actual installs, quarantine state, and provisioning evidence remain
  host-scoped outside the repository.

## Canonical Surfaces

- `registry.yml` — tool registry and contract lookup
- `contracts/<tool-id>.yml` — tool-specific installation and verification
  contracts

## Non-Goals

- storing host binaries under `/.octon/**`
- silently mutating host state during `/init`
- replacing repo-local policy or requirements surfaces
