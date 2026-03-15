# `/.extensions/` Interplay Brief

This brief isolates one specific question: how a descendant-local sidecar concept could relate to the proposed repo-root `/.extensions/` system.

## 1. Current `/.extensions/` Proposal In One Sentence

`/.extensions/` is currently proposed as a repo-root-only, additive pack source surface whose runtime-facing effects are compiled and governed from `/.octon/`.

## 2. What `/.extensions/` Is Trying To Achieve

- repo-root specialization without changing native `/.octon/` authority
- additive capabilities and reference content
- strong validation and fail-closed behavior
- runtime-facing effective catalogs and artifact maps
- no second governance root

## 3. What Descendant-Local Sidecars Would Be Trying To Achieve

- locality of context and specialization near a descendant directory
- possible local memory, local decisions, local capabilities, and local knowledge
- reduced context noise and stronger local relevance
- possibly better domain/feature-level autonomy or isolation

## 4. Relationship Patterns The Downstream Agent Should Evaluate

### Pattern A: Separate layers

- `/.extensions/` handles repo-root additive specialization packs.
- descendant-local sidecars handle locality and local state/context.
- Strength:
  - clean conceptual split if enforced well
- Risk:
  - two separate extension/specialization mechanisms may increase conceptual and implementation complexity

### Pattern B: `/.extensions/` as a building block inside local sidecars

- local sidecars can contain or reference pack-like units using the same fragment model as `/.extensions/`.
- Strength:
  - reuse of one content model
- Risk:
  - current `/.extensions/` proposal is explicitly root-bound and pack-centric, so this would require canonical redesign of that proposal

### Pattern C: local sidecars are projections, `/.extensions/` remains the only additive source layer

- local-sidecar directories contain only derived local views, state, or rebased effective artifacts
- source content still comes from `/.octon/` and optionally `/.extensions/`
- Strength:
  - preserves central authority strongly
- Risk:
  - may undershoot the user's hypothesis if the goal is genuine local authorship and ownership

### Pattern D: local sidecars replace the need for `/.extensions/`

- descendant-local sidecars become the main specialization mechanism
- Strength:
  - one locality model instead of two
- Risk:
  - high tension with the existing `/.extensions/` proposal and with portability/self-containment goals

### Pattern E: reject one or both layers

- conclude that descendant-local sidecars should not exist
- keep repo-root `/.octon/` and optionally `/.extensions/` only
- Strength:
  - preserves simplicity if locality needs can be met through better indexing, root-harness context partitioning, missions, or scoped projections
- Risk:
  - may leave real locality pain unsolved

## 5. Questions The Downstream Agent Must Resolve Explicitly

1. Is `/.extensions/` fundamentally about distribution and packaging, while local sidecars are about locality and execution context?
2. If yes, are they complementary or overlapping?
3. If local sidecars can hold capabilities, are those capabilities authored locally, imported from packs, or projected from root-level catalogs?
4. If local sidecars can hold context or memory, are those authoritative local sources or derivative local bundles?
5. If local sidecars exist, does the runtime discover them directly, or does `/.octon/` compile effective views that include them?
6. What is the precedence order among:
   - native `/.octon/`
   - `/.extensions/`
   - descendant-local sidecars
   - derived effective indexes
7. Can local sidecars ever influence governance or only runtime/context specialization?

## 6. Initial Guardrails Suggested By Current Repository Constraints

These are not final recommendations. They are current-constraint-aware guardrails that any viable model must address.

- descendant-local sidecars should not become independent governance roots without explicit canonical architecture change
- descendant-local sidecars should not bypass `/.octon/` validation and effective-resolution machinery
- if local sidecars hold executable capability content, runtime-facing discovery should likely still resolve through Octon-owned effective indexes
- if local sidecars hold memory or decisions, ownership boundaries must distinguish:
  - active state
  - durable decisions
  - graph/projection materializations
  - normative policy
- if `/.extensions/` remains root-only, any reuse of pack concepts locally would require either:
  - a separate local-pack concept
  - or an expansion of the `/.extensions/` contract

## 7. Minimum Output Expected From The Downstream Agent On This Topic

The downstream recommendation should include:

- a direct statement of whether `/.extensions/` and descendant-local sidecars are the same concept, layered concepts, or mutually exclusive concepts
- a precedence model across the two
- a topology model showing where each lives
- a list of artifact classes allowed in each
- a fail-closed model for invalid, conflicting, or stale local content
