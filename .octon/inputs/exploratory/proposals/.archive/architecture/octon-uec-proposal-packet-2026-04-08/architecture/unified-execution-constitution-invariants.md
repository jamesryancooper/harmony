# Unified Execution Constitution Invariants

Every invariant below is mandatory for full target-state attainment. Failure of any invariant blocks certification.

## UEC-I001 — Constitutional kernel supremacy

**Invariant.** `/.octon/framework/constitution/**` together with `/.octon/instance/**` is the only authored authority for runtime and policy behavior.

- **Canonical source of truth:** `/.octon/framework/constitution/**`; `/.octon/instance/**`
- **Dependent non-authoritative mirrors/views:** Root ingress adapters; generated views; release disclosures
- **Required validator(s):** V-SOT-001, V-SOT-002
- **Evidence required for certification:** `authority-classification-report.yml`

## UEC-I002 — Mirror discipline

**Invariant.** Tool-facing mirrors (`AGENTS.md`, `CLAUDE.md`, `/.octon/AGENTS.md`, editor-specific projections) must be byte-for-byte mirrors or schema-valid adapters and must not add policy/runtime text.

- **Canonical source of truth:** Root `AGENTS.md`; `CLAUDE.md`; `/.octon/AGENTS.md`
- **Dependent non-authoritative mirrors/views:** `.claude/**`, `.codex/**`, `.cursor/**`
- **Required validator(s):** V-SOT-002
- **Evidence required for certification:** `mirror-parity-report.yml`

## UEC-I003 — Dual precedence binding

**Invariant.** Normative and epistemic precedence must be resolved through one runtime-visible precedence path and one evidence report.

- **Canonical source of truth:** `/.octon/framework/constitution/precedence/{normative.yml,epistemic.yml}`
- **Dependent non-authoritative mirrors/views:** Human-readable summaries
- **Required validator(s):** V-PREC-001
- **Evidence required for certification:** `precedence-resolution-report.yml`

## UEC-I004 — Host projection non-authority

**Invariant.** GitHub labels, comments, checks, CI state, and Studio surfaces are projections only and can never mint authority on their own.

- **Canonical source of truth:** Host adapter manifests under `/.octon/framework/engine/runtime/adapters/host/**` and authority contracts
- **Dependent non-authoritative mirrors/views:** Projected host UI/state
- **Required validator(s):** V-AUTH-001
- **Evidence required for certification:** `host-projection-parity-report.yml`

## UEC-I005 — Support-target single source of truth

**Invariant.** Every run, adapter, capability pack, disclosure artifact, and release claim must resolve through `/.octon/instance/governance/support-targets.yml`.

- **Canonical source of truth:** `/.octon/instance/governance/support-targets.yml`
- **Dependent non-authoritative mirrors/views:** Run cards, HarnessCards, adapter manifests
- **Required validator(s):** V-SUP-001
- **Evidence required for certification:** `support-target-consistency-report.yml`

## UEC-I006 — No shadow authority surfaces

**Invariant.** Proposal packets, generated outputs, discovery registries, exploratory inputs, and archived compatibility material are non-authoritative unless explicitly promoted through authored authority.

- **Canonical source of truth:** Authority classification map
- **Dependent non-authoritative mirrors/views:** Generated registries; proposal packet; `inputs/**`
- **Required validator(s):** V-SOT-001, V-LEG-001
- **Evidence required for certification:** `shadow-authority-report.yml`

## UEC-I007 — Legal objective stack

**Invariant.** The legal execution stack is workspace charter + mission charter (when required) + run contract + stage attempt; illegal combinations are rejected.

- **Canonical source of truth:** Objective contracts family
- **Dependent non-authoritative mirrors/views:** Rendered summaries, bootstrap orientation docs
- **Required validator(s):** V-OBJ-001
- **Evidence required for certification:** `objective-stack-legality-report.yml`

## UEC-I008 — Single canonical run root

**Invariant.** Every consequential run binds exactly one canonical control root and one canonical evidence root before side effects occur.

- **Canonical source of truth:** Run manifest + runtime README
- **Dependent non-authoritative mirrors/views:** Run disclosure mirrors
- **Required validator(s):** V-RUN-001
- **Evidence required for certification:** `run-root-completeness-report.yml`

## UEC-I009 — Durable lifecycle

**Invariant.** Every run has runtime state, rollback posture, checkpoints, contamination state, retry records, events, and resumable evidence links.

- **Canonical source of truth:** Run root schema + runtime contracts
- **Dependent non-authoritative mirrors/views:** Human summaries
- **Required validator(s):** V-RUN-001, V-RUN-002
- **Evidence required for certification:** `durable-lifecycle-report.yml`

## UEC-I010 — Unambiguous mission semantics

**Invariant.** Mission-backed, run-only, and stage-only executions must be machine-distinguishable with no contradictory fields.

- **Canonical source of truth:** Run contract schema + mission schema
- **Dependent non-authoritative mirrors/views:** Narrative mission docs
- **Required validator(s):** V-OBJ-002
- **Evidence required for certification:** `mission-run-normalization-report.yml`

## UEC-I011 — Compatibility shims retired

**Invariant.** Historical objective and agency compatibility shims cannot remain live-authoritative after cutover.

- **Canonical source of truth:** Compatibility retirement register
- **Dependent non-authoritative mirrors/views:** Archived git history, tagged releases
- **Required validator(s):** V-LEG-001
- **Evidence required for certification:** `compatibility-retirement-report.yml`

## UEC-I012 — Canonical authority artifacts

**Invariant.** ApprovalRequest, ApprovalGrant, ExceptionLease, Revocation, QuorumPolicy, and DecisionArtifact are the only live authority forms for governed actions.

- **Canonical source of truth:** Authority contracts family
- **Dependent non-authoritative mirrors/views:** Host projections
- **Required validator(s):** V-AUTH-001, V-AUTH-002
- **Evidence required for certification:** `authority-artifact-completeness-report.yml`

## UEC-I013 — Fail-closed routing

**Invariant.** Unsupported, under-approved, or unsafe actions must route to `deny`, `stage_only`, or `escalate`; never silently continue.

- **Canonical source of truth:** Governance exclusions + policy interface
- **Dependent non-authoritative mirrors/views:** Host UI cues
- **Required validator(s):** V-AUTH-003
- **Evidence required for certification:** `fail-closed-routing-report.yml`

## UEC-I014 — Governed capability packs

**Invariant.** Capability packs are first-class governed artifacts with explicit scopes, routes, and disclosure.

- **Canonical source of truth:** Capability pack manifests + contracts
- **Dependent non-authoritative mirrors/views:** Requested capability pack lists in runs
- **Required validator(s):** V-CAP-001
- **Evidence required for certification:** `capability-pack-governance-report.yml`

## UEC-I015 — Explicit authority boundaries

**Invariant.** Human, model, host, and runtime responsibilities are explicit and machine-checkable.

- **Canonical source of truth:** Ownership roles + adapter manifests + authority contracts
- **Dependent non-authoritative mirrors/views:** Human process docs
- **Required validator(s):** V-AUTH-001
- **Evidence required for certification:** `authority-boundaries-report.yml`

## UEC-I016 — Tri-class evidence retention

**Invariant.** Evidence must be classified into git-inline, git-pointer, and external-immutable with hash/provenance linkage.

- **Canonical source of truth:** Retention contracts family
- **Dependent non-authoritative mirrors/views:** Run manifests and cards
- **Required validator(s):** V-EVD-001, V-EVD-002
- **Evidence required for certification:** `evidence-retention-proof.yml`

## UEC-I017 — Truthful disclosure surfaces

**Invariant.** RunCard and HarnessCard are schema-validated disclosure surfaces generated from canonical artifacts and truthful about admitted support universe.

- **Canonical source of truth:** Disclosure contracts + release/run disclosure roots
- **Dependent non-authoritative mirrors/views:** README summaries
- **Required validator(s):** V-DISC-001, V-DISC-002
- **Evidence required for certification:** `disclosure-truth-report.yml`

## UEC-I018 — Complete intervention and measurement capture

**Invariant.** All material human overrides, repairs, approvals, waivers, measurements, and cost/latency signals must be retained and linked to the run root.

- **Canonical source of truth:** Observability runtime contracts
- **Dependent non-authoritative mirrors/views:** Summary dashboards
- **Required validator(s):** V-OBS-001, V-OBS-002
- **Evidence required for certification:** `intervention-measurement-completeness.yml`

## UEC-I019 — Complete proof planes

**Invariant.** Structural, functional, behavioral, governance, maintainability, and recovery proof planes must exist and gate claims.

- **Canonical source of truth:** Assurance families + run evidence
- **Dependent non-authoritative mirrors/views:** Release summaries
- **Required validator(s):** V-ASS-001
- **Evidence required for certification:** `proof-plane-coverage-report.yml`

## UEC-I020 — Lab is first-class

**Invariant.** `framework/lab/**` is distinct from assurance and populated with replay, shadow, scenario, fault, and probe assets that feed proof.

- **Canonical source of truth:** `/.octon/framework/lab/**`
- **Dependent non-authoritative mirrors/views:** Release summaries
- **Required validator(s):** V-LAB-001
- **Evidence required for certification:** `lab-substance-report.yml`

## UEC-I021 — Evaluator independence

**Invariant.** Held-out checks, evaluator independence, and anti-overfitting posture are explicit and evidenced.

- **Canonical source of truth:** Assurance policy + lab probes
- **Dependent non-authoritative mirrors/views:** Narrative notes
- **Required validator(s):** V-LAB-002
- **Evidence required for certification:** `evaluator-independence-report.yml`

## UEC-I022 — Dual-pass idempotent convergence

**Invariant.** Re-running the full regeneration + validation stack on the cutover branch after a clean first pass must produce no constitution-related diff.

- **Canonical source of truth:** Validation workflow definitions
- **Dependent non-authoritative mirrors/views:** Human signoff notes
- **Required validator(s):** V-CERT-001
- **Evidence required for certification:** `second-pass-no-diff-report.yml`

## UEC-I023 — Model portability by contract

**Invariant.** Model portability is mediated by the Model Adapter Contract and conformance suites, not by prompt shape alone.

- **Canonical source of truth:** Model adapter manifests + contracts
- **Dependent non-authoritative mirrors/views:** Narrative docs
- **Required validator(s):** V-SUP-001
- **Evidence required for certification:** `model-portability-report.yml`

## UEC-I024 — Host and pack admission controls

**Invariant.** Host adapters and capability packs cannot enter the live claim without admission evidence and support-target closure.

- **Canonical source of truth:** Support-target matrix + adapter/pack manifests
- **Dependent non-authoritative mirrors/views:** Release marketing copy
- **Required validator(s):** V-SUP-001, V-CAP-001
- **Evidence required for certification:** `admission-closure-report.yml`

## UEC-I025 — Build-to-delete discipline

**Invariant.** Legacy persona scaffolding, obsolete shims, and no-longer-load-bearing overlays are retired once target-state replacements are proven.

- **Canonical source of truth:** Retirement register + agency manifest
- **Dependent non-authoritative mirrors/views:** Release notes
- **Required validator(s):** V-LEG-001
- **Evidence required for certification:** `retirement-register-report.yml`

## UEC-I026 — Universal completion semantics

**Invariant.** Octon may claim full Unified Execution Constitution attainment only when the admitted live support universe equals the target support universe and no in-scope exclusions remain.

- **Canonical source of truth:** HarnessCard + support-target matrix + closure certificate
- **Dependent non-authoritative mirrors/views:** README / announcements
- **Required validator(s):** V-DISC-002, V-CERT-001
- **Evidence required for certification:** `universal-attainment-proof.yml`
