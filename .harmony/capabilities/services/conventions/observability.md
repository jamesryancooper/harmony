---
title: Service Observability
scope: harness
applies_to: services
migrated_from: packages/kits/kit-base/src/observability.ts
---

# Service Observability

Services inherit kit observability primitives with a service-oriented naming convention.

## Span Naming

Required naming convention:

- `service.{id}.{action}`

Examples:

- `service.guard.check`
- `service.cost.estimate`
- `service.flow.run`

This replaces the kit-era `kit.{kitName}.{action}` naming while preserving event and attribute semantics.

## Required Attributes

Per root operation span:

- `run.id`
- `service.name` (for services: `harmony.service.{id}`)
- `service.version`
- `stage`

Common optional correlation attributes:

- `git.sha`
- `repo`
- `branch`
- dependency-specific attributes (for example `provider`, `endpoint`)

## Event Vocabulary

Standard span events:

- `state.enter`
- `inputs.validated`
- `artifact.write`
- `gate.pass`
- `gate.block`
- `hitl.requested`
- `hitl.approved`
- `hitl.rejected`
- `hitl.waived`
- `error`
- `policy.fail`
- `eval.fail`
- `flag.toggle`

## Error and Status Semantics

- Success path sets span status `OK`.
- Failures set span status `ERROR`, with recorded exception.
- Guard/policy/evaluation outcomes should emit explicit gate events for auditability.
