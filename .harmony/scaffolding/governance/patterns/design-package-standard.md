# Design Package Standard

## Purpose

Define the standard for future Harmony design packages that must serve as
temporary but buildable end-to-end implementation blueprints.

This standard applies only to packages that opt in with a root
`design-package.yml`.

## Scope And Rollout

- `design-package.yml` is the opt-in marker for a manifest-governed package.
- Packages without that manifest remain legacy implementation material.
- The standard applies to new packages only in this rollout.
- A standard-governed package is still temporary implementation material. It is
  not a canonical runtime, documentation, policy, or contract authority.

Manifest-governed packages also project into `/.design-packages/registry.yml`.

## Package Classes

Supported `package_class` values in v1:

- `domain-runtime`
- `experience-product`

## Core Artifact Set

Every standard-governed package must contain:

- `README.md`
- `design-package.yml`
- `navigation/artifact-catalog.md`
- `navigation/source-of-truth-map.md`
- `implementation/README.md`
- `implementation/minimal-implementation-blueprint.md`
- `implementation/first-implementation-plan.md`

Reduced legacy-archive exception:

- packages with `status=archived` and `archive.archived_from_status=legacy-unknown`
  may use the reduced legacy-archive contract instead of the full core artifact
  set
- reduced legacy-archive packages must still contain `README.md` and
  `design-package.yml`
- reduced legacy-archive packages preserve historical artifacts as-is and are
  validated as archived historical material rather than implementation-ready
  blueprints

## Class-Specific Required Docs

### `domain-runtime`

- `normative/architecture/domain-model.md`
- `normative/architecture/runtime-architecture.md`
- `normative/execution/behavior-model.md`
- `normative/assurance/implementation-readiness.md`

### `experience-product`

- `normative/experience/user-journeys.md`
- `normative/experience/information-architecture.md`
- `normative/experience/screen-states-and-flows.md`
- `normative/assurance/implementation-readiness.md`

## Optional Modules

Allowed `selected_modules` values:

- `contracts`
- `conformance`
- `reference`
- `history`
- `canonicalization`

Module requirements:

- `contracts`
  - `contracts/README.md`
  - `contracts/schemas/`
  - `contracts/fixtures/valid/`
  - `contracts/fixtures/invalid/`
- `conformance`
  - `conformance/README.md`
  - `conformance/scenarios/`
  - `validation.conformance_validator_path`
- `reference`
  - `reference/README.md`
- `history`
  - `history/README.md`
- `canonicalization`
  - `navigation/canonicalization-target-map.md`

## Manifest Contract

`design-package.yml` must define these exact top-level fields:

- `schema_version`
- `package_id`
- `title`
- `summary`
- `package_class`
- `selected_modules`
- `implementation_targets`
- `status`
- `archive.archived_at`
- `archive.archived_from_status`
- `archive.disposition`
- `archive.original_path`
- `archive.promotion_evidence`
- `lifecycle.temporary`
- `lifecycle.exit_expectation`
- `validation.default_audit_mode`
- `validation.package_validator_path`
- `validation.conformance_validator_path`

Allowed values:

- `schema_version`: `design-package-v1`
- `package_class`: `domain-runtime` | `experience-product`
- `status`: `draft` | `in-review` | `implementation-ready` | `archived`
- `archive.archived_from_status`: `draft` | `in-review` |
  `implementation-ready` | `legacy-unknown`
- `archive.disposition`: `implemented` | `historical`
- `validation.default_audit_mode`: `rigorous` | `short`

Contract rules:

- `package_id` must match the package directory name.
- `implementation_targets` must contain one or more repo-relative durable target
  paths outside `.design-packages/`.
- active packages must live at `/.design-packages/<package_id>/`.
- archived packages must live at `/.design-packages/.archive/<package_id>/`.
- `archive.*` fields are forbidden unless `status=archived`.
- `archive.*` fields are required when `status=archived`.
- `archive.promotion_evidence` must be non-empty when
  `archive.disposition=implemented`.
- `lifecycle.temporary` must remain `true`.
- `validation.package_validator_path` may be `null`.
- `validation.conformance_validator_path` may be `null` only when the
  `conformance` module is not selected.

Schema path:

- `.harmony/scaffolding/runtime/templates/design-package.schema.json`
- `.harmony/scaffolding/runtime/templates/design-package-registry.schema.json`

## Registry Contract

`/.design-packages/registry.yml` must define:

- `schema_version`
- `active`
- `archived`

The registry is a projection, not the primary authority. It must mirror the
manifest-governed package set exactly.

- `active[]` entries project:
  - `id`
  - `path`
  - `title`
  - `package_class`
  - `status`
  - `implementation_targets`
- `archived[]` entries project:
  - `id`
  - `path`
  - `title`
  - `package_class`
  - `status`
  - `disposition`
  - `archived_at`
  - `archived_from_status`
  - `original_path`
  - `implementation_targets`

Authority order:

1. `design-package.yml`
2. `registry.yml`
3. `README.md`

## README Contract

Every standard-governed package README must:

- describe the package as a `temporary, implementation-scoped design package`
- state that it is `not a canonical runtime, documentation, policy, or contract authority`
- include an `Implementation Targets` section
- include an `Exit Path` section

Archived package READMEs must also:

- include `Status: \`archived\``
- include `Archive Disposition: \`implemented\`` or
  `Archive Disposition: \`historical\``

The README may describe package-local reading order or precedence, but it must
not claim enduring repository authority.

## Readiness Definition

A package is only `implementation-ready` when a competent engineer can derive,
from the package alone, the required:

- components or subsystems
- data structures and contracts
- algorithms or deterministic behaviors
- runtime model
- failure and recovery behavior
- validation expectations
- first implementation slice

without inventing architecture.

## Canonicalization Independence Rule

Durable implementation targets must stand on their own after promotion.

- Canonical runtime, documentation, governance, and validation artifacts must
  not retain references to `.design-packages/<package_id>/` or
  `.design-packages/.archive/<package_id>/`.
- If a promoted target needs a contract, schema, fixture, or operator guide
  that originated in the package, that artifact must be materialized into the
  durable target surface before merge.
- Temporary package provenance belongs in plans, PRs, receipts, or historical
  material, not in canonical target artifacts.

## Validation And Workflow Path

Standard-governed packages use:

- `.harmony/assurance/runtime/_ops/scripts/validate-design-package-standard.sh`
  for baseline structure and contract validation
- `/audit-design-package` for iterative hardening toward implementation
  readiness

The standard validator is a baseline gate. Domain-specific package validators
may add stronger checks.

The validator also enforces:

- archive-path placement
- archive metadata completeness
- registry-to-manifest consistency
- promotion-evidence existence for implemented archived packages

Nested validator contract:

- paths in `validation.package_validator_path` and
  `validation.conformance_validator_path` resolve from the repository root
- shell validators must accept the package path as their first positional
  argument
- Python validators must accept the package path as their first positional
  argument
