# State Evidence

`state/evidence/**` stores retained operational evidence.

## Canonical Evidence Classes

| Path | Purpose |
| --- | --- |
| `state/evidence/runs/**` | Run receipts, digests, and execution evidence |
| `state/evidence/decisions/**` | Operational allow/block/escalate evidence |
| `state/evidence/validation/**` | Validation receipts and audit evidence |
| `state/evidence/migration/**` | Migration provenance and rollback traceability |

Evidence is append-oriented and retention-governed. It must not be treated as
active task state or rebuildable generated output.
