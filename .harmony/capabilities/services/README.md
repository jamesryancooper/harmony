# Services

Domain capabilities with typed contracts for invocation-driven composite behavior.

## Contents

| File/Dir | Purpose |
|---|---|
| `manifest.yml` | Service discovery index |
| `registry.yml` | Extended service metadata |
| `capabilities.yml` | Service capability schema and constraints |
| `conventions/` | Harness-wide cross-cutting contracts (errors, run records, observability, idempotency) |
| `_template/` | Service scaffold template |
| `_scripts/validate-services.sh` | Structural and contract validator |
| `_state/` | Service logs and run state |

## Interface Types

- `shell`: POSIX script entrypoint
- `mcp`: networked/MCP adapter
- `library`: runtime/library implementation pointer

## Skill Integration

Skills may whitelist services with:

```yaml
allowed-services: guard cost
```

Service IDs resolve against `services/manifest.yml`.
