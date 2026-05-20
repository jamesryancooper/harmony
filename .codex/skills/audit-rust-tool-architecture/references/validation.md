# Audit Rust Tool Architecture Validation

## Severity Model

- Critical: destructive behavior, silent incorrect output, security exposure,
  or unreviewable mutation risk.
- High: architecture blocks testing, safe evolution, or reliable use.
- Medium: maintainability drag, coupling, or avoidable complexity.
- Low: hygiene or clarity issue.
- Info: useful observation without required remediation.

## Report Acceptance

The report is complete when it includes:

- current architecture classification
- script maturity assessment
- project layout recommendation
- boundary, error/config/logging/testing, effects, async/concurrency, and
  performance findings as applicable
- anti-patterns found
- smallest sufficient migration recommendation
- acceptance criteria and validation commands
- risk notes and overengineering boundaries

## Post-Remediation Done Gate

When `post_remediation=true`, the run passes only if:

- every finding at or above `severity_threshold` is closed or explicitly
  accepted outside this skill
- controlled reruns preserve stable finding IDs
- coverage and determinism receipts are present

Discovery mode records the done gate but does not block output.
