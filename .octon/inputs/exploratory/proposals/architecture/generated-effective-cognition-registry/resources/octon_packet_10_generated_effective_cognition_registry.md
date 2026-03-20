# Packet 10 — Generated / Effective / Cognition / Registry

**Proposal design packet for ratifying, normalizing, and implementing Octon's rebuildable generated output architecture inside the five-class Super-Root.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Generated class-root boundaries, effective control-plane outputs, cognition-derived outputs, generated proposal discovery, generation metadata, commit policy, and migration from legacy mixed-path and extra-bucket generated placement
- **Implementation order:** 10 of 15 in the ratified proposal sequence
- **Primary outcome:** Consolidate all rebuildable outputs under `generated/**`, normalize final subdomains to `effective/**`, `cognition/**`, and `proposals/**`, enforce non-authority of generated views, and ratify the default commit-versus-rebuild policy
- **Dependencies:** Hard dependencies: Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 5 — Overlay and Ingress Model; Packet 6 — Locality and Scope Registry; Packet 7 — State, Evidence, and Continuity; Packet 8 — Inputs/Additive/Extensions; Packet 9 — Inputs/Exploratory/Proposals. Cross-packet contract sync: Packet 11 — Memory, Context, ADRs, and Operational Decision Evidence; Packet 12 — Capability Routing and Host Integration; Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness
- **Migration role:** Rehome rebuildable outputs from legacy mixed paths and provisional generated buckets into one final generated class-root contract, move retained validation/evidence out of generated placement, and freeze the ratified commit policy for generated artifacts
- **Current repo delta:** The live repository already exposes a class-root `/.octon/generated/**` tree and includes top-level generated subdomains such as `artifacts/`, `assurance/`, `cognition/`, `effective/`, and `proposals/`, which means the generated class root is no longer hypothetical. The repo also already carries `generated/proposals/registry.yml`. Packet 10 is still required because the ratified architecture narrows and normalizes the final generated contract to `effective/**`, `cognition/**`, and `proposals/**`, clarifies what must move out of `generated/**`, and locks the commit-versus-rebuild policy.

> **Packet intent:** define one final contract for rebuildable generated outputs so Octon can publish effective runtime-facing views, cognition-derived views, and proposal discovery outputs without letting generated artifacts masquerade as source-of-truth, retained evidence, or repo-owned authored authority.

## 1. Why this proposal exists

The ratified Super-Root architecture is only safe if Octon can answer one question consistently:

**What is rebuildable output, and what is not?**

Without a clean generated contract, systems drift toward one of three bad outcomes:

- generated outputs start acting like source-of-truth
- retained evidence gets mixed with disposable build artifacts
- operators cannot tell what is safe to delete, regenerate, diff, or commit

Packet 10 exists because the final blueprint deliberately separates four concepts that were historically easy to blur:

- **authored authority** in `framework/**` and `instance/**`
- **operational truth and retained evidence** in `state/**`
- **raw non-authoritative inputs** in `inputs/**`
- **rebuildable outputs** in `generated/**`

The generated class is where those distinctions become operational.

It must cover all rebuildable outputs that are necessary for runtime and repository workflows, including:

- runtime-facing effective views for locality, capabilities, and extensions
- cognition-derived outputs such as graph materializations, projection artifacts, and generated summaries
- proposal discovery outputs such as the proposal registry
- artifact maps and generation locks that prove what was built, from which inputs, and whether it is fresh enough to trust

The live repository already shows why this packet is needed. The `generated/**` class root now exists, and the root tree currently includes `generated/artifacts/**`, `generated/assurance/**`, `generated/cognition/**`, `generated/effective/**`, and `generated/proposals/**`. That is progress, but it is not yet the final normalized contract. Packet 10 is the ratified step that turns “generated exists” into “generated has one stable architecture.”

## 2. Problem statement

Octon needs one final generated-output architecture that is:

- explicit about what is rebuildable versus what is retained evidence
- explicit about which generated outputs are runtime-facing and must fail closed when stale
- explicit about which generated outputs are small reviewable artifacts worth committing by default
- explicit about which generated outputs are higher-churn and should normally be rebuilt locally
- explicit about how artifact maps and generation locks participate in publication and validation
- explicit about migration from older mixed-path and extra-bucket generated placement

Without Packet 10, Octon leaves several important ambiguities unresolved:

- whether `generated/effective/**` is the only runtime-facing generated surface or just one of several
- whether generated cognition outputs can quietly become source-of-truth because they are committed
- whether current buckets such as `generated/artifacts/**` and `generated/assurance/**` are permanent parts of the architecture or only transitional
- whether validation evidence belongs in `generated/**` or in `state/evidence/**`
- whether proposal discovery is just another ad hoc generated file or a governed generated surface
- whether teams may invent their own commit-vs-rebuild rules per generated subtree

Packet 10 resolves those ambiguities and gives implementation work one final answer.

## 3. Final target-state decision summary

- All rebuildable outputs live under `generated/**`.
- `generated/**` is never authoritative.
- The canonical final generated subdomains are:
  - `generated/effective/**`
  - `generated/cognition/**`
  - `generated/proposals/**`
- Runtime-facing effective outputs live only under `generated/effective/**`.
- Cognition-derived graph, projection, and summary outputs live only under `generated/cognition/**`.
- Proposal discovery outputs live only under `generated/proposals/**`.
- Every generated output set must carry source digests, generator version, schema version, generation timestamp, and freshness metadata.
- Runtime and policy consumers may trust generated outputs only when the required generation locks are fresh.
- Generated outputs may be deleted and rebuilt.
- Generated outputs must never become source-of-truth.
- Retained validation evidence and other non-rebuildable receipts do **not** belong in `generated/**`; they belong in `state/evidence/**`.
- `generated/artifacts/**` and `generated/assurance/**` are not final top-level generated buckets in the ratified architecture.
- The default generated-output commit policy is ratified as part of this packet.

## 4. Scope

This packet does all of the following:

- defines the final generated class-root model
- defines the canonical paths for effective outputs, cognition-derived outputs, and proposal discovery outputs
- defines the purpose and contents of artifact maps and generation locks
- defines the default commit-versus-rebuild matrix for generated outputs
- defines which current generated buckets are transitional and how they must be normalized
- defines freshness, publication, and stale-output behavior for runtime-facing generated views
- defines migration from older mixed-path output placement and provisional generated top-level buckets

## 5. Non-goals

This packet does **not** do any of the following:

- re-litigate the five-class Super-Root
- make generated outputs authoritative
- define raw pack or raw proposal placement
- define detailed routing weights for capability selection
- define graph ontology internals beyond the class-root contract
- define a separate `.octon.graphs/` surface
- define per-repo ad hoc commit policy overrides in v1
- keep `generated/artifacts/**` or `generated/assurance/**` as permanent first-class top-level generated buckets without a later explicit architecture decision

## 6. Canonical paths and artifact classes

**`generated/effective/locality/scopes.effective.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Published effective scope-resolution view

**`generated/effective/locality/artifact-map.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Source-to-effective mapping for locality publication

**`generated/effective/locality/generation.lock.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Freshness, source digest, and publication receipt for locality effective output

**`generated/effective/capabilities/routing.effective.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Published runtime-facing capability routing view

**`generated/effective/capabilities/artifact-map.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Mapping from compiled routing artifacts to their canonical inputs

**`generated/effective/capabilities/generation.lock.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Freshness and publication receipt for routing outputs

**`generated/effective/extensions/catalog.effective.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Published runtime-facing extension catalog

**`generated/effective/extensions/artifact-map.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Effective-id to raw-pack mapping for extension publication

**`generated/effective/extensions/generation.lock.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Freshness and publication receipt for extension outputs

**`generated/cognition/graph/**`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Materialized graph datasets derived from canonical inputs

**`generated/cognition/projections/definitions/**`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Projection definitions and compiled projection descriptors

**`generated/cognition/projections/materialized/**`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Materialized projection outputs rebuilt from canonical sources

**`generated/cognition/summaries/**`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Small human-reviewable summaries such as ADR-derived summaries

**`generated/proposals/registry.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Proposal discovery projection generated from `inputs/exploratory/proposals/**`

## 7. Authority and boundary implications

- `framework/**` and `instance/**` remain the only authored authority surfaces.
- `state/**` remains the only home for mutable operational truth and retained evidence.
- `generated/**` is the only home for rebuildable outputs.
- Runtime and policy consumers may read generated effective outputs, but they may never treat them as source-of-truth.
- Generated cognition outputs may aid understanding, inspection, and tooling, but they may not replace canonical authored or state surfaces.
- Generated proposal discovery is not lifecycle authority; proposal manifests remain the governing source inputs for proposal workflows.
- Any current or future artifact under `generated/**` that is not safely rebuildable from canonical inputs is misplaced by definition.

## 8. Ratified generated-output model

### 8.1 Purpose of the generated class root

`generated/**` exists so that Octon can publish compiled, inspectable, rebuildable artifacts without confusing them with:

- authored policy or runtime authority
- repo-specific durable authority
- operational truth and retained evidence
- raw input material

It is the class root that answers: **this exists because something else authoritative or stateful was processed, compiled, indexed, or summarized**.

### 8.2 Effective control-plane outputs

Canonical effective publication families are:

- `generated/effective/locality/**`
- `generated/effective/capabilities/**`
- `generated/effective/extensions/**`

These outputs are special because they can be runtime-facing. For that reason they must carry:

- source digests
- generator version
- schema version
- generation timestamp
- publication status
- freshness / invalidation semantics

Runtime and policy consumers may use only these published effective outputs, never the raw inputs from which they were compiled.

### 8.3 Cognition-derived outputs

Canonical cognition-derived generated outputs are:

- `generated/cognition/graph/**`
- `generated/cognition/projections/definitions/**`
- `generated/cognition/projections/materialized/**`
- `generated/cognition/summaries/**`

These outputs exist to support:

- navigation
- inspection
- summarization
- downstream tooling
- read-model generation

They are still non-authoritative.

### 8.4 Proposal discovery outputs

Canonical proposal discovery output is:

```text
generated/proposals/registry.yml
```

This registry is generated from proposal manifests and subtype manifests under `inputs/exploratory/proposals/**` and exists to improve discovery and review. It never outranks source proposal manifests.

### 8.5 Generation metadata contract

Every generated output family must carry enough metadata to answer all of the following:

- what canonical inputs were used?
- which generator built this output?
- which schema version was applied?
- when was it built?
- when does it become stale?
- what other file(s) belong to the same published generation?

At minimum, every published effective family must include:

- the primary effective view
- an `artifact-map.yml`
- a `generation.lock.yml`

### 8.6 Ratified commit policy matrix

The ratified default generated-output commit policy is:

- **`generated/effective/**`**  
  Commit by default: **Yes**  
  Reason: runtime-facing, reviewable, and needed for explicit compiled diffs and offline reproducibility

- **`generated/effective/**/artifact-map.yml`**  
  Commit by default: **Yes**  
  Reason: required to explain compiled provenance and validate source mapping

- **`generated/effective/**/generation.lock.yml`**  
  Commit by default: **Yes**  
  Reason: required for freshness checks and fail-closed publication

- **`generated/cognition/summaries/**`**  
  Commit by default: **Yes**  
  Reason: small, reviewable, and useful in pull requests

- **`generated/proposals/registry.yml`**  
  Commit by default: **Yes**  
  Reason: small, reviewable, and improves proposal discovery

- **`generated/cognition/projections/definitions/**`**  
  Commit by default: **Yes**  
  Reason: compiled projection definitions are compact, review-friendly artifacts

- **`generated/cognition/projections/materialized/**`**  
  Commit by default: **No**  
  Reason: higher churn; rebuild locally by default

- **`generated/cognition/graph/**`**  
  Commit by default: **No**  
  Reason: bulkier and higher churn; rebuild locally by default

### 8.7 Normalization of current generated drift

The live repository already contains extra generated top-level buckets such as:

- `generated/artifacts/**`
- `generated/assurance/**`

Those are treated as **migration-era buckets**, not final architectural categories.

Ratified normalization rule:

- rebuildable artifact maps, locks, and similar publication-support files move into `generated/effective/**`
- retained assurance evidence moves into `state/evidence/validation/**`
- any truly rebuildable assurance-derived output must be rehomed under `generated/effective/**` or another explicitly approved generated family
- no free-form top-level generated bucket may remain after final cutover without its own approved architecture contract

### 8.8 Explicitly rejected generated models

The following are rejected:

- treating generated outputs as authoritative because they are committed
- using `generated/**` as a cache for retained evidence that is not safely rebuildable
- allowing runtime or policy to consume raw input paths instead of generated effective outputs
- keeping ad hoc top-level generated buckets indefinitely
- inventing a separate `.octon.graphs/` root
- treating generated proposal registry output as lifecycle authority

## 9. Schema, manifest, and contract changes required

### Required schema and contract families

- `generated/effective/**/artifact-map.yml` schema
- `generated/effective/**/generation.lock.yml` schema
- effective view schemas for:
  - locality
  - capability routing
  - extensions
- `generated/cognition/projections/definitions/**` schema
- generated summary schema conventions for `generated/cognition/summaries/**`
- `generated/proposals/registry.yml` schema

### Related contracts that must be updated

- `octon.yml` commit policy and profile references
- validation and fail-closed contracts so stale effective outputs are rejected
- Packet 8 extension publication contract so extension effective generations are consistent with active state
- Packet 12 capability-routing contract so adapters read only generated routing outputs
- Packet 11 memory/decisions contract so summaries and graph outputs remain derived
- migration contracts so legacy generated buckets are explicitly reclassified or removed

## 10. Validation, assurance, and fail-closed implications

Validation must enforce all of the following:

- every runtime-facing effective family includes an artifact map and generation lock
- required source digests are present
- required generation metadata is present
- generated outputs reference only canonical inputs
- no authoritative surface treats generated outputs as source-of-truth
- no runtime or policy consumer reads raw proposal or raw extension paths where generated effective views are required
- stale or invalid effective outputs fail closed
- generated cognition outputs may be stale only for non-operational inspection workflows, and stale status must be visible
- `generated/artifacts/**` and `generated/assurance/**` are either empty, migrated, or explicitly tolerated only during migration

### Fail-closed behavior

- invalid effective publication blocks runtime use of that effective family
- stale `generated/effective/**` output blocks runtime or policy use
- invalid proposal registry blocks proposal discovery workflows only
- invalid cognition-derived outputs do not become runtime blockers unless another packet explicitly declares a runtime dependency on them

## 11. Portability, compatibility, and trust implications

- `generated/**` is never the primary portability unit.
- Generated outputs are either committed for reviewability/offline reproducibility or rebuilt locally per the commit matrix.
- Committing a generated output does **not** change its authority status.
- Generated outputs that incorporate extension data are only as publishable as the trust and compatibility decisions that produced them.
- A repo snapshot excludes `generated/**` even when some generated outputs are committed by default; generated artifacts remain rebuildable outputs, not bootstrap inputs.

## 12. Migration and rollout implications

### Migration work authorized by this packet

- normalize final generated subdomains to:
  - `generated/effective/**`
  - `generated/cognition/**`
  - `generated/proposals/**`
- rehome existing generated artifact maps and locks into their final effective families
- move retained validation/assurance evidence out of `generated/**` and into `state/evidence/validation/**`
- reclassify or eliminate provisional `generated/artifacts/**` and `generated/assurance/**` top-level buckets
- ratify the default commit policy matrix
- align runtime publication and validation pipelines to the generated effective contract

### Important sequencing rules

Packet 10 must land after:

- Packet 1 — Super-Root Semantics and Taxonomy
- Packet 2 — Root Manifest, Profiles, and Export Semantics
- Packet 3 — Framework/Core Architecture
- Packet 4 — Repo-Instance Architecture
- Packet 5 — Overlay and Ingress Model
- Packet 6 — Locality and Scope Registry
- Packet 7 — State, Evidence, and Continuity
- Packet 8 — Inputs/Additive/Extensions
- Packet 9 — Inputs/Exploratory/Proposals

Packet 10 must land before:

- Packet 11 — Memory, Context, ADRs, and Operational Decision Evidence
- Packet 12 — Capability Routing and Host Integration
- Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness
- Packet 15 — Migration and Rollout

### Explicit migration rule

Do not finalize `generated/cognition/**` or `generated/effective/**` contracts until:

- the raw-input dependency ban is enforced
- Packet 8 has locked the desired/actual/compiled extension model
- Packet 9 has locked the proposal-registry authority boundary
- current `generated/artifacts/**` and `generated/assurance/**` contents have a ratified destination

## 13. Dependencies and suggested implementation order

- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 5 — Overlay and Ingress Model; Packet 6 — Locality and Scope Registry; Packet 7 — State, Evidence, and Continuity; Packet 8 — Inputs/Additive/Extensions; Packet 9 — Inputs/Exploratory/Proposals; cross-packet contract sync with Packet 11 — Memory, Context, ADRs, and Operational Decision Evidence; Packet 12 — Capability Routing and Host Integration; Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness
- **Suggested implementation order:** 10
- **Blocks:** final routing publication, final memory-summary routing, final proposal discovery contract, and final validation cutover for stale generated outputs

## 14. Acceptance criteria

- All rebuildable outputs live under `generated/**`.
- Runtime-facing effective outputs live only under `generated/effective/**`.
- Generated cognition outputs live only under `generated/cognition/**`.
- Proposal discovery lives only under `generated/proposals/registry.yml`.
- Every runtime-facing effective family publishes an artifact map and generation lock.
- Generated outputs carry source digests, generator version, schema version, and generation timestamps.
- Stale runtime-facing effective outputs fail closed.
- `generated/artifacts/**` and `generated/assurance/**` no longer survive as unexplained final top-level generated buckets.
- Retained validation or assurance evidence is no longer stored in `generated/**`.
- The ratified generated-output commit policy matrix is implemented and documented.
- Teams can explain clearly what is safe to delete and regenerate and what is not.

## 15. Supporting evidence to reference

- `/.octon/README.md` for the class-first super-root baseline
- `/.octon/octon.yml` for manifest/profile policy and the current migration baseline
- current `/.octon/generated/**` tree, especially the presence of `artifacts/`, `assurance/`, `cognition/`, `effective/`, and `proposals/`
- `/.octon/generated/proposals/registry.yml`
- `/.octon/cognition/_meta/architecture/runtime-vs-ops-contract.md`
- Packet 8 — Inputs/Additive/Extensions
- Packet 9 — Inputs/Exploratory/Proposals
- Ratified blueprint sections on generated outputs, commit policy, and migration sequencing

## 16. Settled decisions that must not be re-litigated

- Generated outputs remain non-authoritative.
- Runtime-facing effective outputs live under `generated/effective/**`.
- Proposal discovery registry lives under `generated/proposals/registry.yml`.
- Generated proposal registry is committed by default.
- Graph outputs and materialized projections are rebuilt locally by default.
- No `.octon.graphs/` root is introduced.
- Raw inputs are not runtime-facing dependencies.
- Retained validation/evidence artifacts do not belong in `generated/**`.

## 17. Remaining narrow open questions

None.
