from __future__ import annotations

from pathlib import Path
from textwrap import dedent
from typing import Iterable, Tuple

import pytest

from ..graph import (
    build_assessment_graph,
    declare_no_update_node,
    detect_issues_node,
    map_node,
)
from ..run import (
    run_assessment_from_canonical_prompt,
)
from ..state import (
    AlignmentReport,
    AssessmentState,
    FileInventoryItem,
    Issue,
    IssueSeverity,
    IssueType,
)


def _write_manifest(tmp_path: Path, raw_yaml: str) -> Path:
    manifest_path = tmp_path / "manifest.yaml"
    manifest_path.write_text(dedent(raw_yaml))
    return manifest_path


def _edge_pairs(edges: Iterable) -> set[Tuple[str, str]]:
    return {(edge.source, edge.target) for edge in edges}


def _repo_root() -> Path:
    current = Path(__file__).resolve()
    for ancestor in current.parents:
        if (ancestor / "pnpm-workspace.yaml").exists():
            return ancestor
    raise RuntimeError("Could not locate repository root from test path.")


def _base_graph_state() -> dict:
    repo_root = _repo_root()
    return {
        "run_id": "test-run",
        "workspace_root": str(repo_root),
        "docs_path": "docs/harmony/architecture",
        "expected_files": [],
        "expected_cross_refs": {},
        "thresholds": {},
    }


def test_build_assessment_graph_wires_all_terminal_nodes_to_end(tmp_path: Path) -> None:
    manifest_path = _write_manifest(
        tmp_path,
        """
        steps:
          - id: branching-root
            meta:
              action: map
              step_index: 1
          - id: branch-a
            depends_on: [branching-root]
            meta:
              action: map
              step_index: 2
          - id: branch-b
            depends_on: [branching-root]
            meta:
              action: map
              step_index: 3
        """,
    )

    graph = build_assessment_graph(
        repo_root=tmp_path,
        workflow_manifest=str(manifest_path),
    )
    edges = _edge_pairs(graph.get_graph().edges)

    assert ("branch-a", "__end__") in edges
    assert ("branch-b", "__end__") in edges


def test_build_assessment_graph_respects_entrypoint_override(tmp_path: Path) -> None:
    manifest_path = _write_manifest(
        tmp_path,
        """
        steps:
          - id: expensive-inventory
            meta:
              action: inventory
              step_index: 1
          - id: detached-map
            meta:
              action: map
              step_index: 2
        """,
    )

    graph = build_assessment_graph(
        repo_root=tmp_path,
        workflow_manifest=str(manifest_path),
        entrypoint="detached-map",
    )
    inner_graph = graph.get_graph()
    start_edges = [
        edge.target for edge in inner_graph.edges if edge.source == "__start__"
    ]
    assert start_edges == ["detached-map"]


def test_build_assessment_graph_rejects_unknown_entrypoint(tmp_path: Path) -> None:
    manifest_path = _write_manifest(
        tmp_path,
        """
        steps:
          - id: root
            meta:
              action: map
              step_index: 1
        """,
    )

    with pytest.raises(ValueError):
        build_assessment_graph(
            repo_root=tmp_path,
            workflow_manifest=str(manifest_path),
            entrypoint="nonexistent-node",
        )


def test_build_assessment_graph_executes_inventory_node() -> None:
    repo_root = _repo_root()
    manifest = repo_root / "packages" / "prompts" / "assessment" / "architecture" / "workflows" / "architecture-assessment.yaml"
    graph = build_assessment_graph(
        repo_root=repo_root,
        workflow_manifest=str(manifest),
    )

    final_state = graph.invoke(_base_graph_state())

    assert final_state.get("inventory"), "Inventory should be populated from architecture docs"


def test_map_node_returns_empty_update_without_mutation() -> None:
    state = {"terminology_map": {"term": "value"}}
    original = state.copy()

    result = map_node(state)

    assert result == {}
    assert state == original


def test_detect_issues_node_uses_expected_files_from_state() -> None:
    updates = detect_issues_node(
        {
            "run_id": "gap-test",
            "inventory": [],
            "expected_files": ["docs/harmony/architecture/runtime-policy.md"],
        }
    )

    issues = updates["issue_register"]
    assert any(
        issue.type == IssueType.gap and "runtime-policy.md" in issue.description
        for issue in issues
    ), "Expected missing runtime-policy gap to be reported via state configuration"


def test_detect_issues_node_uses_expected_cross_refs_from_state() -> None:
    inventory = [
        FileInventoryItem(
            path="docs/harmony/architecture/overview.md",
            links=[],
        )
    ]
    updates = detect_issues_node(
        {
            "run_id": "xref-test",
            "inventory": inventory,
            "expected_cross_refs": {
                "docs/harmony/architecture/overview.md": [
                    "docs/harmony/architecture/runtime-policy.md"
                ]
            },
        }
    )

    issues = updates["issue_register"]
    assert any(
        issue.type == IssueType.cross_link and "runtime-policy" in issue.description
        for issue in issues
    ), "Expected cross-link issue when expected_cross_refs requires it"


def test_declare_no_update_node_respects_thresholds_and_severity() -> None:
    state = {
        "run_id": "threshold-test",
        "thresholds": {"min_alignment_score_for_no_update": 95},
        "issue_register": [],
        "alignment_report": AlignmentReport(
            executive_summary="Needs review",
            alignment_score=92,
        ),
    }

    update = declare_no_update_node(state)
    report = update.get("alignment_report")
    assert report is None, "Score below threshold should not trigger no-update declaration"

    state["alignment_report"] = AlignmentReport(
        executive_summary="Needs review",
        alignment_score=99,
    )
    state["issue_register"] = [
        Issue(
            id="issue-1",
            type=IssueType.conflict,
            severity=IssueSeverity.high,
            location="docs/test.md:1",
            description="High severity issue",
        )
    ]
    update = declare_no_update_node(state)
    report = update.get("alignment_report")
    assert report is None, "High severity issues should prevent no-update declaration"

    state["issue_register"] = []
    update = declare_no_update_node(state)
    report = update.get("alignment_report")
    assert report is not None and "No updates required" in report.executive_summary


@pytest.mark.slow
def test_run_assessment_from_canonical_prompt_returns_alignment_state() -> None:
    repo_root = _repo_root()
    canonical = (
        repo_root
        / "packages"
        / "prompts"
        / "assessment"
        / "architecture"
        / "architecture-assessment.md"
    )
    manifest = (
        repo_root
        / "packages"
        / "prompts"
        / "assessment"
        / "architecture"
        / "workflows"
        / "architecture-assessment.yaml"
    )

    state = run_assessment_from_canonical_prompt(
        canonical_prompt_path=canonical,
        workflow_manifest_path=manifest,
        workflow_entrypoint="architecture-inventory",
        repo_root=repo_root,
        run_id="test-run",
    )

    assert isinstance(state, AssessmentState)
    assert state.alignment_report is not None
    assert state.alignment_report.alignment_score is not None

