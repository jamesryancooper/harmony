---
title: Discover Resolve
description: Resolve a discovered node back to file path.
access: human
argument-hint: "--file <path-to-request-json>"
---

# Discover Resolve `/discover-resolve`

Run `discover.resolve` through the filesystem-graph service.

Request JSON must include:

```json
{
  "command": "discover.resolve",
  "payload": {
    "node_id": "file:.harmony/START.md"
  }
}
```
