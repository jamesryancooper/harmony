# Kit Architecture

This document defines the architectural principles, patterns, assessments, and operational guidelines for the Harmony Kit ecosystem. Use it to understand design decisions, tradeoffs, and the reasoning behind the architecture.

**Status:** Production-ready architecture (Schema v1.3.0, Methodology v0.2.0)  
**Audience:** Senior engineers and system architects

## Table of Contents

- [Philosophy](#philosophy)
- [Design Pattern Alignment](#design-pattern-alignment)
- [Architectural Assessment](#architectural-assessment)
- [Architecture Alignment Score](#architecture-alignment-score)
- [Architectural Strengths](#architectural-strengths)
- [Component and Responsibility Matrix](#component-and-responsibility-matrix)
- [Request Flow Overview](#request-flow-overview)
- [Source of Truth Table](#source-of-truth-table)
- [RACI Matrix](#raci-matrix)
- [Kit Granularity Policy](#kit-granularity-policy)
- [Dependency Rules](#dependency-rules)
- [Resolving Circular Concerns](#resolving-circular-concerns)
- [kit-base vs. New Kit Threshold](#kit-base-vs-new-kit-threshold)
- [Planned Kits Evaluation](#planned-kits-evaluation)
- [Risks and Anti-Patterns](#risks-and-anti-patterns)
- [New Kit Implementation Checklist](#new-kit-implementation-checklist)
- [Summary](#summary)
- [Versioning](#versioning)
- [Related Documentation](#related-documentation)

---

## Philosophy

**Kits are modular building blocks for AI agents.** Each kit encapsulates a single, well-scoped responsibility that AI agents orchestrate to accomplish tasks. Human developers rarely interact with kits directly — they orchestrate AI agents via the `harmony` CLI.

```text
Human → harmony CLI → AI Agents → Kits → Results
```

---

## Design Pattern Alignment

This table explains how the Kit system architecture aligns with common architectural patterns and where it intentionally diverges.

| Pattern | Alignment | How It Manifests | Divergences / Notes |
|---------|-----------|------------------|---------------------|
| **Layered Architecture** | ✅ Strong | `kit-base` → Domain Kits → Orchestration. Clear dependency direction (downward only). | Kits do not form a strict N-tier — they're peer modules at the same layer above `kit-base`. |
| **Hexagonal / Ports & Adapters** | ✅ Strong | Each kit defines typed ports (schemas) and provides adapters (HTTP runners, CLI). Domain logic is isolated from transport. | HTTP/CLI adapters are thin wrappers; core logic lives in programmatic API. |
| **Plugin / Extension Architecture** | ⚠️ Partial | Kits are modular building blocks that can be composed. Pluggable storage backends (`IdempotencyStorage`). | Kits are not dynamically discovered or loaded — they're statically composed at build time. |
| **Modular Monolith** | ✅ Strong | All kits live in a single repo/workspace with clear boundaries. Each kit has its own package, types, and tests. | This is the **primary architectural pattern**. Boundaries are enforced by TypeScript, not network calls. |
| **Microservices** | ❌ Intentionally avoided | HTTP runners enable service-like deployment, but kits are designed as libraries, not services. | Microservice overhead is inappropriate for a 2-person team. HTTP exists for cross-language access, not service isolation. |
| **Event-Driven / Pub-Sub** | ❌ Not implemented | No event bus or async messaging between kits. | Kits communicate via direct invocation. Event sourcing may be considered for complex workflows later. |
| **Contract-First** | ✅ Strong | JSON schemas define kit inputs/outputs. Zod provides runtime validation. Methodology-as-Code encodes constraints. | Contracts are versioned with deprecation windows. AI agents consume schemas directly. |
| **Observable Architecture** | ✅ Strong | Every operation produces OTel spans, run records, and typed errors. Built-in audit trail. | Observability is not optional — it's a first-class concern in every kit. |
| **Fail-Closed Governance** | ✅ Strong | Exit codes have semantic meaning. Errors are typed signals, not just messages. Orchestrators make deterministic decisions. | Stricter than typical library error handling — designed for autonomous AI agents. |

---

## Architectural Assessment

### Is This the "Right" Architecture?

This table evaluates how well the Kit system fits its intended requirements, constraints, and goals.

| Evaluation Factor | Assessment | Evidence | For Your Context |
|-------------------|------------|----------|------------------|
| **Simplicity** | ⚠️ Moderate | Many moving parts (schemas, metadata, run records, idempotency). Each part is individually simple. | Acceptable complexity for the value delivered. A simpler system would lack observability, idempotency, or typed contracts. |
| **Evolvability** | ✅ Excellent | Semantic versioning, deprecation windows, enforcement modes enable safe changes. Contract-first design allows independent evolution. | New kits can be added without modifying existing ones. Methodology changes follow schema versioning. |
| **AI-Friendliness** | ✅ Excellent | Machine-readable schemas, deterministic behavior, typed errors, observable operations. AI agents consume contracts directly. | This is the **primary design goal**. Humans read docs; agents read schemas. |
| **Human Overhead** | ✅ Low | Triple interface pattern (API, HTTP, CLI) serves different needs. Humans interact via `harmony` CLI, not directly with kits. | Day-to-day development rarely touches kit internals. |
| **Enterprise-Grade** | ✅ High | Audit trails, idempotency, policy enforcement, observability, typed errors. | "Enterprise-ish" without enterprise bureaucracy. Quality without governance overhead. |
| **Team Size Fit** | ✅ Appropriate | Modular monolith avoids microservice ops overhead. Single repo enables full-stack changes in one PR. | Designed specifically for a 2-person team orchestrating AI agents. |
| **Performance** | ✅ Good | Programmatic API avoids HTTP overhead. O(1) idempotency lookups via index file. Run records are async-writable. | Performance is not the bottleneck — AI model latency dominates. |
| **Testability** | ✅ Excellent | Each kit has isolated tests. Typed contracts enable property-based testing. In-memory storage backends for unit tests. | High test coverage is achievable because boundaries are clear. |

### Compared to Alternatives

| Alternative Approach | Pros | Why We Didn't Choose It |
|----------------------|------|-------------------------|
| **Single monolithic SDK** | Simpler dependency graph, one import | Less modularity; harder for AI agents to reason about capabilities; no granular observability |
| **Microservices per kit** | Strong isolation, independent scaling | Massive ops overhead for 2 people; network latency; distributed debugging complexity |
| **Plugin architecture with dynamic loading** | Maximum runtime flexibility | Security concerns; harder to type; debugging nightmares; unnecessary for known kit set |
| **Event-sourced/CQRS** | Full audit trail, temporal queries | Overkill for current scale; adds complexity without clear benefit yet |

### Dimensional Assessment

| Dimension | Description | Strengths | Risks / Tradeoffs | Mitigations |
|-----------|-------------|-----------|-------------------|-------------|
| **Scalability** | Ability to handle increased load and add new kits | Modular design allows adding kits without changing existing ones; horizontal scaling possible via HTTP runners | File-based idempotency storage doesn't scale to multi-node; run record scans can be slow at high volume | Use durable storage adapter (Redis) when needed; index file provides O(1) lookups; retention policies limit growth |
| **Extensibility** | Ease of adding new capabilities | Clear granularity policy; typed dependency system; `kit-base` provides reusable infrastructure | New kits require careful evaluation against granularity criteria; risk of over-fragmentation | Decision heuristic documented; ObservaKit rejection shows policy is applied |
| **Observability** | Visibility into system behavior | Every operation produces OTel spans, run records, typed errors; centralized via `HARMONY_RUNS_DIR`; export to OTel Collector | Run records consume disk space; observability adds overhead | Retention policies; cleanup commands; run records are append-only (no read amplification) |
| **Developer Experience** | Ease of understanding and using kits | Triple interface pattern; consistent CLI flags; typed errors; comprehensive documentation | Learning curve for Methodology-as-Code; schema versioning adds conceptual overhead | Enforcement modes allow gradual adoption; human-focused docs separate from AI-focused schemas |
| **Reliability** | Ability to operate correctly under failure | Idempotency prevents duplicate operations; typed errors enable deterministic recovery; fail-closed governance | In-memory idempotency lost on crash; run record writes can fail | Durable storage available; safe write utilities; crash recovery via run record replay |
| **Security** | Protection against misuse and vulnerabilities | GuardKit checks for injection, secrets, PII; policy violations block operations; audit trail via run records | Secrets in run records if not redacted; HTTP runners need transport security | Redaction at write boundaries; HTTPS for HTTP interface; no secrets in observable outputs |
| **Maintainability** | Ease of making changes without breaking things | Separation of concerns; single responsibility per kit; typed contracts; deprecation windows | Tight coupling to methodology schemas; breaking changes require coordination | Semantic versioning; N-1 support; enforcement modes for transitions |

---

## Architecture Alignment Score

This section provides a quantitative assessment of how well the Kit system aligns with Harmony's methodology, architectural principles, and best practices.

**Assessment Date:** December 2025  
**Overall Grade:** 9.4/10

### Scoring Table

| Criterion | Score | Evidence |
|-----------|-------|----------|
| **Pillar Alignment** | 10/10 | Schema v1.3.0 includes all 5 Harmony pillars (`speed_with_safety`, `simplicity_over_complexity`, `quality_through_determinism`, `guided_agentic_autonomy`, `evolvable_modularity`). All kits declare pillar alignment in metadata. FlowKit demonstrates full alignment with `evolvable_modularity`. |
| **Observability** | 10/10 | OTel spans with `kit.<name>.<action>` naming. Run record query CLI (`kit-runs list/show/find/stats`). Centralized storage via `HARMONY_RUNS_DIR`. Export to OTel Collector. State transition events (`state.enter`, `gate.pass`, `artifact.write`). |
| **Error Handling** | 10/10 | Exit codes 0-8 with semantic meaning documented and implemented. HTTP status mapping defined. Typed error classes (`PolicyViolationError`, `InputValidationError`, etc.). Fail-closed governance with deterministic error handling. |
| **Run Records** | 9/10 | Enabled by default (`enableRunRecords: true`). Include `outputs` for idempotency replay. Query, export, and cleanup commands. Centralized via `HARMONY_RUNS_DIR`. Deduction: Runtime schema validation at write-time not confirmed in all paths. |
| **CLI Interface** | 9/10 | Comprehensive `cli-flags.ts` with `--dry-run`, `--stage`, `--risk`, `--idempotency-key`, `--cache-key`, `--trace`, `--format`. Flag validation for risk levels. Help text generation. Deduction: GuardKit/CostKit lack dedicated CLI entrypoints. |
| **Schema Validation** | 8/10 | Zod schemas documented for runtime validation. Schema v1.3.0 requires `determinism`, `safety`, `idempotency` fields. Input/output schemas declared in metadata. Deduction: Explicit `validateWithSchema()` calls not confirmed at all API boundaries. |
| **Idempotency** | 9/10 | `IdempotencyStorage` interface with multiple backends. `RunRecordIdempotencyStorage` for durable storage. Run records include `determinism.idempotencyKey` and `inputsHash`. `IdempotencyConflictError` (exit 7) implemented. Deduction: File-based storage has race condition risks in high-concurrency scenarios. |
| **Documentation** | 10/10 | Comprehensive ARCHITECTURE.md with design patterns, assessments, RACI matrix, granularity policy. ROADMAP.md with decision log. Triple interface pattern documented. Source of truth table. New kit implementation checklist. |

### Remaining Areas for Improvement

| Area | Impact | Description | Recommendation |
|------|--------|-------------|----------------|
| **CLI Entrypoints** | Minor | GuardKit and CostKit lack dedicated `cli.ts` entrypoints | Add CLI entrypoints to remaining kits for consistency |
| **Runtime Schema Validation** | Minor | Zod validation not confirmed at all kit entry points | Add explicit `validateWithSchema()` calls at API boundaries |
| **Idempotency Concurrency** | Conditional | File-based storage has race condition risks at high concurrency | Monitor in production; use Redis adapter when kits run as concurrent services (documented in ROADMAP) |
| **Main Export Barrel** | Minor | `src/index.ts` only re-exports FlowKit | Either remove or export all kits from barrel file |
| **Dry-Run Mode** | Minor | Kit classes don't expose explicit `dryRun` option in constructor | Add `dryRun: boolean` to kit configs to suppress side-effects programmatically |

### Conclusion

**Overall Grade: 9.4/10** — Production-ready architecture with excellent methodology alignment.

The Kit system demonstrates strong architectural alignment with Harmony's principles:

| Aspect | Status | Notes |
|--------|--------|-------|
| ✅ Pillar Alignment | Complete | All 5 pillars in schema and types; declared in kit metadata |
| ✅ CLI Standardization | Complete | Comprehensive flags in `kit-base/cli-flags.ts` |
| ✅ Idempotency | Implemented | Durable storage via run records; typed errors |
| ✅ Run Records | Default On | Query capabilities; centralized storage |
| ✅ Documentation | Comprehensive | ARCHITECTURE.md, ROADMAP.md with decision log |
| ✅ Policy Configuration | Consistent | All kits declare policy in metadata |

The remaining 0.6 points of improvement opportunity are minor polish items that don't affect production readiness:

- CLI entrypoints for all kits (consistency)
- Explicit dry-run support in constructors (convenience)
- Schema validation at all boundaries (defense in depth)

The architecture successfully answers the fundamental question: **How do you make software development safe and deterministic when AI agents are doing the work?** — with typed contracts, observable operations, fail-closed policies, and machine-readable methodology.

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
kit-runs stats --since 2025-01-01
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

## Component and Responsibility Matrix

| Kit | Primary Responsibility | Domain | Upstream Dependencies | Downstream Consumers | Key Contracts |
|-----|------------------------|--------|----------------------|----------------------|---------------|
| **kit-base** | Cross-cutting infrastructure | Infrastructure | None | All kits | `KitMetadata`, `RunRecord`, `KitError` |
| **FlowKit** | Workflow orchestration | Orchestration | kit-base | AI agents, harmony CLI | `FlowConfig`, `FlowRunRequest`, `FlowRunResult` |
| **GuardKit** | AI output safety | Safety | kit-base | FlowKit, AI agents | `CheckResult`, `SanitizeResult`, `GuardrailResult` |
| **PromptKit** | Prompt compilation | LLM | kit-base | FlowKit, AI agents | `CompiledPrompt`, `PromptMetadata`, `PromptInfo` |
| **CostKit** | Budget management | LLM | kit-base | FlowKit, AI agents | `CostEstimate`, `BudgetStatus`, `UsageRecord` |

---

## Request Flow Overview

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              Request Flow                                        │
└─────────────────────────────────────────────────────────────────────────────────┘

1. INVOCATION
   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
   │ CLI Command │  or  │ HTTP Runner │  or  │ Direct API  │
   └──────┬──────┘      └──────┬──────┘      └──────┬──────┘
          │                    │                    │
          └────────────────────┼────────────────────┘
                               │
2. FLAG/CONFIG PARSING         ▼
   ┌──────────────────────────────────────────────────┐
   │ parseStandardFlags() / config resolution         │
   │ Priority: CLI flags > env vars > kit defaults    │
   └──────────────────────────┬───────────────────────┘
                               │
3. VALIDATION                  ▼
   ┌──────────────────────────────────────────────────┐
   │ validateWithSchema(InputSchema, input)           │
   │ → InputValidationError (exit 5) on failure       │
   └──────────────────────────┬───────────────────────┘
                               │
4. IDEMPOTENCY CHECK           ▼
   ┌──────────────────────────────────────────────────┐
   │ checkIdempotencyKey(key, kit, op, inputs)        │
   │ → Return cached result if exists                 │
   │ → IdempotencyConflictError (exit 7) if pending   │
   └──────────────────────────┬───────────────────────┘
                               │
5. EXECUTION                   ▼
   ┌──────────────────────────────────────────────────┐
   │ withKitSpan(ctx, operation, async () => {        │
   │   emitStateTransition("pending", "executing")    │
   │   const result = await kit.operation(input)      │
   │   emitGateResult("policy_check", passed)         │
   │   return result                                  │
   │ })                                               │
   └──────────────────────────┬───────────────────────┘
                               │
6. RUN RECORD                  ▼
   ┌──────────────────────────────────────────────────┐
   │ writeRunRecord({                                 │
   │   runId, kit, inputs, outputs,                   │
   │   status, traceId, durationMs                    │
   │ }, runsDir)                                      │
   └──────────────────────────┬───────────────────────┘
                               │
7. RESPONSE                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Return typed result or throw typed error         │
   │ CLI: JSON/text output + exit code                │
   │ HTTP: JSON response + HTTP status                │
   │ API: Return value or thrown exception            │
   └──────────────────────────────────────────────────┘
```

---

## Source of Truth Table

| Concern | Source of Truth | Location | Consumers |
|---------|-----------------|----------|-----------|
| **Kit capabilities** | Kit metadata JSON | `<kit>/metadata/kit.metadata.json` | AI agents, validation scripts |
| **Input/output contracts** | JSON Schema + Zod | `<kit>/schema/*.json`, `<kit>/src/schemas.ts` | Runtime validation, documentation generation |
| **Methodology constraints** | Methodology-core schema | `kit-base/schema/methodology-core.v1.json` | Kit metadata validation, CI |
| **Error codes** | Error classes in kit-base | `kit-base/src/errors.ts` | All kits, orchestrators, documentation |
| **CLI flags** | Flag definitions in kit-base | `kit-base/src/cli-flags.ts` | All kit CLIs, help text |
| **Run record format** | Run record schema | `kit-base/schema/run-record.v1.json` | Run record writers, query tools |
| **Kit version** | `package.json` | `<kit>/package.json` | Build tools, metadata |
| **Schema version** | Kit metadata | `schemaVersion` field in metadata | Compatibility checks |

---

## RACI Matrix

This matrix clarifies responsibilities for kit operations across different components.

*R = Responsible, A = Accountable, C = Consulted, I = Informed*

| Activity | Kit Code | kit-base | FlowKit (Orchestrator) | Harmony CLI | Human |
|----------|----------|----------|------------------------|-------------|-------|
| **Input validation** | R | A | — | — | — |
| **Business logic execution** | R,A | — | — | — | — |
| **OTel span creation** | R | A (helpers) | — | — | — |
| **Run record creation** | R | A (helpers) | — | — | — |
| **Error type selection** | R | A (types) | — | — | — |
| **Workflow orchestration** | — | — | R,A | — | — |
| **Policy enforcement** | C | — | R,A | — | — |
| **HITL checkpoint** | I | — | R | C | A |
| **Budget approval** | I | — | R | C | A |
| **Kit implementation** | R,A | C | — | — | I |
| **Schema evolution** | C | R,A | — | — | I |

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

---

## Risks and Anti-Patterns

This section documents common risks and anti-patterns to avoid when working with the Kit system.

| Risk / Anti-Pattern | Description | How to Detect | Mitigation |
|---------------------|-------------|---------------|------------|
| **Circular dependencies** | Kit A requires Kit B requires Kit A | CI validation; dependency graph analysis | Use `integratesWith` for bidirectional relationships; extract shared contracts to `kit-base` |
| **Over-fragmentation** | Too many small kits with trivial responsibilities | Single-consumer kits; kits with no independent value | Apply granularity criteria; merge underused kits |
| **Under-fragmentation** | Monolithic kits doing too much | Kits with >3 distinct responsibilities; frequent cross-concern changes | Split by responsibility; extract to new kit if criteria met |
| **Leaky abstractions** | Internal types exposed in public API | Type imports crossing kit boundaries | Keep contracts in schema files; use `@internal` annotations |
| **Observability gaps** | Operations without spans or run records | Operations not appearing in `kit-runs list` | Ensure all public methods use `withKitSpan` |
| **Schema drift** | Runtime behavior diverging from schemas | Validation errors in production; AI agent failures | CI validation; property-based testing against schemas |
| **Methodology coupling without versioning** | Methodology changes breaking kits silently | Kits failing after methodology updates | Always include `methodologyVersion`; use enforcement modes |
| **In-memory assumptions** | Assuming idempotency survives restarts | Duplicate operations after restarts | Use `RunRecordIdempotencyStorage` when durability matters |
| **Unbounded run records** | No retention policy configured | Disk usage growing indefinitely | Configure `cleanupRunRecords` with retention policy |

---

## New Kit Implementation Checklist

Use this checklist when implementing a new kit to ensure architectural consistency.

### Granularity Validation

- [ ] Distinct responsibility (doesn't fit existing kit)
- [ ] Distinct contract (own input/output schema)
- [ ] Independent operation (useful standalone)
- [ ] Multiple consumers (not single-purpose)
- [ ] Single responsibility preserved (not bloating existing kit)

### Metadata

- [ ] `kit.metadata.json` with `schemaVersion: "1.3.0"`
- [ ] `methodologyVersion: "0.2.0"` specified
- [ ] `dependencies` block with `requires`, `orchestrates`, `integratesWith`
- [ ] Pillar alignment documented
- [ ] Lifecycle stages specified

### Contracts

- [ ] Input schema (`schema/<kit>.inputs.v1.json`)
- [ ] Output schema (`schema/<kit>.outputs.v1.json`)
- [ ] Zod schemas for runtime validation (`src/schemas.ts`)
- [ ] Typed error usage (from `kit-base`)

### Interfaces

- [ ] Programmatic API (class or factory function)
- [ ] HTTP runner (`createHttp<Kit>Runner`)
- [ ] CLI with standard flags (`<kit>/src/cli.ts`)
- [ ] `bin` entry in `package.json`

### Observability

- [ ] OTel spans via `withKitSpan` for all operations
- [ ] Span naming: `kit.<name>.<action>`
- [ ] Run record generation (default: enabled)
- [ ] Typed exit codes for all error paths

### Testing

- [ ] Unit tests for core logic
- [ ] Schema validation tests
- [ ] CLI integration tests
- [ ] Error path coverage

---

## Summary

### Is the Architecture Correct?

**Yes — for the stated goals and constraints.**

The architecture is "correct" in that it:

1. **Solves the right problem**: Enabling AI agents to perform development tasks with human oversight
2. **Fits the team size**: Modular monolith avoids microservice overhead for a 2-person team
3. **Prioritizes the right concerns**: Observability, determinism, and idempotency over raw performance
4. **Enables evolution**: Versioned schemas and deprecation windows allow safe changes

The architecture would be "incorrect" if the goal were maximum simplicity (it has moving parts), highest performance (observability adds overhead), or traditional enterprise governance (it's lean by design).

### Is It Following Best Practices?

**Yes — with intentional divergences documented.**

| Area | Alignment | Notes |
|------|-----------|-------|
| **Single Responsibility** | ✅ Aligned | Each kit has one job; `kit-base` handles cross-cutting concerns |
| **Dependency Inversion** | ✅ Aligned | Kits depend on abstractions (`IdempotencyStorage` interface, not concrete storage) |
| **Contract-First Design** | ✅ Aligned | JSON schemas define interfaces; runtime validation via Zod |
| **Observable Systems** | ✅ Aligned | OTel, run records, typed errors — observability is not optional |
| **Semantic Versioning** | ✅ Aligned | Schema and methodology versions follow semver with deprecation windows |
| **Dynamic Plugin Loading** | ❌ Intentionally avoided | Static composition at build time; security and type safety > runtime flexibility |
| **Microservices** | ❌ Intentionally avoided | HTTP exists for cross-language access, not service isolation |

### The Fundamental Question This Architecture Solves

> **How do you make software development safe and deterministic when AI agents are doing the work?**

The answer — **typed contracts, observable operations, fail-closed policies, and machine-readable methodology** — is exactly what this architecture provides.

AI agents cannot read documentation like humans. They need:
- Schemas to understand valid inputs/outputs
- Deterministic errors to make decisions
- Audit trails to prove what happened
- Idempotency to safely retry

This architecture delivers all four.

### Key Tradeoffs and Known Limitations

| Tradeoff | We Accept | We Get |
|----------|-----------|--------|
| **Complexity over simplicity** | Many concepts (schemas, versioning, run records) | Observability, idempotency, safe evolution |
| **Overhead over performance** | Run records, OTel spans, validation | Debugging, audit, determinism |
| **Static over dynamic composition** | No runtime plugin discovery | Type safety, security, simpler debugging |
| **File-based over distributed storage** | Idempotency doesn't scale to multi-node by default | Zero infrastructure requirements; pluggable when needed |
| **Methodology coupling** | Schema changes when methodology changes | AI agents consume methodology as contracts |

**Known Limitations:**

1. **Concurrent writes to idempotency index** can race — use Redis adapter for high concurrency
2. **Run record scans** slow at high volume — use index-based queries and retention policies
3. **HTTP runner error mapping** needs validation across all kits
4. **Cross-language SDKs** not yet generated — HTTP works but lacks type safety

### Recommended Next Steps

| Priority | Area | Action | Trigger |
|----------|------|--------|---------|
| **High** | Replay command | Implement `kit-runs replay <runId>` | When debugging complex failures |
| **Medium** | Index rebuild | Implement `kit-runs rebuild-index` | When index corruption detected |
| **Medium** | Dashboard templates | Create Grafana dashboards for kit metrics | When monitoring becomes important |
| **Low** | OpenAPI generation | Auto-generate from Zod schemas | When Python agents are frequently used |
| **Watch** | Idempotency concurrency | Monitor for race conditions in logs | When kits run as concurrent services |
| **Watch** | Run record volume | Monitor disk usage; tune retention | When `kit-runs usage` shows >1GB per kit |

---

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

### 2025-12 Architecture Alignment Score

- Added [Architecture Alignment Score](#architecture-alignment-score) section with quantitative assessment
- Documented scoring table with 8 criteria (Pillar Alignment, Observability, Error Handling, Run Records, CLI Interface, Schema Validation, Idempotency, Documentation)
- Added Remaining Areas for Improvement table
- Added Conclusion with alignment breakdown and overall grade (9.4/10)
- Updated Table of Contents

### 2025-12 Comprehensive Architecture Documentation

- Added [Design Pattern Alignment](#design-pattern-alignment) table
- Added [Architectural Assessment](#architectural-assessment) with evaluation tables
- Added [Component and Responsibility Matrix](#component-and-responsibility-matrix)
- Added [Request Flow Overview](#request-flow-overview) diagram
- Added [Source of Truth Table](#source-of-truth-table)
- Added [RACI Matrix](#raci-matrix) for kit operations
- Added [Risks and Anti-Patterns](#risks-and-anti-patterns) section
- Added [New Kit Implementation Checklist](#new-kit-implementation-checklist)
- Added [Summary](#summary) section with architectural assessment
- Updated Table of Contents with all new sections

### 2025-12 Centralized Run Records

- Added `HARMONY_RUNS_DIR` environment variable for centralized run record storage
- Documented direnv setup with `.envrc` example
- Updated Run Record Query Capabilities with centralized storage guidance
- Added `runs/` to `.gitignore`

### 2025-12 Production-Ready Architecture

- Added comprehensive [Architectural Strengths](#architectural-strengths) section
- Created [ROADMAP.md](./ROADMAP.md) for future considerations
- Documented Observable by Default, Pluggable Idempotency, Triple Interface Pattern
- Added Run Record Query Capabilities documentation
- Established decision log for architectural choices
