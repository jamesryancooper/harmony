---
title: Snapshot Build
description: Build deterministic filesystem-graph snapshot artifacts.
access: human
argument-hint: "[--root <path>] [--state-dir <path>] [--set-current true|false]"
---

# Snapshot Build `/snapshot-build`

Build deterministic snapshot artifacts for filesystem-graph operations.

## Usage

```text
/snapshot-build
/snapshot-build --root .
/snapshot-build --root .harmony --set-current true
```

## Implementation

```bash
.harmony/runtime/run tool interfaces/filesystem-graph snapshot.build --json \
  '{"root":".","state_dir":".harmony/runtime/_ops/state/snapshots","set_current":true}'
```
