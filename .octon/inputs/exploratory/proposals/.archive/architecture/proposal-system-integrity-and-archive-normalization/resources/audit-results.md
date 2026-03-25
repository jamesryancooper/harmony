# Audit Results

## 1. Executive verdict

**Overall verdict: mostly complete but with important gaps.**

Octon’s proposal-system improvement work is **architecturally pointed in the right direction and substantially implemented**, but it is **not yet fully complete or fully correct in operational reality**. The repo now has the right core boundaries, the right lifecycle operations, a deterministic proposal-registry generator, generated artifact catalogs, and stronger integration into Octon’s authority/evidence/orchestration model. But the implementation is **not yet truly done** because the committed registry is still out of sync with the repo’s own canonical projection logic, archive normalization is still incomplete, and the machine-readable schema layer still lags the live template/validator contract. ([GitHub][1])

So the implementation should **not** be considered “complete and correct.” It is better described as **mostly complete, with several high-leverage remaining corrections needed before it is genuinely complete, fail-closed, and architecturally clean**. ([GitHub][2])

## 2. Intended design reconstruction

### Explicit design intent from the thread

The intended improvement package was narrow and conservative:

* preserve the existing model that proposals are **temporary, non-canonical change packets**, not durable repository authority;
* preserve the current four kinds and current lifecycle vocabulary;
* keep `proposal.yml` as package SSOT, followed by exactly one subtype manifest;
* keep `/.octon/generated/proposals/registry.yml` as a **generated discovery projection**, not a source of truth;
* make registry integrity fail-closed in both directions;
* align standards, templates, schemas, validators, and registry assumptions;
* add or complete explicit lifecycle operations for create, validate, audit, promote, and archive;
* make “implemented” operationally provable through promotion evidence and target checks;
* normalize archive integrity;
* keep `source-of-truth-map.md` manual and meaningful;
* simplify `artifact-catalog.md` into generated/projection-only inventory;
* strengthen subtype standards only where needed, without bloating the system.

### Reasonable inference from the thread

A reasonable reading of the intended design was that **the proposal system should mature mostly by tightening seams**, not by redesigning the model. The expected end state was: same conceptual model, better contract alignment, better lifecycle tooling, cleaner archive, deterministic registry projection, and stronger proof that proposals exit into durable targets without remaining de facto authorities.

The repository now codifies much of that same intent in the archived implementation proposal, ADR 065, and the migration evidence bundle. ADR 065 explicitly states that proposal lifecycle authority remains in `proposal.yml` plus exactly one subtype manifest, that `generate-proposal-registry.sh` becomes the canonical registry writer, that source-of-truth maps remain manual while artifact catalogs become generated inventory, and that archive packets included in the main projection must be standard-conformant and validator-clean. ([GitHub][3])

## 3. Current implemented state

### Verified implementation

The broader Octon architecture still treats proposals correctly. Repo architecture docs say durable authored authority lives in `framework/**` and `instance/**`, `state/**` is authoritative for operational/evidence truth, `generated/**` is rebuildable and non-authoritative, and raw `inputs/**` must never become direct runtime or policy dependencies. Proposal paths remain under `inputs/exploratory/proposals/**`, and the updated architecture docs now explicitly describe proposal lifecycle authority as residing in `proposal.yml` and the subtype manifest, with the proposal registry as discovery-only and the artifact catalog as generated inventory. ([GitHub][4])

The improvement work is visibly implemented across the workflow system. Octon now has canonical workflow units for `create-*-proposal`, subtype audit workflows, a generic `validate-proposal`, plus new `promote-proposal` and `archive-proposal` meta workflows. Those workflows are not merely prose; the workflow framework treats `workflow.yml` and stage assets as canonical operational contracts, and the proposal workflows define verification gates, state/evidence outputs, registry regeneration behavior, and fail-closed checks. ([GitHub][5])

The proposal-registry model was also materially upgraded. A canonical `generate-proposal-registry.sh` script now exists, validates packages before projection, builds deterministic active and archived fragments, checks duplicate keys, supports a check mode that fails if the committed registry differs from the manifest projection, and excludes archived design imports whose `archive.archived_from_status` is `legacy-unknown` from the main projection. That is a strong implementation of the intended “generated projection, not hand-edited authority” design. ([GitHub][6])

Artifact-catalog handling also moved in the intended direction. The architecture docs now describe `navigation/artifact-catalog.md` as generated inventory, create and archive workflows explicitly regenerate it from the on-disk package shape, and the improvement proposal itself states that the current standard still requires the file while the promoted design converts it into generated inventory. That is an acceptable transitional realization of the intended simplification. ([GitHub][1])

The implementation proposal itself was carried through the proposal machinery: there is now an archived architecture proposal package for `proposal-system-integrity-and-archive-normalization`, with manifests, navigation files, architecture docs, resources, archive metadata, linked promotion evidence, and a matching canonical ADR (`ADR 065`) plus migration evidence bundle in `state/evidence/**`. ([GitHub][7])

### Verified contradictory or incomplete implementation

Despite those upgrades, the repo is **not** in a clean steady state.

The committed `/.octon/generated/proposals/registry.yml` is still inconsistent with the repo’s own current projection rules. It still contains archived design entries under `.archive/design/**` with `legacy-unknown` lineage, even though the canonical generator now explicitly excludes those entries from the main registry projection. It also does **not** contain the archived implementation proposal `proposal-system-integrity-and-archive-normalization`, even though that package exists under `.archive/architecture/**` and the generator’s archived-entry logic would include a standard-conformant archived architecture proposal like that. ([GitHub][8])

Archive normalization is also incomplete. `mission-scoped-reversible-autonomy` was repaired and now has coherent archived state in both package and registry. But `self-audit-and-release-hardening` still uses `archive.archived_from_status: "proposed"` in both the archived manifest and the registry, even though the current lifecycle only allows `draft`, `in-review`, `accepted`, `implemented`, `rejected`, and `legacy-unknown` for archived imports. `harness-integrity-tightening` still shows the same invalid archived-from status in the registry. And `capability-routing-host-integration` still appears in the archived architecture registry, but the visible archive directory only contains `resources/` and not a complete standard-conformant archived proposal packet. ([GitHub][9])

The machine-readable contract layers are still not fully aligned. The architecture template and validator use `architecture_scope` and `decision_type`, but the architecture schema still requires `architecture_kind`. The migration validator uses `change_profile` and `release_state`, but the migration schema still expects a nested validation plan template path rather than `release_state`. The policy validator uses `policy_area` and `change_type`, but the policy schema still requires `policy_kind`. And the base proposal schema still does not include `archive.disposition: superseded`, even though the proposal standard, registry schema, and archive workflow do. ([GitHub][10])

### Inferred behavior

I did **not** verify a branch-protection or CI gate that universally enforces the new generator check. But because the current committed registry still differs from what the canonical generator now says the main projection should contain, the repo is plainly **not** in a fully enforced fail-closed steady state. That is an inference about operational enforcement, but it is grounded in the visible mismatch between the current registry, the current archive tree, and the canonical generator’s own rules. ([GitHub][8])

## 4. Implementation fidelity matrix

### 1) Preserve proposals as temporary and non-canonical

**Intended behavior:** proposals stay temporary, non-canonical, and cannot become durable runtime or policy authority.
**Observed implementation:** implemented. Repo architecture and proposal docs still place proposals under exploratory inputs, prohibit raw inputs from becoming direct runtime/policy dependencies, and active proposal manifests still declare `temporary: true`. ([GitHub][1])
**Architectural judgment:** correct and preserved.

### 2) Preserve package SSOT order (`proposal.yml` then one subtype manifest)

**Intended behavior:** `proposal.yml` remains package SSOT, followed by exactly one subtype manifest.
**Observed implementation:** implemented. Repo architecture and ADR 065 say proposal lifecycle authority remains in `proposal.yml` plus the subtype manifest, and validators still enforce exactly one subtype manifest. ([GitHub][1])
**Architectural judgment:** preserved.

### 3) Keep registry as generated projection, not authority

**Intended behavior:** registry remains discovery-only and generated/projection-only.
**Observed implementation:** implemented differently but acceptable in design, partial in practice. The architecture docs and ADR now explicitly frame the registry as discovery-only, and `generate-proposal-registry.sh` is the canonical writer. But the committed registry is currently stale relative to that design. ([GitHub][1])
**Architectural judgment:** model is correct; steady-state execution is incomplete.

### 4) Keep current kinds and lifecycle vocabulary

**Intended behavior:** no new proposal kinds; no new active lifecycle states.
**Observed implementation:** implemented. The proposal standard still uses `design`, `migration`, `policy`, `architecture`, and the current active status set remains `draft`, `in-review`, `accepted`, `implemented`, `rejected`, `archived`. Archive disposition values expanded, but lifecycle states did not. ([GitHub][11])
**Architectural judgment:** correct and non-bloated.

### 5) Align standards, templates, schemas, validators, registry assumptions

**Intended behavior:** one coherent contract across all layers.
**Observed implementation:** partially implemented. Templates and validators now agree with each other for architecture, migration, and policy. But the machine-readable schemas still lag those contracts, and the proposal schema still disagrees with the registry schema on `superseded`. ([GitHub][10])
**Architectural judgment:** important remaining gap.

### 6) Correct subtype manifest drift

**Intended behavior:** machine-readable subtype contract matches actual usage.
**Observed implementation:** partially implemented. Actual usage, templates, and validators align, but schemas do not. ([GitHub][10])
**Architectural judgment:** still incomplete.

### 7) Archive metadata/disposition consistency

**Intended behavior:** archive metadata coherent across standards, schemas, validators, registry, and packages.
**Observed implementation:** partially implemented. Standards, validators, registry schema, and archive workflow all support `superseded`, but the base proposal schema does not. Archive metadata handling is better than before, but not internally consistent. ([GitHub][11])
**Architectural judgment:** incomplete.

### 8) Registry integrity fail-closed in both directions

**Intended behavior:** detect and prevent missing entries, orphaned entries, duplicates, path mismatches, kind/status/archive mismatches.
**Observed implementation:** partially implemented, and currently not achieved in repo state. Package-to-registry validation exists. Deterministic registry generation/check exists. Duplicate key detection exists. But the current committed registry still contains stale and orphan-like entries and misses at least one archived proposal that should be present, so fail-closed integrity is not yet fully realized in practice. ([GitHub][12])
**Architectural judgment:** strong mechanism, incomplete execution.

### 9) Normalize archive integrity

**Intended behavior:** archived packages and registry entries agree; invalid historical packets are normalized or excluded.
**Observed implementation:** partially implemented. Some archive defects were repaired, including `mission-scoped-reversible-autonomy`. But invalid `archived_from_status: "proposed"` values remain, and at least one archived package path is still structurally incomplete while projected in the registry. ([GitHub][9])
**Architectural judgment:** not yet complete.

### 10) Add explicit lifecycle operations: create / validate / audit / promote / archive

**Intended behavior:** explicit operations exist and are integrated into Octon workflows.
**Observed implementation:** implemented. Create and subtype audit workflows exist; validate, promote, and archive workflows now also exist as canonical workflow units with stage assets and verification gates. ([GitHub][13])
**Architectural judgment:** complete and well integrated.

### 11) Make “implemented” operationally provable

**Intended behavior:** implemented status backed by target existence, proposal-path independence, and evidence.
**Observed implementation:** partially implemented. The promote workflow now requires promotion evidence paths, target existence, proposal-path independence, manifest update, and registry regeneration. That is the right proof shape. But because archive and registry cleanup is incomplete, corpus-wide trust in “implemented + archived” remains weaker than intended. ([GitHub][14])
**Architectural judgment:** good design, incomplete end-to-end realization.

### 12) Strengthen promotion evidence and archive semantics

**Intended behavior:** promotion receipts link to archive semantics where needed.
**Observed implementation:** implemented for the new flow, partial historically. Archived implemented proposals can require promotion evidence; the base validator enforces that implemented archives include promotion evidence, and the archive workflow requires evidence for `disposition: implemented`. The improvement proposal itself follows that pattern. Historical corpus cleanup is still incomplete. ([GitHub][12])
**Architectural judgment:** largely implemented, but historical normalization remains incomplete.

### 13) Keep `source-of-truth-map.md` manual and meaningful

**Intended behavior:** source-of-truth map remains a real manual boundary/precedence artifact.
**Observed implementation:** partially implemented. The architecture docs explicitly describe it that way, live packages like `migration-rollout` and the archived implementation proposal use it well, but generic proposal docs and templates still weaken it somewhat by centering reading order and by placing the registry above subtype docs in the primary input ordering. ([GitHub][1])
**Architectural judgment:** directionally correct, not uniformly strong.

### 14) Simplify `artifact-catalog.md`

**Intended behavior:** generated/projection-only or clearly justified.
**Observed implementation:** implemented differently but acceptable. The file is still required during the transition, but architecture docs and workflows now treat it as generated inventory and regenerate it automatically. ([GitHub][1])
**Architectural judgment:** acceptable transitional implementation.

### 15) Strengthen subtype standards without adding ceremony

**Intended behavior:** architecture, migration, and policy standards become more semantically useful where needed.
**Observed implementation:** mostly missing. Design standard remains rich, but migration, policy, and architecture standards are still largely file checklists with minimal semantic strengthening. ([GitHub][15])
**Architectural judgment:** one of the intended improvements was only weakly realized.

## 5. Invariant preservation review

### Preserved

The core invariants were largely preserved:

* proposals remain non-canonical and temporary in both repo architecture and live packages; ([GitHub][1])
* the package SSOT remains `proposal.yml` plus exactly one subtype manifest; ([GitHub][1])
* the registry remains conceptually projection-only, not a declared authority; ([GitHub][1])
* the four proposal kinds were preserved; ([GitHub][11])
* the lifecycle vocabulary was preserved; ([GitHub][11])
* explicit promotion targets remain required; ([GitHub][12])
* validators and promote workflow still prohibit promoted outputs from retaining proposal-path dependencies. ([GitHub][12])

### Weakened

Two invariants were preserved in principle but weakened in clarity:

* the source-of-truth-map remains manual in strong live examples, but the generic docs/templates do not consistently present it as the main proposal-local boundary/precedence artifact; ([GitHub][16])
* the registry is still *described* as projection-only, but current committed drift weakens practical trust in that claim. ([GitHub][1])

### Violated

The design intent that the registry become a clean, fail-closed projection and that archive integrity be normalized was **not fully achieved**. The live repo state still violates those goals through stale registry entries, missing registry entries, invalid archived-from statuses, and incomplete archived package structure. ([GitHub][8])

### Intentionally improved without breaking the model

The most successful improvements were:

* making artifact catalogs generated rather than manually trusted; ([GitHub][1])
* introducing canonical validate/promote/archive workflow operations; ([GitHub][17])
* making deterministic registry generation the canonical write path instead of direct manual mutation. ([GitHub][2])

## 6. Gap and issue inventory

### Issue 1: Committed registry is still stale against the canonical generator

**Classification:** architectural, validation, discovery, promotion/archive
**What the issue is:** the committed `registry.yml` still contains archived design imports that the canonical generator now excludes, and it is missing the archived implementation proposal that the generator would include. ([GitHub][8])
**Why it matters:** this breaks the central “generated projection, fail-closed integrity” improvement. Discovery becomes unreliable for humans and agents, and the promoted cutover claims are no longer fully true.
**Where it appears:** `/.octon/generated/proposals/registry.yml`, archive tree, generator behavior.
**Severity:** high
**Type of miss:** implementation drift / incomplete cutover
**Exact recommended action:** regenerate the registry from manifests with the canonical generator, commit the result, and ensure the result includes the implementation proposal and excludes legacy-unknown design imports from the main projection. Then keep that check fail-closed on future changes. ([GitHub][6])

### Issue 2: Archive normalization is still incomplete

**Classification:** promotion/archive, lifecycle, validation
**What the issue is:** invalid or incomplete archived packets remain in the main archive/projection surface. `self-audit-and-release-hardening` and `harness-integrity-tightening` still use invalid `archived_from_status: "proposed"`, and `capability-routing-host-integration` still appears structurally incomplete. ([GitHub][18])
**Why it matters:** archived status becomes less trustworthy, registry integrity is weakened, and the archive no longer cleanly proves proposal exit.
**Where it appears:** archived package manifests and `registry.yml`.
**Severity:** high
**Type of miss:** incomplete normalization / drift
**Exact recommended action:** correct invalid archived-from statuses to valid lifecycle values where known, classify truly unknown lineage as `legacy-unknown` only where justified, and either restore `capability-routing-host-integration` as a complete archived proposal packet or remove it from the main projection. ([GitHub][11])

### Issue 3: Machine-readable schema drift still exists

**Classification:** architectural, validation
**What the issue is:** architecture, migration, and policy schemas still do not match the live template/validator contract; proposal schema still disagrees with registry/archive handling on `superseded`. ([GitHub][10])
**Why it matters:** the repo still has multiple competing machine contracts for the same artifacts. Tools and humans can disagree about validity.
**Where it appears:** proposal-related schema files under `framework/scaffolding/runtime/templates/`.
**Severity:** high
**Type of miss:** implementation miss
**Exact recommended action:** update the schemas to match the manifest fields already used by templates, validators, and live proposals, and align `proposal.schema.json` with the archive disposition support used elsewhere. ([GitHub][10])

### Issue 4: Reverse-consistency is strong in mechanism, but not yet effective in practice

**Classification:** validation, automation, discovery
**What the issue is:** the repo now has a deterministic generator/check, which is a good reverse-consistency mechanism, but the current committed state still violates it. ([GitHub][6])
**Why it matters:** the intended fail-closed behavior exists conceptually, but the repo is not yet reliably staying inside it.
**Where it appears:** generator script versus current registry/archive state.
**Severity:** high
**Type of miss:** operational enforcement gap
**Exact recommended action:** make the generator check a required fail-closed gate for relevant changes and bring the repository back to a generator-clean steady state first. I did not verify the current CI wiring, so the enforcement-gap part is inferred from the current drift rather than directly observed in CI config. ([GitHub][6])

### Issue 5: Proposal README and enforced standard are slightly out of sync

**Classification:** governance, ergonomics
**What the issue is:** the proposal workspace README’s “every proposal must include” list omits the navigation files, while the proposal standard and validators still require them. ([GitHub][19])
**Why it matters:** this creates authoring ambiguity and weakens the contract surface.
**Where it appears:** `/.octon/inputs/exploratory/proposals/README.md` versus proposal standard and validator behavior.
**Severity:** medium
**Type of miss:** drift
**Exact recommended action:** either restore those files to the README’s required list or explicitly mark them as required-by-standard/generated-by-workflow so the surfaces agree. ([GitHub][19])

### Issue 6: Source-of-truth-map is implemented unevenly

**Classification:** governance, ergonomics, integration tension
**What the issue is:** the architecture docs and strong live examples treat the source-of-truth map as a real manual boundary artifact, but generic templates still frame it more as reading-order support than as the main proposal-local authority/boundary explainer. ([GitHub][1])
**Why it matters:** the artifact does real work when strong, but becomes ceremony when under-specified.
**Where it appears:** proposal-core templates and proposal standard authority ordering.
**Severity:** medium
**Type of miss:** partial design realization
**Exact recommended action:** tighten the generic template and standard language so the source-of-truth map consistently names external authorities, local authorities, derived projections, and boundary rules. ([GitHub][1])

### Issue 7: Migration, policy, and architecture standards remain too file-oriented

**Classification:** governance
**What the issue is:** those subtype standards are still mostly required-file lists with limited semantic guidance on authority boundaries, promotion proof, or exit semantics. ([GitHub][20])
**Why it matters:** one of the intended improvements was to strengthen them slightly without adding bloat; that has not been fully realized.
**Where it appears:** subtype standards under `framework/scaffolding/governance/patterns/`.
**Severity:** medium
**Type of miss:** partial implementation
**Exact recommended action:** add a small amount of semantic guidance to each standard: what must be promotable, what evidence is expected, what the source-of-truth map should clarify, and what “implemented” means for that subtype. ([GitHub][20])

### Issue 8: Canonical decision/evidence claims currently overstate completion

**Classification:** integration tension, promotion/archive, validation
**What the issue is:** ADR 065 and the migration evidence bundle say the live archive is coherent enough for fail-closed projection and that previously broken archive cases were normalized, but the current repo still contains several contradictory cases. ([GitHub][2])
**Why it matters:** the repo’s own promoted narrative is currently stronger than the actual implementation state.
**Where it appears:** ADR/evidence versus current archive/registry state.
**Severity:** high
**Type of miss:** drift/error after cutover or incomplete cutover
**Exact recommended action:** either finish the cleanup so the claims become true, or amend the decision/evidence language to reflect the actual remaining exceptions. Finishing the cleanup is the better tradeoff. ([GitHub][2])

## 7. Integration assessment

### Authority model

Integrated well. The proposal-system improvements fit Octon’s authority model: proposals remain non-canonical, generated registry remains non-authoritative by design, durable authority remains in `framework/**` and `instance/**`, and raw proposal inputs are still barred from becoming direct runtime/policy dependencies. ([GitHub][1])

### Evidence model

Integrated well in structure. Proposal workflows write verification bundles under `state/evidence/**`, validate/promote/archive flows all define bundle outputs, and the implementation proposal itself links to promotion evidence and an accepted ADR. ([GitHub][17])

### Promotion model

Largely integrated. The promote workflow now verifies evidence paths, target existence, proposal-path independence, updates manifest status, and regenerates the registry. That fits the intended model well. The remaining problem is not model fit; it is historical/archive cleanup and steady-state trust. ([GitHub][14])

### Archive model

Partially integrated. Archive workflow semantics are good and align with the intended design, but the archive corpus is not yet fully normalized, so the model is correct while the repository data remains partially dirty. ([GitHub][21])

### Validation model

Substantially integrated, but not fully coherent. Validators, workflows, and the registry generator are present and meaningful. But schemas still lag, and the live registry/archive state shows the validation/projection contract is not yet fully clean in practice. ([GitHub][17])

### Workflow / orchestration model

Integrated well. The new proposal operations were added using Octon’s canonical workflow model rather than as one-off scripts, which is the right architectural choice. ([GitHub][5])

### Generated / projection model

Architecturally integrated, operationally incomplete. The repo now has the right generator/writer model for the proposal registry, but the committed registry currently fails to reflect that model cleanly. ([GitHub][2])

## 8. What is actually complete

These parts are genuinely done and should be treated as complete:

* the non-canonical proposal boundary is preserved and integrated into repo architecture; ([GitHub][1])
* the core proposal kinds and lifecycle states were preserved without bloat; ([GitHub][11])
* create, audit, validate, promote, and archive workflow surfaces now exist as canonical workflow units; ([GitHub][13])
* promote now has the right proof shape: evidence paths, target existence, no proposal-path dependencies, manifest update, registry regeneration; ([GitHub][14])
* archive now has the right operational shape: canonical destination path, archive metadata write, artifact-catalog regeneration, registry regeneration; ([GitHub][21])
* deterministic registry generation exists and is the declared canonical write path; ([GitHub][2])
* artifact-catalog simplification was implemented in a good transitional form; ([GitHub][1])
* the implementation proposal itself was properly packaged, promoted, and archived with linked evidence and a canonical ADR. ([GitHub][3])

## 9. What is not actually complete

These parts still need work:

* **Registry steady state is not complete.** The committed registry is stale relative to the canonical generator and current archive tree. This is a **missing/incorrect final state**, not just a documentation issue. ([GitHub][8])
* **Archive normalization is not complete.** Invalid archive metadata and incomplete archived package structure remain in the main archive/projection surface. This is **partial and still dirty**, not complete. ([GitHub][18])
* **Schema alignment is not complete.** The machine-readable schemas are still out of sync with actual manifests, templates, and validators. This is **missing**, not merely optional cleanup. ([GitHub][22])
