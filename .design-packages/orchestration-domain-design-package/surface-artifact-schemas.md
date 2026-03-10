# Surface Artifact Schemas

## Purpose

Identify required surface-local artifacts that need machine-readable schemas to
prevent implementation drift.

This document is normative for schema coverage expectations.

## Required Schema Coverage

| Surface | Artifact | Required Schema |
|---|---|---|
| `automations` | `bindings.yml` | `contracts/schemas/automation-bindings.schema.json` |
| `workflows` | `workflow.yml` | `contracts/schemas/workflow-execution.schema.json` |
| `watchers` | `watcher.yml` | `contracts/schemas/watcher-definition.schema.json` |
| `watchers` | `rules.yml` | `contracts/schemas/watcher-rules.schema.json` |
| `incidents` | `actions.yml` | `contracts/schemas/incident-actions.schema.json` |
| coordination manager | lock artifact | `contracts/schemas/coordination-lock.schema.json` |
| approvals / overrides | approval artifact | `contracts/schemas/approval-and-override.schema.json` |
| governance | approver authority registry | `contracts/schemas/approver-authority-registry.schema.json` |

For `workflows`, the schema-backed artifact is the definition contract
(`workflow.yml`), not registry metadata or prose guidance.

`stages/*.md` remain Markdown assets. They do not require a JSON Schema, but
they must be resolved only from a valid `workflow.yml` and remain subject to
drift checks for relative pathing and local asset ownership.

## Validation Mode

Each required schema must have:

- a machine-readable schema
- one valid fixture
- one invalid fixture
- validator enforcement in
  `validate-orchestration-design-package.sh`

## Relationship To Discovery Layers

`contracts/discovery-and-authority-layer-contract.md` defines where artifacts
live. This document defines which of those artifacts must be schema-backed.

## Migration Rule

If an artifact is required by surface layout and operator behavior, but lacks a
schema, the package is not fully hardened for independent implementation.
