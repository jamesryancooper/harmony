# Workflows

All workflows live in `.harmony/orchestration/workflows/`, organized by group.

**Discovery:** Read `manifest.yml` for workflow index (Tier 1). After matching, read `registry.yml` for extended metadata (Tier 2). Then load `WORKFLOW.md` when a workflow is activated.

## Composition Boundaries

Workflows are one part of the composition model:

- **Composite Skill** (`.harmony/capabilities/skills/composite-skills.md`):
  reusable skill bundle with a stable command and contract.
- **Workflow** (this directory):
  ordered procedural execution with staged checkpoints.
- **Team** (`.harmony/agency/teams/`):
  actor topology and handoff policy.

Use workflows when execution order and checkpoint structure are primary.
Use Composite Skills when reusable capability bundling is primary.
Teams may standardize which workflows and composite skills are used.

## Workflow Groups

- `meta/` — Harness management (create, evaluate, migrate, update) and meta-workflows (create, evaluate, update workflow/skill)
- `quality-gate/` — Codebase integrity and release gates (refactor, orchestrate-audit, pre-release-audit, documentation-quality-gate)
- `foundations/` — Stack-specific project scaffolding (python-api, swift-macos-app)
- `missions/` — Mission lifecycle (create, complete)
- `flowkit/` — FlowKit LangGraph integration
- `projects/` — Project creation
- `ideation/` — Scratchpad content promotion
- `tasks/` — Guided operational playbooks (single-file workflows)
