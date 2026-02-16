---
title: Filesystem Graph
description: Invoke filesystem-graph service operations via JSON input.
access: human
argument-hint: "--op <operation> --json '<payload-json>'"
---

# Filesystem Graph `/filesystem-graph`

Run the filesystem-graph runtime service directly.

## Usage

```text
/filesystem-graph --op fs.stat --json '{"path":".harmony/START.md"}'
```

## Implementation

```bash
.harmony/runtime/run tool interfaces/filesystem-graph <operation> --json '<payload-json>'
```
