# Kit System Roadmap

This document tracks future considerations, planned enhancements, and areas to monitor as the Kit system evolves.

**Status:** Active planning document  
**Last Updated:** December 2024  
**Architecture Version:** Production-ready (Schema v1.3.0, Methodology v0.2.0)

## Table of Contents

- [Future Considerations](#future-considerations)
- [Planned Enhancements](#planned-enhancements)
- [Monitoring Areas](#monitoring-areas)
- [Planned Kits](#planned-kits)
- [Decision Log](#decision-log)

---

## Future Considerations

These are architectural areas that work well today but should be monitored and potentially enhanced as usage grows.

### 1. Idempotency Index Concurrency

**Current State:** The `IdempotencyIndexManager` uses file-based JSON storage with auto-persist. This works well for CLI invocations and single-process scenarios.

**Consideration:** In high-concurrency scenarios (multiple processes writing simultaneously), file-based storage could lead to race conditions or lost updates.

**Current Mitigation:**

- Run records are typically single-process CLI invocations
- Each kit run generates a unique run ID
- Index updates are atomic at the file level (write full file)

**Future Options:**

1. **Atomic file writes** — Use write-rename pattern for safer concurrent access
2. **File locking** — Add advisory locks for multi-process coordination
3. **External storage** — Redis or SQLite adapter for `IdempotencyStorage` interface
4. **Distributed locking** — For multi-node deployments

**When to Act:** When kits are deployed as concurrent services (>1 process writing to same runs directory) or when index corruption is observed in logs.

---

### 2. Run Record Export Volume

**Current State:** Export can push to file, stdout, or OpenTelemetry Collector. Works well for typical volumes.

**Consideration:** If run records accumulate significantly (thousands per day), export operations could become slow due to full directory scans.

**Current Mitigation:**

- `cleanupRunRecords` with retention policies prevents unbounded growth
- Index file provides O(1) lookups for idempotency keys
- Pagination support in `listRunRecords`

**Future Options:**

1. **Incremental export** — Track last-exported timestamp, export only new records
2. **Streaming export** — Stream records to collector instead of batch
3. **Index-based export** — Add date-based index for efficient time-range queries
4. **Background export service** — Separate process for continuous export

**When to Act:** When export operations take >30 seconds or when storage exceeds planned capacity.

---

### 3. HTTP Runner Error Mapping

**Current State:** HTTP runners translate kit errors to HTTP status codes. Basic mapping exists.

**Consideration:** Ensure consistent mapping across all kits and document the contract explicitly.

**Current Mapping:**

| Kit Exit Code | HTTP Status | Meaning |
|---------------|-------------|---------|
| 0 | 200 | Success |
| 1 | 500 | Internal error |
| 2 | 403 | Policy violation |
| 3 | 422 | Evaluation failure |
| 4 | 400 | Guard violation |
| 5 | 400 | Input validation error |
| 6 | 502 | Upstream provider error |
| 7 | 409 | Idempotency conflict |
| 8 | 500 | Cache integrity error |

**Future Options:**

1. **Centralize mapping** — Single source of truth in `kit-base/http-client.ts`
2. **Add error details header** — `X-Kit-Error-Code` header for programmatic handling
3. **Retry-After header** — For 429/503 responses from rate limiting
4. **Problem Details RFC 7807** — Standardized error response format

**When to Act:** When building cross-language clients or when error handling inconsistencies are reported.

---

### 4. Run Record Schema Evolution

**Current State:** Run records follow a JSON schema with version tracking. Schema changes are backward compatible.

**Consideration:** As new kits are added and requirements evolve, the run record schema may need significant changes.

**Current Mitigation:**

- `schemaVersion` field in every record
- Readers can handle unknown fields gracefully
- Deprecation windows per Methodology-as-Code policy

**Future Options:**

1. **Schema registry** — Centralized schema management with compatibility checking
2. **Multiple schema versions** — Support reading old versions while writing new
3. **Migration scripts** — Tools to upgrade old run records to new schema
4. **Compression** — For run records with large outputs, consider optional compression

**When to Act:** When planning a breaking schema change or when storage efficiency becomes a concern.

---

### 5. Cross-Language SDK Generation

**Current State:** TypeScript is the primary language. HTTP runners enable cross-language consumption.

**Consideration:** Python, Go, and other language clients would benefit from generated SDKs.

**Current Mitigation:**

- HTTP interface provides language-agnostic access
- OpenAPI-style schemas could enable SDK generation
- CLI can be wrapped by any language

**Future Options:**

1. **OpenAPI spec generation** — Auto-generate from Zod schemas
2. **SDK generators** — Use openapi-generator or similar for Python, Go, Java
3. **Language-specific kits** — Native implementations for high-volume languages
4. **gRPC support** — For performance-critical cross-language calls

**When to Act:** When Python/Go agents are frequently used or when HTTP overhead becomes problematic.

---

## Planned Enhancements

These are features that would improve the system but are not yet implemented.

### Short-Term (Next Quarter)

| Enhancement | Description | Priority |
|-------------|-------------|----------|
| **Replay command** | `kit-runs replay <runId>` to re-execute with same inputs | High |
| **Index rebuild** | `kit-runs rebuild-index` to recover from corruption | Medium |
| **Diff command** | `kit-runs diff <runId1> <runId2>` to compare runs | Medium |
| **Watch mode** | `kit-runs watch --kit flowkit` for real-time monitoring | Low |

### Medium-Term (Next 6 Months)

| Enhancement | Description | Priority |
|-------------|-------------|----------|
| **Dashboard integration** | Grafana dashboard templates for kit metrics | Medium |
| **Cost analytics** | Aggregate cost tracking across all kits | Medium |
| **Performance benchmarks** | Automated performance regression testing | Medium |
| **Schema validation CLI** | `kit-base validate-schema <file>` for metadata | Low |

### Long-Term (Next Year)

| Enhancement | Description | Priority |
|-------------|-------------|----------|
| **Distributed tracing UI** | Built-in trace viewer for run records | Low |
| **Machine learning integration** | EvalKit integration with ML evaluation frameworks | Low |
| **Multi-tenant support** | Namespace isolation for shared infrastructure | Low |

---

## Monitoring Areas

These are metrics and patterns to watch for system health.

### Run Record Health

```bash
# Check for index/record mismatches
kit-runs stats --kit all

# Monitor disk usage
kit-runs usage

# Verify cleanup is running
kit-runs list --since 30d --limit 1000 | wc -l
```

**Alert thresholds:**

- Disk usage > 1GB per kit → Review retention policy
- Failed runs > 10% → Investigate root causes
- Average duration increasing → Check for performance regression

### Idempotency Health

```bash
# Check for stale pending operations
grep '"state": "pending"' runs/*/.idempotency-index.json | wc -l
```

**Alert thresholds:**

- Pending operations > 100 → Possible process crashes leaving stale state
- Index size > 10MB → Consider cleanup or archival

### Error Distribution

Monitor error exit codes across kits:

| Exit Code | Healthy Range | Action if Exceeded |
|-----------|---------------|-------------------|
| 1 (generic) | < 1% | Investigate unexpected errors |
| 2 (policy) | < 5% | Review policy rules |
| 5 (validation) | < 2% | Improve input validation messaging |
| 6 (upstream) | < 3% | Check external service health |
| 7 (idempotency) | Any | Expected for replays |

---

## Planned Kits

These kits are planned based on the [Kit Granularity Policy](./ARCHITECTURE.md#kit-granularity-policy).

| Kit | Status | Description | Dependencies |
|-----|--------|-------------|--------------|
| **SpecKit** | 🔄 Planned | Specification generation and validation | kit-base |
| **PlanKit** | 🔄 Planned | Implementation planning and ADR generation | kit-base, SpecKit |
| **TestKit** | 🔄 Planned | Test generation and execution | kit-base, EvalKit |
| **EvalKit** | 🔄 Planned | AI output evaluation and quality scoring | kit-base |
| **PolicyKit** | 🔄 Planned | Policy enforcement and compliance | kit-base |
| **PatchKit** | 🔄 Planned | PR creation and code patches | kit-base |

### Kit Evaluation Queue

Before creating any new kit, evaluate against the [granularity criteria](./ARCHITECTURE.md#when-to-create-a-new-kit-positive-criteria):

| Proposed Kit | Evaluation Status | Notes |
|--------------|-------------------|-------|
| CacheKit | ❌ Rejected | Caching is cross-cutting → kit-base |
| NotifyKit | ⏳ Pending | Evaluate if multiple kits need notifications |
| ScheduleKit | ⏳ Pending | Evaluate if scheduling is kit responsibility |

---

## Decision Log

Significant architectural decisions are recorded here for context.

### 2024-12 ObservaKit Rejected

**Decision:** Do not create ObservaKit as a separate kit.

**Rationale:**

- Observability instrumentation (spans, logs, metrics) is cross-cutting infrastructure → belongs in `kit-base`
- Observability operations (dashboards, alerting, querying) are external system concerns → not kit responsibility
- Creating ObservaKit would fragment observability code across kit-base and a kit

**Alternatives considered:**

1. ObservaKit with full observability stack → Too broad, external system territory
2. ObservaKit for advanced instrumentation → Blurs line with kit-base
3. Enhance kit-base observability → **Selected** — keeps instrumentation cohesive

### 2024-12 Durable Idempotency via Run Records

**Decision:** Use run records as the durable backing store for idempotency.

**Rationale:**

- Run records already provide audit trail
- Avoids introducing new storage system
- Index file provides O(1) lookups
- Natural alignment: completed operations have both run record and idempotency record

**Alternatives considered:**

1. Separate SQLite database → Additional dependency, separate from audit trail
2. Redis → Requires external infrastructure
3. In-memory only → Insufficient for production **→ Kept as default for CLI**

### 2024-12 Triple Interface Pattern

**Decision:** Every kit exposes Programmatic API, HTTP, and CLI interfaces.

**Rationale:**

- Different consumers have different needs
- Programmatic API is primary (fastest, typed)
- HTTP enables cross-language consumption
- CLI enables human debugging and CI/CD

**Principles:**

- All interfaces share the same implementation
- Return equivalent data structures
- CLI is never the only way to access a capability

### 2024-12 Centralized Runs via HARMONY_RUNS_DIR

**Decision:** Add `HARMONY_RUNS_DIR` environment variable for centralized run records.

**Rationale:**

- Enables aggregation of run records from all kits in one location
- Consistent with existing env var patterns (`HARMONY_ENFORCEMENT_MODE`, `HARMONY_ENV`)
- Works for both programmatic and CLI usage without code changes
- No config file management needed

**Implementation:**

- `getRunsDirectory()` checks `HARMONY_RUNS_DIR` before falling back to `./runs`
- Priority: env var > config option > CLI flag > default
- Run records still organized by kit subdirectory: `$HARMONY_RUNS_DIR/<kitName>/`
- Added `runs/` to `.gitignore` (run records are not committed)

**Recommended Setup (direnv):**

Create `.envrc` in the project root:

```bash
# .envrc - Harmony environment configuration
# Loaded automatically by direnv when entering this directory

# Centralized run records directory for all kits
export HARMONY_RUNS_DIR=$PWD/runs
```

Then run `direnv allow` to enable auto-loading.

**Alternatives considered:**

1. Config file (`.harmonyrc.json`) → More complex, requires file management
2. Per-kit configuration only → Works but requires configuring each kit
3. Environment variable → **Selected** — simple, consistent, universal

---

## Contributing to This Document

When adding future considerations:

1. **Describe current state** — What works today
2. **Explain the consideration** — What might need to change
3. **List current mitigations** — Why it's okay for now
4. **Propose future options** — What could be done
5. **Define trigger** — When to act

When logging decisions:

1. **State the decision** clearly
2. **Explain rationale** — Why this choice
3. **List alternatives** considered
4. **Note date** for context

---

## Related Documentation

- [ARCHITECTURE.md](./ARCHITECTURE.md) — Architectural principles and strengths
- [README.md](./README.md) — Quick start and usage
- [kit-base/README.md](./kit-base/README.md) — Shared infrastructure details
- [Methodology-as-Code](../../docs/harmony/ai/methodology/methodology-as-code.md) — Schema evolution policy
