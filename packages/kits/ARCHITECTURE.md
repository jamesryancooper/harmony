# Kit Architecture

This document defines the architectural principles, granularity policy, and dependency rules for the Harmony Kit ecosystem.

## Philosophy

**Kits are modular building blocks for AI agents.** Each kit encapsulates a single, well-scoped responsibility that AI agents orchestrate to accomplish tasks. Human developers rarely interact with kits directly — they orchestrate AI agents via the `harmony` CLI.

```
Human → harmony CLI → AI Agents → Kits → Results
```

## Kit Granularity Policy

### Guiding Principle

Each kit has a **single, well-scoped responsibility** that maps cleanly to one domain. We avoid both extremes:

- **Too coarse**: Monolithic kits that do too much, violating single responsibility
- **Too fine**: Proliferation of tiny kits that create dependency complexity

### When to Create a New Kit (Positive Criteria)

Create a new kit when **ALL** of these are true:

1. **Distinct responsibility** — The capability doesn't fit an existing kit's domain
2. **Distinct contract** — It has its own input/output schema that differs from existing kits
3. **Independent operation** — It can be useful standalone, without requiring another kit
4. **Multiple consumers** — It would be used by multiple workflows or other kits
5. **Single responsibility preserved** — Adding it to an existing kit would violate that kit's focus

### When NOT to Create a New Kit (Negative Criteria)

Do not create a kit when:

1. **Fits existing kit** — The capability belongs in an existing kit's domain
2. **Cross-cutting infrastructure** — It's used by ALL kits (→ belongs in `kit-base`)
3. **Circular dependency** — It would create circular `requires` dependencies
4. **Single consumer** — Only one other kit would use it (→ make it a capability of that kit)
5. **No independent value** — It cannot operate meaningfully on its own

### Decision Heuristic

Before proposing a new kit, ask:

1. "Could this be a capability of an existing kit?" → If yes, add to existing kit
2. "Is this cross-cutting infrastructure?" → If yes, add to `kit-base`
3. "Does this need to be independent?" → If no, reconsider

## Dependency Rules

### Dependency Types

Kit dependencies are categorized into three types with distinct semantics:

| Type | Meaning | Direction | Example |
|------|---------|-----------|---------|
| **requires** | Runtime dependency; must be available | One-way only | All kits require `kit-base` |
| **orchestrates** | This kit controls/coordinates another | Parent → Child | FlowKit orchestrates GuardKit |
| **integratesWith** | Optional integration; can work together | Bidirectional OK | CostKit integrates with PromptKit |

### Dependency Rules

1. **All kits require kit-base** — This is implicit and one-way
2. **Kits are orchestrated, not aware of orchestrators** — GuardKit doesn't know FlowKit exists
3. **Circular `requires` are forbidden** — If A requires B, B cannot require A
4. **Circular `orchestrates` are forbidden** — No bidirectional orchestration
5. **Circular `integratesWith` are allowed** — These are optional integrations

### Current Kit Dependency Graph

```
kit-base (infrastructure)
    ↑ requires
    |
┌───┴───────────────────────────────┐
│                                   │
│  ┌─────────┐                      │
│  │ FlowKit │ ─── orchestrates ───→ PromptKit
│  │         │ ─── orchestrates ───→ GuardKit
│  │         │ ─── orchestrates ───→ CostKit
│  └─────────┘                      │
│                                   │
│  PromptKit ←── integratesWith ──→ GuardKit
│  PromptKit ←── integratesWith ──→ CostKit
│  GuardKit  ←── integratesWith ──→ CostKit
│                                   │
└───────────────────────────────────┘
```

## Resolving Circular Concerns

When two capabilities seem to need each other (e.g., PolicyKit evaluating EvalKit, EvalKit evaluating PolicyKit):

### Resolution Strategies

1. **Extract shared contracts** — Move shared types/schemas to `kit-base`
2. **Orchestration pattern** — Have FlowKit orchestrate the interaction; neither kit knows about the other
3. **Precedence rules** — Define which kit is "upstream" (one evaluates the other, not vice versa)

### Example: PolicyKit and EvalKit

```
BAD:  PolicyKit ←── requires ──→ EvalKit  (circular!)

GOOD: kit-base defines shared RuleResult schema
      FlowKit orchestrates: PolicyKit → EvalKit (sequential)
      Neither kit imports the other
```

## kit-base vs. New Kit Threshold

Use this table to decide whether a capability belongs in `kit-base` or warrants a new kit:

| Criterion | kit-base | New Kit |
|-----------|----------|---------|
| **Consumers** | All kits need it | Some kits/workflows need it |
| **Nature** | Infrastructure (errors, types, tracing) | Domain logic (costs, guards, prompts) |
| **Independence** | No standalone value | Independently useful |
| **Contract** | No input/output schema | Has distinct schemas |
| **State** | Stateless utilities | May have configuration/state |

### What Belongs in kit-base

- Error types and exit codes
- OpenTelemetry instrumentation helpers
- Run record creation utilities
- CLI flag parsing
- Zod validation utilities
- Idempotency key management
- Common types (lifecycle stages, risk tiers, pillars)

### What Becomes a Kit

- Domain-specific logic with distinct I/O contracts
- Capabilities that can operate independently
- Features that multiple workflows consume differently

## Planned Kits Evaluation

Applying the granularity heuristic to planned kits:

| Kit | Verdict | Rationale |
|-----|---------|-----------|
| **SpecKit** | ✅ Create | Distinct responsibility (spec validation), independent operation, clear contract |
| **PlanKit** | ✅ Create | Distinct responsibility (planning/ADR), independent operation, clear contract |
| **TestKit** | ⚠️ Evaluate | May overlap with EvalKit — both do "quality assessment". Consider: TestKit = generation + execution; EvalKit = scoring/evaluation |
| **EvalKit** | ✅ Create | Distinct responsibility (quality scoring), clear contract, multiple consumers |
| **PolicyKit** | ✅ Create | Distinct responsibility (rule enforcement), clear contract, used by many kits |
| **ObservaKit** | ❌ Do not create | Observability instrumentation belongs in `kit-base`. Observability operations (dashboards, alerting) are external systems, not kits |
| **PatchKit** | ✅ Create | Distinct responsibility (PR/patch creation), independent operation, clear contract |

### TestKit vs. EvalKit Decision

These kits have related but distinct responsibilities:

| Aspect | TestKit | EvalKit |
|--------|---------|---------|
| **Question** | "Does this code behave correctly?" | "Does this output meet quality criteria?" |
| **Inputs** | Code, test specs | AI outputs, evaluation criteria |
| **Outputs** | Test results (pass/fail) | Quality scores, evaluations |
| **Primary use** | Verify stage | Verify stage |

**Verdict**: Both should exist as separate kits. TestKit focuses on functional correctness (generate and run tests). EvalKit focuses on qualitative assessment (score AI outputs against criteria).

### ObservaKit Decomposition

The proposed "ObservaKit" should NOT be created. Instead:

| Concern | Where It Belongs |
|---------|------------------|
| Span creation, trace context | `kit-base/observability` (already exists) |
| Log formatting, redaction | `kit-base/observability` (already exists) |
| Metric collection | `kit-base/observability` (enhance if needed) |
| Trace aggregation/querying | External (OpenTelemetry Collector → Tempo) |
| Alert management | External (Prometheus/Alertmanager) |
| Dashboard generation | External (Grafana) |

## Versioning

This architecture document aligns with:

- **Schema version**: 1.3.0
- **Methodology version**: 0.2.0

Changes to dependency types or granularity policy should bump the schema version.

## Related Documentation

- [Kit README](./README.md) — Package overview and quick start
- [kit-base README](./kit-base/README.md) — Shared infrastructure documentation
- [Methodology-as-Code](../../docs/harmony/ai/methodology/methodology-as-code.md) — Schema versioning policy

