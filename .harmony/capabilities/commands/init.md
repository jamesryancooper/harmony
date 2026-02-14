---
title: Initialize Project
description: Generate project-level bootstrap files from .harmony templates.
access: human
argument-hint: "[@project-root] [--force] [--no-claude-alias] [--with-boot-files]"
---

# Initialize Project `/init`

Initialize project-level files after dropping `.harmony/` into a repository.

## Usage

```text
/init
/init @path/to/project-root
/init @path/to/project-root --force
/init @path/to/project-root --with-boot-files
```

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `@project-root` | No | Target project root. Defaults to parent of current `.harmony/`. |
| `--force` | No | Overwrite existing `AGENTS.md` with rendered template. |
| `--dry-run` | No | Show actions without writing files. |
| `--no-claude-alias` | No | Skip creating/verifying `CLAUDE.md -> AGENTS.md` alias. |
| `--with-boot-files` | No | Also generate `BOOT.md` and `BOOTSTRAP.md` from templates. |

## Implementation

Run:

```bash
.harmony/scaffolding/_ops/scripts/init-project.sh [--repo-root <path>] [--force] [--dry-run] [--no-claude-alias] [--with-boot-files]
```

Behavior:

1. Render `AGENTS.md` from `.harmony/scaffolding/templates/AGENTS.md`.
2. Use `.harmony/agency/manifest.yml` `default_agent` for contract paths.
3. Optionally render `BOOT.md` and `BOOTSTRAP.md` for BOOT compatibility.
4. Create `CLAUDE.md -> AGENTS.md` symlink when safe.
5. Preserve existing files unless `--force` is supplied.

## Output

- `AGENTS.md` (generated or skipped)
- `BOOT.md` and `BOOTSTRAP.md` (optional; generated or skipped)
- `CLAUDE.md` symlink to `AGENTS.md` (created, verified, or skipped)
- Summary of actions/warnings

## References

- **Script:** `.harmony/scaffolding/_ops/scripts/init-project.sh`
- **Templates:** `.harmony/scaffolding/templates/AGENTS.md`, `.harmony/scaffolding/templates/BOOT.md`, `.harmony/scaffolding/templates/BOOTSTRAP.md`
- **Canonical:** `.harmony/README.md#adopting-in-other-repos`
