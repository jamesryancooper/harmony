---
title: Engineering Principles & Standards (Successor v2026-02-24)
description: Active versioned successor charter aligning Harmony to agent-first, system-governed, complexity-calibrated operation.
status: Active successor
mutability: versioned
agent_editable: true
risk_tier: critical
change_policy: supersede-only
owner: "@you"
last_reviewed: 2026-02-24
effective_date: 2026-02-24
---

# Engineering Principles & Standards (Successor v2026-02-24)

**Status:** Active successor
**Applies to:** Architecture, code, documentation, configuration, delivery practices
**Goal:** High integrity delivery with **minimal sufficient complexity**, strong auditability, and durable cross-project consistency for agent operation.

> This is the active successor charter for evolving standards.
> The immutable constitutional anchor remains `principles.md` and is never edited in place.

---

## 0) Scope and Authority

- This successor governs active framing and terminology for Harmony principles.
- All unchanged constraints from `principles.md` remain in force.
- When wording conflicts exist between this successor and legacy guidance, this successor governs active interpretation.
- Policy evolution remains supersede-only (new versioned successor + ADR).

---

## 1) Canonical Framing (Normative)

### 1.1 Agent-First Purpose

- Harmony standardizes how **agents** operate across projects through shared contracts, workflows, capabilities, safety controls, and auditability.
- Humans remain governance authors, oversight operators, and escalation authority.
- Humans are not the primary standardization target in active framing.

### 1.2 System-Governed Model

- Harmony is **system-governed**.
- Governance is encoded in contracts, policies, workflows, and enforcement checks that run by default.
- Human involvement is required for policy authorship, time-boxed exceptions, and escalation handling.

### 1.3 Managed Complexity

- Governing rule: **as simple as possible, as complex as necessary**, balanced for reliability, operability, and future change.
- Replace simplicity gate language with **Complexity Calibration**.
- Complexity Calibration test: complexity must be justified by risk, scale, safety, performance, or compliance.
- Reject both under-engineering and over-engineering.
- Complexity Fitness criteria: complexity must be proportional, intentional, and maintainable.

### 1.4 Wording Normalization (Normative)

- Prefer: `minimal sufficient complexity`.
- Prefer: `smallest robust solution that meets constraints`.
- Deprecate: `favor simplicity` where it weakens reliability/operability expectations.
- Deprecate: `smallest solution` and viability-only wording without robustness and constraint fitness.

---

## 2) Updated Precedence Emphasis (When Principles Tension)

Use this order when tradeoffs are ambiguous:

1. Correctness and safety
2. Design integrity (cohesion, boundaries, change cost)
3. Complexity Calibration (minimal sufficient complexity with explicit justification)
4. Maintainability and operability
5. Performance and efficiency (measured, budgeted)
6. Delivery speed

Exceptions still require written rationale, owner, timebox, and exit path.

---

## 3) Migration Notes

- This successor is introduced by ADR `040-principles-charter-successor-v2026-02-24.md`.
- ADR 020 is superseded for active framing adoption.
- The canonical complexity attribute identifier for downstream governance/scoring migration is `complexity_calibration`.
