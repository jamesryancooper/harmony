# Workflow Statechart v1

This contract defines a workflow-facing statechart overlay for Run Lifecycle v1.
It does not create a second control plane and does not replace the canonical
Run Journal, `runtime-state.yml`, execution authorization, context-pack,
effect-token, evidence-store, support-target, or fail-closed contracts.

## Canonical Binding

Workflow state is reconstructed from the existing run lifecycle roots:

- `/.octon/state/control/execution/runs/<run-id>/events.ndjson`
- `/.octon/state/control/execution/runs/<run-id>/events.manifest.yml`
- `/.octon/state/control/execution/runs/<run-id>/runtime-state.yml`
- `/.octon/state/control/execution/runs/<run-id>/rollback-posture.yml`
- `/.octon/state/evidence/runs/<run-id>/**`
- `/.octon/state/evidence/disclosure/runs/<run-id>/run-card.yml`

The workflow statechart is an overlay and validation view. Accepted lifecycle
movement still happens only through the canonical Run Journal append path
described by Run Lifecycle v1 and Run Journal v1.

## State Mapping

| Workflow state | Run Lifecycle v1 state | Notes |
| --- | --- | --- |
| `draft` | `draft` | Request exists but no run roots are live. |
| `bound` | `bound` | Bound run roots exist before consequential effects. |
| `authorized` | `authorized` | Decision artifact, grant bundle, support binding, context pack, and token readiness are present. |
| `running` | `running` | An authorized stage attempt is active. |
| `paused` | `paused` | Execution is intentionally suspended at a safe interrupt boundary. |
| `staged` | `staged` | Authority routing allows stage-only continuation or escalation only. |
| `revoked` | `revoked` | A revocation or equivalent stop condition is active. |
| `failed` | `failed` | Execution failed before successful compensation or closeout. |
| `rolled_back` | `rolled_back` | Rollback or compensation completed. |
| `succeeded` | `succeeded` | Requested work finished under a valid support posture. |
| `denied` | `denied` | Request or transition was denied before further consequential work. |
| `closed` | `closed` | Evidence completeness, disclosure, and review requirements passed. |

## Legal Transitions

The legal transition matrix is exactly the Run Lifecycle v1 matrix:

- `draft` -> `bound`, `denied`
- `bound` -> `authorized`, `staged`, `denied`
- `authorized` -> `running`, `staged`, `revoked`, `denied`
- `running` -> `paused`, `failed`, `revoked`, `succeeded`, `staged`
- `paused` -> `running`, `revoked`, `failed`
- `staged` -> `authorized`, `revoked`, `closed`
- `revoked` -> `rolled_back`, `closed`
- `failed` -> `rolled_back`, `closed`
- `rolled_back` -> `closed`
- `succeeded` -> `closed`
- `denied` -> `closed`
- `closed` -> terminal

Any transition outside that matrix is invalid and must fail closed with a
deterministic fail-closed reason code. A generated diagram, generated read
model, proposal packet, raw input, host label, or chat transcript is never a
valid lifecycle authority source.

## Required Transition Facts

Every workflow transition attempt must preserve the Run Lifecycle v1 separation
of facts:

- control refs for run contract, manifest, journal, runtime state, rollback
  posture, authority, checkpoints, and stage attempts;
- retained evidence refs for context, receipts, replay, assurance,
  measurements, interventions, snapshots, and disclosure inputs;
- generated refs only as derived read models; and
- state rebuild provenance back to canonical journal events and bounded side
  artifacts.

## Task-Specific Harness Binding

A task-specific execution harness may compile a task into workflow-statechart
execution only when it binds all of these fields:

- objective;
- run contract;
- support target;
- capability envelope;
- context pack;
- authorization route;
- effect-token classes;
- evidence obligations;
- rollback or compensation posture;
- human-intervention posture;
- model/cost policy; and
- closeout criteria.

The harness binds a task to existing runtime authority. It does not authorize
execution, mint grants, consume effects, close runs, or widen support claims by
itself.

## Generated Projection Rule

Generated statechart diagrams and read models are navigation aids only. They
must cite durable source specs or retained evidence, carry an explicit
non-authority notice, and remain forbidden as runtime authority, policy
authority, control truth, support-claim authority, or closeout evidence.

## Related Contracts

- `/.octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/task-specific-execution-harness-v1.md`
- `/.octon/framework/engine/runtime/spec/task-specific-execution-harness-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/task-specific-execution-harness-compile-receipt-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/run-lifecycle-v1.md`
- `/.octon/framework/engine/runtime/spec/run-journal-v1.md`
- `/.octon/framework/engine/runtime/spec/execution-authorization-v1.md`
- `/.octon/framework/engine/runtime/spec/context-pack-builder-v1.md`
- `/.octon/framework/engine/runtime/spec/authorized-effect-token-v1.md`
- `/.octon/framework/engine/runtime/spec/evidence-store-v1.md`
