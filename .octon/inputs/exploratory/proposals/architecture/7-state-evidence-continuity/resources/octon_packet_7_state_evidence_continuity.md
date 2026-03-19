# Packet 7 — State, Evidence, and Continuity

**Proposal design packet for ratifying, normalizing, and implementing the `state/**` class root inside Octon's five-class Super-Root architecture.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Mutable operational truth, retained evidence, continuity placement, control-state boundaries, retention-governed evidence classes, and migration sequencing into `state/**`
- **Implementation order:** 7 of 15 in the ratified proposal sequence
- **Primary outcome:** Make `state/**` the canonical home for repo continuity, scope continuity, retained evidence, and mutable control state without confusing those surfaces with durable authored authority or rebuildable generated outputs
- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest and Behaviorally Complete Profile Model; Packet 4 — Repo-Instance Architecture; Packet 6 — Locality and Scope Registry
- **Migration role:** Move repo continuity and retained evidence into canonical `state/**` surfaces before scope continuity lands; keep scope continuity blocked until the scope registry and scope validation pipeline are live
- **Current repo delta:** The live repo already exposes the Super-Root and a `state/**` class root, including `/.octon/state/continuity/repo/log.md`, but continuity, memory, and runtime-vs-ops reference docs still retain legacy placement language that points at `/.octon/continuity/**`; this packet ratifies the new class-root placement and closes that contract drift

> **Packet intent:** define the final contract for mutable operational truth and retained evidence so Octon can preserve durable repo authority in `instance/**`, keep raw inputs non-authoritative in `inputs/**`, and keep rebuildable outputs in `generated/**` without losing handoff continuity, run evidence, or operational traceability.

## 1. Why this proposal exists

The ratified Super-Root blueprint depends on a clear distinction between:

- durable repo-owned authority
- mutable operational truth
- retained evidence
- rebuildable generated outputs

Packet 7 exists because the current repository still reflects two partially overlapping models.

On the one hand, the live class-first `/.octon/README.md` already says `state/**` is the canonical home for operational truth and retained evidence. On the other hand, the legacy continuity and memory reference surfaces still describe continuity, runs, and operational decision evidence in pre-ratification locations such as `/.octon/continuity/**`. The runtime-vs-ops contract likewise still allowlists legacy mutable targets such as `/.octon/continuity/**` rather than the final class-rooted `/.octon/state/**` boundary. Packet 7 is the contract that closes that gap and prevents state placement from drifting during implementation.

Without a ratified state packet, teams will continue to answer critical operational questions inconsistently:

- What exactly belongs in `state/**` versus `instance/**`?
- Is active continuity the same thing as retained evidence?
- Where do run receipts, validation receipts, migration receipts, and operational decision evidence live?
- Is extension activation state authored configuration or mutable operational state?
- Can scope continuity exist before scope identity is validated?
- What is safe to reset, compact, retain, or archive?

Packet 7 turns those answers into one enforceable model.

## 2. Problem statement

Octon needs a final state architecture that is:

- class-root aligned
- compatible with single-root authority
- explicit about mutable truth versus durable authored authority
- explicit about retained evidence versus rebuildable generated artifacts
- safe under fail-closed validation and retention governance
- understandable to operators performing resets, migrations, exports, and post-upgrade regeneration

The current repo already proves the need for this packet.

The live continuity README still describes session history, task state, entity state, next actions, decision evidence, and run evidence under a legacy `continuity/` domain path. The live memory map likewise still routes session continuity and run-evidence lifecycle through those older paths. At the same time, the class-first Super-Root now exists and the root README already says `state/**` is where operational truth and retained evidence belong. Packet 7 ratifies the new placement, preserves the working semantics of continuity, and prevents future ambiguity about whether evidence is “just another generated artifact.”

The ratified architecture must also resolve an internal conceptual split that earlier materials handled loosely:

- **continuity** is active resumable work state
- **evidence** is retained, append-oriented operational trace
- **control state** is mutable current-state truth about quarantine and publication

Those are all stateful, but they are not interchangeable.

## 3. Final target-state decision summary

- `state/**` is the canonical class root for mutable operational truth and retained evidence.
- Active continuity lives under `state/continuity/**`.
- Retained evidence lives under `state/evidence/**`.
- Mutable control state lives under `state/control/**`.
- Repo continuity lives under `state/continuity/repo/**`.
- Scope continuity lives under `state/continuity/scopes/<scope-id>/**`.
- Run evidence lives under `state/evidence/runs/**`.
- Operational decision evidence lives under `state/evidence/decisions/**`.
- Validation receipts live under `state/evidence/validation/**`.
- Migration receipts live under `state/evidence/migration/**`.
- Extension active/quarantine state lives under `state/control/extensions/**`.
- Locality quarantine state lives under `state/control/locality/**`.
- `state/**` is authoritative only as operational truth and evidence, not as authored policy/runtime authority.
- `state/**` is excluded from `bootstrap_core` and `repo_snapshot`.
- Repo continuity migration lands before scope continuity.
- Scope continuity may not land until scope registry and scope validation are live.
- Retained evidence is not treated as rebuildable generated output and must not be casually deleted with normal regeneration workflows.

## 4. Scope

This packet does all of the following:

- defines the final placement of active continuity, retained evidence, and control state
- distinguishes continuity, evidence, and control as separate state subdomains
- defines canonical repo and scope continuity paths
- defines canonical evidence classes for runs, decisions, validation, and migration
- defines the desired-versus-actual extension state split where `instance/extensions.yml` remains authored desired configuration and `state/control/extensions/active.yml` is derived operational truth
- defines reset, retention, and migration implications for stateful artifacts
- defines fail-closed and quarantine expectations for stateful operational surfaces
- defines the sequencing rule that repo continuity lands before scope continuity

## 5. Non-goals

This packet does **not** do any of the following:

- re-litigate the five-class Super-Root
- re-litigate whether durable repo authority belongs in `instance/**`
- make state an authored governance or runtime authority surface
- redefine ADRs as mutable state
- redefine proposals as evidence or continuity state
- treat retained evidence as rebuildable generated output
- create a generic `memory/` directory
- change the ratified locality rule that one path resolves to zero or one active scope in v1
- introduce descendant-local `.octon/` roots or local sidecars

## 6. Canonical paths and artifact classes

**`state/continuity/repo/log.md`**  
Class: State  
Authority: operational truth  
Mutability: append-only  
Purpose: chronological repo-wide session log and handoff narrative

**`state/continuity/repo/tasks.json`**  
Class: State  
Authority: operational truth  
Mutability: read-write  
Purpose: structured task state for repo-wide or cross-scope work

**`state/continuity/repo/entities.json`**  
Class: State  
Authority: operational truth  
Mutability: read-write  
Purpose: tracked entity state used during execution and coordination

**`state/continuity/repo/next.md`**  
Class: State  
Authority: operational truth  
Mutability: read-write  
Purpose: immediate actionable next steps for resumption

**`state/continuity/scopes/<scope-id>/{log.md,tasks.json,entities.json,next.md}`**  
Class: State  
Authority: operational truth  
Mutability: mixed append-only and read-write, matching repo continuity semantics  
Purpose: scope-bound active work state

**`state/evidence/runs/**`**  
Class: State  
Authority: retained operational evidence  
Mutability: append-oriented / retention-governed  
Purpose: run receipts, digests, and other execution evidence

**`state/evidence/decisions/repo/**`**  
Class: State  
Authority: retained operational evidence  
Mutability: append-oriented / retention-governed  
Purpose: repo-level allow/block/escalate and other operational decision evidence

**`state/evidence/decisions/scopes/<scope-id>/**`**  
Class: State  
Authority: retained operational evidence  
Mutability: append-oriented / retention-governed  
Purpose: scope-level operational decision evidence

**`state/evidence/validation/**`**  
Class: State  
Authority: retained operational evidence  
Mutability: append-oriented / retention-governed  
Purpose: validation receipts and enforcement evidence that must survive regeneration

**`state/evidence/migration/**`**  
Class: State  
Authority: retained operational evidence  
Mutability: append-oriented / retention-governed  
Purpose: migration receipts, conversion evidence, and rollback traceability

**`state/control/extensions/active.yml`**  
Class: State  
Authority: operational control truth  
Mutability: read-write / replaceable via publication  
Purpose: actual active extension state derived from the authored desired configuration and successful validation/publication

**`state/control/extensions/quarantine.yml`**  
Class: State  
Authority: operational control truth  
Mutability: read-write  
Purpose: blocked packs, affected dependents, reason codes, and acknowledgements

**`state/control/locality/quarantine.yml`**  
Class: State  
Authority: operational control truth  
Mutability: read-write  
Purpose: quarantined scopes and locality validation outcomes

## 7. Authority and boundary implications

- `state/**` is authoritative only for operational truth, retained evidence, and mutable control state.
- `state/**` is **not** an authored runtime, governance, or policy surface.
- `instance/**` remains the authoritative home for durable repo-owned authored artifacts such as locality manifests, durable context, ADRs, and desired extension configuration.
- `generated/**` remains the home for rebuildable outputs only.
- `inputs/**` remains non-authoritative and may not be used directly by runtime or policy consumers.
- Continuity is the live handoff/resumption layer, not the canonical store for architecture decisions.
- Evidence is durable operational trace, not an active task ledger.
- Control state records the currently active or quarantined publication state for mutable operational subsystems; it is not the authored desired configuration.

## 8. Ratified state, evidence, and continuity model

### 8.1 State class semantics

The ratified model treats `state/**` as a **class root**, not as one undifferentiated bucket.

It has three subdomains:

- `state/continuity/**` — active work state
- `state/evidence/**` — retained operational trace and receipts
- `state/control/**` — mutable control truth about current publication and quarantine state

This distinction matters because all three are stateful, but they have different lifecycle rules:

- continuity is actively updated during work
- evidence is append-oriented and retention-governed
- control state is the current operational truth about what is published, blocked, or acknowledged

### 8.2 Continuity model

#### Repo continuity

Canonical placement:

```text
state/continuity/repo/**
```

Repo continuity owns active work state that is:

- repo-wide
- cross-scope
- orchestration-wide
- not cleanly reducible to one scope

#### Scope continuity

Canonical placement:

```text
state/continuity/scopes/<scope-id>/**
```

Scope continuity owns active work state that is:

- clearly bound to one ratified scope
- best resumed from scope-local handoff context
- not required as repo-wide primary truth

#### One-primary-home rule

Detailed active state for a work item must have **one primary home**.

- If work is cross-scope or repo-wide, the primary home is repo continuity.
- If work is stable and clearly bound to one scope, the primary home is that scope's continuity.
- Repo continuity may summarize or link scope work, but it must not become a duplicate detailed ledger for the same scope-local task state.

### 8.3 Evidence model

Canonical placement:

```text
state/evidence/**
```

Evidence is retained because it supports:

- traceability
- auditability
- incident analysis
- validation history
- migration history
- safety receipts

#### Run evidence

Canonical placement:

```text
state/evidence/runs/**
```

This owns run receipts, digests, and other execution-evidence artifacts that must survive output regeneration.

#### Operational decision evidence

Canonical placement:

```text
state/evidence/decisions/**
```

This owns allow/block/escalate and other operational decision evidence. It is not an ADR surface and must not be treated as one.

#### Validation evidence

Canonical placement:

```text
state/evidence/validation/**
```

This owns receipts proving why a failed-closed or successful validation outcome occurred.

#### Migration evidence

Canonical placement:

```text
state/evidence/migration/**
```

This owns receipts, provenance, and rollback context for architecture and schema migrations.

### 8.4 Control-state model

Canonical placement:

```text
state/control/**
```

Control state holds current mutable truth about operational publication state.

#### Desired versus actual extension state

The ratified extension model now distinguishes four layers:

1. `instance/extensions.yml` — desired authored configuration
2. `state/control/extensions/active.yml` — actual active operational state
3. `state/control/extensions/quarantine.yml` — blocked/quarantined state
4. `generated/effective/extensions/**` — published compiled outputs

This packet owns layers 2 and 3.

#### Locality quarantine state

Canonical placement:

```text
state/control/locality/quarantine.yml
```

This is the mutable current-state record for invalid or blocked scopes. It is not the source-of-truth for scope identity. That remains in `instance/locality/**`.

### 8.5 Relationship to ADRs and durable context

The following remain **outside** `state/**`:

- durable repo context
- scope durable context
- ADRs
- memory policy

Canonical placements remain:

- `instance/cognition/context/**`
- `instance/cognition/decisions/**`
- `framework/agency/governance/MEMORY.md`

Packet 7 therefore reinforces the memory-routing principle: mutable work state and retained operational evidence do not become cognition authority.

### 8.6 Relationship to generated outputs

The following remain **outside** `state/**` because they are rebuildable:

- effective indexes
- graphs
- projections
- summaries
- proposal registries

Canonical placement remains:

```text
generated/**
```

If an artifact can be reconstructed from authoritative sources and generators, it is not state. If it must survive regeneration as retained evidence or operational truth, it belongs in `state/**`.

### 8.7 Reset, retention, and lifecycle model

State operations are split deliberately.

#### Reset active state

A standard “reset working state” workflow may reset:

- `state/continuity/**`
- selected `state/control/**` records where safe and explicitly governed

It must **not** blindly purge retained evidence.

#### Retention and compaction

Evidence under `state/evidence/**` is retention-governed. Cleanup and compaction must be handled by explicit retention workflows, not by generic reset or regeneration commands.

#### Generated regeneration

Deleting and rebuilding `generated/**` must never delete `state/**`.

### 8.8 Explicitly rejected state models

The following are rejected:

- using `state/**` as a second authored governance surface
- keeping retained evidence under `generated/**`
- keeping scope continuity inside `instance/**`
- treating operational decision evidence as ADRs
- using `state/**` as a generic memory bucket
- introducing a separate root-level `.octon.state/`

## 9. Schema, manifest, and contract changes required

### State class contract

Ratify `state/**` as a first-class Super-Root class with these required subdomains:

- `continuity/`
- `evidence/`
- `control/`

### Continuity artifact schemas

Canonical schemas should exist for:

- `log.md` semantics
- `tasks.json`
- `entities.json`
- `next.md`

The same schema family may be used for repo continuity and scope continuity, with placement and ownership deciding scope.

### Evidence schemas

Schema families must exist or be extended for:

- run evidence
- operational decision evidence
- validation receipts
- migration receipts

### Control-state schemas

Required schemas:

- `state/control/extensions/active.yml`
- `state/control/extensions/quarantine.yml`
- `state/control/locality/quarantine.yml`

### Related contracts that must be updated

- the memory map must be rewritten to route active continuity and retained evidence through `state/**`
- continuity docs must be updated from legacy `.octon/continuity/**` placement to the class-rooted `state/continuity/**` model
- runtime-vs-ops contract must be updated so mutable allowlists and examples recognize `/.octon/state/**` and declared `/.octon/generated/**` targets instead of the legacy `/.octon/continuity/**` default
- extension packet contracts must reference the desired/actual/quarantine/compiled split
- migration contracts must define how legacy continuity and evidence paths rehome into `state/**`

## 10. Validation, assurance, and fail-closed implications

Validation must enforce all of the following:

- `state/**` writes are allowed only for governed automation and only to declared mutable targets
- continuity artifacts must conform to canonical continuity schemas
- evidence artifacts must conform to their evidence schemas and retention rules
- scope continuity must not exist for undeclared or invalid `scope_id`s
- `state/control/extensions/active.yml` must correspond to a valid published generation under `generated/effective/extensions/**`
- quarantined extension or locality state must be visible in `state/control/**`
- generated outputs must not be mistaken for state and state must not be treated as rebuildable output
- any undeclared state write target fails closed

### Fail-closed behavior

- invalid repo continuity shape blocks continuity publication/validation
- invalid scope continuity blocks only the affected scope path, not unrelated repo continuity
- invalid extension active state blocks extension publication and forces fallback to framework+instance native behavior
- invalid quarantine state blocks publication rather than being silently ignored
- invalid evidence placement fails validation rather than allowing ad hoc receipts to accumulate in mixed locations

## 11. Portability, compatibility, and trust implications

- `state/**` is excluded from `bootstrap_core`.
- `state/**` is excluded from `repo_snapshot`.
- `state/**` is preserved in full-fidelity repo clones.
- `state/**` is never part of the portable framework bundle.
- `state/**` is repo-specific by default.
- Trust policy does not live in `state/**`; trust decisions remain in authored control metadata such as `instance/extensions.yml`.
- Compatibility state for runtime publication is reflected through generated locks and control-state publication, not by treating stateful artifacts as portable core inputs.

## 12. Migration and rollout implications

### Migration work authorized by this packet

- ratify `state/continuity/**`, `state/evidence/**`, and `state/control/**` as canonical class-rooted state surfaces
- move legacy repo continuity artifacts into `state/continuity/repo/**`
- move legacy run evidence and operational decision evidence into `state/evidence/**`
- introduce control-state records for extension active/quarantine state and locality quarantine state
- update memory, continuity, and runtime-vs-ops docs to reference the new class-root placements

### Important sequencing rules

Packet 7 must land after:

- Packet 1 — Super-Root Semantics and Taxonomy
- Packet 2 — Root Manifest and Behaviorally Complete Profile Model
- Packet 4 — Repo-Instance Architecture
- Packet 6 — Locality and Scope Registry

Packet 7 must land before:

- Packet 8 — Inputs/Additive/Extensions (desired/actual/quarantine publication model)
- Packet 10 — Memory, Context, ADRs, and Operational Decision Evidence
- Packet 13 — Validation, Fail-Closed, Quarantine, and Staleness
- Packet 15 — Migration and Rollout

### Explicit sequencing rule for continuity

1. move **repo continuity** into `state/continuity/repo/**`
2. move retained run/decision evidence into `state/evidence/**`
3. ratify locality under `instance/locality/**` and ship scope validation
4. only then introduce **scope continuity** under `state/continuity/scopes/**`

## 13. Dependencies and suggested implementation order

- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest and Behaviorally Complete Profile Model; Packet 4 — Repo-Instance Architecture; Packet 6 — Locality and Scope Registry
- **Suggested implementation order:** 7
- **Blocks:** desired/actual extension-state ratification, memory-routing finalization, validation cutover, and migration completion

## 14. Acceptance criteria

- `state/**` is ratified as the canonical class root for mutable operational truth and retained evidence.
- Repo continuity lives under `state/continuity/repo/**`.
- Scope continuity lives under `state/continuity/scopes/**`, but only after locality registry and validation are live.
- Run evidence, operational decision evidence, validation receipts, and migration receipts live under `state/evidence/**`.
- Extension active state and quarantine state live under `state/control/extensions/**`.
- Locality quarantine state lives under `state/control/locality/**`.
- `instance/extensions.yml` is explicitly treated as desired authored configuration, not actual active state.
- Evidence is no longer conflated with generated output.
- Active continuity is no longer conflated with retained evidence.
- Reset and regeneration workflows can distinguish what is safe to clear, what must be retained, and what must be rebuilt.
- Teams no longer need to infer whether continuity, evidence, or control state belongs under legacy mixed domain paths.

## 15. Supporting evidence to reference

- Current `/.octon/README.md` — live class-root statement that `state/**` owns operational truth and retained evidence
- Current `/.octon/state/continuity/repo/log.md` — live repo continuity scaffold inside the class-rooted state surface
- Current `/.octon/cognition/runtime/context/memory-map.md` — legacy routing baseline that still needs class-rooted updates
- Current `/.octon/continuity/README.md` — legacy continuity placement that this packet replaces
- Current `/.octon/cognition/_meta/architecture/runtime-vs-ops-contract.md` — mutation allowlist and fail-closed baseline that must be updated to recognize `state/**`
- Ratified Super-Root blueprint — sections on state, generated outputs, extension desired/actual/quarantine state, memory routing, and migration sequencing

Reference URLs:

- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/README.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/state/continuity/repo/log.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/cognition/runtime/context/memory-map.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/continuity/README.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/cognition/_meta/architecture/runtime-vs-ops-contract.md>
- <https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/extensions.yml>

## 16. Settled decisions that must not be re-litigated

- `state/**` is the canonical class root for mutable operational truth and retained evidence.
- `state/**` is not an authored governance or runtime authority surface.
- Active continuity belongs in `state/continuity/**`.
- Retained evidence belongs in `state/evidence/**`.
- Mutable control state belongs in `state/control/**`.
- Scope continuity does not land before locality registry and validation.
- ADRs remain in `instance/**`.
- Generated outputs remain in `generated/**`.
- There is no generic `memory/` surface.
- There is no descendant-local continuity topology outside the root-owned scope model.

## 17. Remaining narrow open questions

None. This packet is ratified for proposal drafting and ready to move into formal architecture proposal authoring.
