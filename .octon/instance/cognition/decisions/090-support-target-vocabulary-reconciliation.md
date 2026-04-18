# ADR 090: Support-Target Vocabulary Reconciliation

- Date: 2026-04-18
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/framework/constitution/support-targets.schema.json`
  - `/.octon/framework/constitution/{CHARTER.md,charter.yml}`
  - `/.octon/instance/charter/{workspace.md,workspace.yml}`

## Context

The live support declaration used `bounded-admitted-live-universe`, while the
schema allowed `bounded-admitted-finite` and `global-complete-finite`. The live
repo no longer truthfully supports a globally complete final universe.

## Decision

Use `bounded-admitted-finite` as the active support-claim mode.

Rules:

1. The active live claim is the supported subset of tuple admissions only.
2. Stage-only, unsupported, experimental, and unadmitted surfaces stay outside
   the active live claim and must appear under explicit non-live or blocker
   accounting.
3. Broad tier lists remain taxonomy; tuple admissions and dossiers define live
   support truth.

## Consequences

- Support vocabulary becomes schema-valid.
- The live claim can narrow without inventing a second support plane.
- Full-support or globally-complete wording is no longer valid until real proof
  exists.
