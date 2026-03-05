---
title: Performance and Scalability
description: Provider-agnostic performance and scalability policy with default budgets and CI pass/fail criteria.
owner: "cognition-owner"
audience: internal
scope: methodology-governance
last_reviewed: 2026-03-05
canonical_links:
  - "/AGENTS.md"
  - "/.harmony/agency/governance/CONSTITUTION.md"
  - "/.harmony/agency/governance/DELEGATION.md"
  - "/.harmony/agency/governance/MEMORY.md"
  - "/.harmony/cognition/practices/methodology/authority-crosswalk.md"
---

# Performance and Scalability

Use this policy to define budgets, validate regressions, and keep scaling behavior predictable.

## Default Budgets (Normative)

- p95 API latency: <= 300ms warm, <= 600ms including cold-start effects.
- p95 route TTFB (top critical route): <= 400ms.
- 5xx error rate: <= 0.5% during rollout watch windows.
- Bundle delta budget on critical app surfaces: <= +10% relative to baseline unless waived.

## CI Pass/Fail Criteria

- T1: no required perf gate unless change touches perf-critical surfaces.
- T2: fail if p95 latency or bundle delta exceeds budget by >10% in preview/staging checks.
- T3: fail if budget exceeds threshold at any rollout stage without an approved, timeboxed waiver.

## Operational Guidance

- Prefer explicit cache-key discipline and bounded TTLs.
- Move long-running or burst-prone workloads to background processing.
- Use rate limiting and backpressure on externally reachable paths.
- Keep load tests reproducible: minimum 2 minutes or 1,000 requests for risky changes.

## Cost-Performance Correlation

Track cost and latency together in review receipts. Regressions in either dimension require explicit mitigation or scoped rollback.
