---
title: Discover Explain
description: Explain candidate relevance and provenance for progressive discovery.
access: human
argument-hint: "--file <path-to-request-json>"
---

# Discover Explain `/discover-explain`

Run `discover.explain` through the filesystem-graph service.

Request JSON must include:

```json
{
  "command": "discover.explain",
  "payload": {
    "query": "<text>",
    "candidate_node_ids": ["file:.harmony/START.md"]
  }
}
```
