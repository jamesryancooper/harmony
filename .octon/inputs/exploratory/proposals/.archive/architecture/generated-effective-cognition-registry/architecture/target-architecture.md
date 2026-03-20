# Target Architecture

## Decision

Ratify `/.octon/generated/**` as the single class root for rebuildable output
and normalize the final published generated families to:

- `generated/effective/**`
- `generated/cognition/**`
- `generated/proposals/**`

Within that contract:

- runtime-facing effective outputs live only under
  `generated/effective/{locality,capabilities,extensions}/**`
- cognition-derived graph, projection, and summary outputs live only under
  `generated/cognition/**`
- proposal discovery lives only at `generated/proposals/registry.yml`
- every runtime-facing effective family publishes a primary effective view, an
  `artifact-map.yml`, and a `generation.lock.yml`
- every published effective family carries source digests, generator version,
  schema version, generation timestamp, and freshness metadata
- generated outputs remain rebuildable and non-authoritative even when they
  are committed by default
- stale or invalid runtime-facing effective outputs fail closed
- retained validation and assurance evidence moves to
  `state/evidence/validation/**`
- `generated/artifacts/**` and `generated/assurance/**` are migration-era
  buckets, not permanent architectural categories

The live repository has already internalized the generated class root, the
proposal registry, cognition outputs, and effective locality and extension
publication families. Packet 10 exists to normalize those real surfaces into
one final contract rather than letting mixed generated buckets harden by
accident.

## Status

- status: accepted proposal drafted from ratified Packet 10 inputs
- proposal area: generated class-root boundaries, effective control-plane
  outputs, cognition-derived outputs, generated proposal discovery, generation
  metadata, commit policy, and migration from mixed-path or extra-bucket
  generated placement
- implementation order: 10 of 15 in the ratified proposal sequence
- dependencies:
  - `super-root-semantics-and-taxonomy`
  - `root-manifest-profiles-and-export-semantics`
  - `framework-core-architecture`
  - `repo-instance-architecture`
  - `overlay-and-ingress-model`
  - `locality-and-scope-registry`
  - `state-evidence-continuity`
  - `inputs-additive-extensions`
  - `inputs-exploratory-proposals`
- cross-packet contract sync:
  - `memory-context-adrs-operational-decision-evidence`
  - `capability-routing-host-integration`
  - `validation-fail-closed-quarantine-staleness`
- migration role: consolidate rebuildable outputs under the final generated
  contract, reclassify extra generated buckets, and freeze the default
  commit-versus-rebuild policy

## Why This Proposal Exists

The five-class super-root is only safe if Octon can answer one operational
question consistently:

**What is rebuildable output, and what is not?**

Without Packet 10, Octon leaves three high-risk ambiguities unresolved:

- generated views can drift into acting like source-of-truth
- retained validation evidence can get mixed with disposable build outputs
- operators cannot tell what is safe to delete, regenerate, diff, or commit

Packet 10 exists because earlier packets already separated authored authority,
operational truth, raw inputs, and generated outputs at the class-root level.
This proposal makes that separation operational for the repo's real generated
surfaces.

### Current Live Signals This Proposal Must Normalize

| Current live signal | Current live source | Ratified implication |
| --- | --- | --- |
| The generated class root already exists and already contains `artifacts/`, `assurance/`, `cognition/`, `effective/`, and `proposals/` | `/.octon/generated/**` | Packet 10 is normalization work, not a hypothetical new root |
| Proposal discovery is already generated and committed | `/.octon/generated/proposals/registry.yml` | The registry must stay rebuildable and non-authoritative rather than becoming a second proposal authority surface |
| Effective locality and extension families already publish view, artifact map, and generation lock artifacts | `/.octon/generated/effective/locality/**` and `/.octon/generated/effective/extensions/**` | Packet 10 must ratify the shared publication metadata contract and commit policy for runtime-facing generated views |
| Capability generated outputs exist, but not yet in the final routing publication shape | `/.octon/generated/effective/capabilities/**` | Packet 10 must reserve the final family contract while Packet 12 normalizes the concrete routing view to `routing.effective.yml` plus support artifacts |
| Live assurance docs still point at `generated/effective/assurance/**`, while top-level `generated/assurance/**` also exists | `/.octon/framework/assurance/runtime/README.md`, `/.octon/generated/effective/assurance/**`, and `/.octon/generated/assurance/**` | Packet 10 must treat these as drift that needs reclassification rather than silently ratifying them as permanent generated families |
| Cognition-derived graph and projection outputs already exist | `/.octon/generated/cognition/**` | Packet 10 must keep them derived, define their commit policy, and prevent them from masquerading as memory or ADR authority |
| The runtime-vs-ops contract already forbids mutable generated or retained-evidence placement under portable `_ops/` helpers | `/.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md` | Packet 10 must finish the placement model by distinguishing rebuildable output from retained evidence inside the generated/state boundary |

## Problem Statement

Octon needs one final generated-output architecture that is:

- explicit about what is rebuildable versus what is retained evidence
- explicit about which generated outputs are runtime-facing and must fail
  closed when stale
- explicit about which generated outputs are compact and reviewable enough to
  commit by default
- explicit about which generated outputs are bulkier, higher-churn read models
  that should normally be rebuilt locally
- explicit about how artifact maps and generation locks participate in
  publication and validation
- explicit about migration away from legacy mixed paths and extra generated
  buckets

Without Packet 10, the repo still leaves open:

- whether `generated/effective/**` is the only runtime-facing generated
  control plane
- whether generated cognition views can quietly become source-of-truth because
  they are committed
- whether `generated/artifacts/**`, `generated/assurance/**`, and
  `generated/effective/assurance/**` are permanent architecture or transition
  debt
- whether retained validation evidence belongs under `generated/**` or
  `state/evidence/**`
- whether teams may invent their own commit-versus-rebuild rules per
  generated subtree

## Scope

- define the final generated class-root model
- define the canonical paths for runtime-facing effective outputs,
  cognition-derived outputs, and proposal discovery outputs
- define the minimum metadata contract for effective publication
- ratify the default commit-versus-rebuild matrix for generated outputs
- define which current generated buckets are transitional and how they must be
  normalized
- define freshness, publication, and stale-output behavior for runtime-facing
  generated views
- define migration from mixed-path output placement and provisional top-level
  generated buckets

## Non-Goals

- re-litigating the five-class super-root
- making generated outputs authoritative
- defining raw proposal or raw extension placement
- defining capability-routing ranking weights
- inventing a separate `.octon.graphs/` root
- keeping `generated/artifacts/**` or `generated/assurance/**` as permanent
  generated top-level buckets without a later explicit architecture decision

## Canonical Generated Contract

### Generated Class Root

`generated/**` exists only for artifacts that are produced by compiling,
indexing, projecting, summarizing, or otherwise transforming canonical inputs
or operational truth that live somewhere else.

Implications:

- generated outputs may be deleted and rebuilt
- committing a generated output does not change its authority status
- authored or state surfaces must never depend on generated artifacts as
  source-of-truth
- any artifact under `generated/**` that cannot be safely rebuilt from
  canonical inputs is misplaced

### Runtime-Facing Effective Outputs

Canonical effective publication families are:

- `generated/effective/locality/**`
- `generated/effective/capabilities/**`
- `generated/effective/extensions/**`

These families are special because runtime or policy consumers may read them.
For that reason they are the only generated families that must always carry
freshness and publication metadata as part of the family contract.

| Family | Primary effective view | Required support artifacts | Source authority stays in |
| --- | --- | --- | --- |
| Locality | `generated/effective/locality/scopes.effective.yml` | `artifact-map.yml`, `generation.lock.yml` | `instance/locality/**` and `state/control/locality/**` |
| Capabilities | `generated/effective/capabilities/routing.effective.yml` | `artifact-map.yml`, `generation.lock.yml` | framework/instance capability authority plus validated extension publications |
| Extensions | `generated/effective/extensions/catalog.effective.yml` | `artifact-map.yml`, `generation.lock.yml` | `instance/extensions.yml` and `state/control/extensions/**` |

The current live capability catalogs under
`generated/effective/capabilities/**` are transitional. Packet 10 locks the
family boundary; Packet 12 completes the final routing publication shape.

### Cognition-Derived Outputs

Canonical cognition-derived generated outputs are:

- `generated/cognition/graph/**`
- `generated/cognition/projections/definitions/**`
- `generated/cognition/projections/materialized/**`
- `generated/cognition/summaries/**`

These outputs support navigation, inspection, summarization, downstream
tooling, and read-model generation. They remain non-authoritative even when
their source material comes from durable repo context, ADRs, or operational
evidence.

Rules:

- summaries are compact and reviewable enough to commit by default
- projection definitions are compact compiled artifacts and commit by default
- graph datasets and materialized projections rebuild locally by default
- stale cognition outputs may remain inspectable only with visible staleness
  warnings
- no cognition output may replace `instance/cognition/**` or `state/**` as a
  governing surface

### Proposal Discovery Output

Canonical proposal discovery output is:

```text
generated/proposals/registry.yml
```

This registry is generated from
`inputs/exploratory/proposals/<kind>/<proposal-id>/**` and the matching
archive tree. It improves discovery and review. It never outranks
`proposal.yml` or subtype manifests as lifecycle authority.

### Generation Metadata Contract

Every runtime-facing effective family must answer all of the following:

- what canonical inputs were used?
- which generator built the output?
- which schema version was applied?
- when was the output built?
- when does it become stale?
- which files belong to the same published generation?

At minimum, every published effective family must include:

- the primary effective view
- an `artifact-map.yml`
- a `generation.lock.yml`

At minimum, effective publication metadata must include:

- source digests for every required canonical input family
- generator version
- schema version
- generation timestamp
- generation or publication identifier
- freshness or invalidation metadata

### Ratified Commit Policy Matrix

| Generated path class | Commit by default | Reason |
| --- | ---: | --- |
| `generated/effective/**` | Yes | runtime-facing, reviewable, and needed for explicit compiled diffs and offline reproducibility |
| `generated/effective/**/artifact-map.yml` | Yes | needed to explain compiled provenance and validate source mapping |
| `generated/effective/**/generation.lock.yml` | Yes | needed for freshness and fail-closed validation |
| `generated/cognition/summaries/**` | Yes | small, human-reviewable, useful in PRs |
| `generated/proposals/registry.yml` | Yes | small, reviewable, improves proposal discoverability |
| `generated/cognition/projections/definitions/**` | Yes | compact compiled projection definitions are useful review artifacts |
| `generated/cognition/projections/materialized/**` | No | higher churn, rebuild locally by default |
| `generated/cognition/graph/**` | No | bulky and higher churn, rebuild locally by default |

Committed generated outputs remain non-authoritative and still participate in
staleness validation.

### Normalization Of Current Generated Drift

The live repository already carries extra or provisional generated surfaces:

- `generated/artifacts/**`
- `generated/assurance/**`
- `generated/effective/assurance/**`
- non-final capability catalogs under `generated/effective/capabilities/**`

Ratified normalization rules are:

- rebuildable publication-support artifacts belong inside the specific
  effective family they support
- retained assurance and validation evidence belongs in
  `state/evidence/validation/**`
- any truly rebuildable assurance-derived output must be rehomed under an
  explicitly ratified generated family rather than left in a free-form bucket
- no unexplained top-level generated bucket survives final cutover
- no unexplained effective subfamily survives final cutover without an
  explicit architecture contract

Packet 10 therefore treats the current assurance-generated surfaces as
transition debt, not as final categories.

## Validation And Failure Model

Validation must enforce all of the following:

- every runtime-facing effective family includes a primary effective view,
  `artifact-map.yml`, and `generation.lock.yml`
- required source digests and generation metadata are present
- generated outputs reference only canonical inputs
- no authoritative surface treats generated outputs as source-of-truth
- no runtime or policy consumer reads raw proposal or raw extension paths
  where generated effective outputs are required
- stale or invalid effective outputs fail closed
- stale cognition-derived outputs are visibly stale and remain non-runtime
- invalid proposal registry output blocks proposal discovery workflows only
- `generated/artifacts/**`, `generated/assurance/**`, and other transition
  buckets are either empty, migrated, or explicitly tolerated only during
  migration

## Portability And Trust Implications

- `generated/**` is never the portability unit
- `bootstrap_core` and `repo_snapshot` continue to exclude `generated/**`
- generated outputs are either committed for reviewability or rebuilt locally
  according to the ratified matrix
- trust and compatibility decisions that influence generated effective
  outputs still originate in authoritative or state surfaces, not in generated
  artifacts themselves

## Migration Framing

Packet 10 lands after packets 1 through 9 and before packets 11, 12, 14, and
15. It does not invent a new generated tree. It normalizes the live repo's
current generated surfaces into one final class-root contract and makes the
commit-versus-rebuild policy explicit.

Required migration outcomes are:

- keep all rebuildable outputs under `generated/**`
- keep runtime-facing generated control-plane outputs only under
  `generated/effective/**`
- keep proposal discovery only under `generated/proposals/registry.yml`
- move retained validation and assurance evidence out of `generated/**`
- reclassify or remove provisional generated buckets before final cutover

## Explicit Rejections

Packet 10 explicitly rejects:

- treating generated outputs as authoritative because they are committed
- using `generated/**` as a cache for retained evidence that is not safely
  rebuildable
- allowing runtime or policy consumers to read raw input paths instead of
  generated effective views
- keeping ad hoc top-level generated buckets indefinitely
- inventing a separate `.octon.graphs/` root
- treating generated proposal-registry output as lifecycle authority
