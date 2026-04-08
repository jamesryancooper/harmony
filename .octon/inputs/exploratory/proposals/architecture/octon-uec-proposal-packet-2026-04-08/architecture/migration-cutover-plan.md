# Migration / Cutover Plan

## 1. Cutover Model

The migration is executed as **one atomic, clean-break, big-bang cutover**.

There is no sanctioned intermediate steady state on `main`.
All normalization, deletion, admission, validator wiring, disclosure regeneration, and closure certification happen on one isolated cutover branch/worktree.
Only after every blocking validator is green **twice** and the second pass produces no constitution-related diff may the change land.

## 2. Preconditions (All Must Be True)

1. The proposal packet has been ratified and recorded as the governing cutover plan.
2. A single protected cutover branch/worktree exists.
3. Mainline merges are frozen except emergency fixes, and any emergency fixes are rebased into the cutover branch before validation.
4. All file/path additions in `architecture/file-change-map.md` exist on the cutover branch.
5. Every finding in `architecture/current-state-gap-map.md` is implemented to the point of validator readiness.
6. The target support universe is fully declared in `/.octon/instance/governance/support-targets.yml`.
7. No in-scope live claim exclusions remain in the candidate HarnessCard.
8. All legacy live-authoritative shims and persona surfaces are deleted or archived as non-authoritative.
9. All validators in `architecture/validation-plan.md` exist and are wired into blocking CI.
10. The release closure directory `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/` exists.

If any precondition is false, cutover is aborted before validation.

## 3. Exact Cutover Sequencing

### Step A — Freeze and branch
- freeze merges
- create or refresh the cutover branch from the latest frozen `main`
- stamp `<cutover-release-id>` in release lineage and closure manifest stub

### Step B — Normalize authority and objective stack
- update constitutional kernel and instance authority surfaces
- repair all run/mission/stage semantics
- retire live compatibility shims
- enforce ingress mirror discipline

### Step C — Centralize authority and broaden admission
- reduce GitHub/CI/Studio workflows to projection-only behavior
- finalize authority artifacts and fail-closed routing
- add governed capability packs and admit the full support universe

### Step D — Complete runtime, evidence, observability, proof, and lab
- normalize every canonical run root
- prove external immutable replay with restore drills
- populate observability, measurement, and intervention coverage
- populate proof planes and lab assets

### Step E — Delete live legacy surfaces and regenerate disclosure
- remove active architect persona surfaces
- regenerate all RunCards, HarnessCard, effective closure views, and release manifests from canonical sources only

### Step F — Validation pass 1
- run the entire cutover validation stack
- collect every evidence artifact into the closure bundle

### Step G — Validation pass 2
- clean the worktree
- rerun every generator and validator
- capture the no-diff report

### Step H — Certify and merge
- emit closure summary, closure certificate, universal attainment proof, and final HarnessCard
- write the durable closeout ADR
- perform one protected merge/tag/release
- unfreeze `main`

## 4. Fail-Closed Abort Conditions Before Merge

Abort the cutover immediately if **any** of the following occur:

- any blocking validator is red on pass 1
- any blocking validator is red on pass 2
- any constitution-related diff appears on pass 2
- any support-target tuple remains stage-only or excluded while the candidate HarnessCard still claims universal completion
- any mirror/parity drift is detected
- any hidden human repair is detected without intervention records
- any external immutable replay artifact fails hash verification or restore drill
- any legacy persona/compatibility surface remains live-authoritative
- any run artifact still violates the legal mission/run/stage state machine
- any host workflow still mints effective authority directly

No exception lease may be used to bypass these abort conditions for certification.

## 5. Rollback / Recovery Posture

Rollback is permitted **only** as a full revert of the single cutover merge commit or merge train, restoring the last bounded-support release state.

Partial rollback is forbidden because it would reintroduce a mixed constitutional state and violate the clean-break rule.

If rollback occurs:
1. revert the full cutover merge
2. retract the universal HarnessCard and closure certificate
3. restore the last bounded release lineage entry
4. mark certification as failed
5. reopen the packet with explicit blocker findings

## 6. Post-Cutover Normalization / Regeneration / Archive Actions

Immediately after the atomic merge:
- regenerate all `/.octon/generated/effective/**` views on `main`
- verify release lineage and manifest indexes
- publish the final HarnessCard and closure bundle
- publish or update the durable ADR set
- start the post-cutover drift watch workflow
- ensure deleted legacy surfaces remain absent from runtime discovery
- ensure archived compatibility surfaces are not referenced by any live authority or runtime path

## 7. Cutover Success Definition

The cutover succeeds only if:
- the merge lands once
- the merged tree already reflects the full target state
- the second validation pass produced no constitution-related diff
- the closure certificate is present
- the final HarnessCard contains no in-scope exclusions
- every finding status is closed
