# Target Architecture

## Decision

Ratify `/.octon/state/**` as the canonical class root for mutable operational
truth and retained evidence inside the five-class super-root.

The promoted Packet 7 contract requires:

- `state/continuity/**` to be the only canonical home for active resumable
  work state
- `state/evidence/**` to be the only canonical home for retained operational
  trace and receipts
- `state/control/**` to be the canonical home for mutable current-state truth
  about publication, activation, and quarantine
- repo continuity to live under `state/continuity/repo/**`
- scope continuity to live under `state/continuity/scopes/<scope-id>/**` only
  after locality registry and validation are live
- run evidence, operational decision evidence, validation receipts, and
  migration receipts to live under `state/evidence/**`
- extension actual/quarantine state and locality quarantine state to live
  under `state/control/**`
- `instance/extensions.yml` to remain desired authored configuration while
  `state/control/extensions/active.yml` records actual active state and
  `generated/effective/extensions/**` carries the compiled runtime-facing
  publication
- `state/**` to remain outside authored governance/runtime authority and
  outside `bootstrap_core` and `repo_snapshot`
- reset, retention, and regeneration workflows to treat continuity, evidence,
  and control state as different lifecycle classes rather than a single bucket

This proposal does not create a second memory system or a second authored
authority surface. It finishes the class-root boundary the live repository has
already started to implement and makes the remaining placement, validation,
and retention rules machine-enforceable.

## Status

- status: accepted proposal drafted from ratified Packet 7 inputs
- proposal area: mutable operational truth, retained evidence, continuity
  placement, control-state boundaries, retention-governed evidence classes,
  and migration sequencing into `state/**`
- implementation order: 7 of 15 in the ratified proposal sequence
- dependencies:
  - `super-root-semantics-and-taxonomy`
  - `root-manifest-profiles-and-export-semantics`
  - `repo-instance-architecture`
  - `locality-and-scope-registry`
- migration role: normalize repo continuity and retained evidence under
  `state/**`, then keep scope continuity gated on the locality registry and
  scope-validation pipeline

## Why This Proposal Exists

Packet 1 ratified the five-class super-root. Packet 4 ratified `instance/**`
as durable repo-owned authority. Packet 6 ratified scope identity under
`instance/locality/**` and the rule that scope continuity may not land before
locality validation. Packet 7 is the contract that makes the remaining mutable
surfaces coherent.

The live repository is already partway into the target state:

- `.octon/README.md` already identifies `state/**` as the class root for
  operational truth and retained evidence.
- Repo continuity already exists at
  `.octon/state/continuity/repo/{log.md,tasks.json,entities.json,next.md}`.
- Run, validation, and migration evidence already live under
  `.octon/state/evidence/**`.
- Extension and locality control state already live under
  `.octon/state/control/{extensions,locality}/`.

What remains is contract drift. The current repository still contains
partially overlapping explanations of continuity and evidence, and those
surfaces do not yet express the full packet-7 model consistently.

### Current Live Signals This Proposal Must Normalize

| Current live signal | Current live source | Ratified implication |
| --- | --- | --- |
| `state/**` is already declared the class-rooted home for operational truth and retained evidence | `.octon/README.md` | Packet 7 must ratify and normalize the live state root rather than invent a competing mutable surface |
| Repo continuity already exists in the class-rooted state surface | `.octon/state/continuity/repo/{log.md,tasks.json,entities.json,next.md}` | Repo continuity should be stabilized in place and become the canonical migration anchor for later scope continuity |
| Evidence already lives outside `generated/**` | `.octon/state/evidence/{runs,validation,migration}/**` and `.octon/state/evidence/decisions/repo/**` | Evidence must be explicitly treated as retained operational trace, not as rebuildable generated output |
| Extension and locality control state already exist as stateful records | `.octon/state/control/extensions/{active,quarantine}.yml` and `.octon/state/control/locality/quarantine.yml` | Desired, actual, quarantine, and compiled extension state must be made explicit and validator-enforced |
| Memory routing already points active work state and run evidence into `state/**` | `.octon/instance/cognition/context/shared/memory-map.md` | Memory routing must distinguish continuity, evidence, control state, durable context, and ADRs at packet-7 granularity |
| Runtime-vs-ops already allows writes into `state/control/**`, `state/evidence/**`, and repo continuity only | `.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md` | Mutation policy must recognize the full class-rooted state boundary and future scope continuity rather than a repo-continuity special case alone |
| Continuity architecture docs still package decisions and runs as continuity-adjacent append surfaces | `.octon/framework/cognition/_meta/architecture/state/continuity/README.md` and related docs | Packet 7 must separate active continuity from retained evidence without losing the working continuity semantics already in use |
| Scaffolding still exposes continuity artifacts through a `templates/octon/continuity/` path | `.octon/framework/scaffolding/runtime/templates/octon/continuity/**` | Promotion work must align scaffolding and generated guidance with the final `state/**` placement contract |

## Problem Statement

Octon needs a final state architecture that is:

- class-root aligned
- compatible with single-root authority
- explicit about mutable operational truth versus durable authored authority
- explicit about retained evidence versus rebuildable generated outputs
- safe under fail-closed validation and retention governance
- understandable to operators performing resets, migrations, exports, and
  post-upgrade regeneration

The critical ambiguity Packet 7 resolves is that "stateful" is not one
lifecycle. Continuity, evidence, and control state all change over time, but
they are not interchangeable:

- continuity is live resumable work state
- evidence is retained trace and receipts
- control state is the current operational truth for publication and
  quarantine

Without that split, teams cannot answer basic operational questions
deterministically:

- what can be reset safely
- what must survive regeneration
- what belongs in `instance/**` versus `state/**`
- what is desired configuration versus actual active state
- when scope-local state is legal
- where validators, migration tools, and audits should look for receipts

## Scope

- define the authoritative meaning of `state/**` inside the super-root
- define `state/continuity/**`, `state/evidence/**`, and `state/control/**`
  as distinct lifecycle subdomains
- define canonical repo and scope continuity paths
- define canonical evidence classes for runs, operational decisions,
  validation, and migration
- define the desired-versus-actual extension state split
- define reset, retention, and portability rules for stateful artifacts
- define fail-closed validation and quarantine expectations for mutable state
- preserve the repo-before-scope continuity sequencing rule

## Non-Goals

- re-litigating the five-class super-root
- re-litigating whether durable repo authority belongs in `instance/**`
- turning `state/**` into a second authored governance or runtime surface
- redefining ADRs as mutable state
- redefining proposals or raw packs as stateful evidence
- treating retained evidence as rebuildable generated output
- introducing a generic `memory/` directory
- introducing descendant-local `.octon/` roots, local sidecars, or alternate
  scope-continuity topologies

## State Class Contract

### Required State Subdomains

| Path | Authority kind | Lifecycle | Purpose |
| --- | --- | --- | --- |
| `state/continuity/repo/**` | Operational truth | Mixed append-only and mutable | Repo-wide and cross-scope active work state |
| `state/continuity/scopes/<scope-id>/**` | Operational truth | Mixed append-only and mutable | Scope-bound active work state for one valid scope |
| `state/evidence/runs/**` | Retained operational evidence | Append-oriented and retention-governed | Run receipts, digests, and execution evidence |
| `state/evidence/decisions/repo/**` | Retained operational evidence | Append-oriented and retention-governed | Repo-level operational allow/block/escalate evidence |
| `state/evidence/decisions/scopes/<scope-id>/**` | Retained operational evidence | Append-oriented and retention-governed | Scope-level operational decision evidence |
| `state/evidence/validation/**` | Retained operational evidence | Append-oriented and retention-governed | Validation receipts, enforcement evidence, and audit trace |
| `state/evidence/migration/**` | Retained operational evidence | Append-oriented and retention-governed | Migration receipts, provenance, and rollback context |
| `state/control/extensions/active.yml` | Operational control truth | Read-write, replaceable through governed publication | Actual validated active extension set |
| `state/control/extensions/quarantine.yml` | Operational control truth | Read-write | Blocked packs, affected dependents, reason codes, and acknowledgements |
| `state/control/locality/quarantine.yml` | Operational control truth | Read-write | Quarantined scopes and locality validation outcomes |

Other domain-specific `state/control/**` records already present in the repo
remain compatible when separately ratified by their owning contracts. Packet 7
standardizes the extension and locality control records required by the
super-root blueprint and the lifecycle rules that all control-state records
must follow.

### Continuity Model

Repo continuity lives at:

```text
state/continuity/repo/**
```

It owns active work that is repo-wide, cross-scope, orchestration-wide, or not
cleanly reducible to one scope.

Scope continuity lives at:

```text
state/continuity/scopes/<scope-id>/**
```

It owns active work that is stable, clearly bound to one declared scope, and
best resumed from scope-local context. Scope continuity is illegal until the
locality registry and scope-validation pipeline are canonical and fail closed.

Detailed active work state has one primary home:

- cross-scope or repo-wide work belongs in repo continuity
- stable single-scope work belongs in that scope's continuity
- repo continuity may summarize or link scope work but must not duplicate the
  detailed scope ledger

### Evidence Model

Evidence lives only under:

```text
state/evidence/**
```

Evidence is retained because it supports traceability, auditability, incident
analysis, validation history, migration history, and safety receipts. It is
not an active task ledger and must not be mistaken for generated output.

| Evidence class | Canonical placement | Notes |
| --- | --- | --- |
| Run evidence | `state/evidence/runs/**` | Receipts and digests that must survive generated regeneration |
| Operational decision evidence | `state/evidence/decisions/**` | Operational allow/block/escalate records; never an ADR surface |
| Validation evidence | `state/evidence/validation/**` | Receipts proving why validation passed, failed, or quarantined |
| Migration evidence | `state/evidence/migration/**` | Conversion receipts, provenance, and rollback traceability |

### Control-State Model

Control state records current mutable truth about what is active, blocked, or
quarantined. It is not authored desired configuration.

#### Desired Versus Actual Extension State

| Layer | Canonical path | Role |
| --- | --- | --- |
| Desired authored configuration | `instance/extensions.yml` | Human-authored repo-owned desired state |
| Actual active operational state | `state/control/extensions/active.yml` | Current validated active set and published generation reference |
| Quarantine / withdrawal state | `state/control/extensions/quarantine.yml` | Current blocked state and acknowledgement metadata |
| Runtime-facing compiled outputs | `generated/effective/extensions/**` | Rebuildable effective view consumed by runtime and policy clients |

Publication of `state/control/extensions/active.yml` and
`generated/effective/extensions/**` must be atomic. Runtime may not use a
published extension generation unless the active state, generation lock, and
quarantine state agree.

#### Locality Quarantine State

`state/control/locality/quarantine.yml` is the mutable current-state record
for invalid or blocked scopes. It does not author scope identity. That
authority remains under `instance/locality/**`.

## Boundary Rules

| Surface | Authority status | What it may own | What it may not own |
| --- | --- | --- | --- |
| `instance/**` | Authoritative authored | Durable repo context, ADRs, locality authority, desired extension configuration | Mutable control truth, retained evidence, rebuildable outputs |
| `state/**` | Authoritative operational | Continuity, evidence, and current control state | Authored policy, runtime, governance, or durable architecture decisions |
| `generated/**` | Non-authoritative | Rebuildable effective views, graphs, summaries, registries, and locks | Active task state, retained evidence, desired configuration |
| `inputs/**` | Non-authoritative | Raw additive and exploratory input material | Direct runtime or policy authority |

The memory-routing rule stays intact:

- memory policy remains in `.octon/framework/agency/governance/MEMORY.md`
- durable context remains in `.octon/instance/cognition/context/**`
- ADRs remain in `.octon/instance/cognition/decisions/**`
- mutable operational continuity and evidence remain in `state/**`
- derived summaries, graphs, and projections remain in `generated/**`

## Reset, Retention, And Portability

### Lifecycle Matrix

| Surface class | Standard working-state reset | Retention or compaction | Portability |
| --- | --- | --- | --- |
| `state/continuity/**` | May be reset by explicit working-state reset workflows | Not retention-governed beyond continuity-specific history rules | Excluded from `bootstrap_core` and `repo_snapshot` |
| `state/control/**` | Only selected records may be reset, and only by governed workflows | Current-state truth should be replaced or cleared only with explicit operational semantics | Excluded from `bootstrap_core` and `repo_snapshot` |
| `state/evidence/**` | Must not be purged by generic reset or regeneration commands | Retention-governed cleanup and compaction only | Excluded from `bootstrap_core` and `repo_snapshot` |
| `generated/**` | May be deleted and rebuilt | Rebuilt from authoritative sources and generators | Excluded from `bootstrap_core` and `repo_snapshot`, except as committed generated outputs in the working repo |

State is repo-specific by default. It stays out of the portable framework
bundle and out of behaviorally complete snapshot exports, but it is preserved
in full-fidelity Git clones.

## Validation And Fail-Closed Behavior

Validation must enforce all of the following:

- state writes are allowed only for governed automation and only to declared
  mutable targets
- continuity artifacts conform to canonical continuity schemas
- evidence artifacts conform to their schema families and retention rules
- scope continuity does not exist for undeclared, invalid, or quarantined
  `scope_id` values
- `state/control/extensions/active.yml` references a valid published
  generation under `generated/effective/extensions/**`
- quarantined extension and locality state remains visible under
  `state/control/**`
- generated outputs are never mistaken for state and state is never treated as
  rebuildable output
- any undeclared state write target fails closed

The fail-closed behavior is:

- invalid repo continuity blocks continuity publication and validation
- invalid scope continuity blocks the affected scope path only, not unrelated
  repo continuity
- invalid extension active state blocks extension publication and falls back to
  framework-plus-instance native behavior only
- invalid quarantine state blocks publication rather than being silently
  ignored
- invalid evidence placement fails validation rather than allowing ad hoc
  receipts to accumulate in mixed locations

## Migration And Rollout Sequence

The ratified sequencing rule remains binding:

1. move or normalize repo continuity into `state/continuity/repo/**`
2. move or normalize retained run and decision evidence into
   `state/evidence/**`
3. keep locality under `instance/locality/**` and ship scope validation
4. only then introduce or publish scope continuity under
   `state/continuity/scopes/**`
5. remove legacy continuity-plane wording, mixed-path assumptions, and
   special-case mutation allowlists only after the class-rooted contract is
   canonical

The live repository already contains most of the target-state surfaces. The
remaining work is therefore a normalization and contract-hardening pass, not a
greenfield state migration.
