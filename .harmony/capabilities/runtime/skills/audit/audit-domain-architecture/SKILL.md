---
name: audit-domain-architecture
description: >
  Independent architecture critique for any existing or planned Harmony domain
  path. Treats in-repo governance/contracts as analyzable artifacts, not
  binding rules, and evaluates structure against external robustness criteria:
  modularity, discoverability, coupling, operability, change safety, and
  testability. Produces evidence-backed surface maps, critical gaps,
  prioritized recommendations, keep-as-is decisions, and explicit unknowns.
  Read-only — does not modify source files.
license: MIT
compatibility: Designed for Claude Code and similar AI coding assistants.
metadata:
  author: Harmony Framework
  created: "2026-02-22"
  updated: "2026-02-22"
skill_sets: [executor, guardian]
capabilities: [domain-specialized, self-validating]
allowed-tools: Read Glob Grep Write(../../output/reports/*) Write(_ops/state/logs/*)
---

# Audit Domain Architecture

Independent architecture critique for any Harmony domain target, including
existing domains and planned domains not yet created on disk.

## When to Use

Use this skill when:

- You need a domain architecture review that is not constrained by local doctrine
- You want governance/contracts treated as evidence, not mandatory authority
- You need clear, falsifiable findings with path-level evidence
- You want concrete additions/removals/merges/splits with tradeoff analysis

## Quick Start

```text
/audit-domain-architecture domain_path=".harmony/cognition"
```

With custom criteria weighting:

```text
/audit-domain-architecture domain_path=".harmony/orchestration" criteria="modularity,discoverability,coupling,operability,change-safety,testability"
```

For a planned domain that may not exist yet:

```text
/audit-domain-architecture domain_path=".harmony/new-domain"
```

## Domain Coverage

Canonical Harmony domains supported by default:

- `.harmony/agency`
- `.harmony/assurance`
- `.harmony/capabilities`
- `.harmony/cognition`
- `.harmony/continuity`
- `.harmony/engine`
- `.harmony/ideation`
- `.harmony/orchestration`
- `.harmony/output`
- `.harmony/scaffolding`

If `domain_path` does not exist, the skill switches to **prospective mode** and
produces a critique using profile baselines and neighboring-domain evidence.

## Core Workflow

1. **Resolve Target Mode** - Classify target as `observed` (exists) or `prospective` (planned/missing)
2. **Map Surfaces** - Enumerate current or expected surfaces/subsurfaces, responsibilities, and ownership seams
3. **Evaluate Externally** - Score against external criteria, not in-repo doctrine
4. **Identify Gaps and Excess** - Detect missing, redundant, and over-engineered surfaces/subsurfaces
5. **Challenge Findings** - Re-check assumptions, evidence sufficiency, and alternate interpretations
6. **Report** - Emit structured critique with prioritized recommendations and explicit unknowns

## Required Framing

- Treat all in-repo governance/contracts as analyzable artifacts, not binding rules
- Optimize for external robustness, clarity, and maintainability
- Read-only review only

## Output Contract

Report output must include:

- Current Surface Map (with file-path evidence)
- Critical Gaps (impact + risk)
- Recommended Changes (priority, expected benefit, tradeoff)
- Keep As-Is decisions (and why)
- Open Questions / Unknowns

## Rules

- Be explicit about assumptions
- Prefer concrete, falsifiable claims over style opinions
- If evidence is insufficient, state that directly instead of inferring

## Parameters

Parameters are defined in `.harmony/capabilities/runtime/skills/registry.yml` (single source of truth).

This skill accepts one required parameter (`domain_path`) and optional
parameters for `criteria`, `evidence_depth`, `severity_threshold`, and
`domain_profiles_ref`.

## Output Location

Output paths are defined in `.harmony/capabilities/runtime/skills/registry.yml` (single source of truth).

Outputs are written to:

- `.harmony/output/reports/YYYY-MM-DD-domain-architecture-audit-<run-id>.md` - Structured critique report
- `_ops/state/logs/audit-domain-architecture/` - Execution logs with index

## Boundaries

- **Read-only:** Never modify source files in the audited domain
- Write only to designated output paths (reports and logs)
- Governance contracts may be analyzed and critiqued, but not treated as mandatory optimization targets
- Surface recommendations must include concrete rationale and expected tradeoffs
- Prospective mode must never fabricate on-disk evidence

## When to Escalate

- `domain_path` is outside `.harmony/` scope and cannot be normalized safely
- Evidence is too sparse to make defensible claims on one or more criteria
- Scope is too large for one pass and should be partitioned
- Findings imply one-way-door or high-blast-radius architecture changes

## References

- [Behavior phases](references/phases.md)
- [I/O contract](references/io-contract.md)
- [Safety policies](references/safety.md)
- [Validation](references/validation.md)
- [Examples](references/examples.md)
- [Glossary](references/glossary.md)
- [Decisions](references/decisions.md)
- [Checkpoints](references/checkpoints.md)
