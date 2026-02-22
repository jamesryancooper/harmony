---
acceptance_criteria:
  - "Report includes all five required output sections"
  - "Run declares target mode as observed or prospective"
  - "Surface map includes file-path evidence"
  - "Prospective mode explicitly records domain absence evidence and profile baseline"
  - "Critical gaps include both impact and risk"
  - "Recommendations include priority, expected benefit, and tradeoff"
  - "At least one keep-as-is decision is justified when applicable"
  - "Unknowns are stated where evidence is insufficient"
  - "Assumptions are explicit and scoped"
---

# Validation

A run is complete when all acceptance criteria are satisfied and claims are
traceable to concrete evidence.

## Reproducibility Rule

Given the same codebase state and parameters, the high-level findings should be
substantially stable.

## Mode Integrity Rule

- `observed` mode findings must be grounded in on-disk domain evidence.
- `prospective` mode findings must distinguish observed comparator evidence from
  forward-looking inferences.
