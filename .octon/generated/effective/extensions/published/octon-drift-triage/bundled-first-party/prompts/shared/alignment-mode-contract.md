# Alignment Mode Contract

`alignment_mode` behavior is owned by:

`/.octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-prompt-bundle.sh`

Supported modes:

- `auto`:
  block when the bundle or its required anchors are stale
- `always`:
  force a freshness block pending explicit realignment
- `skip`:
  allow degraded execution only when the bundle is present and the failure is
  not foundational

This bundle may mention the modes, but it must not redefine their semantics.
