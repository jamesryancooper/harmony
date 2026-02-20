---
title: Harness Scaffolding Scripts
description: Executable scaffolding scripts owned by the scaffolding runtime surface.
---

# Harness Scaffolding Scripts

Scaffolding runtime scripts are executable utilities used to bootstrap and validate harness assets.

## Location

```text
.harmony/scaffolding/runtime/_ops/scripts/
└── init-project.sh    # Bootstrap project-level AGENTS/BOOT/alignment files
```

## `init-project.sh`

The primary scaffolding bootstrap script. It renders project-level files from the canonical templates under `scaffolding/runtime/templates/`.

### Purpose

- Generate `AGENTS.md` from template using default-agent interpolation
- Optionally generate compatibility boot files (`BOOT.md`, `BOOTSTRAP.md`)
- Generate root `alignment-check` shim
- Optionally initialize agent-platform adapter bootstrap config

### Usage

```bash
.harmony/scaffolding/runtime/_ops/scripts/init-project.sh
```

Optional flags:

- `--with-boot-files`
- `--with-agent-platform-adapters`
- `--agent-platform-adapters <csv>`
- `--force`
- `--dry-run`

## Script Conventions

1. Scripts live under `scaffolding/runtime/_ops/scripts/`.
2. Scripts use fail-fast shell settings (`set -euo pipefail`).
3. Scripts operate only on canonical runtime/governance/practices surfaces.
4. Scripts fail closed on missing required templates or manifests.

## See Also

- [Templates](./templates.md) - canonical scaffolding templates
- [README.md](./README.md) - scaffolding architecture index
