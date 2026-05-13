# Octon Proposal Lifecycle: Run Program Lifecycle

Run the generic lifecycle runner for one proposal program target:

```sh
octon lifecycle run --lifecycle proposal-program --target <program-packet-path>
```

Use `--run-id`, `--executor`, `--max-iterations`, `--set key=value`, and
`--set-file key=path` when deterministic resume, mock execution, bounded loop
testing, or creation input binding is required. The runner plans from the
published lifecycle contract, evaluates parent review, child-readiness, and
parent receipt gates, records workflow evidence and checkpoints, and reports
the next route.

This wrapper is not a dispatcher route and has no prompt bundle. It must
preserve child authority boundaries and must not treat parent support receipts
as child receipts.
