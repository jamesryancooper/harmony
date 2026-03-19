# Control-State Schemas

JSON Schema contracts for Packet 7 control-state records.

## Schema Files

| Schema | Live target |
| --- | --- |
| `extension-active-state.schema.json` | `.octon/state/control/extensions/active.yml` |
| `extension-quarantine-state.schema.json` | `.octon/state/control/extensions/quarantine.yml` |
| `locality-quarantine-state.schema.json` | `.octon/state/control/locality/quarantine.yml` |

These schemas define the minimum Packet 7 control-state wire contract. Runtime
validators may apply stricter cross-file consistency checks in addition to the
schema.
