# Goal Explicitness Migration Task Breakdown (Execution-Ready)

Date: 2026-02-24  
Primary owner: `harmony-platform`  
Canonical goal (authoritative text):  
`Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.`

## Execution Rules

1. Respect precedence: `AGENTS.md` -> `CONSTITUTION.md` -> `DELEGATION.md` -> `MEMORY.md` -> `AGENT.md` -> `SOUL.md`.
2. Do not edit immutable charter: `/.harmony/cognition/governance/principles/principles.md`.
3. Use exact canonical goal text in required control points (no paraphrase at those points).
4. Keep edits targeted; avoid broad rewrites.
5. Run step verification command before starting the next step.

## Owner Map

- `harmony-platform`: cross-domain orchestration + final convergence
- `agency-owner`: agency governance/contracts/runtime agent surfaces
- `cognition-owner`: governance purpose/pillars/methodology consistency
- `continuity-owner`: continuity architecture/readmes
- `capabilities-owner`: skills/workflows/services manifests and scaffolds
- `orchestration-owner`: workflow templates/manifests
- `scaffolding-owner`: bootstrap templates
- `assurance-owner`: regression checks and alignment gates

## Step 0: Baseline Snapshot

Owner: `harmony-platform`

File list:

1. No edits (baseline only)

Exact edit order:

1. Confirm working tree state.
2. Confirm canonical goal is not yet explicit in required control points.

Verification command:

```bash
git status --short && \
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" \
  AGENTS.md \
  .harmony/agency/governance/CONSTITUTION.md \
  .harmony/agency/governance/DELEGATION.md \
  .harmony/agency/governance/MEMORY.md \
  .harmony/agency/runtime/agents/architect/AGENT.md \
  .harmony/agency/runtime/agents/architect/SOUL.md || true
```

## Wave 1: Governance and Contracts

## Step 1: Root Precedence Anchor

Owner: `harmony-platform`

File list:

1. `AGENTS.md`

Exact edit order:

1. In `Canonical Framing`, append canonical goal sentence verbatim.
2. Keep existing framing bullets unchanged unless needed for coherence.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" AGENTS.md
```

## Step 2: Constitution Explicitness

Owner: `agency-owner`

File list:

1. `.harmony/agency/governance/CONSTITUTION.md`

Exact edit order:

1. Add explicit goal statement in `Contract Scope` or `Non-Negotiables`.
2. Ensure wording remains subordinate to root `AGENTS.md`.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" .harmony/agency/governance/CONSTITUTION.md
```

## Step 3: Delegation Explicitness

Owner: `agency-owner`

File list:

1. `.harmony/agency/governance/DELEGATION.md`

Exact edit order:

1. Add explicit goal mapping in `Delegation Principles` and/or `Delegation Packet Requirements`.
2. Keep delegation mechanics unchanged.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" .harmony/agency/governance/DELEGATION.md
```

## Step 4: Memory Explicitness

Owner: `agency-owner`

File list:

1. `.harmony/agency/governance/MEMORY.md`

Exact edit order:

1. Add explicit goal mapping in scope/intent section.
2. Tie memory retention to observability/debuggability and safe evolution.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" .harmony/agency/governance/MEMORY.md
```

## Step 5: Default Agent Contracts

Owner: `agency-owner`

File list:

1. `.harmony/agency/runtime/agents/architect/AGENT.md`
2. `.harmony/agency/runtime/agents/architect/SOUL.md`

Exact edit order:

1. Add canonical goal sentence in AGENT scope/directive section.
2. Add concise canonical goal reference in SOUL philosophy/boundary section.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" \
  .harmony/agency/runtime/agents/architect/AGENT.md \
  .harmony/agency/runtime/agents/architect/SOUL.md
```

## Step 6: Immutable Charter Handling Gate

Owner: `cognition-owner`

File list:

1. `.harmony/cognition/governance/principles/principles.md` (read-only check)
2. Optional successor: `.harmony/cognition/governance/principles/principles-v2026-02-24.md`
3. Optional ADR in `.harmony/cognition/runtime/decisions/`

Exact edit order:

1. Confirm immutable charter remains unedited.
2. If principle-layer explicit canonical sentence is required, create successor + ADR + index links.

Verification command:

```bash
git diff -- .harmony/cognition/governance/principles/principles.md
```

## Wave 2: Runtime and Domain Docs

## Step 7: Top-Level Harness Entrypoints

Owner: `harmony-platform`

File list:

1. `.harmony/README.md`
2. `.harmony/START.md`

Exact edit order:

1. Add canonical goal sentence in `.harmony/README.md` Purpose/Overview.
2. Add canonical goal sentence in `.harmony/START.md` near top orientation.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" .harmony/README.md .harmony/START.md
```

## Step 8: Domain Root READMEs

Owner: `harmony-platform`

File list:

1. `.harmony/agency/README.md`
2. `.harmony/capabilities/README.md`
3. `.harmony/capabilities/runtime/README.md`
4. `.harmony/cognition/README.md`
5. `.harmony/orchestration/README.md`
6. `.harmony/continuity/README.md`
7. `.harmony/engine/governance/README.md`

Exact edit order:

1. Add one-line canonical goal mapping at top of each file.
2. Keep surface catalogs unchanged.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" \
  .harmony/agency/README.md \
  .harmony/capabilities/README.md \
  .harmony/capabilities/runtime/README.md \
  .harmony/cognition/README.md \
  .harmony/orchestration/README.md \
  .harmony/continuity/README.md \
  .harmony/engine/governance/README.md
```

## Step 9: Continuity Architecture Explicitness

Owner: `continuity-owner`

File list:

1. `.harmony/continuity/_meta/architecture/continuity-plane.md`
2. `.harmony/continuity/runs/README.md`
3. `.harmony/continuity/_meta/architecture/runs-retention.md`

Exact edit order:

1. Add explicit mapping from continuity evidence to debuggability and safe evolution.
2. Keep lifecycle/retention semantics unchanged.

Verification command:

```bash
rg -n 'determin|observ|debug|evolv|trust' \
  .harmony/continuity/_meta/architecture/continuity-plane.md \
  .harmony/continuity/runs/README.md \
  .harmony/continuity/_meta/architecture/runs-retention.md
```

## Step 10: Purpose/Pillar Drift Fix

Owner: `cognition-owner`

File list:

1. `.harmony/cognition/governance/purpose/convivial-purpose.md`
2. Any directly linked governance-purpose index files if needed

Exact edit order:

1. Replace active “five pillars” references with current six-pillar framing.
2. Preserve purpose narrative; only fix active terminology drift.

Verification command:

```bash
rg -n "five pillars|six pillars" .harmony/cognition/governance/purpose/convivial-purpose.md .harmony/cognition/governance/pillars/README.md
```

## Wave 3: Capabilities, Workflows, and Templates

## Step 11: Workflow and Skill Scaffold Templates

Owner: `orchestration-owner`

File list:

1. `.harmony/orchestration/runtime/workflows/_scaffold/template/WORKFLOW.md`
2. `.harmony/capabilities/runtime/skills/_scaffold/template/SKILL.md`
3. `.harmony/capabilities/runtime/services/_scaffold/template/SERVICE.md`

Exact edit order:

1. Add required “Goal Alignment” section to `WORKFLOW.md`.
2. Add required “Goal Alignment” section to `SKILL.md`.
3. Add explicit canonical goal note to `SERVICE.md` template body/frontmatter guidance.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" \
  .harmony/orchestration/runtime/workflows/_scaffold/template/WORKFLOW.md \
  .harmony/capabilities/runtime/skills/_scaffold/template/SKILL.md \
  .harmony/capabilities/runtime/services/_scaffold/template/SERVICE.md
```

## Step 12: Runtime Manifests Goal Metadata

Owner: `capabilities-owner`

File list:

1. `.harmony/orchestration/runtime/workflows/manifest.yml`
2. `.harmony/capabilities/runtime/skills/manifest.yml`
3. `.harmony/capabilities/runtime/services/manifest.yml`
4. `.harmony/capabilities/runtime/commands/manifest.yml`

Exact edit order:

1. Add top-level goal-alignment metadata/comment to each manifest.
2. Do not modify IDs/paths/schema-critical fields.

Verification command:

```bash
rg -n "goal|reliable|determin|observ|debug|evolv|trust" \
  .harmony/orchestration/runtime/workflows/manifest.yml \
  .harmony/capabilities/runtime/skills/manifest.yml \
  .harmony/capabilities/runtime/services/manifest.yml \
  .harmony/capabilities/runtime/commands/manifest.yml
```

## Step 13: Scaffolding Bootstrap Propagation

Owner: `scaffolding-owner`

File list:

1. `.harmony/scaffolding/runtime/templates/AGENTS.md`
2. `.harmony/scaffolding/runtime/templates/harmony/START.md`
3. `.harmony/scaffolding/runtime/templates/harmony/continuity/tasks.json`
4. `.harmony/scaffolding/runtime/templates/harmony/agency/manifest.yml`
5. `.harmony/scaffolding/runtime/templates/harmony/manifest.json` (template consistency fixes)

Exact edit order:

1. Add canonical goal sentence to template `AGENTS.md`.
2. Add canonical goal sentence to template harness `START.md`.
3. Seed canonical goal in template `continuity/tasks.json` goal field guidance.
4. Add goal alignment metadata/reference in template agency manifest.
5. Correct stale template structure references in template manifest if required for coherence.

Verification command:

```bash
CANON='Enable reliable agent execution that is deterministic enough to trust, observable enough to debug, and flexible enough to evolve.' && \
rg -nF "$CANON" \
  .harmony/scaffolding/runtime/templates/AGENTS.md \
  .harmony/scaffolding/runtime/templates/harmony/START.md \
  .harmony/scaffolding/runtime/templates/harmony/continuity/tasks.json && \
rg -n "goal|alignment|assurance|runtime/agents" .harmony/scaffolding/runtime/templates/harmony/manifest.json
```

## Wave 4: Assurance and Regression Checks

## Step 14: Framing Validator Upgrade

Owner: `assurance-owner`

File list:

1. `.harmony/assurance/runtime/_ops/scripts/validate-framing-alignment.sh`

Exact edit order:

1. Add explicit canonical goal check for required control points.
2. Keep existing framing marker checks (`agent-first`, `system-governed`, etc.) unless intentionally superseded.
3. Add drift check for active contradictory wording (for example, `five pillars` where no longer valid).

Verification command:

```bash
bash .harmony/assurance/runtime/_ops/scripts/validate-framing-alignment.sh
```

## Step 15: SSOT Drift Validator Extension

Owner: `assurance-owner`

File list:

1. `.harmony/assurance/runtime/_ops/scripts/validate-ssot-precedence-drift.sh`

Exact edit order:

1. Add checks that precedence-layer goal wording does not conflict.
2. Keep existing precedence checks intact.

Verification command:

```bash
bash .harmony/assurance/runtime/_ops/scripts/validate-ssot-precedence-drift.sh
```

## Step 16: Full Alignment Gate

Owner: `harmony-platform`

File list:

1. No edits (gate run)

Exact edit order:

1. Run targeted profiles first (`framing,harness`).
2. Run full relevant stack (`framing,harness,agency,workflows,skills,services,weights`).
3. Capture failures and loop back to owning step.

Verification command:

```bash
bash .harmony/assurance/runtime/_ops/scripts/alignment-check.sh --profile framing,harness,agency,workflows,skills,services,weights
```

## Final Done Gate

All items below must be true:

1. Canonical goal text is explicit in all required control points.
2. No active-doc contradiction remains (`five pillars` drift resolved in active governance-purpose surfaces).
3. Scaffold templates propagate explicit goal text by default.
4. Framing and SSOT validators pass.
5. Full alignment-check profile passes.

