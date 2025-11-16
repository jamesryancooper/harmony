from __future__ import annotations

from pathlib import Path

import pytest

from ..graph import build_architecture_assessment_graph
from ..state import ArchitectureAssessmentState

REPO_ROOT = Path(__file__).resolve().parents[5]
WORKFLOW_MANIFEST = (
    "packages/prompts/assessment/architecture/workflows/architecture-assessment.yaml"
)


def test_build_architecture_assessment_graph_rejects_unknown_entrypoint() -> None:
    with pytest.raises(ValueError):
        build_architecture_assessment_graph(
            repo_root=REPO_ROOT,
            workflow_manifest=WORKFLOW_MANIFEST,
            entrypoint="nonexistent-node",
        )


def test_build_architecture_assessment_graph_executes_inventory_node() -> None:
    graph = build_architecture_assessment_graph(
        repo_root=REPO_ROOT,
        workflow_manifest=WORKFLOW_MANIFEST,
    )

    state = ArchitectureAssessmentState(
        run_id="test-run",
        workspace_root=str(REPO_ROOT),
    )

    final_state = graph.invoke(state)
    if isinstance(final_state, dict):
        final_state = ArchitectureAssessmentState.model_validate(final_state)
    assert final_state.inventory, "Inventory should be populated from architecture docs"

