---
title: Filesystem Graph
description: Invoke filesystem-graph service operations via JSON input.
access: human
argument-hint: "--file <path-to-request-json>"
---

# Filesystem Graph `/filesystem-graph`

Run the filesystem-graph service with a JSON payload.

## Usage

```text
/filesystem-graph --file <path-to-request-json>
```

## Implementation

```bash
bash .harmony/capabilities/services/interfaces/filesystem-graph/impl/filesystem-graph.sh < <path-to-request-json>
```
