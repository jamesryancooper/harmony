# Commands

## Core Migration Edits

```bash
git mv .harmony/cognition/_meta/architecture/content-plane \
  .harmony/cognition/_meta/architecture/artifact-surface

git mv .harmony/cognition/_meta/architecture/artifact-surface/runtime-content-layer.md \
  .harmony/cognition/_meta/architecture/artifact-surface/runtime-artifact-layer.md
```

## Static Sweep Commands

```bash
rg -n "content-plane" .harmony \
  --glob '!**/target/**' \
  --glob '!**/_ops/state/**' \
  --glob '!**/runtime/migrations/**' \
  --glob '!**/runtime/decisions/**' \
  --glob '!**/runtime/context/decisions.md' \
  --glob '!**/practices/methodology/migrations/legacy-banlist.md' \
  --glob '!**/output/reports/migrations/**'

rg -n "Content Plane|content publishing surface|Harmony Content Publishing Surface|\\bHCP\\b|Harmony Content Plane" .harmony \
  --glob '!**/target/**' \
  --glob '!**/_ops/state/**' \
  --glob '!**/runtime/migrations/**' \
  --glob '!**/runtime/decisions/**' \
  --glob '!**/runtime/context/decisions.md' \
  --glob '!**/practices/methodology/migrations/legacy-banlist.md' \
  --glob '!**/output/reports/migrations/**'
```

## Diff Hygiene

```bash
git diff --check -- \
  .harmony/cognition/_meta/architecture/artifact-surface \
  .harmony/cognition/runtime/knowledge-plane/knowledge-plane.md \
  .harmony/continuity/_meta/architecture/three-planes-integration.md
```
