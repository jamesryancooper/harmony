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
bash .harmony/capabilities/services/interfaces/filesystem-graph/impl/snapshot-build.sh \
  [--root <path>] \
  [--state-dir <path>] \
  [--set-current true|false]
```
