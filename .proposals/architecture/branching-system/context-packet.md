# Context Packet

This document distills the repository-local context that a downstream research agent would otherwise miss.

Labels used in this packet:

- `Fact`: grounded in current repository sources.
- `Inference`: a reasoned conclusion drawn from those sources.
- `Open question`: unresolved issue or ambiguity.
- `User hypothesis`: an idea supplied by the user that is not validated as current architecture.

## 1. Current-State Summary

### 1.1 Canonical harness posture

- `Fact`: Octon is an agent-first, system-governed engineering harness operating inside a managed filesystem boundary.
- `Fact`: The managed filesystem boundary includes the repository root containing `/.octon/` and its descendants, excluding explicit human-led zones.
- `Fact`: `/.octon/` is the current canonical repo-root harness and control surface.
- `Fact`: Canonical authored bootstrap governance lives under `/.octon/`, while repo-root `AGENTS.md` and `CLAUDE.md` are ingress adapters.

### 1.2 High-authority topology

- `Fact`: High-authority architectural material emphasizes a single repo-root `.octon/` directory organized by domain.
- `Fact`: The root umbrella specification treats `/.octon/` as the cross-subsystem canonical surface.
- `Fact`: `/.octon/octon.yml` is the current portability and resolution manifest.
- `Fact`: Runtime, governance, practices, and `_ops` are bounded concern surfaces; `_ops` is explicitly non-canonical.

### 1.3 Runtime authority model

- `Fact`: `engine/runtime/` is the only executable authority surface for engine behavior.
- `Fact`: `engine/governance/` is normative runtime policy authority.
- `Fact`: `capabilities/` defines capability declaration semantics and discovery metadata.
- `Fact`: If capability semantics conflict with engine enforcement, engine enforcement wins for execution.

### 1.4 Discovery model

- `Fact`: Progressive disclosure is a current Octon principle and architecture requirement.
- `Fact`: The general model is lightweight index first, richer metadata second, full definition only when needed.
- `Fact`: Skills follow a manifest -> registry -> `SKILL.md` -> references model.
- `Fact`: Cognition docs use canonical markdown plus colocated `*.index.yml` sidecar section indexes and directory `index.yml` files.

### 1.5 Fail-closed posture

- `Fact`: Deny-by-default is canonical for capabilities.
- `Fact`: Missing, unknown, ambiguous, or unevaluable permission decisions must fail closed.
- `Fact`: Material side effects require explicit governance, evidence, and no-silent-apply behavior.
- `Fact`: `_ops/` automation is restricted to allowlisted write roots and must not mutate immutable governance targets without an explicit exception.

### 1.6 Current cognition, memory, decision, and continuity placement

- `Fact`: `cognition/runtime/context/` is durable shared context and guidance.
- `Fact`: `cognition/runtime/decisions/` is the append-only ADR surface.
- `Fact`: `cognition/runtime/context/decisions.md` is a generated summary of ADR metadata, not the authoritative decision source.
- `Fact`: `continuity/` owns active work state and handoff state.
- `Fact`: `continuity/decisions/` owns append-oriented decision evidence for allow/block/escalate outcomes.
- `Fact`: `knowledge/graph/` is a generated runtime knowledge dataset, not a primary authority surface.
- `Fact`: `projections/` are derived read models and explicitly non-authoritative.

### 1.7 Current implementation reality about locality

- `Fact`: The live architecture does not currently expose an implemented, canonical descendant-local sidecar system for runtime/governance/local memory specialization.
- `Fact`: A filesystem scan found no active descendant `.octon` harnesses in the working tree outside archived, temporary, or human-led areas.
- `Inference`: Descendant-local sidecars are currently architectural possibilities, not implemented canonical behavior.

## 2. Canonical Architecture Invariants

- `Fact`: `/.octon/` remains the domain-organized harness root.
- `Fact`: Portability is metadata-driven, not based on multiple top-level roots.
- `Fact`: Governance contracts remain normative authority for their domains.
- `Fact`: Runtime artifacts remain in `runtime/`; operational scripts and mutable state remain in `_ops/`.
- `Fact`: Derived projections do not become source-of-truth.
- `Fact`: The system is intended to be self-contained under `/.octon/` and portable across repositories.
- `Fact`: Human-led zones remain excluded from autonomous access unless explicitly scoped.
- `Fact`: Continuity artifacts that are append-only must preserve historical integrity.
- `Fact`: Material decisions and actions require traceability and receipts.

## 3. Proposal Landscape Summary

### 3.1 Branching-system draft concept

- `Fact`: The branching-system draft is exploratory, non-canonical proposal material.
- `Fact`: It uses octopus-derived metaphors such as tentacles, nervous system, limbs, and distributed capability reach.
- `Inference`: Its main architectural push is toward a central-governance-plus-distributed-locality model.
- `Open question`: Whether those metaphors correspond to a sound filesystem and authority model is unresolved.

### 3.2 `/.extensions/` sidecar pack proposal

- `Fact`: The `/.extensions/` proposal is also non-canonical, but much more concrete.
- `Fact`: It proposes a repo-root-only `/.extensions/` source surface for additive specialization packs.
- `Fact`: It keeps runtime authority, precedence, governance, and derived effective indexes inside `/.octon/`.
- `Fact`: It explicitly forbids governance, practices, methodology, agency, orchestration, engine authority, assurance authority, services, mutable runtime state, and compiled effective indexes inside `/.extensions/`.
- `Fact`: It requires validated effective catalogs and artifact maps under `/.octon/engine/_ops/state/extensions/`.
- `Fact`: It is pack-centric, not domain-centric.

### 3.3 Relationship pressure between the two proposals

- `Inference`: Both proposals are trying to solve specialization and locality, but at different scopes.
- `Inference`: `/.extensions/` is currently framed as repo-root additive specialization, not descendant-local specialization.
- `Open question`: Whether descendant-local sidecars should reuse the `pack` concept, compose with it, or remain orthogonal is unresolved.

## 4. Summary Of The Branching-System Draft Concept

- `Fact`: The draft frames Octon as central intelligence plus distributed reach.
- `Fact`: It maps the octopus metaphor to authority surfaces, workflow/capability channels, feedback loops, and objective-bound movement.
- `Inference`: The strongest implementation-relevant ideas are not the metaphors themselves, but:
  - central governance with distributed specialization
  - locality-aware context and capability placement
  - explicit authority surfaces for local execution
  - a need for a clearer model of how repo-wide and local context relate
- `Open question`: The draft does not currently provide a concrete authority, precedence, filesystem, or fail-closed model for descendant-local surfaces.

## 5. Summary Of The `/.extensions/` Sidecar-Pack Proposal

- `Fact`: `/.extensions/` is proposed as an optional repo-root sidecar boundary, not a second authority root.
- `Fact`: Packs may contribute additive skills, commands, templates, prompts, context docs, and validation assets.
- `Fact`: Core manifests remain authoritative; extension fragments are additive only.
- `Fact`: Raw `.extensions/` paths must not become direct live dependencies of canonical `/.octon/` manifests or registries.
- `Fact`: Runtime consumers must use Octon-compiled effective indexes and artifact maps.
- `Fact`: Writes or durable outputs declared by extension artifacts must be rebased into Octon-owned destinations or fail closed.
- `Inference`: `/.extensions/` is architected as a controlled import/specialization plane, not as a local autonomy plane.

## 6. Tensions Between Locality And Centralized Authority

### 6.1 Strong centralization signals

- `Fact`: The umbrella architecture, ADR-010, engine authority boundaries, and bootstrap decisions all reinforce a single repo-root harness.
- `Fact`: Portability and governance are framed as self-contained within `/.octon/`.
- `Fact`: Current live capability and cognition surfaces are centralized under `/.octon/`.

### 6.2 Locality signals

- `Fact`: The `Locality` principle says context should live close to where it is needed.
- `Fact`: That principle includes hierarchical/local harness examples and descendant continuity examples.
- `Fact`: The same principle also warns against inventing alternate harness roots and says domain-specific context should stay under repo-root harness paths.

### 6.3 Interpreting the tension

- `Inference`: Current repo materials are not fully aligned on how far locality is allowed to go.
- `Inference`: The conflict is not evenly weighted. The single-root stance is backed by stronger architecture authority, including the umbrella specification and ADR-010, while the nested/local-harness stance is expressed in a lower-weight operational principle guide and adjacent reference material.
- `Inference`: Current default interpretive weight therefore favors repo-root centrality unless or until Octon changes that architecture canonically.
- `Inference`: There is a distinction trying to emerge between:
  - local relevance
  - local projection
  - local state isolation
  - local canonical authority
- `Open question`: Which of those should descendant-local sidecars actually provide?

## 7. Preliminary Terminology Observations

- `Fact`: Octon already uses "sidecar" for colocated discovery index files.
- `Inference`: Reusing bare `sidecar` for descendant-local runtime/context surfaces could create ambiguity unless qualified.
- `User hypothesis`: possible names include `tentacles`, `nodes`, and `branches`.
- `Inference`: those names are vivid but may obscure whether the concept is:
  - a local bundle of artifacts
  - a local projection
  - a local pack
  - a local harness
  - a local capsule or cell
- `Open question`: the eventual name should reflect implementable behavior, not metaphorical appeal.

## 8. What Appears Settled vs Unsettled

### Appears settled

- `Fact`: `/.octon/` is the canonical root governance/control surface today.
- `Fact`: runtime/governance/practices/_ops separation is a real architecture rule.
- `Fact`: portability is currently declared through `/.octon/octon.yml`.
- `Fact`: cognition/continuity/decisions/projections already have differentiated ownership.
- `Fact`: `/.extensions/` is currently a proposal for repo-root additive specialization, not for descendant-local governance.

### Appears unsettled

- `Open question`: whether descendant-local sidecars should exist at all
- `Open question`: whether local specialization should be represented as:
  - local sidecars
  - repo-root extensions plus local scoping
  - missions/projects only
  - richer projections without new local source surfaces
- `Open question`: whether local context/memory/decisions should be canonical locally or only projected locally
- `Open question`: whether local capabilities should be packs, fragments, overlays, or isolated bundles

## 9. Known Unknowns

- `Open question`: Should localized decisions be ADR-grade authorities, continuity evidence, or local references to repo-root canonical decisions?
- `Open question`: Should local sidecars be portable assets, repo-specific state, or a mix?
- `Open question`: How should local sidecars interact with current `octon.yml` portability declarations?
- `Open question`: If local sidecars exist, do they need their own discovery indexes, or should repo-root effective indexes compile them?
- `Open question`: If both `/.extensions/` and descendant-local sidecars exist, which compiles first and which has precedence?
- `Open question`: What is the failure mode when local and root-localized content disagree?
- `Open question`: Would descendant-local sidecars require canonical changes before they can be considered an extension of the present model?

## 10. Research Pitfalls To Avoid

- `Fact`: Proposal materials are not canonical.
- `Fact`: Sidecar already has a narrow discovery meaning inside cognition docs.
- `Fact`: Locality guidance currently contains conflicting signals.

Avoid:

- treating the octopus metaphors as architecture
- assuming descendant-local sidecars already exist because locality examples mention them
- assuming `/.extensions/` is already canonical
- allowing raw local or extension source paths to become runtime-facing authority without explicit effective-resolution rules
- placing governance or `_ops` state into new local surfaces without a precise authority model
- duplicating repo-root norms into local copies rather than defining source/projection relationships
- maximizing locality at the cost of fail-closed governance, portability, or auditability
