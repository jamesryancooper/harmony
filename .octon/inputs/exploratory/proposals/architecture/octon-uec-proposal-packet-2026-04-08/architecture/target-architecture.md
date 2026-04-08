# Target Architecture: Full Unified Execution Constitution

## 1. Target-State Statement

The target state is **not** a repository constitution with execution features attached. It is a **fully unified execution constitution** in which Octon’s constitutional rules, objective model, authority model, runtime lifecycle, evidence regime, disclosure surfaces, proof planes, portability controls, and evolution discipline are all machine-enforced through one coherent repository-local control plane.

The atomic claim permitted after cutover is:

> Octon is a fully attained Unified Execution Constitution for the complete in-scope target support universe, with no unresolved in-scope exclusions, no shadow authority surfaces, no partial implementations, and dual-pass evidence-backed closure certification.

Anything weaker than that is not target-state attainment.

## 2. Semantic Invariants vs Implementation Mechanics

### 2.1 Semantic invariants

Semantic invariants are the truths that must remain valid even if file names, scripts, or internal implementation details change.

- One constitutional kernel governs runtime and policy behavior.
- One legal objective stack exists.
- One canonical authority regime exists.
- One durable run lifecycle exists.
- One tri-class evidence regime exists.
- One truthful disclosure regime exists.
- One complete support universe exists for the target-state claim.
- One full proof + lab regime exists.
- One no-shadow-authority rule exists.
- One dual-pass no-diff certification rule exists.

### 2.2 Implementation mechanics

Implementation mechanics are the concrete repo artifacts that realize the semantic invariants.

- constitutional contracts under `/.octon/framework/constitution/contracts/**`
- repo authority under `/.octon/instance/**`
- run roots under `/.octon/state/control/execution/runs/**`
- evidence roots under `/.octon/state/evidence/**`
- adapter manifests under `/.octon/framework/engine/runtime/adapters/**`
- support targets under `/.octon/instance/governance/support-targets.yml`
- capability packs under `/.octon/instance/governance/capability-packs/**`
- proof suites under `/.octon/framework/assurance/**`
- lab surfaces under `/.octon/framework/lab/**`
- disclosure surfaces under `/.octon/state/evidence/disclosure/**`
- generated effective views under `/.octon/generated/effective/**`
- CI enforcement under `/.github/workflows/**`

Implementation mechanics may evolve. Semantic invariants may not.

## 3. Post-Cutover Authority Status (Unambiguous)

| Surface | Post-cutover status | Governed domain | Can gate runtime/policy? | Derives from | Can ever become authoritative without explicit promotion? |
| --- | --- | --- | --- | --- | --- |
| `/.octon/framework/constitution/**` | authoritative | portable constitutional kernel, contracts, precedence, obligations | yes | n/a | yes |
| `/.octon/instance/**` | authoritative | repo-specific durable authority: workspace charter, missions, governance, support targets, decisions | yes | n/a | yes |
| `/.octon/state/control/execution/runs/**` | authoritative operational truth | run-time control truth for bound consequential execution | yes | n/a | yes |
| `/.octon/state/evidence/**` | authoritative retained evidence | retained evidence, receipts, replay indexes, measurements, interventions, disclosure | no runtime authority; yes evidence authority | n/a | no |
| `/.octon/state/evidence/disclosure/runs/**/run-card.yml` | authoritative disclosure | truthful run disclosure generated from canonical run/evidence surfaces | no | `run-contract.yml`, `run-manifest.yml`, evidence roots | no |
| `/.octon/state/evidence/disclosure/releases/**/harness-card.yml` | authoritative release disclosure | truthful release/support claim disclosure | no | support-target matrix + proof bundle + closure bundle | no |
| `/.octon/generated/**` | non-authoritative | rebuildable effective views and indexes | no | authored authority + state/evidence | no |
| `/.octon/inputs/**` | non-authoritative | additive and exploratory inputs only | no | n/a | no |
| proposal packet artifacts | non-authoritative | planning and ratification input only | no | n/a | no |
| `/AGENTS.md`, `/CLAUDE.md`, `/.octon/AGENTS.md` | non-authoritative thin adapters | tool-facing ingress mirrors only | no | `/.octon/instance/ingress/AGENTS.md` | no |
| `.claude/**`, `.codex/**`, `.cursor/**` | non-authoritative projections/overlays | tool/runtime-specific overlays only | no unless explicitly promoted | canonical ingress + contracts | no |
| GitHub labels/comments/checks, CI status, Studio UI projection | non-authoritative host projection | projection of canonical authority and runtime state | no | canonical authority artifacts + run state | no |

## 4. Constitutional Layer

### 4.1 What Octon is
Octon is a governed autonomous engineering harness whose actual operational identity is the Unified Execution Constitution anchored in repository-local authored authority and durable run/evidence state.

### 4.2 What Octon is for
It exists to turn model capability into governed action that is durable under model change, maintainable over long horizons, replayable, auditable, and explicit about authority and proof.

### 4.3 What Octon is not
It is not:
- a prompt pack
- a GitHub-label constitution
- a persona/roleplay shell
- a documentation corpus with optional runtime glue
- a bounded-support release that markets itself as universal completion

### 4.4 Non-negotiable obligations
- fail closed on missing authority, missing proof, unsupported support-target tuples, or unresolved shadow authority
- retain evidence and disclosure sufficient for replay and audit
- keep generated outputs non-authoritative
- keep host projections non-authoritative
- keep proposal packets non-authoritative
- never allow in-scope exclusions to coexist with a universal-complete claim

## 5. Objective / Intent Layer

The only legal objective stack after cutover is:

1. `workspace charter pair`
2. `mission charter pair` when mission-backed continuity is required
3. `run contract`
4. `stage attempt`

### 5.1 Workspace charter
Repo-wide durable narrative and machine objective authority.

### 5.2 Mission charter
Continuity container for overlapping, recurring, or long-horizon autonomy.

### 5.3 Run contract
Atomic consequential execution binding. No consequential work exists outside a run contract.

### 5.4 Stage attempt
Retry, staged execution, resumption, and checkpoint context subordinate to the bound run.

### 5.5 Illegal states
The following become invalid:
- `requires_mission: true` with `mission_id: null`
- `mission_mode: none` on a mission-required run
- any stage attempt not subordinate to an existing run root
- any consequential action whose objective source is only a bootstrap or compatibility shim

## 6. Durable Control Layer

### 6.1 Super-root
The class-root super-root remains:

- `framework/` — portable authored core
- `instance/` — repo-specific authored authority
- `inputs/` — additive, exploratory, non-authoritative inputs
- `state/` — operational truth and retained evidence
- `generated/` — rebuildable outputs only

### 6.2 Dual precedence
Both normative and epistemic precedence remain constitutionally required, but they become operational only through one runtime-resolved effective precedence output.

### 6.3 Overlay discipline
Overlays may exist only as non-authoritative mirrors or optional local projections. They may not contain new runtime or policy authority.

## 7. Policy / Authority Layer

### 7.1 Canonical artifacts
The live authority regime uses only:
- ApprovalRequest
- ApprovalGrant
- ExceptionLease
- Revocation
- QuorumPolicy
- DecisionArtifact
- grant bundles / authority bundles

### 7.2 Human / model / runtime / host boundaries
- humans define or approve authority where constitutionally required
- models reason inside the harness; they do not mint authority
- runtime/governance surfaces mint canonical authority artifacts
- hosts project canonical state; they never originate it

### 7.3 Fail-closed routing
Every action route must terminate in one of:
- `allow`
- `stage_only`
- `escalate`
- `deny`

Anything outside an admitted support tuple or without sufficient authority artifacts fails closed.

## 8. Runtime Layer

### 8.1 Run-first lifecycle
Octon’s canonical execution primitive is the run, not the mission and not the conversation.

### 8.2 Consequential binding
Before side effects:
- canonical run control root exists
- canonical evidence root exists
- runtime state exists
- rollback posture exists
- checkpoint root exists
- contamination root exists
- retry records root exists
- decision and authority bundle refs exist

### 8.3 Event-sourced or equivalently durable behavior
A run must remain resumable from persisted state and event/evidence lineage, not from fragile chat continuity.

### 8.4 Rollback and contamination
Rollback/compensation posture and contamination handling are explicit run-root artifacts, not implied operational behavior.

## 9. Evidence, Replay, and Retention Layer

### 9.1 Evidence classes
The only legal evidence classes are:

- `git-inline`
- `git-pointer`
- `external-immutable`

### 9.2 Replay rules
External immutable evidence is not “modeled” only. It is proven through hash-linked write, retrieval, and restore evidence.

### 9.3 Intervention and measurement
Intervention records and measurement records are complete or the claim fails.

## 10. Verification / Evaluation Layer

### 10.1 Required proof planes
- structural
- functional
- behavioral
- governance
- maintainability
- recovery

### 10.2 Evaluator independence
Held-out checks, evaluator separation, and anti-overfitting controls are mandatory where claims extend beyond deterministic verification.

## 11. Lab Layer

The lab is a first-class authored domain, distinct from assurance. It contains:
- scenarios
- replay packs
- shadow runs
- faults
- probes
- governance/runtime experiment surfaces

Lab assets are not decorative. They must feed behavioral proof and retained lab evidence.

## 12. Disclosure Layer

### 12.1 RunCard
Mandatory per-run disclosure artifact.

### 12.2 HarnessCard
Mandatory release-level disclosure artifact.

### 12.3 Universal completion rule
A HarnessCard may represent Octon as **fully attained** only if:
- admitted universe == target universe
- no in-scope exclusions remain
- all proof planes are green
- dual-pass certification is green
- no audit findings remain open

## 13. Portability / Adapter Layer

### 13.1 Portable kernel
The kernel remains repo-local but portable in design through formal contracts.

### 13.2 Model adapter contract
Model portability is mediated only through the model adapter contract and conformance suites.

### 13.3 Host adapter contract
Host integrations remain adapters, not authority sources.

### 13.4 Capability packs
Browser/UI and API action surfaces arrive only through governed capability packs with explicit route and approval semantics.

## 14. Post-Cutover Target Support Universe

| Dimension | Full target-state admitted universe |
| --- | --- |
| Model tiers | repo-local-governed, frontier-governed |
| Host adapters | repo-shell, github-control-plane, ci-control-plane, studio-control-plane |
| Workload tiers | observe-and-read, repo-consequential, boundary-sensitive |
| Language/resource tiers | reference-owned, extended-governed |
| Locale tiers | english-primary, spanish-secondary |
| Capability packs | repo, git, shell, telemetry, browser, api |

This is the **target universe** for the full-attainment claim. If any element remains excluded, the claim cannot be universal-complete.

## 15. No-Shadow-Authority Rule

The following classes of artifact are permanently barred from becoming live authority unless explicitly promoted through authored authority with matching validator changes:

- proposal packets
- generated indexes and registries
- exploratory inputs
- release notes and marketing copy
- root or tool-specific ingress mirrors
- host-native status surfaces
- archived compatibility artifacts

## 16. Success Condition

Octon reaches the target architecture only when every invariant in `architecture/unified-execution-constitution-invariants.md` is green, every finding in `architecture/current-state-gap-map.md` is closed, and the cutover is certified by the dual-pass no-diff program in `architecture/closure-certification-plan.md`.
