# Decision Record Plan

These ADRs are the durable authored record of the cutover. The proposal packet is not the long-lived completion record.

## ADR-UEC-001

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-001-universal-claim-semantics.md`
- **Decision recorded:** Universal full-attainment claim semantics and the difference between bounded completion and universal completion.
- **Authoritative scope:** All release disclosure and external claims.
- **Canonical references it must cite:**
  - `/.octon/framework/constitution/CHARTER.md`
  - `/.octon/framework/constitution/contracts/disclosure/harness-card-v2.schema.json`
  - `/.octon/instance/governance/support-targets.yml`
- **Superseded lineage closed or updated:** Ambiguous 'claim_status: complete' semantics in bounded HarnessCards.
- **Explicit reopening rule:** Only if the target support universe itself changes or the constitutional charter changes.

## ADR-UEC-002

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-002-objective-stack-normalization.md`
- **Decision recorded:** Legal combinations for workspace/mission/run/stage and the retirement of contradictory mission/run encodings.
- **Authoritative scope:** All objective contracts and run artifacts.
- **Canonical references it must cite:**
  - `/.octon/framework/constitution/contracts/objective/README.md`
  - `/.octon/framework/constitution/contracts/objective/run-contract-v3.schema.json`
  - `/.octon/framework/constitution/contracts/objective/stage-attempt-v1.schema.json`
- **Superseded lineage closed or updated:** Legacy mission/run ambiguity and historical shims.
- **Explicit reopening rule:** Only with stronger runtime or governance evidence requiring a different legal state machine.

## ADR-UEC-003

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-003-runtime-authority-centralization.md`
- **Decision recorded:** Canonical runtime/governance surfaces are the sole origin of authority artifacts; host systems are projections only.
- **Authoritative scope:** Approvals, grants, leases, revocations, decisions, and host workflows.
- **Canonical references it must cite:**
  - `/.octon/framework/engine/runtime/adapters/host/github-control-plane.yml`
  - `/.github/workflows/pr-autonomy-policy.yml`
  - `/.github/workflows/ai-review-gate.yml`
  - `/.octon/framework/constitution/contracts/authority/**`
- **Superseded lineage closed or updated:** Any host-native authority behavior.
- **Explicit reopening rule:** Only if a new host adapter requires a constitutionally stronger central mechanism.

## ADR-UEC-004

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-004-capability-pack-admission.md`
- **Decision recorded:** Governed capability pack model and the admission criteria for browser/UI and API action surfaces.
- **Authoritative scope:** Capability packs and action-surface governance.
- **Canonical references it must cite:**
  - `/.octon/framework/constitution/contracts/adapters/capability-pack-v1.schema.json`
  - `/.octon/instance/governance/capability-packs/**`
  - `/.octon/instance/governance/exclusions/action-classes.yml`
- **Superseded lineage closed or updated:** Implicit or stage-only-only pack semantics.
- **Explicit reopening rule:** Only if new action surfaces or risk classes are introduced.

## ADR-UEC-005

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-005-external-replay-proof.md`
- **Decision recorded:** Tri-class evidence retention and hash-linked external immutable replay proof are mandatory for universal claims.
- **Authoritative scope:** Replay, retained evidence, and external object storage.
- **Canonical references it must cite:**
  - `/.octon/framework/constitution/contracts/retention/**`
  - `/.octon/state/evidence/external-index/**`
- **Superseded lineage closed or updated:** Manifest-only external replay claims.
- **Explicit reopening rule:** Only if a different immutable evidence backend is adopted.

## ADR-UEC-006

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-006-agency-simplification-and-retirement.md`
- **Decision recorded:** Orchestrator is the sole active kernel persona; architect and other legacy persona surfaces are retired from live runtime paths.
- **Authoritative scope:** Agency runtime discovery and tool-facing projections.
- **Canonical references it must cite:**
  - `/.octon/framework/agency/manifest.yml`
  - `/.octon/framework/agency/runtime/agents/orchestrator/**`
  - `/.octon/framework/agency/runtime/agents/architect/**`
- **Superseded lineage closed or updated:** Historical persona-heavy agency runtime.
- **Explicit reopening rule:** Only with stronger separation-of-duties evidence requiring a new active kernel persona.

## ADR-UEC-007

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-007-dual-precedence-resolution.md`
- **Decision recorded:** Normative and epistemic precedence must resolve through one effective precedence output.
- **Authoritative scope:** Runtime policy resolution and source-of-truth ordering.
- **Canonical references it must cite:**
  - `/.octon/framework/constitution/precedence/normative.yml`
  - `/.octon/framework/constitution/precedence/epistemic.yml`
- **Superseded lineage closed or updated:** Parallel undeclared precedence consumption.
- **Explicit reopening rule:** Only if a new precedence category is introduced constitutionally.

## ADR-UEC-008

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-008-proof-plane-and-lab-closure.md`
- **Decision recorded:** Full-attainment requires all proof planes plus a substantively populated lab domain feeding behavioral proof.
- **Authoritative scope:** Assurance, lab, and certification.
- **Canonical references it must cite:**
  - `/.octon/framework/assurance/**`
  - `/.octon/framework/lab/**`
- **Superseded lineage closed or updated:** Implicit or structure-only proof claims.
- **Explicit reopening rule:** Only if the proof-plane taxonomy itself changes.

## ADR-UEC-009

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-009-support-target-universe.md`
- **Decision recorded:** Defines the full target support universe for models, hosts, workloads, language-resource tiers, locale tiers, and capability packs.
- **Authoritative scope:** Support-target policy and release claims.
- **Canonical references it must cite:**
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/framework/engine/runtime/adapters/{model,host}/**`
- **Superseded lineage closed or updated:** Bounded admitted-universe release line.
- **Explicit reopening rule:** Only if Octon intentionally changes its target support universe.

## ADR-UEC-010

- **Exact path:** `/.octon/instance/governance/decisions/ADR-UEC-010-full-attainment-certification.md`
- **Decision recorded:** Durable authored closeout decision recording that Octon has reached full Unified Execution Constitution attainment.
- **Authoritative scope:** Final completion record.
- **Canonical references it must cite:**
  - `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/closure-certificate.yml`
  - `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/harness-card.yml`
- **Superseded lineage closed or updated:** No prior durable full-attainment closeout.
- **Explicit reopening rule:** Only if a future audit proves post-cutover drift or target-state regression.
