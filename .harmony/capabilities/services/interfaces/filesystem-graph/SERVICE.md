---
name: filesystem-graph
description: >
  Native-first service for filesystem operations, deterministic snapshots,
  graph traversal, and progressive discovery.
interface_type: library
version: "0.1.0"
metadata:
  author: "harmony"
  created: "2026-02-15"
  updated: "2026-02-15"
input_schema: schema/input.schema.json
output_schema: schema/output.schema.json
rules: rules/
fixtures: fixtures/
contracts:
  invariants: contracts/invariants.md
  errors: contracts/errors.yml
compatibility_profile: compatibility.yml
generation_manifest: impl/generated.manifest.json
stateful: true
deterministic: true
dependencies:
  requires: []
  orchestrates: []
  integratesWith: [query, agent-platform]
observability:
  service_name: "harmony.service.filesystem-graph"
  required_spans:
    - "service.filesystem-graph.fs"
    - "service.filesystem-graph.snapshot"
    - "service.filesystem-graph.kg"
    - "service.filesystem-graph.discover"
policy:
  rules:
    - native-first-required
    - files-source-of-truth
    - fail-closed-invalid-snapshot
  enforcement: block
  fail_closed: true
idempotency:
  required: true
  key_from: [command, snapshotId, payloadHash]
impl:
  entrypoint: "runtime/run tool interfaces/filesystem-graph"
  timeout_ms: 60000
  health_check: null
dry_run: true
allowed-tools: Read Glob
---

# Filesystem Graph Service

Native-first operation surface for filesystem + derived graph workflows.
