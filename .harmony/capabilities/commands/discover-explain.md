---
title: Discover Explain
description: Explain candidate relevance and provenance for progressive discovery.
access: human
argument-hint: "--query <text> --candidate-node-ids '<json-array>'"
---

# Discover Explain `/discover-explain`

Run `discover.explain` through the filesystem-graph service.

```bash
.harmony/runtime/run tool interfaces/filesystem-graph discover.explain --json \
  '{"query":"<text>","candidate_node_ids":["file:.harmony/START.md"]}'
```
