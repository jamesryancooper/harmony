# Actor, Runtime, Cognition, and Assurance Model

## Actor model

### Target vocabulary

| Term | Durable meaning | Runtime status |
|---|---|---|
| Accountable orchestrator | Single owner for planning, execution discipline, delegation, risk tiering, final integration, and closeout. | Required for consequential run. |
| Bounded specialist | Focused assistant or specialist role with narrow permissions and escalation triggers. | Optional. |
| Independent verifier | Separate judgment role used for materiality, separation-of-duties, or benchmark/proof needs. | Optional and justified. |
| Team/profile | Reusable composition/routing configuration. | Not a runtime actor. |

### Rules

- Exactly one accountable orchestrator per consequential run.
- Specialists cannot own missions or mint authority.
- Verifier cannot retroactively authorize actions; it supplies evidence/judgment through canonical control/evidence paths.
- Teams cannot become hidden swarms or second schedulers.
- Actor privilege is least-privilege and capability-gated.

## Runtime model

### Minimum runtime-native services

1. Run manager.
2. Authorization/policy engine.
3. Capability gateway.
4. Context assembler.
5. Evidence/receipt store.
6. Telemetry/replay store.
7. Lease/directive/circuit-breaker controller.
8. Rollback/recovery service.
9. Host/model adapter boundary.
10. Browser/UI service when admitted.
11. API/connector egress service when admitted.
12. Assurance/benchmark runner.

### Material execution invariant

No material path may bypass:

```text
ExecutionRequest -> authorize_execution -> GrantBundle -> governed invocation -> ExecutionReceipt -> retained evidence
```

## Cognition/context/retrieval model

### Target posture

- Context packs are the primary frontier-native context unit.
- Generated cognition is derived read-model material only.
- Retrieval is used when justified by data size, dynamism, externality, legal scope, or exact provenance, not as accidental memory.
- Raw inputs and proposals are source material only and never direct runtime/policy dependencies.
- Context packs must record provenance, freshness, source hashes, authority labels, generated/authoritative separation, and omissions.

### Generated cognition guardrails

Generated cognition may:

- summarize missions;
- project operator digests;
- provide read-only graph/projection datasets;
- help build context packs when fresh and labeled.

Generated cognition may not:

- approve or deny actions;
- define support truth;
- override policy;
- serve as mission control state;
- be treated as ADR/memory authority;
- satisfy evidence obligations.

## Orchestration/mission/run model

- Missions are continuity containers.
- Runs are atomic consequential execution units.
- Workflows are governance/evidence/recovery/publication procedures, not model-thought recipes.
- Stage/promote/finalize patterns remain valid when they encode authority and evidence.
- Workflow-only execution remains transitional compatibility and should expire.

## Assurance model

Assurance must prove these properties:

1. structural coherence;
2. authority correctness;
3. support-target truth;
4. capability admission correctness;
5. runtime receipt completeness;
6. replayability;
7. rollback/recovery quality;
8. intervention quality;
9. behavior under faults and denials;
10. comparative governance value against raw frontier-model baselines.

## Benchmark model

Benchmark suites should compare:

- raw frontier model with same context;
- raw frontier model plus thin tool wrapper;
- Octon-governed single-orchestrator run;
- Octon-governed run with verifier;
- degraded/local profile.

The primary score is not intelligence gain. The primary score is governance value: authorized actions, denied unsafe actions, evidence completeness, replayability, rollback/recovery, intervention quality, and support honesty.
