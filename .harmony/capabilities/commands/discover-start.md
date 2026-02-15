---
title: Discover Start
description: Start progressive discovery for a query using the active snapshot.
access: human
argument-hint: "--file <path-to-request-json>"
---

# Discover Start `/discover-start`

Run `discover.start` through the filesystem-graph service.

## Implementation

```bash
bash .harmony/capabilities/services/interfaces/filesystem-graph/impl/filesystem-graph.sh < <path-to-request-json>
```

Request JSON must include:

```json
{
  "command": "discover.start",
  "payload": {
    "query": "<text>",
    "limit": 20
  }
}
```
