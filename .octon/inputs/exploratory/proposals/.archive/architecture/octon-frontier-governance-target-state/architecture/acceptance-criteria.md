# Acceptance Criteria

## Packet-level acceptance

The proposal packet is review-ready when:

- `proposal.yml` and `architecture-proposal.yml` are present and valid.
- `resources/frontier-governance-architecture-review.md` includes the full upstream review.
- All required architecture and resource files exist.
- `navigation/source-of-truth-map.md` distinguishes canonical authority, proposal-local authority, generated projections, and retained evidence.
- `SHA256SUMS.txt` is generated for packet contents.
- `FULL_PACKET_CONTENTS.md` contains concatenated packet contents for archival review.

## Target-state implementation acceptance

The target state is accepted only when all of the following are true:

1. **Support truth**
   - `support-targets.yml` validates against `support-targets.schema.json`.
   - Support mode vocabulary is consistent across live file, schema, charter, and docs.
   - Operational support truth is finite admitted tuples with support dossiers.

2. **Authority clarity**
   - No runtime, policy, approval, support, or publication path treats raw inputs, generated outputs, proposals, host UI, chat state, or model memory as authority.
   - Durable promoted targets do not depend on this proposal path.

3. **Run enforceability**
   - No material side effect occurs without execution request, grant/denial, run control root, run evidence root, receipt obligations, and rollback posture when required.
   - Denials and escalations emit machine-readable reason codes and retained receipts.

4. **Context legitimacy**
   - Consequential runs have context packs with source hashes, authority labels, freshness checks, generated/authoritative separation, token/byte accounting, and known omissions.
   - Generated cognition is used only as a derived read model and is provenance-labeled.

5. **Capability gating**
   - Tools, services, browser/API packs, and adapters execute only through admitted packs, granted capabilities, and support-target-compatible routes.
   - Browser/API actions fail closed unless runtime service, egress/replay evidence, and support dossier requirements are met.

6. **Rollback and recovery**
   - Material actions have rollback or compensation posture consistent with materiality.
   - Recovery drills for repo mutation, stale context, circuit breaker, mission pause/resume, and browser/API staged scenarios produce retained evidence.

7. **Intervention quality**
   - Pause, narrow, revoke, safing, resume, and circuit-breaker paths are validated and evidenced.
   - Human interventions are control/evidence artifacts, not hidden chat or UI state.

8. **Proof automation**
   - RunCards are generated from retained run evidence.
   - HarnessCards are generated from support/lab/benchmark evidence.
   - Evidence completeness is machine-checked.

9. **Benchmark honesty**
   - Octon is benchmarked against raw frontier-model and thin-wrapper baselines.
   - Octon demonstrates governance value at acceptable overhead: better authorization discipline, evidence completeness, replayability, rollback/recovery quality, and support-claim correctness.

10. **Actor simplicity**
    - A consequential run has exactly one accountable orchestrator.
    - Specialists are bounded and optional.
    - Verifier is optional and materially justified.
    - Teams are composition profiles, not runtime actors.

11. **Workflow economy**
    - Retained core workflows encode authority, evidence, recovery, publication, or support-admission value.
    - Thinking-only workflows are removed, demoted, or moved to practices/optional packs.

12. **Portability honesty**
    - Frontier-native and degraded/local tiers are explicitly declared.
    - Adapter claims are proof-backed and limited to admitted tuples.
    - Experimental adapters cannot produce live support claims.

## Rejection criteria

Reject or defer this proposal if implementation attempts to:

- treat generated cognition as authority;
- make proposal files runtime dependencies;
- broaden support claims without tuple proof;
- make browser/API/multimodal support live before runtime/evidence readiness;
- delete governance surfaces merely because they resemble old AI tooling;
- preserve workflows, agent topologies, or cognition layers without governance/runtime/assurance value.
