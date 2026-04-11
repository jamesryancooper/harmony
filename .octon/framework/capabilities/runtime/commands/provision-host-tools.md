---
title: Provision Host Tools
description: Verify, install, or repair host-scoped external tools required by the current repository.
access: agent
argument-hint: 'verify|install|repair [@repo-root] [--consumer <id>] [--mode <mode>] [--octon-home <path>] [--emit-env <path>] [--tool-id <id>] [--allow-path-adoption true|false]'
---

# Provision Host Tools `/provision-host-tools`

Provision or verify host-scoped external tools required by the current
repository without storing binaries under `/.octon/**`.

## Usage

```text
/provision-host-tools verify
/provision-host-tools verify --consumer repo-hygiene --mode audit
/provision-host-tools install --consumer repo-hygiene --mode audit
/provision-host-tools repair --consumer repo-hygiene --mode audit
/provision-host-tools verify @path/to/repo --octon-home /path/to/octon-home
```

## Parameters

| Parameter | Required | Description |
| --- | --- | --- |
| `verify\|install\|repair` | Yes | Action to perform. |
| `@repo-root` | No | Target repo root. Defaults to the current repo. |
| `--consumer <id>` | No | Resolve tools for one consumer, such as `repo-hygiene`. |
| `--mode <mode>` | No | Consumer mode such as `scan`, `enforce`, or `audit`. |
| `--octon-home <path>` | No | Override host-scoped Octon home. |
| `--emit-env <path>` | No | Write resolved environment exports for downstream consumers. |
| `--tool-id <id>` | No | Limit the action to one tool id. |
| `--allow-path-adoption true\|false` | No | Override whether already-installed PATH tools may be adopted. |

## Implementation

Run:

```bash
.octon/framework/scaffolding/runtime/_ops/scripts/provision-host-tools.sh verify|install|repair [--repo-root <path>] [--consumer <id>] [--mode <mode>] [--octon-home <path>] [--emit-env <path>] [--tool-id <id>] [--allow-path-adoption true|false]
```

Behavior:

1. Resolve the current repo root and repo-owned desired host-tool requirements.
2. Resolve the host-scoped Octon home from `OCTON_HOME` or OS defaults.
3. Verify or install tools into host-scoped versioned roots outside the repo.
4. Record actual active or quarantine state outside the repo.
5. Emit provisioning receipts and repo-resolution views.
6. Optionally write a shell env file for consumer commands.

## Output

- Host-scoped actual state under `$OCTON_HOME/state/control/host-tools/**`
- Host-scoped provisioning receipts under
  `$OCTON_HOME/state/evidence/provisioning/host-tools/**`
- Host-scoped generated repo resolution views under
  `$OCTON_HOME/generated/effective/host-tools/repos/**`
- Optional environment export file for downstream commands

## Boundary

- Do not store host binaries under `/.octon/**`.
- Do not silently mutate host tools during `/init`.
- Fail closed when mandatory tools remain unresolved.
