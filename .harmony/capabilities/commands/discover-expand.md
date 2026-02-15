---
title: Discover Expand
description: Expand progressive discovery frontier by traversing graph neighbors.
access: human
argument-hint: "--file <path-to-request-json>"
---

# Discover Expand `/discover-expand`

Run `discover.expand` through the filesystem-graph service.

Request JSON must include:

```json
{
  "command": "discover.expand",
  "payload": {
    "node_ids": ["file:.harmony/START.md"],
    "limit": 100
  }
}
```
