# Design Packages

`/.design-packages/` is a temporary workspace for implementation-oriented design
material.

Future packages that opt into the standard-governed design-package contract must
include a root `design-package.yml`. Packages without that manifest remain
legacy implementation material and are not validated against the standard by
default.

Manifest-governed packages are registered in `registry.yml`.

- active manifest-governed packages live directly under `/.design-packages/<id>/`
- archived manifest-governed packages live under `/.design-packages/.archive/<id>/`
- packages without a manifest remain legacy material outside the registry until
  they are normalized

## Non-Canonical Rule

Design packages are implementation aids. They are not canonical runtime,
documentation, policy, or contract authorities.

Implications:

- design packages may be archived or removed after implementation lands
- implementation outputs must point to long-lived `/.harmony/` or repo-native
  authority surfaces, not back to the design package as a source of truth
- generated workflow reports, blueprints, plans, and summaries must not claim
  that the design package is authoritative or canonical

## Authoring Rules

When creating or updating a design package:

- state clearly that the package is temporary and implementation-scoped
- describe the package as an aid, input, draft, or working design material
- avoid phrases such as `canonical`, `authoritative architecture specification`,
  or `source of truth` when referring to the design package itself
- package-local precedence maps are allowed only when they are explicitly framed
  as temporary implementer guidance rather than enduring repository authority
- if downstream artifacts need canonical authority, point them to the intended
  runtime or documentation surface that will survive package removal
- for standard-governed packages, follow
  `.harmony/scaffolding/governance/patterns/design-package-standard.md`

## Lifecycle Expectation

Each design package should make its exit path obvious:

- implementation target surfaces
- archive or removal expectation after implementation
- any temporary assumptions that must be resolved before the package is retired

## Manifest-Governed Discovery

For manifest-governed packages, use this authority order:

1. `design-package.yml`
2. `registry.yml`
3. `README.md`

`registry.yml` is a projection for fast lookup. It must not replace the package
manifest as the lifecycle authority.
