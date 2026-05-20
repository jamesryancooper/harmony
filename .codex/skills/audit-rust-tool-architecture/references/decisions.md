# Audit Rust Tool Architecture Decisions

## Mode

- `audit`: discover current risks and recommendations.
- `migration-plan`: include staged migration guidance in the audit report.
- `post-remediation`: verify that prior findings are resolved and apply the
  strict done gate.

## Evidence Depth

- `quick`: inspect direct Cargo and entrypoint files only.
- `standard`: inspect entrypoints, tests, config, error handling, and effects.
- `deep`: include broader dependency, performance, concurrency, and adjacent
  workspace evidence.

## Workspace Advice

Recommend workspace splitting only when at least one condition is evidenced:

- independent package boundaries
- materially different dependency sets
- multiple release or executable surfaces
- reusable internal crates with stable APIs
- compile-time or feature-boundary pressure that a module split cannot solve

Otherwise prefer one Cargo package with `src/lib.rs`, thin binaries, modules,
and tests.

## Severity Threshold

Filter findings only after classification. Never omit critical safety evidence
from the summary, even if a threshold is configured too narrowly.

## Post-Remediation

When `post_remediation=true`, completion requires zero open findings at or
above `severity_threshold` and stable finding identity across the requested
convergence policy.
