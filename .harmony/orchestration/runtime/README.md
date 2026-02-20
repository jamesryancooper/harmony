# Orchestration Runtime

`runtime/` contains executable orchestration artifacts.

## Contents

| Path | Purpose | Discovery |
|------|---------|-----------|
| `workflows/` | Multi-step procedures and workflow contracts | `workflows/manifest.yml` |
| `missions/` | Time-bounded mission artifacts and lifecycle state | `missions/registry.yml` |

## Boundary

Only runtime orchestration artifacts belong here.
Governance contracts belong in `../governance/`.
