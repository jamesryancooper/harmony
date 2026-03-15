# Constraint And Invariant Brief

This brief states what must remain true if Octon evolves and where ambiguity still needs resolution.

Labels:

- `Constraint`: must remain true or must not be violated.
- `Ambiguity`: current repository signals conflict or remain incomplete.
- `Inference`: reasoned implication for architecture work.

## 1. Non-Negotiable Constraints

### 1.1 Canonical authority must remain unambiguous

- `Constraint`: `/.octon/` remains the canonical repository-level governance and control surface unless Octon first changes that architecture explicitly.
- `Constraint`: proposal material must not be treated as canonical authority.
- `Constraint`: generated or effective surfaces must not silently replace source-of-truth ownership.

### 1.2 Fail-closed governance must survive

- `Constraint`: unknown, invalid, ambiguous, or unevaluable local-sidecar behavior must fail closed.
- `Constraint`: new local surfaces must not bypass deny-by-default, no-silent-apply, intent binding, or evidence requirements.
- `Constraint`: any discovery, precedence, or inheritance model must block on ambiguity rather than guess.

### 1.3 Runtime vs `_ops` separation must survive

- `Constraint`: executable/discovery runtime authority remains in `runtime/`.
- `Constraint`: operational support and mutable state remain in `_ops/`.
- `Constraint`: local-sidecar design must not reintroduce `_ops/` as a shadow canonical runtime or governance layer.

### 1.4 Portability/self-containment defaults must survive

- `Constraint`: Octon core behavior must remain self-contained under `/.octon/`.
- `Constraint`: any optional specialization layer must not redefine Octon core behavior.
- `Constraint`: any local-sidecar model must be explainable in `octon.yml` and related contracts if it affects portability or discovery.

### 1.5 Memory and cognition ownership boundaries must survive

- `Constraint`: memory policy remains governed from agency governance, not from ad hoc local notes.
- `Constraint`: active execution state remains distinct from durable context, ADRs, decision evidence, graph data, and projections.
- `Constraint`: graph and projection surfaces remain derived unless explicitly redesigned through canonical contract changes.

### 1.6 `/.extensions/` proposal constraints must be considered directly

- `Constraint`: if `/.extensions/` is adopted, it is currently proposed as root-only, additive, and non-authoritative with respect to governance.
- `Constraint`: any descendant-local sidecar concept must explain whether it is separate from, built on, or incompatible with `/.extensions/`.
- `Constraint`: the downstream agent must not assume `/.extensions/` packs can contain governance, methodology, agency, orchestration, or mutable runtime state under the current proposal framing.

## 2. What Must Not Be Violated

- `Constraint`: do not create a second hidden authority root that competes with `/.octon/`.
- `Constraint`: do not duplicate canonical norms into local copies without explicit source/projection rules.
- `Constraint`: do not let raw descendant-local or extension source paths become direct runtime-facing dependencies without validated effective-resolution rules.
- `Constraint`: do not mix active work state, durable decisions, and policy authority in a single undifferentiated local bucket unless the model explicitly redefines those concerns.
- `Constraint`: do not weaken auditability, traceability, or portability merely to gain locality convenience.
- `Constraint`: do not let naming metaphors stand in for a topology, precedence model, or validation contract.

## 3. Current Ambiguities To Preserve

### 3.1 Single-root vs hierarchical locality

- `Ambiguity`: strong current architecture artifacts favor a single repo-root harness.
- `Ambiguity`: the active `Locality` principle includes hierarchical local-harness examples and descendant continuity examples.
- `Inference`: the current repo is not fully internally aligned on whether descendant-local harness-like surfaces are legitimate architecture, transitional examples, or stale guidance.

### 3.2 Scope of local canonicality

- `Ambiguity`: some materials suggest local context should remain under repo-root domain paths.
- `Ambiguity`: some locality examples imply deeper local state isolation.
- `Inference`: the unresolved question is not only "local or central," but "local source," "local projection," or "local state only."

### 3.3 Relationship to `/.extensions/`

- `Ambiguity`: `/.extensions/` solves additive specialization at repo root, but descendant-local sidecars may also solve locality/specialization.
- `Inference`: the downstream agent must determine whether these are:
  - separate layers
  - nested building blocks
  - or redundant concepts

### 3.4 Portability metadata gap

- `Ambiguity`: current `octon.yml` does not yet expose the release/API keys expected by the `/.extensions/` proposal, and it has no local-sidecar model.
- `Inference`: any recommendation that depends on portability-aware descendant-local sidecars would need canonical manifest evolution.

## 4. Implications For The Downstream Recommendation

- `Inference`: a viable local-sidecar model probably needs to keep canonical governance and repo-wide authority in `/.octon/`.
- `Inference`: a viable local-sidecar model must define whether local artifacts are authoritative, projected, or operational-only on a class-by-class basis.
- `Inference`: a viable model should probably reuse current Octon strengths:
  - explicit indexes
  - explicit ownership
  - additive-only composition where possible
  - effective/derived runtime-facing views
  - strict collision and precedence rules
- `Inference`: a recommendation to reject descendant-local sidecars is legitimate if the locality benefits can be achieved through root-harness projections, missions, or `/.extensions/` without introducing a second topology layer.
