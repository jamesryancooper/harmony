# Source Digest

This digest is designed for a non-repo research agent. Each entry explains why the source matters and what it says without requiring the file itself.

Authority levels used here:

- `canonical`
- `proposal`
- `reference`
- `example`
- `other`

## 1. `AGENTS.md`

- Authority level: `canonical` ingress
- Why it matters:
  - Establishes contract precedence, execution-profile governance, and the requirement to favor minimal sufficient complexity.
- Distilled key points:
  - Root `AGENTS.md` is an ingress adapter to `/.octon/AGENTS.md`.
  - Repository-wide behavior is governed by a contract chain headed by `AGENTS.md`.
  - Any implementation/change work must select a `change_profile`.
  - The harness is explicitly agent-first and system-governed.

## 2. `/.octon/AGENTS.md`

- Authority level: `canonical`
- Why it matters:
  - Same ingress content, but this is the canonical authored copy under `/.octon/`.
- Distilled key points:
  - Confirms canonical control lives inside `/.octon/`.
  - Requires reading objective and intent contracts before work.
  - Reinforces smallest robust solution as design default.

## 3. `/.octon/OBJECTIVE.md`

- Authority level: `canonical`
- Why it matters:
  - Defines Octon's present workspace goal and optimization targets.
- Distilled key points:
  - Octon exists to evolve itself as a portable governed harness.
  - In-scope work includes runtime, governance, portability, and bootstrap behavior.
  - Success depends on self-containment, portability, internal consistency, and trustable validation.

## 4. `/.octon/CHARTER.md`

- Authority level: `canonical`
- Why it matters:
  - Highest cross-domain constitutional source inside Octon's managed filesystem scope.
- Distilled key points:
  - Defines the managed filesystem boundary as the repo root containing `/.octon/` and descendants.
  - States that Octon is governed, fail-closed, objective-bound, and evidence-backed.
  - Defines the precedence ladder across governance surfaces.
  - Clarifies source-of-truth versus execution versus mutable operational state.

## 5. `/.octon/cognition/runtime/context/intent.contract.yml`

- Authority level: `canonical`
- Why it matters:
  - Machine-readable active intent contract for autonomous execution authority.
- Distilled key points:
  - Authorized actions are repo-local only.
  - Governance and release guardrails are hard boundaries.
  - Assurance, correctness, portability, and productivity are explicitly ordered.

## 6. `/.octon/START.md`

- Authority level: `canonical` orientation
- Why it matters:
  - Explains the boot sequence, top-level structure, naming rules, and the canonical path for agent execution.
- Distilled key points:
  - All resources now live under `.octon/`.
  - Introduces the domain-organized structure and the `runtime/` vs `_ops/` split.
  - Marks ideation as human-led.

## 7. `/.octon/cognition/_meta/architecture/specification.md`

- Authority level: `canonical`
- Why it matters:
  - Cross-subsystem umbrella specification for `/.octon/`.
- Distilled key points:
  - The harness root must remain domain-organized under `/.octon/`.
  - Portability is metadata-driven through `octon.yml`.
  - Progressive disclosure, deny-by-default, no silent apply, runtime vs `_ops`, and contract registry coverage are all normative requirements.

## 8. `/.octon/cognition/_meta/architecture/runtime-vs-ops-contract.md`

- Authority level: `canonical`
- Why it matters:
  - Prevents `_ops/` from becoming shadow runtime or governance authority.
- Distilled key points:
  - `runtime/` is canonical runtime behavior and discovery.
  - `_ops/` is operational scripts and mutable state.
  - `_ops/` writes are allowlisted and fail closed.
  - Immutable governance targets cannot be mutated by default.

## 9. `/.octon/octon.yml`

- Authority level: `canonical`
- Why it matters:
  - Single source of truth for portability, human-led paths, and resolution rules.
- Distilled key points:
  - Portable paths are explicitly declared.
  - Human-led zones are explicitly declared.
  - Current manifest is centered on root `/.octon/` paths.
  - It currently lacks the release/version keys proposed for `/.extensions/`.

## 10. `/.proposals/README.md`

- Authority level: `reference` for proposal handling
- Why it matters:
  - Defines proposal non-canonicality and lifecycle.
- Distilled key points:
  - Proposal artifacts are temporary and non-authoritative.
  - Durable implementation authority must land in `/.octon/` or repo-native targets, not remain in proposal space.

## 11. `/.proposals/architecture/branching-system/draft-concept.md`

- Authority level: `proposal`
- Why it matters:
  - The primary exploratory narrative for the descendant-local sidecar idea.
- Distilled key points:
  - Uses octopus-derived metaphors to argue for central governance with distributed local reach.
  - Suggests local memory, decisions, tools, and capability surfaces.
  - Does not define a precise authority or precedence model.

## 12. `/.proposals/architecture/extensions-sidecar-pack-system/README.md`

- Authority level: `proposal`
- Why it matters:
  - Frames `/.extensions/` as an implementation-scoped architecture proposal and lists the supporting source set.
- Distilled key points:
  - `/.extensions/` is a repo-root sidecar proposal.
  - Durable implementation authority still belongs in `/.octon/`.

## 13. `/.proposals/architecture/extensions-sidecar-pack-system/architecture/target-architecture.md`

- Authority level: `proposal`
- Why it matters:
  - The most detailed current proposal for specialization outside `/.octon/`.
- Distilled key points:
  - `/.extensions/` is root-only and pack-centric.
  - Extension content is additive only.
  - Governance, practices, methodology, agency, orchestration, engine authority, assurance authority, services, mutable state, and compiled indexes are excluded.
  - Runtime-facing integration happens through Octon-compiled effective indexes and artifact maps.

## 14. `/.proposals/architecture/extensions-sidecar-pack-system/architecture/implementation-plan.md`

- Authority level: `proposal`
- Why it matters:
  - Shows the scale and type of implementation work expected if `/.extensions/` is adopted.
- Distilled key points:
  - Requires new contracts, schemas, runtime discovery, effective-index compilation, host integration, validation, scaffolding, and operator workflows.
  - Keeps operational entrypoints inside `/.octon/`, not inside `/.extensions/`.

## 15. `/.proposals/architecture/extensions-sidecar-pack-system/reference/effective-index-merge-and-precedence.md`

- Authority level: `proposal`
- Why it matters:
  - Best current proposed model for how additive source surfaces could be merged without becoming direct authority.
- Distilled key points:
  - Core Octon content is always the base and extensions are additive.
  - Conflicts fail closed rather than override.
  - Runtime consumers use effective catalogs and artifact maps, not raw extension paths.

## 16. `/.proposals/architecture/extensions-sidecar-pack-system/navigation/source-of-truth-map.md`

- Authority level: `proposal`
- Why it matters:
  - Explicitly maps source-of-truth versus derived/enforced surfaces for `/.extensions/`.
- Distilled key points:
  - Raw `.extensions/` is source and selection only.
  - `/.octon/` remains runtime authority and derived effective projection owner.
  - Helps distinguish source surfaces from runtime-facing effective surfaces.

## 17. `/.proposals/architecture/extensions-sidecar-pack-system/architecture/acceptance-criteria.md`

- Authority level: `proposal`
- Why it matters:
  - Concise checklist of what the `/.extensions/` proposal considers complete.
- Distilled key points:
  - Makes explicit the root-only binding, allowed/excluded content classes, compatibility keys, rebased output rules, and cleanup requirements.

## 18. `/.octon/README.md`

- Authority level: `reference` orientation
- Why it matters:
  - Summarizes the harness purpose, structure, and discovery model in one place.
- Distilled key points:
  - The harness is a single repo-root operating layer.
  - Progressive disclosure, continuity, portability, and bounded governance are first-class concepts.

## 19. `/.octon/scope.md`

- Authority level: `reference` local scope declaration
- Why it matters:
  - Clarifies the root harness as repo-wide and lists content-placement guidance.
- Distilled key points:
  - The root `.octon/` is described as the repo-wide harness.
  - Domain-specific content is described as belonging in the domain's own harness or under root-harness domain paths, which contributes to the ambiguity about locality.

## 20. `/.octon/cognition/runtime/context/index.yml`

- Authority level: `canonical` discovery index
- Why it matters:
  - Shows how current context files are discovered and routed.
- Distilled key points:
  - Context discovery is explicit and indexed.
  - Includes memory-map, decisions, continuity, glossary, constraints, and other routing aids.
  - Encodes governance and enforcement bindings for contract-bearing context entries.

## 21. `/.octon/cognition/runtime/context/memory-map.md`

- Authority level: `canonical`
- Why it matters:
  - Best current compact statement of memory-class placement.
- Distilled key points:
  - Memory policy lives in agency governance.
  - Active execution state lives in continuity.
  - Durable context lives in cognition runtime context.
  - ADRs are in runtime decisions; summaries in context are derived.
  - Knowledge graph surfaces are not task-state surfaces.

## 22. `/.octon/continuity/README.md`

- Authority level: `reference` with operational contract content
- Why it matters:
  - Defines current continuity ownership and session workflow.
- Distilled key points:
  - `continuity/` owns session state, task state, and next actions.
  - It is distinct from cognition context and decisions.

## 23. `/.octon/continuity/decisions/README.md`

- Authority level: `reference` with placement rules
- Why it matters:
  - Defines routing/approval/block evidence placement.
- Distilled key points:
  - Decision evidence for allow/block/escalate belongs in continuity decisions.
  - It is continuity evidence, not active task state.

## 24. `/.octon/cognition/runtime/README.md`

- Authority level: `reference`
- Why it matters:
  - Summarizes runtime cognition surfaces and their separation.
- Distilled key points:
  - Distinguishes context, decisions, analyses, knowledge, migrations, evidence, evaluations, and projections.

## 25. `/.octon/cognition/runtime/knowledge/graph/README.md`

- Authority level: `reference`
- Why it matters:
  - Clarifies graph ownership.
- Distilled key points:
  - Graph datasets are runtime-generated materializations, not primary narrative authority.

## 26. `/.octon/cognition/runtime/projections/README.md`

- Authority level: `reference`
- Why it matters:
  - Clarifies derived read-model status.
- Distilled key points:
  - Projections are query-friendly derived views only.
  - Source-of-truth remains elsewhere.

## 27. `/.octon/capabilities/README.md`

- Authority level: `reference`
- Why it matters:
  - Explains the bounded role of capabilities versus engine.
- Distilled key points:
  - Capabilities defines commands, skills, tools, services and their governance.
  - Engine owns execution/enforcement semantics.

## 28. `/.octon/capabilities/runtime/skills/manifest.yml`

- Authority level: `canonical` discovery metadata
- Why it matters:
  - Concrete example of progressive disclosure and centralized skill registration.
- Distilled key points:
  - Skills are globally registered in a root-harness manifest.
  - Discovery metadata is centralized today.

## 29. `/.octon/capabilities/runtime/skills/registry.yml`

- Authority level: `canonical` extended metadata
- Why it matters:
  - Shows where execution metadata, I/O paths, and operational state declarations currently live.
- Distilled key points:
  - Skills declare I/O, outputs, and operational artifacts centrally.
  - Output and state paths are validated against repository scope.

## 30. `/.octon/engine/README.md`

- Authority level: `reference`
- Why it matters:
  - States engine invariants crisply.
- Distilled key points:
  - `engine/runtime/` is the only executable authority surface.
  - `engine/governance/` is normative runtime policy.

## 31. `/.octon/engine/governance/README.md`

- Authority level: `canonical` domain governance index
- Why it matters:
  - Defines boundary between engine enforcement and capabilities semantics.
- Distilled key points:
  - Engine wins when execution semantics conflict with capability declarations.
  - Unresolved conflicts fail closed.

## 32. `/.octon/engine/governance/instruction-layer-precedence.md`

- Authority level: `canonical`
- Why it matters:
  - Shows how instruction precedence and missing metadata are handled.
- Distilled key points:
  - Higher-precedence instruction layers cannot be overridden by lower ones.
  - Ambiguous or incomplete precedence metadata fails closed.

## 33. `/.octon/engine/governance/runtime-capability-authority-boundary.md`

- Authority level: `canonical`
- Why it matters:
  - Helps determine where a future local-sidecar rule would belong.
- Distilled key points:
  - Execution behavior belongs to engine.
  - Capability identity/requirements belong to capabilities.

## 34. `/.octon/cognition/governance/principles/locality.md`

- Authority level: `canonical` operational principle guide
- Why it matters:
  - Main current source supporting locality as a design principle.
- Distilled key points:
  - Context should live close to where it is needed.
  - The same document both endorses hierarchical/local harness examples and warns against inventing alternate harness roots.
  - This is a real ambiguity, not a clean settled rule.

## 35. `/.octon/cognition/governance/principles/progressive-disclosure.md`

- Authority level: `canonical`
- Why it matters:
  - Important for any future discovery model.
- Distilled key points:
  - Discovery should be layered and explicit.
  - Full detail should load only when needed.

## 36. `/.octon/cognition/governance/principles/portability-and-independence.md`

- Authority level: `canonical`
- Why it matters:
  - Important for deciding whether local sidecars would harm portability.
- Distilled key points:
  - Core behavior must remain self-contained under `/.octon/`.
  - Optional adapters must not redefine core behavior.

## 37. `/.octon/cognition/governance/principles/deny-by-default.md`

- Authority level: `canonical`
- Why it matters:
  - Important for fail-closed local-sidecar design.
- Distilled key points:
  - Unknown or ambiguous permissions are denied.
  - Exceptions must be explicit, scoped, and time-boxed.

## 38. `/.octon/cognition/runtime/decisions/010-single-root-capability-structure.md`

- Authority level: `canonical` ADR
- Why it matters:
  - Strongest current decision favoring a single root organized by capability/function.
- Distilled key points:
  - Octon intentionally consolidated former split roots into a single `.octon/`.
  - Portability moved into metadata, not directory splits.

## 39. `/.octon/cognition/runtime/decisions/036-cognition-sidecar-section-index-architecture.md`

- Authority level: `canonical` ADR
- Why it matters:
  - Demonstrates current accepted meaning of one kind of sidecar in Octon.
- Distilled key points:
  - Sidecars are accepted today for discovery metadata next to canonical docs.
  - They are used to reduce duplication, not create new authority roots.

## 40. `/.octon/cognition/runtime/decisions/044-intent-contract-and-boundary-enforcement.md`

- Authority level: `canonical` ADR
- Why it matters:
  - Shows how seriously Octon treats machine-readable boundary enforcement.
- Distilled key points:
  - Intent and boundary enforcement are first-class.
  - Missing or invalid boundary binding must fail closed.

## 41. `/.octon/cognition/runtime/decisions/047-self-contained-bootstrap-and-ingress-adapters.md`

- Authority level: `canonical` ADR
- Why it matters:
  - Reaffirms that authored bootstrap governance lives in `/.octon/`.
- Distilled key points:
  - Repo-root ingress files are generated adapters.
  - The canonical authored bootstrap model is self-contained within `/.octon/`.
