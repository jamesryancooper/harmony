# State Architecture

This directory defines the canonical Packet 7 state contract for the active
`.octon/` harness.

## State Subdomains

| Subdomain | Purpose | Canonical live surface |
| --- | --- | --- |
| `continuity/` | Active resumable work state | `.octon/state/continuity/**` |
| `evidence/` | Retained operational trace and receipts | `.octon/state/evidence/**` |
| `control/` | Mutable current-state publication and quarantine truth | `.octon/state/control/**` |

`state/**` is authoritative only as operational truth and retained evidence.
It is not an authored governance, runtime, or ADR surface.

## Document Map

| Path | Description |
| --- | --- |
| `continuity/README.md` | Canonical continuity contract, lifecycle rules, and schema references |
| `evidence/README.md` | Canonical retained-evidence model and evidence class boundaries |
| `control/README.md` | Canonical control-state model and desired/actual/quarantine split |

## Boundary Rules

- Durable repo authority remains under `instance/**`.
- Rebuildable compiled outputs remain under `generated/**`.
- Active continuity is not retained evidence.
- Retained evidence is not rebuildable generated output.
- Control state records current mutable truth; it is not authored desired
  configuration.
