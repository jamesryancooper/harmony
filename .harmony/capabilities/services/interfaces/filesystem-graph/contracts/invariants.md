# Invariants

1. Files are canonical source-of-truth.
2. Snapshot IDs are deterministic for identical input trees.
3. Snapshot artifacts are immutable after creation.
4. Graph operations require valid snapshot artifacts.
5. Discovery operations return bounded, explicit frontier expansions.
6. Graph entities returned to callers are resolvable to file path or source locator.
7. Provider-specific terms are disallowed in core filesystem-graph files.
8. Runtime metrics are emitted per operation with latency, status, scanned file counts, and bytes-read fields.
9. Per-operation latency and error budgets are enforced by CI SLO gates.
10. Automated SLO tuning can tighten budgets from CI history but must not loosen them.
11. Snapshot/discovery operations must enforce bounded file/byte/time limits and fail closed on limit exceedance.
12. Corrupt snapshot artifacts must fail with actionable remediation guidance.
13. Snapshot artifacts must be marked ready only after complete write, and incomplete builds must be rejected.
14. Snapshot retention GC must preserve current/new snapshots while enforcing configured count/age/size budgets.
15. CI must assert deterministic snapshot IDs across Linux and macOS fixture builds.
