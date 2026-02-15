---
title: Snapshot Diff
description: Compare two filesystem-graph snapshots.
access: human
argument-hint: "--base <snapshot-id|path> --head <snapshot-id|path> [--state-dir <path>]"
---

# Snapshot Diff `/snapshot-diff`

Compare two snapshots and emit added/removed/changed paths.

## Usage

```text
/snapshot-diff --base snap-aaaa --head snap-bbbb
```

## Implementation

```bash
bash .harmony/capabilities/services/interfaces/filesystem-graph/impl/snapshot-diff.sh \
  --base <snapshot-id|path> \
  --head <snapshot-id|path> \
  [--state-dir <path>]
```
