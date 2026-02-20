---
title: Scaffolding Bounded Surfaces Migration Evidence
description: Verification evidence for the clean-break migration to scaffolding runtime/governance/practices bounded surfaces.
---

# Scaffolding Bounded Surfaces Migration Evidence

## Migration

- ID: `2026-02-20-scaffolding-bounded-surfaces`
- Plan: `/.harmony/cognition/methodology/migrations/2026-02-20-scaffolding-bounded-surfaces/plan.md`

## Static Verification

Command:

```bash
rg -n "\.harmony/scaffolding/(templates/|prompts/|examples/|patterns/|_ops/scripts/)|scaffolding/(templates/|prompts/|examples/|patterns/|_ops/scripts/)" AGENTS.md .harmony .github --glob '!.harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh' --glob '!.harmony/cognition/methodology/migrations/**' --glob '!.harmony/output/**' --glob '!.harmony/ideation/**' --glob '!.harmony/runtime/_ops/state/**' --glob '!.harmony/cognition/decisions/**' --glob '!.harmony/cognition/context/decisions.md' --glob '!.harmony/continuity/log.md'
```

Result:

- Exit code `1` (no matches), which is expected for this sweep.

Legacy path presence check:

```bash
for p in .harmony/scaffolding/templates .harmony/scaffolding/prompts .harmony/scaffolding/examples .harmony/scaffolding/patterns .harmony/scaffolding/_ops/scripts; do if [ -e "$p" ]; then echo "EXISTS $p"; else echo "REMOVED $p"; fi; done
```

Result:

- `REMOVED .harmony/scaffolding/templates`
- `REMOVED .harmony/scaffolding/prompts`
- `REMOVED .harmony/scaffolding/examples`
- `REMOVED .harmony/scaffolding/patterns`
- `REMOVED .harmony/scaffolding/_ops/scripts`

## Runtime/Contract Verification

Commands:

```bash
bash .harmony/scaffolding/runtime/_ops/scripts/init-project.sh --dry-run
cd .harmony && bash init.sh
bash .harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh
bash .harmony/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness
```

Result:

- `init-project.sh --dry-run` exit code `0` (bootstrap templates resolved from `scaffolding/runtime/templates/`).
- `init.sh` (run from `.harmony/`) exit code `0` and includes new scaffolding surfaces in key-subdirectory checks.
- `validate-harness-structure.sh` exit code `0` (`Validation summary: errors=0 warnings=0`) including deprecated scaffolding path removal checks.
- `alignment-check.sh --profile harness` exit code `0` (`Alignment check summary: errors=0`).

## CI-Gate Verification

Updated gate surfaces:

- `/.harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh`
- `/.harmony/init.sh`
- `/.github/workflows/agency-validate.yml`
- `/.github/workflows/flags-stale-report.yml`

These updates enforce canonical scaffolding runtime/governance/practices surfaces and remove legacy path assumptions from trigger and drift checks.
