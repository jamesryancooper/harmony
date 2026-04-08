# Current-State Gap Map

This gap map normalizes the audit into stable findings. No audit finding disappears without an explicit closure target and validator path.

| Finding ID | Title | Severity | Violated invariant(s) | Validator(s) | Closure target |
| --- | --- | --- | --- | --- | --- |
| UEC-F001 | Bounded live claim still excludes in-scope target-state surfaces | critical | UEC-I005, UEC-I014, UEC-I017, UEC-I024, UEC-I026 | V-SUP-001, V-CAP-001, V-DISC-002, V-CERT-001 | Closed at cutover; no bounded in-scope exclusions remain. |
| UEC-F002 | Mission/run/stage semantics are internally inconsistent | critical | UEC-I007, UEC-I010 | V-OBJ-001, V-OBJ-002, V-CERT-001 | Closed at cutover; no contradictory mission/run combinations remain. |
| UEC-F003 | Historical objective compatibility shims still remain in live paths | high | UEC-I006, UEC-I011, UEC-I025 | V-LEG-001, V-SOT-001, V-CERT-001 | Closed at cutover; retained only as archival provenance or removed entirely. |
| UEC-F004 | Normative and epistemic precedence are declared but not runtime-unified and proven | high | UEC-I003 | V-PREC-001, V-CERT-001 | Closed at cutover; one runtime-visible precedence resolver is authoritative. |
| UEC-F005 | Authority is still partly mediated by host workflows instead of a fully central runtime authority engine | high | UEC-I004, UEC-I012, UEC-I015 | V-AUTH-001, V-AUTH-002, V-AUTH-003, V-CERT-001 | Closed at cutover; host systems no longer originate authority. |
| UEC-F006 | ExceptionLease, Revocation, and QuorumPolicy exist structurally but are not fully exercised across real governed paths | high | UEC-I012, UEC-I013 | V-AUTH-002, V-AUTH-003, V-CERT-001 | Closed at cutover; exercised and enforced on every relevant route. |
| UEC-F007 | Proof planes are materially uneven; behavioral, recovery, and evaluator-independence evidence lags structural/governance strength | high | UEC-I019, UEC-I021 | V-ASS-001, V-LAB-002, V-CERT-001 | Closed at cutover; every proof plane blocks claims for its admitted universe. |
| UEC-F008 | Lab is first-class in structure but still under-substantiated as an operational experimentation domain | medium | UEC-I020 | V-LAB-001, V-ASS-001 | Closed at cutover; lab is operationally substantial and proof-feeding. |
| UEC-F009 | External immutable replay is modeled and indexed but not end-to-end proven | high | UEC-I016 | V-EVD-001, V-EVD-002, V-CERT-001 | Closed at cutover; external replay is provably restorable and hash-linked. |
| UEC-F010 | Observability and trace-query substance is less proven than disclosure/reporting artifacts | medium | UEC-I018, UEC-I019 | V-OBS-001, V-OBS-002, V-ASS-001 | Closed at cutover; observability depth matches disclosure claims. |
| UEC-F011 | Intervention completeness and hidden human repair capture are not yet proven | high | UEC-I018 | V-OBS-001, V-CERT-001 | Closed at cutover; no hidden human repair remains. |
| UEC-F012 | Browser and API action surfaces are not yet first-class, governed, admitted capability packs | critical | UEC-I014, UEC-I024, UEC-I026 | V-CAP-001, V-SUP-001, V-DISC-002 | Closed at cutover; browser and API packs are admitted and evidenced. |
| UEC-F013 | Support-target matrix is real but not yet the hard gate for every adapter, run, capability pack, and release claim | high | UEC-I005, UEC-I024 | V-SUP-001, V-DISC-002, V-CERT-001 | Closed at cutover; support-targets are binding, not advisory. |
| UEC-F014 | Legacy persona-heavy architect surfaces remain in the active tree | medium | UEC-I006, UEC-I025 | V-LEG-001, V-SOT-001 | Closed at cutover; no active architect persona surface remains. |
| UEC-F015 | Build-to-delete, retirement, and ablation discipline is not formalized enough for low-entropy evolution | medium | UEC-I022, UEC-I025 | V-LEG-001, V-CERT-001 | Closed at cutover; build-to-delete is machine-visible. |
| UEC-F016 | RunCard and HarnessCard semantics allow bounded-complete claims to be mistaken for universal completion | high | UEC-I017, UEC-I026 | V-DISC-001, V-DISC-002, V-CERT-001 | Closed at cutover; no bounded claim can masquerade as full attainment. |
| UEC-F017 | Tool-facing ingress mirrors need explicit parity enforcement to prevent shadow authority re-entry | high | UEC-I002, UEC-I006 | V-SOT-002, V-CERT-001 | Closed at cutover; no tool-facing mirror can drift into authority. |
| UEC-F018 | Dual-pass idempotent closure certification is not yet the mandatory universal merge gate for full-attainment claims | critical | UEC-I022, UEC-I026 | V-CERT-001 | Closed at cutover; universal claim impossible without dual-pass green certification. |

## UEC-F001 — Bounded live claim still excludes in-scope target-state surfaces

- **Audit evidence reference:** full-audit.md §§B, C, I, L; repo evidence: release HarnessCard, `/.octon/state/evidence/disclosure/releases/2026-04-06-target-state-closure-provable-closure/harness-card.yml`
- **Impacted files / surfaces:**
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/framework/engine/runtime/adapters/model/frontier-governed.yml`
  - `/.octon/framework/engine/runtime/adapters/host/{github-control-plane.yml,ci-control-plane.yml,studio-control-plane.yml}`
  - `/.octon/instance/governance/capability-packs/{browser.yml,api.yml}`
  - `/.octon/state/evidence/disclosure/releases/**/harness-card.yml`
- **Violated target-state invariant(s):** UEC-I005, UEC-I014, UEC-I017, UEC-I024, UEC-I026
- **Severity / criticality:** critical
- **Classification:** harden
- **Why this is a gap:**
  - Release HarnessCard excludes frontier-governed execution, browser/API packs, and GitHub/CI/Studio host adapters from the live claim.
  - Current claim status is 'complete' only for an admitted bounded universe.
- **Exact remediation required:** Expand the admitted support universe to the full target-state set and hard-block any universal-complete HarnessCard until every in-scope adapter and capability pack has passing admission evidence. Remove all in-scope exclusions from the release claim.
- **Required validator(s):** V-SUP-001, V-CAP-001, V-DISC-002, V-CERT-001
- **Required closure evidence:**
  - `support-target-consistency-report.yml`
  - `admission-closure-report.yml`
  - `universal-attainment-proof.yml`
  - `updated HarnessCard with no in-scope exclusions`
- **Closure status target:** Closed at cutover; no bounded in-scope exclusions remain.

## UEC-F002 — Mission/run/stage semantics are internally inconsistent

- **Audit evidence reference:** full-audit.md §§C, D(2), G, L; repo evidence: `/.octon/state/control/execution/runs/uec-global-github-repo-consequential-20260404/run-contract.yml`
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/contracts/objective/run-contract-v3.schema.json`
  - `/.octon/framework/constitution/contracts/objective/stage-attempt-v1.schema.json`
  - `/.octon/framework/constitution/contracts/objective/README.md`
  - `/.octon/state/control/execution/runs/**/run-contract.yml`
  - `/.octon/state/control/execution/runs/**/run-manifest.yml`
- **Violated target-state invariant(s):** UEC-I007, UEC-I010
- **Severity / criticality:** critical
- **Classification:** normalize
- **Why this is a gap:**
  - Sample run contract contains `mission_id: null`, `requires_mission: true`, and `mission_mode: none` in the same artifact.
  - Objective family states run is atomic unit while mission remains continuity container.
- **Exact remediation required:** Tighten the legal objective-state combinations, migrate every run artifact to legal mission/run/stage encodings, and fail schema validation on any contradictory field set.
- **Required validator(s):** V-OBJ-001, V-OBJ-002, V-CERT-001
- **Required closure evidence:**
  - `objective-stack-legality-report.yml`
  - `mission-run-normalization-report.yml`
  - `schema and instance migration diff`
- **Closure status target:** Closed at cutover; no contradictory mission/run combinations remain.

## UEC-F003 — Historical objective compatibility shims still remain in live paths

- **Audit evidence reference:** full-audit.md §§B, C, D(2), J, M; repo evidence: `/.octon/framework/constitution/contracts/objective/README.md`
- **Impacted files / surfaces:**
  - `/.octon/instance/bootstrap/OBJECTIVE.md`
  - `/.octon/instance/cognition/context/shared/intent.contract.yml`
  - `/.octon/framework/constitution/contracts/objective/README.md`
  - `/.octon/instance/governance/retirement-register.yml`
- **Violated target-state invariant(s):** UEC-I006, UEC-I011, UEC-I025
- **Severity / criticality:** high
- **Classification:** delete
- **Why this is a gap:**
  - Objective family explicitly retains `/.octon/instance/bootstrap/OBJECTIVE.md` and `/.octon/instance/cognition/context/shared/intent.contract.yml` as compatibility shims.
- **Exact remediation required:** Remove these shims from all live-authority and execution paths; either delete them or reclassify them as archived, non-authoritative provenance with explicit retirement records and no runtime references.
- **Required validator(s):** V-LEG-001, V-SOT-001, V-CERT-001
- **Required closure evidence:**
  - `compatibility-retirement-report.yml`
  - `retirement register entry`
  - `grep-free runtime reference proof`
- **Closure status target:** Closed at cutover; retained only as archival provenance or removed entirely.

## UEC-F004 — Normative and epistemic precedence are declared but not runtime-unified and proven

- **Audit evidence reference:** full-audit.md §§D(1),(3), F, L
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/precedence/normative.yml`
  - `/.octon/framework/constitution/precedence/epistemic.yml`
  - `/.octon/framework/engine/runtime/config/policy-interface.yml`
  - `/.octon/generated/effective/precedence/**`
- **Violated target-state invariant(s):** UEC-I003
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Ingress names both normative and epistemic precedence files as canonical read set.
  - Audit did not establish one runtime-visible resolver or proof artifact showing both ladders are consumed uniformly.
- **Exact remediation required:** Create one precedence resolution path that materializes an effective precedence view and gate all runtime/policy decisions on it. Emit machine-readable precedence evidence on every certification pass.
- **Required validator(s):** V-PREC-001, V-CERT-001
- **Required closure evidence:**
  - `precedence-resolution-report.yml`
  - `effective precedence output`
  - `runtime resolver invocation proof`
- **Closure status target:** Closed at cutover; one runtime-visible precedence resolver is authoritative.

## UEC-F005 — Authority is still partly mediated by host workflows instead of a fully central runtime authority engine

- **Audit evidence reference:** full-audit.md §§D(4), F, I, L; repo evidence: host adapter and PR workflows
- **Impacted files / surfaces:**
  - `/.octon/framework/engine/runtime/adapters/host/github-control-plane.yml`
  - `/.github/workflows/pr-autonomy-policy.yml`
  - `/.github/workflows/ai-review-gate.yml`
  - `/.octon/state/control/execution/approvals/**`
  - `/.octon/state/evidence/control/execution/**`
- **Violated target-state invariant(s):** UEC-I004, UEC-I012, UEC-I015
- **Severity / criticality:** high
- **Classification:** re-bound
- **Why this is a gap:**
  - GitHub host adapter correctly states non-authoritative projection, but PR and review workflows still materialize meaningful control behavior via host glue.
  - The audit did not prove that all consequential authority issuance is centralized outside host workflows.
- **Exact remediation required:** Make the canonical authority engine the sole minter of decision/grant/lease/revocation artifacts; reduce GitHub/CI workflows to invocation and projection only, with parity checks against canonical artifacts.
- **Required validator(s):** V-AUTH-001, V-AUTH-002, V-AUTH-003, V-CERT-001
- **Required closure evidence:**
  - `authority-centralization-report.yml`
  - `host-projection-parity-report.yml`
  - `authority-artifact-completeness-report.yml`
- **Closure status target:** Closed at cutover; host systems no longer originate authority.

## UEC-F006 — ExceptionLease, Revocation, and QuorumPolicy exist structurally but are not fully exercised across real governed paths

- **Audit evidence reference:** full-audit.md §§D(4), E, F, K
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/contracts/authority/**`
  - `/.octon/state/control/execution/approvals/**`
  - `/.octon/state/control/execution/runs/**`
  - `/.octon/framework/assurance/governance/suites/**`
- **Violated target-state invariant(s):** UEC-I012, UEC-I013
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Authority schemas exist and safe-stage exercises are present, but broad consequential-path enforcement and coverage were not proven.
- **Exact remediation required:** Require lease/revocation/quorum artifact coverage for all relevant routes, add coverage suites and exemplar exercises, and fail any governed path that lacks its required authority artifacts.
- **Required validator(s):** V-AUTH-002, V-AUTH-003, V-CERT-001
- **Required closure evidence:**
  - `authority-artifact-completeness-report.yml`
  - `fail-closed-routing-report.yml`
  - `exercise coverage manifest`
- **Closure status target:** Closed at cutover; exercised and enforced on every relevant route.

## UEC-F007 — Proof planes are materially uneven; behavioral, recovery, and evaluator-independence evidence lags structural/governance strength

- **Audit evidence reference:** full-audit.md §§C, D(7), H, K, L
- **Impacted files / surfaces:**
  - `/.octon/framework/assurance/behavioral/**`
  - `/.octon/framework/assurance/recovery/**`
  - `/.octon/framework/assurance/maintainability/**`
  - `/.octon/state/evidence/runs/**/assurance/**`
- **Violated target-state invariant(s):** UEC-I019, UEC-I021
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Assurance families exist for all planes.
  - Sample run evidence includes multi-plane artifacts, but operational density remains strongest in structural/governance lanes.
- **Exact remediation required:** Populate held-out behavioral suites, recovery drills, maintainability checks, and evaluator-independence policy so that each proof plane has real gating substance, not only placeholders and single exemplars.
- **Required validator(s):** V-ASS-001, V-LAB-002, V-CERT-001
- **Required closure evidence:**
  - `proof-plane-coverage-report.yml`
  - `evaluator-independence-report.yml`
  - `recovery drill outputs`
- **Closure status target:** Closed at cutover; every proof plane blocks claims for its admitted universe.

## UEC-F008 — Lab is first-class in structure but still under-substantiated as an operational experimentation domain

- **Audit evidence reference:** full-audit.md §§C, D(8), H, K
- **Impacted files / surfaces:**
  - `/.octon/framework/lab/{scenarios,replay,shadow,faults,probes}/**`
  - `/.octon/state/evidence/lab/**`
  - `/.octon/framework/assurance/behavioral/suites/**`
- **Violated target-state invariant(s):** UEC-I020
- **Severity / criticality:** medium
- **Classification:** harden
- **Why this is a gap:**
  - `framework/lab/**` exists with replay, faults, governance, probes, runtime, scenarios, shadow, and README stating distinction from assurance.
  - Operational depth of scenario packs, adversarial catalogs, and retained evidence remains thinner than the structural spine.
- **Exact remediation required:** Populate the lab with governed scenario packs, replay sets, shadow-run definitions, adversarial probes, and retained evidence indexes tied directly into behavioral proof.
- **Required validator(s):** V-LAB-001, V-ASS-001
- **Required closure evidence:**
  - `lab-substance-report.yml`
  - `lab catalog manifest`
  - `retained lab evidence index`
- **Closure status target:** Closed at cutover; lab is operationally substantial and proof-feeding.

## UEC-F009 — External immutable replay is modeled and indexed but not end-to-end proven

- **Audit evidence reference:** full-audit.md §§C, G, H, L; repo evidence: retention family + run manifests
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/contracts/retention/**`
  - `/.octon/state/evidence/external-index/**`
  - `/.octon/state/evidence/runs/**/replay*`
  - `/.octon/framework/engine/runtime/crates/replay_store`
- **Violated target-state invariant(s):** UEC-I016
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Retention contracts define git-inline, git-pointer, and external-immutable evidence classes plus replay indexes.
  - Run manifests reference external replay indexes, but the audit did not prove backend writes, hash verification, and restore drills.
- **Exact remediation required:** Bind immutable object storage writes to canonical hash manifests, verify retrieval against hashes, and require replay restore drills as part of certification.
- **Required validator(s):** V-EVD-001, V-EVD-002, V-CERT-001
- **Required closure evidence:**
  - `evidence-retention-proof.yml`
  - `external-replay-restore-report.yml`
  - `hash manifest parity report`
- **Closure status target:** Closed at cutover; external replay is provably restorable and hash-linked.

## UEC-F010 — Observability and trace-query substance is less proven than disclosure/reporting artifacts

- **Audit evidence reference:** full-audit.md §§D(10), G, K
- **Impacted files / surfaces:**
  - `/.octon/framework/observability/runtime/contracts/**`
  - `/.octon/state/evidence/runs/**/{measurements,interventions,traces,replay}/**`
  - `/.octon/framework/engine/runtime/crates/{telemetry_sink,runtime_bus}/**`
- **Violated target-state invariant(s):** UEC-I018, UEC-I019
- **Severity / criticality:** medium
- **Classification:** harden
- **Why this is a gap:**
  - Observability runtime contracts exist for intervention, measurement, drift, and report bundles.
  - The repo proves schemas and summaries more strongly than end-to-end queryable trace operations.
- **Exact remediation required:** Add mandatory trace pointer, measurement summary, failure taxonomy, and runtime query proofs for each admitted support target and exemplar run class.
- **Required validator(s):** V-OBS-001, V-OBS-002, V-ASS-001
- **Required closure evidence:**
  - `measurement-trace-coverage.yml`
  - `failure-taxonomy coverage report`
  - `trace pointer verification output`
- **Closure status target:** Closed at cutover; observability depth matches disclosure claims.

## UEC-F011 — Intervention completeness and hidden human repair capture are not yet proven

- **Audit evidence reference:** full-audit.md §§H, K, L
- **Impacted files / surfaces:**
  - `/.octon/framework/observability/runtime/contracts/{intervention-log-v1.schema.json,intervention-record-v1.schema.json}`
  - `/.octon/state/evidence/runs/**/interventions/**`
  - `/.github/workflows/{pr-autonomy-policy.yml,ai-review-gate.yml}`
- **Violated target-state invariant(s):** UEC-I018
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Intervention schemas and logs exist.
  - The audit did not prove that every approval, manual override, rerun, hotfix, or repair is captured.
- **Exact remediation required:** Cross-check interventions against workflow reruns, approval events, branch fixes, and manual merge/unmerge surfaces; fail certification on any unexplained manual touch.
- **Required validator(s):** V-OBS-001, V-CERT-001
- **Required closure evidence:**
  - `intervention-completeness.yml`
  - `manual-touch reconciliation report`
- **Closure status target:** Closed at cutover; no hidden human repair remains.

## UEC-F012 — Browser and API action surfaces are not yet first-class, governed, admitted capability packs

- **Audit evidence reference:** full-audit.md §§B, C, I, L; repo evidence: HarnessCard known limits
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/contracts/adapters/capability-pack-v1.schema.json`
  - `/.octon/instance/governance/capability-packs/{browser.yml,api.yml}`
  - `/.octon/framework/assurance/functional/api/{browser-pack.yml,api-pack.yml}`
  - `/.octon/state/control/execution/runs/**/run-contract.yml`
  - `/.octon/state/evidence/disclosure/**`
- **Violated target-state invariant(s):** UEC-I014, UEC-I024, UEC-I026
- **Severity / criticality:** critical
- **Classification:** add
- **Why this is a gap:**
  - Current release HarnessCard explicitly excludes browser and API packs from the live claim.
  - Requested capability packs in sample consequential run include `api`, but claim remains stage-only.
- **Exact remediation required:** Create canonical governed capability pack manifests, conformance suites, admission exercises, and disclosure bindings for browser and API surfaces; then admit them into the live claim.
- **Required validator(s):** V-CAP-001, V-SUP-001, V-DISC-002
- **Required closure evidence:**
  - `capability-pack-governance-report.yml`
  - `browser/api pack conformance reports`
  - `updated universal HarnessCard`
- **Closure status target:** Closed at cutover; browser and API packs are admitted and evidenced.

## UEC-F013 — Support-target matrix is real but not yet the hard gate for every adapter, run, capability pack, and release claim

- **Audit evidence reference:** full-audit.md §§C, I, K, L
- **Impacted files / surfaces:**
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/framework/engine/runtime/adapters/{model,host}/**`
  - `/.octon/state/control/execution/runs/**/run-{contract,manifest}.yml`
  - `/.octon/state/evidence/disclosure/**`
- **Violated target-state invariant(s):** UEC-I005, UEC-I024
- **Severity / criticality:** high
- **Classification:** normalize
- **Why this is a gap:**
  - Support-targets are referenced by adapters, run contracts, run manifests, RunCards, and HarnessCard.
  - Current release claim still relies on exclusion statements rather than hard universal-claim gating.
- **Exact remediation required:** Make support-target resolution blocking at runtime, disclosure generation, and certification time; any tuple outside the admitted matrix must fail closed and cannot be released.
- **Required validator(s):** V-SUP-001, V-DISC-002, V-CERT-001
- **Required closure evidence:**
  - `support-target-consistency-report.yml`
  - `admission-closure-report.yml`
- **Closure status target:** Closed at cutover; support-targets are binding, not advisory.

## UEC-F014 — Legacy persona-heavy architect surfaces remain in the active tree

- **Audit evidence reference:** full-audit.md §§C, D(5), J, K, L
- **Impacted files / surfaces:**
  - `/.octon/framework/agency/manifest.yml`
  - `/.octon/framework/agency/runtime/agents/architect/**`
  - `/.octon/framework/agency/runtime/agents/orchestrator/**`
  - `/.octon/instance/ingress/AGENTS.md`
- **Violated target-state invariant(s):** UEC-I006, UEC-I025
- **Severity / criticality:** medium
- **Classification:** delete
- **Why this is a gap:**
  - Agency manifest now defaults to `orchestrator`, but legacy `framework/agency/runtime/agents/architect/**` remains in-tree.
- **Exact remediation required:** Remove architect persona surfaces from the live runtime tree or archive them explicitly as non-authoritative historical overlays; make orchestrator the sole active kernel persona surface.
- **Required validator(s):** V-LEG-001, V-SOT-001
- **Required closure evidence:**
  - `compatibility-retirement-report.yml`
  - `agency-manifest diff`
  - `grep-free architect-runtime proof`
- **Closure status target:** Closed at cutover; no active architect persona surface remains.

## UEC-F015 — Build-to-delete, retirement, and ablation discipline is not formalized enough for low-entropy evolution

- **Audit evidence reference:** full-audit.md §§D(11), J, K, M
- **Impacted files / surfaces:**
  - `/.octon/instance/governance/retirement-register.yml`
  - `/.octon/framework/agency/manifest.yml`
  - `/.octon/framework/assurance/maintainability/**`
  - `/.github/workflows/uec-drift-watch.yml`
- **Violated target-state invariant(s):** UEC-I022, UEC-I025
- **Severity / criticality:** medium
- **Classification:** add
- **Why this is a gap:**
  - The kernel is simpler, but the audit did not verify a formal retirement registry or explicit deletion-trigger workflow.
- **Exact remediation required:** Introduce a formal retirement register, explicit ablation criteria, and CI checks that fail when obsolete scaffolding remains live past its retirement trigger.
- **Required validator(s):** V-LEG-001, V-CERT-001
- **Required closure evidence:**
  - `retirement-register-report.yml`
  - `legacy-retirement suite output`
- **Closure status target:** Closed at cutover; build-to-delete is machine-visible.

## UEC-F016 — RunCard and HarnessCard semantics allow bounded-complete claims to be mistaken for universal completion

- **Audit evidence reference:** full-audit.md §§C, E, I, L; repo evidence: HarnessCard `claim_status: complete` plus exclusions
- **Impacted files / surfaces:**
  - `/.octon/framework/constitution/contracts/disclosure/{run-card-v2.schema.json,harness-card-v2.schema.json}`
  - `/.octon/state/evidence/disclosure/releases/**/harness-card.yml`
  - `/.octon/state/evidence/disclosure/runs/**/run-card.yml`
- **Violated target-state invariant(s):** UEC-I017, UEC-I026
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Current HarnessCard uses `claim_status: complete` while also declaring a reduced support universe and explicit known limits.
- **Exact remediation required:** Extend disclosure schemas and generation rules to separate `claim_status`, `attainment_scope`, `target_universe`, `admitted_universe`, and `remaining_exclusions`; block universal-complete labels until universes match exactly.
- **Required validator(s):** V-DISC-001, V-DISC-002, V-CERT-001
- **Required closure evidence:**
  - `disclosure-truth-report.yml`
  - `universal-attainment-proof.yml`
- **Closure status target:** Closed at cutover; no bounded claim can masquerade as full attainment.

## UEC-F017 — Tool-facing ingress mirrors need explicit parity enforcement to prevent shadow authority re-entry

- **Audit evidence reference:** full-audit.md §§F, K; repo evidence: root and `.octon` ingress adapters
- **Impacted files / surfaces:**
  - `/AGENTS.md`
  - `/CLAUDE.md`
  - `/.octon/AGENTS.md`
  - `/.claude/**`
  - `/.codex/**`
  - `/.cursor/**`
- **Violated target-state invariant(s):** UEC-I002, UEC-I006
- **Severity / criticality:** high
- **Classification:** harden
- **Why this is a gap:**
  - Root `AGENTS.md`, root `CLAUDE.md`, and `/.octon/AGENTS.md` already self-classify as thin adapters to `/.octon/instance/ingress/AGENTS.md`.
  - What is missing is a blocking parity validator and explicit classification for other tool-facing overlays.
- **Exact remediation required:** Formally classify each mirror/projection as non-authoritative and enforce byte parity or validated projection rules via CI and certification gates.
- **Required validator(s):** V-SOT-002, V-CERT-001
- **Required closure evidence:**
  - `mirror-parity-report.yml`
  - `shadow-authority-report.yml`
- **Closure status target:** Closed at cutover; no tool-facing mirror can drift into authority.

## UEC-F018 — Dual-pass idempotent closure certification is not yet the mandatory universal merge gate for full-attainment claims

- **Audit evidence reference:** full-audit.md §§G, H, L, M
- **Impacted files / surfaces:**
  - `/.github/workflows/uec-cutover-validate.yml`
  - `/.github/workflows/uec-cutover-certify.yml`
  - `/.octon/generated/effective/closure/**`
  - `/.octon/state/evidence/disclosure/releases/**/closure/**`
- **Violated target-state invariant(s):** UEC-I022, UEC-I026
- **Severity / criticality:** critical
- **Classification:** add
- **Why this is a gap:**
  - Current release closure artifacts exist, but the audit did not establish that dual-pass no-diff certification is the hard gate for universal target-state cutover.
- **Exact remediation required:** Make two consecutive clean regeneration/validation passes with zero second-pass diff the blocking prerequisite for merge, release, and full-attainment certification.
- **Required validator(s):** V-CERT-001
- **Required closure evidence:**
  - `second-pass-no-diff-report.yml`
  - `closure-certificate.yml`
  - `closure-summary.yml`
- **Closure status target:** Closed at cutover; universal claim impossible without dual-pass green certification.
