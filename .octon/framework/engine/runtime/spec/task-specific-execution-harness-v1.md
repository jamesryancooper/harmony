# Task-Specific Execution Harness v1

This contract defines the minimum task-specific harness record needed to bind a
task to Workflow Statechart v1 and Run Lifecycle v1.

The harness is a compilation and validation record. It is not an approval,
grant, effect token, control plane, support-target admission, generated
projection authority, or closeout artifact.

## Required Binding Envelope

A valid harness record must bind:

- objective binding;
- run-contract binding;
- support-target binding;
- capability-envelope binding;
- context-pack binding;
- authorization-route binding;
- effect-token class binding;
- evidence-obligation binding;
- rollback or compensation binding;
- human-intervention binding;
- model/cost policy binding; and
- closeout-criteria binding.

Each binding must point to durable framework, instance, state/control, or
state/evidence surfaces appropriate for its role. Generated projections and raw
input surfaces are invalid as runtime or policy authority. Proposal lineage may
be recorded only outside the binding envelope and only as non-authoritative
lineage.

## Control And Evidence Placement

Harness control refs must stay under `/.octon/state/control/**`. Harness
retained evidence refs must stay under `/.octon/state/evidence/**`. Generated
projection refs, when present, must stay under
`/.octon/generated/cognition/projections/materialized/**` and must carry
`non_authoritative` classification.

## Compilation Receipt

A compilation receipt records that a concrete task harness was checked against
Workflow Statechart v1, Run Lifecycle v1, and the required binding envelope.
The receipt may prove readiness to request authorization, but it does not
authorize material execution. Material effects still require Run Lifecycle v1,
Execution Authorization v1, a valid grant bundle, typed authorized effect
tokens, retained evidence, and journal coverage.

## Related Contracts

- `/.octon/framework/engine/runtime/spec/workflow-statechart-v1.md`
- `/.octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/task-specific-execution-harness-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/task-specific-execution-harness-compile-receipt-v1.schema.json`
- `/.octon/framework/engine/runtime/spec/run-lifecycle-v1.md`
- `/.octon/framework/engine/runtime/spec/execution-authorization-v1.md`
