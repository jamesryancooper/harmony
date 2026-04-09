# Assumptions and Blockers

## Assumptions

### A-001
The authoritative target-state required for this packet is fully represented by the target-state positions preserved in the audit charter, the current-thread design brief, and the repository-grounded audit baseline.

### A-002
The repository path conventions observed on `main` as of 2026-04-08 remain the correct conventions for new constitutional, governance, assurance, and disclosure artifacts.

### A-003
The current release-level closure bundle conventions under
`/.octon/state/evidence/disclosure/releases/<release-id>/closure/**`
remain the canonical release-certification evidence location.

### A-004
The target-state support universe for full attainment is the full in-scope universe encoded or implied by the current adapter manifests, support-target governance, and target-state packet positions:
- model tiers: `repo-local-governed`, `frontier-governed`
- host adapters: `repo-shell`, `github-control-plane`, `ci-control-plane`, `studio-control-plane`
- workload tiers: `observe-and-read`, `repo-consequential`, `boundary-sensitive`
- language/resource tiers: `reference-owned`, `extended-governed`
- locale tiers: `english-primary`, `spanish-secondary`
- capability packs: `repo`, `git`, `shell`, `telemetry`, `browser`, `api`

If this assumption is false, the target-state must be re-ratified before certification.

## Blockers

### B-001 — Universal support universe not yet admitted
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** Octon cannot honestly claim full attainment while frontier-governed, browser/API, and GitHub/CI/Studio surfaces remain excluded from the live claim.

### B-002 — Mission/run normalization not yet completed
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** contradictory mission/run states make the objective model non-final.

### B-003 — Runtime authority not yet fully centralized
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** a second control plane remains possible if host workflows still mint effective authority.

### B-004 — External immutable replay not yet proven end-to-end
**Status:** open  
**Resolvable within packet scope:** yes, assuming backend path is available  
**Why it blocks certification:** full attainment requires provable replay, not manifest-only indexing.

### B-005 — Behavioral / recovery / evaluator-independence proof still incomplete
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** proof-plane completeness is mandatory for the full claim.

### B-006 — Legacy live surfaces not yet retired
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** legacy persona and shim surfaces keep the post-cutover state ambiguous.

### B-007 — Dual-pass no-diff certification not yet proven
**Status:** open  
**Resolvable within packet scope:** yes  
**Why it blocks certification:** without two consecutive clean passes, claim closure is not stable.

## Certification Rule

Certification is prohibited while **any** blocker above remains open.

If additional authoritative target-state requirements from the earlier Proposal and Design Packet exist and are not reflected here, those requirements must be added to this packet before certification. This does **not** block creation of the packet; it does block a final certification claim if such omitted requirements are later discovered.
