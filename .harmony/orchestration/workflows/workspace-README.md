# Workflows

All workflows live in `.harmony/orchestration/workflows/`, organized by domain.

**Discovery:** Read `manifest.yml` for workflow index (Tier 1). After matching, read `registry.yml` for extended metadata (Tier 2). Then load `WORKFLOW.md` when a workflow is activated.

## Workflow Categories

- `workspace/` - Workspace management (create, evaluate, migrate, update)
- `missions/` - Mission lifecycle (create, complete)
- `skills(x)/` - Skill creation workflow
- `workflows/` - Workflow meta-workflows (create, evaluate, update)
- `refactor(x)/` - Codebase refactoring
- `audit/` - Audit orchestration (orchestrate-audit)
- `flowkit/` - FlowKit LangGraph integration
- `projects/` - Project creation
