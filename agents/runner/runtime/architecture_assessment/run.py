from __future__ import annotations

import sys
import uuid
from pathlib import Path

from .graph import build_architecture_assessment_graph
from .parsing import parse_frontmatter
from .state import ArchitectureAssessmentState


def validate_canonical_prompt(
    canonical_prompt_path: str | Path, repo_root: str | Path = "."
) -> dict:
    """
    Validate canonical prompt frontmatter and extract workflow metadata.

    Returns:
        Dict with workflow metadata (workflow.path, entrypoint, etc.)

    Raises:
        ValueError: If frontmatter is missing or invalid.
    """
    prompt_path = Path(canonical_prompt_path)
    if not prompt_path.exists():
        raise ValueError(f"Canonical prompt not found: {canonical_prompt_path}")

    content = prompt_path.read_text(encoding="utf-8")
    frontmatter, _ = parse_frontmatter(content)

    if not frontmatter:
        raise ValueError(f"Canonical prompt missing frontmatter: {canonical_prompt_path}")

    meta = frontmatter.get("meta", {})
    workflow = meta.get("workflow", {})

    if not workflow or "path" not in workflow:
        raise ValueError(
            f"Canonical prompt missing meta.workflow.path: {canonical_prompt_path}"
        )

    workflow_path_value = workflow.get("path")
    repo_root_path = Path(repo_root)

    def _candidate_manifest_paths() -> list[Path]:
        path_value = Path(workflow_path_value)
        candidates: list[Path] = []
        if path_value.is_absolute():
            candidates.append(path_value)
        else:
            candidates.append(repo_root_path / path_value)
            candidates.append(repo_root_path / "packages" / "prompts" / path_value)
            candidates.append(prompt_path.parent / path_value)
        seen: set[str] = set()
        unique: list[Path] = []
        for candidate in candidates:
            key = str(candidate)
            if key not in seen:
                seen.add(key)
                unique.append(candidate)
        return unique

    manifest_path: Path | None = None
    for candidate in _candidate_manifest_paths():
        if candidate.exists():
            manifest_path = candidate
            break

    if manifest_path is None:
        raise ValueError(
            f"Workflow manifest not found for path '{workflow_path_value}' "
            f"referenced by {canonical_prompt_path}"
        )

    return {
        "workflow_path": workflow_path_value,
        "workflow_manifest_path": str(manifest_path),
        "entrypoint": workflow.get("entrypoint"),
        "type": meta.get("type"),
        "subject": meta.get("subject"),
    }


def run_from_canonical_prompt(
    canonical_prompt_path: str | Path,
    repo_root: str | Path = ".",
) -> ArchitectureAssessmentState:
    """
    Entry point for running the Architecture Assessment flow from its canonical prompt.

    Validates the canonical prompt frontmatter, builds the LangGraph graph using
    the workflow manifest, and invokes the graph to produce the final state.
    """
    # Validate canonical prompt
    workflow_meta = validate_canonical_prompt(canonical_prompt_path, repo_root=repo_root)

    # Build initial state
    root_path = Path(repo_root)
    state = ArchitectureAssessmentState(
        run_id=str(uuid.uuid4()),
        workspace_root=str(root_path),
    )

    # Build and run graph
    graph = build_architecture_assessment_graph(
        repo_root=repo_root,
        workflow_manifest=workflow_meta["workflow_manifest_path"],
        entrypoint=workflow_meta.get("entrypoint"),
    )
    final_state = graph.invoke(state)
    if isinstance(final_state, ArchitectureAssessmentState):
        return final_state

    # LangGraph may return a plain dict; convert it back into our state model.
    return ArchitectureAssessmentState.model_validate(final_state)


def main(argv: list[str] | None = None) -> None:
    """
    CLI entrypoint.

    Usage:
        python -m agents.runner.runtime.architecture_assessment.run \
          packages/prompts/assessment/architecture/architecture-assessment.md

    Prints the alignment report as JSON to stdout, or a no-update declaration
    if the architecture docs are fully aligned.
    """
    args = list(sys.argv[1:] if argv is None else argv)
    canonical = (
        args[0]
        if args
        else "packages/prompts/assessment/architecture/architecture-assessment.md"
    )

    try:
        final_state = run_from_canonical_prompt(canonical_prompt_path=canonical)

        if final_state.alignment_report is not None:
            # Print structured JSON for the TypeScript kit to parse
            print(final_state.alignment_report.model_dump_json(indent=2))
        else:
            print("ArchitectureAssessmentFlow completed (no alignment_report set).")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":  # pragma: no cover
    main()

