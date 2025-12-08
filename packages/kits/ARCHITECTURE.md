# Kit Architecture

This document defines the architectural principles, strengths, granularity policy, and dependency rules for the Harmony Kit ecosystem.

**Status:** Production-ready architecture (Schema v1.3.0, Methodology v0.2.0)

## Table of Contents

- [Philosophy](#philosophy)
- [Architectural Strengths](#architectural-strengths)
- [Kit Granularity Policy](#kit-granularity-policy)
- [Dependency Rules](#dependency-rules)
- [Resolving Circular Concerns](#resolving-circular-concerns)
- [kit-base vs. New Kit Threshold](#kit-base-vs-new-kit-threshold)
- [Planned Kits Evaluation](#planned-kits-evaluation)
- [Versioning](#versioning)
- [Related Documentation](#related-documentation)

---

## Philosophy

**Kits are modular building blocks for AI agents.** Each kit encapsulates a single, well-scoped responsibility that AI agents orchestrate to accomplish tasks. Human developers rarely interact with kits directly — they orchestrate AI agents via the `harmony` CLI.

```text
Human → harmony CLI → AI Agents → Kits → Results
```

---

## Architectural Strengths

The Kit system architecture is **production-ready** and designed for AI-first consumption with human oversight. This section documents what developers can expect from the architecture.

### 1. Methodology-as-Code

Methodology constraints are encoded into machine-readable schemas, not just documentation.

| What You Get | How It Works |
|--------------|--------------|
| **Typed contracts** | JSON schemas + Zod validation enforce structure at runtime |
| **Version tracking** | All metadata includes `schemaVersion` and `methodologyVersion` |
| **Safe evolution** | Enforcement modes (`block`, `warn`, `off`) enable graceful transitions |
| **Deprecation windows** | N-1 version support with explicit migration notes |
| **CI validation** | `pnpm --filter @harmony/kit-base validate:methodology` |

**What to expect:** When methodology changes, schemas change. AI agents consume schemas directly; humans read documentation. Breaking changes follow semver with deprecation windows.

See [Methodology-as-Code](../../docs/harmony/ai/methodology/methodology-as-code.md) for the full policy.

### 2. Separation of Concerns

Each kit has a single, well-scoped responsibility with clean boundaries.

```text
┌─────────────────────────────────────────────────────────────────┐
│  kit-base (cross-cutting infrastructure)                         │
│  - Types, Errors, Observability, CLI, Validation, Idempotency   │
└─────────────────────────────────────────────────────────────────┘
                              ↑
                              │ requires (all kits)
                              │
┌─────────────────────────────────────────────────────────────────┐
│  Domain Kits (single responsibility each)                        │
│                                                                   │
│  FlowKit     → Workflow orchestration                            │
│  GuardKit    → Safety gates (injection, secrets, hallucination)  │
│  PromptKit   → Prompt compilation with determinism               │
│  CostKit     → Budget management and cost tracking               │
└─────────────────────────────────────────────────────────────────┘
```

**What to expect:** Infrastructure code lives in `kit-base`. Domain logic lives in individual kits. You'll never find cost estimation in GuardKit or observability helpers spread across kits.

### 3. Observable by Default

Every kit operation produces observable artifacts for debugging and audit.

| Artifact | Purpose | Default |
|----------|---------|---------|
| **OTel spans** | Distributed tracing with `kit.<name>.<action>` naming | Always |
| **Run records** | JSON audit trail with inputs, outputs, timing | Enabled (`--enable-run-records`) |
| **Typed errors** | Exit codes 1-8 with semantic meaning | Always |
| **State events** | `state.enter`, `gate.pass`, `artifact.write` span events | Always |

**What to expect:** You can trace any kit operation from invocation to completion. Run records provide replay capability. Error codes enable deterministic orchestrator decisions.

```bash
# Query run records
kit-runs list --kit flowkit --status failure --limit 10
kit-runs show <runId>
kit-runs find --trace <traceId>
kit-runs stats --since 2024-01-01
```

### 4. Pluggable Idempotency

Operations can be made idempotent with automatic caching and replay.

| Storage Backend | Use Case | Durability |
|-----------------|----------|------------|
| `InMemoryIdempotencyStorage` | Single process, testing | Lost on restart |
| `RunRecordIdempotencyStorage` | Production, services | Survives restarts |
| Custom implementation | Redis, database, etc. | External |

**What to expect:** When you pass `--idempotency-key`, the system automatically uses durable storage. Repeated calls with the same key return cached results without re-execution.

```typescript
// Automatic idempotency protection
const { result, cached, runId } = await withIdempotency(
  key, kitName, operation, inputs,
  async () => executeOperation()
);

if (cached) {
  console.log('Returned cached result from:', runId);
}
```

### 5. Triple Interface Pattern

Every kit exposes three consistent interfaces for different consumers.

| Interface | Primary Consumer | Characteristics |
|-----------|------------------|-----------------|
| **Programmatic API** | AI agents, services | Typed, fastest, full control |
| **HTTP/RPC** | Python/cross-language | Protocol-based, distributed |
| **CLI** | Humans, CI/CD | Text/JSON output, scriptable |

**What to expect:** All interfaces share the same implementation and return equivalent data structures. Choose based on your consumer's needs, not capability differences.

```typescript
// Same result, different interfaces
const api = new GuardKit(config);
const http = createHttpGuardRunner({ baseUrl });
const cli = 'guardkit check --format json';
```

### 6. Fail-Closed Governance

The error taxonomy enables deterministic policy enforcement.

| Exit Code | Error Class | Meaning | Orchestrator Action |
|-----------|-------------|---------|---------------------|
| 0 | — | Success | Continue |
| 1 | `GenericKitError` | Unexpected failure | Retry or escalate |
| 2 | `PolicyViolationError` | Policy gate blocked | Halt, require human |
| 3 | `EvaluationFailureError` | Quality gate failed | Retry with different approach |
| 4 | `GuardViolationError` | Safety issue detected | Block, redact, or sanitize |
| 5 | `InputValidationError` | Schema validation failed | Fix inputs |
| 6 | `UpstreamProviderError` | External service failure | Retry with backoff |
| 7 | `IdempotencyConflictError` | Duplicate operation | Return cached result |
| 8 | `CacheIntegrityError` | Cache corruption | Invalidate and retry |

**What to expect:** Errors are not just messages — they're typed signals that orchestrators can handle deterministically. Exit code 2 always means "policy blocked this"; exit code 7 always means "already done".

### 7. Run Record Query Capabilities

Run records are first-class observable artifacts with full lifecycle management.

**Centralized Storage (Recommended):**

Set `HARMONY_RUNS_DIR` to aggregate all kit run records in one location:

```bash
# Via direnv (.envrc) or shell profile
export HARMONY_RUNS_DIR=$PWD/runs

# Records organized by kit: $HARMONY_RUNS_DIR/<kitName>/*.json
```

**Query Commands:**

```bash
# List and filter
kit-runs list [--kit <name>] [--status success|failure] [--since <date>] [--limit N]

# Inspect individual records
kit-runs show <runId>

# Find by correlation
kit-runs find --trace <traceId>
kit-runs find --idempotency-key <key>

# Statistics and analytics
kit-runs stats [--kit <name>] [--since <date>] [--until <date>]

# Lifecycle management
kit-runs cleanup --max-age 30d [--dry-run]
kit-runs usage

# Export for external systems
kit-runs export --export-format json --output ./export.json
kit-runs export --collector-url http://otel-collector:4318
```

**What to expect:** Run records support query, export, and cleanup. They integrate with OpenTelemetry Collector for centralized observability. Retention policies prevent unbounded growth. See [kit-base/README.md](./kit-base/README.md#run-records) for detailed configuration.

### 8. Typed Dependencies

Kit relationships are explicit and validated.

```json
{
  "dependencies": {
    "requires": ["kit-base"],
    "orchestrates": ["promptkit", "guardkit"],
    "integratesWith": ["costkit"]
  }
}
```

| Dependency Type | Meaning | Validation |
|-----------------|---------|------------|
| `requires` | Must be available at runtime | Circular forbidden |
| `orchestrates` | This kit controls another | Unidirectional only |
| `integratesWith` | Optional integration | Bidirectional OK |

**What to expect:** The dependency graph is explicit and validated. Static analysis can detect circular dependencies before runtime. Documentation is auto-generated from metadata.

### Summary: What Developers Can Expect

| Concern | What You Get |
|---------|--------------|
| **Contracts** | Machine-readable schemas, runtime validation, version tracking |
| **Observability** | OTel tracing, run records, typed errors with exit codes |
| **Idempotency** | Pluggable storage, automatic replay, key derivation |
| **Interfaces** | Programmatic API, HTTP, CLI — all consistent |
| **Governance** | Fail-closed errors, policy enforcement, audit trails |
| **Evolution** | Semantic versioning, deprecation windows, enforcement modes |

---

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

### Enforcement Rules

1. **All kits require kit-base** — This is implicit and one-way
2. **Kits are orchestrated, not aware of orchestrators** — GuardKit doesn't know FlowKit exists
3. **Circular `requires` are forbidden** — If A requires B, B cannot require A
4. **Circular `orchestrates` are forbidden** — No bidirectional orchestration
5. **Circular `integratesWith` are allowed** — These are optional integrations

### Current Kit Dependency Graph

```text
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

```text
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

---

## Related Documentation

| Document | Purpose |
|----------|---------|
| [README.md](./README.md) | Package overview and quick start |
| [ROADMAP.md](./ROADMAP.md) | Future considerations, planned enhancements, decision log |
| [kit-base/README.md](./kit-base/README.md) | Shared infrastructure documentation |
| [Methodology-as-Code](../../docs/harmony/ai/methodology/methodology-as-code.md) | Schema versioning policy |

---

## Changelog

### 2024-12 Centralized Run Records

- Added `HARMONY_RUNS_DIR` environment variable for centralized run record storage
- Documented direnv setup with `.envrc` example
- Updated Run Record Query Capabilities with centralized storage guidance
- Added `runs/` to `.gitignore`

### 2024-12 Production-Ready Architecture

- Added comprehensive [Architectural Strengths](#architectural-strengths) section
- Created [ROADMAP.md](./ROADMAP.md) for future considerations
- Documented Observable by Default, Pluggable Idempotency, Triple Interface Pattern
- Added Run Record Query Capabilities documentation
- Established decision log for architectural choices
