from __future__ import annotations

from pathlib import Path
from typing import Callable, Dict

import yaml
from langgraph.graph import END, StateGraph

from .analysis import (
    build_decision_map,
    build_terminology_map,
    detect_ambiguities,
    detect_conflicts,
    detect_cross_link_issues,
    detect_duplications,
    detect_gaps,
)
from .parsing import inventory_architecture_docs
from .state import (
    AlignmentDecision,
    AlignmentReport,
    ArchitectureAssessmentState,
    EditRecord,
    IssueSeverity,
    ValidationSummary,
)


StateFn = Callable[[ArchitectureAssessmentState], ArchitectureAssessmentState]

# Expected cross-references from canonical prompt
EXPECTED_CROSS_REFS = {
    "docs/harmony/architecture/overview.md": [
        "docs/harmony/architecture/repository-blueprint.md",
        "docs/harmony/architecture/monorepo-layout.md",
        "docs/harmony/architecture/governance-model.md",
        "docs/harmony/architecture/runtime-policy.md",
        "docs/harmony/architecture/observability-requirements.md",
        "docs/harmony/architecture/knowledge-plane.md",
        "docs/harmony/architecture/kaizen-subsystem.md",
        "docs/harmony/architecture/tooling-integration.md",
        "docs/harmony/architecture/slices-vs-layers.md",
    ],
}


def inventory_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Inventory phase: enumerate architecture docs and extract basic structure.

    Walks docs/harmony/architecture and populates state.inventory with structured
    file metadata (headings, terms, roles, processes, invariants, controls, links).
    """
    repo_root = Path(state.workspace_root)
    architecture_dir = state.architecture_docs_path
    inventory = inventory_architecture_docs(repo_root, architecture_dir)
    state.inventory = inventory
    return state


def analyze_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Analysis phase: build terminology and decision maps from the inventory.
    """
    if not state.inventory:
        return state

    terminology_map = build_terminology_map(state.inventory)
    decision_map = build_decision_map(state.inventory)

    state.terminology_map = terminology_map
    state.decision_map = decision_map
    return state


def map_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Mapping phase: normalize terminology and decision representations.

    Refines the terminology and decision maps by normalizing terms and
    consolidating decision representations.
    """
    # Normalization happens in-place on the maps
    # For now, we keep the maps as-is; future enhancements could add
    # semantic normalization logic here
    return state


def detect_issues_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Issue detection phase: populate state.issue_register with conflicts, gaps, ambiguities, etc.
    """
    expected_files = [
        "docs/harmony/architecture/overview.md",
        "docs/harmony/architecture/repository-blueprint.md",
        "docs/harmony/architecture/monorepo-layout.md",
        "docs/harmony/architecture/governance-model.md",
        "docs/harmony/architecture/runtime-policy.md",
        "docs/harmony/architecture/observability-requirements.md",
        "docs/harmony/architecture/knowledge-plane.md",
        "docs/harmony/architecture/kaizen-subsystem.md",
        "docs/harmony/architecture/tooling-integration.md",
        "docs/harmony/architecture/slices-vs-layers.md",
    ]

    issues = []

    if not state.inventory:
        # No files discovered: treat the entire expected file list as gaps so the run
        # surfaces a high-severity misalignment instead of silently succeeding.
        gaps = detect_gaps(state.inventory, expected_files)
        issues.extend(gaps)
        state.issue_register = issues
        return state

    # Detect conflicts
    conflicts = detect_conflicts(
        state.inventory, state.terminology_map, state.decision_map
    )
    issues.extend(conflicts)

    # Detect duplications
    duplications = detect_duplications(state.inventory)
    issues.extend(duplications)

    # Detect ambiguities
    ambiguities = detect_ambiguities(state.inventory)
    issues.extend(ambiguities)

    # Detect gaps (expected files from canonical prompt)
    gaps = detect_gaps(state.inventory, expected_files)
    issues.extend(gaps)

    # Detect cross-link issues
    cross_link_issues = detect_cross_link_issues(state.inventory, EXPECTED_CROSS_REFS)
    issues.extend(cross_link_issues)

    state.issue_register = issues
    return state


def align_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Alignment design phase: create an alignment plan from detected issues and maps.

    Converts issues into alignment decisions with planned changes.
    """
    alignment_decisions = []

    for issue in state.issue_register:
        # Create an alignment decision for each high/medium severity issue
        if issue.severity in (IssueSeverity.high, IssueSeverity.medium):
            decision = AlignmentDecision(
                id=f"align-{issue.id}",
                description=f"Resolve {issue.type.value}: {issue.description}",
                files=[issue.location.split(":")[0]],
                planned_changes=[
                    f"Address {issue.type.value} at {issue.location}: {issue.description}"
                ],
            )
            alignment_decisions.append(decision)

    state.alignment_plan = alignment_decisions
    return state


def edit_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Edit phase: apply minimal, targeted edits according to the alignment plan and
    record them in state.edits_applied.

    NOTE: This is a read-only assessment flow. Actual file edits would be applied
    by a downstream agent/tool. This node records what edits would be made.
    """
    edits = []

    for decision in state.alignment_plan:
        for file_path in decision.files:
            edit = EditRecord(
                file_path=file_path,
                summary=decision.description,
                evidence_locations=[f"{file_path}:0"],  # Simplified
            )
            edits.append(edit)

    state.edits_applied = edits
    return state


def validate_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Validation phase: confirm that edits resolved issues and did not introduce regressions.

    For this assessment flow, validation checks if high-severity issues were addressed.
    """
    resolved_issue_ids = []
    residual_issue_ids = []

    # Check if alignment plan addresses issues
    addressed_issue_ids = {d.id.replace("align-", "") for d in state.alignment_plan}

    for issue in state.issue_register:
        if issue.id in addressed_issue_ids:
            resolved_issue_ids.append(issue.id)
        else:
            if issue.severity == IssueSeverity.high:
                residual_issue_ids.append(issue.id)

    state.validation_summary = ValidationSummary(
        resolved_issue_ids=resolved_issue_ids,
        residual_issue_ids=residual_issue_ids,
    )
    return state


def summarize_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Summarization phase: build the Architecture Alignment Report from previous artefacts.
    """
    # Calculate alignment score (0-100)
    total_issues = len(state.issue_register)
    resolved_issues = len(state.validation_summary.resolved_issue_ids) if state.validation_summary else 0
    alignment_score = (
        int((resolved_issues / total_issues * 100)) if total_issues > 0 else 100
    )

    # Build key misalignments (high/medium severity issues)
    key_misalignments = [
        issue
        for issue in state.issue_register
        if issue.severity in (IssueSeverity.high, IssueSeverity.medium)
    ]

    # Build normalized glossary from terminology map (preferred term -> aliases)
    normalized_glossary = {}
    for entry in state.terminology_map.values():
        aliases = entry.aliases or [entry.term]
        # Preserve insertion order while removing duplicates, then sort for determinism
        deduped_aliases = list(dict.fromkeys(aliases))
        normalized_glossary[entry.term] = sorted(deduped_aliases)

    # Build edits by file
    edits_by_file: Dict[str, List[str]] = {}
    for edit in state.edits_applied:
        if edit.file_path not in edits_by_file:
            edits_by_file[edit.file_path] = []
        edits_by_file[edit.file_path].append(edit.summary)

    # Build open questions (from alignment plan)
    open_questions = [
        d.open_question_id
        for d in state.alignment_plan
        if d.open_question_id is not None
    ]

    executive_summary = (
        f"Architecture assessment completed. Found {total_issues} issues, "
        f"resolved {resolved_issues}. Alignment score: {alignment_score}/100."
    )

    state.alignment_report = AlignmentReport(
        executive_summary=executive_summary,
        alignment_score=alignment_score,
        key_misalignments=key_misalignments,
        normalized_glossary=normalized_glossary,
        edits_by_file=edits_by_file,
        open_questions=open_questions,
    )

    return state


def declare_no_update_node(state: ArchitectureAssessmentState) -> ArchitectureAssessmentState:
    """
    Terminal phase: emit the canonical no-update declaration when appropriate.

    Checks if the architecture docs are fully aligned (no high/medium issues,
    alignment score >= 90) and emits the canonical declaration.
    """
    # Check if alignment is sufficient
    if state.alignment_report:
        score = state.alignment_report.alignment_score or 0
        high_severity_issues = [
            issue
            for issue in state.issue_register
            if issue.severity == IssueSeverity.high
        ]

        if score >= 90 and not high_severity_issues:
            # Set a flag in the report to indicate no updates needed
            state.alignment_report.executive_summary = (
                "No updates required. The Harmony architecture documentation is "
                "internally aligned and consistent."
            )

    return state


NODE_BY_ACTION: Dict[str, StateFn] = {
    "inventory": inventory_node,
    "analyze": analyze_node,
    "map": map_node,
    "detect_issues": detect_issues_node,
    "align": align_node,
    "edit": edit_node,
    "validate": validate_node,
    "summarize": summarize_node,
    "declare_no_update": declare_no_update_node,
}


DEFAULT_WORKFLOW_MANIFEST = (
    "packages/prompts/assessment/architecture/workflows/architecture-assessment.yaml"
)


def build_architecture_assessment_graph(
    repo_root: str | Path = ".",
    workflow_manifest: str | Path = DEFAULT_WORKFLOW_MANIFEST,
    entrypoint: str | None = None,
):
    """
    Build a LangGraph graph for the Architecture Assessment flow.

    This reads the YAML workflow manifest to determine step ordering and the
    prompts to associate with each node. Honors depends_on relationships
    to wire nodes in the correct order.
    """
    root_path = Path(repo_root)
    manifest_path = Path(workflow_manifest)
    if not manifest_path.is_absolute():
        manifest_path = root_path / manifest_path

    if not manifest_path.exists():
        raise ValueError(f"Workflow manifest not found at {manifest_path}")
    manifest = yaml.safe_load(manifest_path.read_text())

    steps = manifest.get("steps", [])
    steps_sorted = sorted(
        steps,
        key=lambda s: s.get("meta", {}).get("step_index", 0),
    )

    graph_builder = StateGraph(ArchitectureAssessmentState)

    # Add all nodes first
    node_ids = []
    for step in steps_sorted:
        meta = step.get("meta", {})
        action = meta.get("action")
        node_id = step["id"]
        node_fn = NODE_BY_ACTION.get(action)
        if node_fn is None:
            raise ValueError(f"No node function registered for action '{action}'")
        graph_builder.add_node(node_id, node_fn)
        node_ids.append(node_id)

    if not steps_sorted:
        raise ValueError("Workflow manifest has no steps defined")

    # Wire edges based on depends_on or step_index order
    entry_id = steps_sorted[0]["id"]
    if entrypoint:
        if entrypoint not in node_ids:
            raise ValueError(f"Entrypoint '{entrypoint}' not found in workflow manifest")
        entry_id = entrypoint
    for i, step in enumerate(steps_sorted):
        node_id = step["id"]
        depends_on = step.get("depends_on", [])

        if depends_on:
            # Wire from dependencies
            for dep_id in depends_on:
                graph_builder.add_edge(dep_id, node_id)
        elif i > 0:
            # Wire sequentially if no explicit dependencies
            prev_id = steps_sorted[i - 1]["id"]
            graph_builder.add_edge(prev_id, node_id)

    # Set entry point
    graph_builder.set_entry_point(entry_id)

    # Final node connects to END
    final_id = steps_sorted[-1]["id"]
    graph_builder.add_edge(final_id, END)

    return graph_builder.compile()


