# Invariants

1. Files are canonical source-of-truth.
2. Snapshot IDs are deterministic for identical input trees.
3. Snapshot artifacts are immutable after creation.
4. Graph operations require valid snapshot artifacts.
5. Discovery operations return bounded, explicit frontier expansions.
6. Graph entities returned to callers are resolvable to file path or source locator.
7. Provider-specific terms are disallowed in core filesystem-graph files.
