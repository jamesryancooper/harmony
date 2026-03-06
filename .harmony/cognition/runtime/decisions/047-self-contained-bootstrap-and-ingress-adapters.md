# ADR 047: Self-Contained Bootstrap And Ingress Adapters

- Date: 2026-03-06
- Status: Accepted
- Deciders: Harmony maintainers
- Related:
  - `/.harmony/AGENTS.md`
  - `/.harmony/OBJECTIVE.md`
  - `/.harmony/scaffolding/runtime/bootstrap/`
  - `/.harmony/scaffolding/runtime/templates/harmony/scaffolding/runtime/bootstrap/`
  - `/AGENTS.md`
  - `/CLAUDE.md`

## Context

Harmony's bootstrap assets were split across reusable template surfaces and
live bootstrap entrypoints, which created avoidable drift. The human-authored
repo bootstrap governance also lived at repo root even though the harness is
meant to be self-contained under `/.harmony/`.

At the same time, external tool discovery and CI still rely on repo-root
ingress files such as `AGENTS.md` and `CLAUDE.md`.

## Decision

Adopt a self-contained bootstrap model with generated ingress adapters.

Rules:

1. Canonical authored bootstrap governance lives under `/.harmony/`.
2. Canonical repo-bootstrap assets live under
   `/.harmony/scaffolding/runtime/bootstrap/`.
3. Reusable scaffolding templates remain under
   `/.harmony/scaffolding/runtime/templates/`.
4. Repo-root `AGENTS.md` and `CLAUDE.md` are ingress adapters to
   `/.harmony/AGENTS.md`, preferably symlinks and otherwise byte-identical
   fallback copies.
5. The human-readable objective brief lives only at `/.harmony/OBJECTIVE.md`.
6. The base `harmony` template carries a generated projection of the bootstrap
   bundle so adopted repositories remain self-contained after scaffold.

## Consequences

### Benefits

- Reduces drift between live bootstrap behavior and projected harness copies.
- Keeps authored bootstrap governance inside the harness boundary.
- Preserves tool and CI discovery through deterministic repo-root adapters.

### Costs

- Adds projection/parity validation work for bootstrap assets.
- Requires active docs and validators to distinguish canonical sources from
  generated ingress files.
