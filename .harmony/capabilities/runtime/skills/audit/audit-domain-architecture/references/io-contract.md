---
io:
  inputs:
    - name: domain_path
      type: text
      required: true
      description: "Domain root path or canonical .harmony domain target to critique"
    - name: criteria
      type: text
      required: false
      default: "modularity,discoverability,coupling,operability,change-safety,testability"
      description: "Comma-separated evaluation criteria"
    - name: evidence_depth
      type: text
      required: false
      default: "standard"
      description: "Evidence intensity: quick, standard, deep"
    - name: severity_threshold
      type: text
      required: false
      default: "all"
      description: "Minimum severity to report: critical, high, medium, low, all"
    - name: domain_profiles_ref
      type: file
      required: false
      default: ".harmony/cognition/governance/domain-profiles.yml"
      description: "Domain profile registry used for baseline expectations in prospective mode"
  outputs:
    - name: critique_report
      path: "../../../output/reports/{{date}}-domain-architecture-audit-{{run_id}}.md"
      format: markdown
      determinism: unique
      description: "Structured independent architecture critique report"
    - name: run_log
      path: "_ops/state/logs/audit-domain-architecture/{{run_id}}.md"
      format: markdown
      determinism: unique
      description: "Execution log for this critique run"
    - name: log_index
      path: "_ops/state/logs/audit-domain-architecture/index.yml"
      format: yaml
      determinism: variable
      description: "Index of critique runs with metadata"
---

# I/O Contract

## Required Output Sections

1. Current Surface Map (with file-path evidence)
2. Critical Gaps (impact + risk)
3. Recommended Changes (priority, expected benefit, tradeoff)
4. Keep As-Is decisions (and why)
5. Open Questions / Unknowns

## Target Resolution Contract

- If `domain_path` exists and is readable, run in `observed` mode.
- If `domain_path` is missing but represents a valid `.harmony/<domain>` target,
  run in `prospective` mode.
- If `domain_path` cannot be normalized as a Harmony target, escalate.

## Evidence Contract

- Every non-trivial claim must include at least one supporting path.
- In prospective mode, claims must cite either comparator-domain paths or profile
  registry paths.
- If a claim cannot be evidenced, it must be downgraded to an explicit unknown.
