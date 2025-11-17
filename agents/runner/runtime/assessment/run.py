from __future__ import annotations

import sys
import uuid
from pathlib import Path
from typing import Any, Dict, List

import yaml

from .graph_factory import compile_assessment_graph
from .paths import resolve_manifest_path, resolve_repo_path
from .parsing import parse_frontmatter
from .state import AssessmentGraphState, AssessmentState


def validate_canonical_prompt(canonical_prompt_path: str | Path) -> Dict[str, str]:
    """
    Validate canonical prompt frontmatter and return lightweight metadata.

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

    title = frontmatter.get("title")
    description = frontmatter.get("description")
    if not title or not description:
        raise ValueError(
            f"Canonical prompt frontmatter must include 'title' and 'description': {canonical_prompt_path}"
        )

    return {"title": str(title), "description": str(description)}


def _load_assessment_config(manifest: Dict[str, Any]) -> Dict[str, Any]:
    assessment_cfg = manifest.get("assessment")
    if not isinstance(assessment_cfg, dict):
        raise ValueError("Workflow manifest missing 'assessment' configuration block.")

    docs_path = assessment_cfg.get("docs_path")
    if not isinstance(docs_path, str) or not docs_path.strip():
        raise ValueError("assessment.docs_path must be a non-empty string.")

    expected_files_raw = assessment_cfg.get("expected_files", [])
    if not isinstance(expected_files_raw, list):
        raise ValueError("assessment.expected_files must be a list when provided.")
    expected_files: List[str] = [str(path) for path in expected_files_raw]

    expected_cross_refs_raw = assessment_cfg.get("expected_cross_refs", {})
    if not isinstance(expected_cross_refs_raw, dict):
        raise ValueError("assessment.expected_cross_refs must be a mapping when provided.")
    expected_cross_refs: Dict[str, List[str]] = {}
    for source, targets in expected_cross_refs_raw.items():
        if not isinstance(targets, list):
            raise ValueError(
                f"assessment.expected_cross_refs['{source}'] must be a list of file paths."
            )
        expected_cross_refs[str(source)] = [str(target) for target in targets]

    thresholds = assessment_cfg.get("thresholds", {})
    if thresholds is None:
        thresholds = {}
    if not isinstance(thresholds, dict):
        raise ValueError("assessment.thresholds must be a mapping when provided.")

    return {
        "docs_path": docs_path,
        "expected_files": expected_files,
        "expected_cross_refs": expected_cross_refs,
        "thresholds": thresholds,
    }


def run_assessment_from_canonical_prompt(
    canonical_prompt_path: str | Path,
    workflow_manifest_path: str | Path,
    workflow_entrypoint: str | None = None,
    repo_root: str | Path = ".",
    run_id: str | None = None,
) -> AssessmentState:
    """
    Execute a config-driven assessment flow using the provided configuration.
    """
    canonical_path = resolve_repo_path(canonical_prompt_path, repo_root)
    validate_canonical_prompt(canonical_path)

    manifest_path = resolve_manifest_path(workflow_manifest_path, repo_root)
    if not manifest_path.exists():
        raise ValueError(f"Workflow manifest not found at {manifest_path}")

    manifest_data = yaml.safe_load(manifest_path.read_text()) or {}
    assessment_config = _load_assessment_config(manifest_data)

    root_path = Path(repo_root)
    initial_state: AssessmentGraphState = {
        "run_id": run_id or str(uuid.uuid4()),
        "workspace_root": str(root_path),
        "docs_path": assessment_config["docs_path"],
        "expected_files": assessment_config["expected_files"],
        "expected_cross_refs": assessment_config["expected_cross_refs"],
        "thresholds": assessment_config["thresholds"],
    }

    graph = compile_assessment_graph(
        workspace_root=root_path,
        workflow_manifest_path=manifest_path,
        workflow_entrypoint=workflow_entrypoint,
    )
    final_state = graph.invoke(initial_state)
    return AssessmentState.model_validate(final_state)


def main(argv: list[str] | None = None) -> None:
    """
    CLI entrypoint (primarily for debugging).

    Usage:
        python -m agents.runner.runtime.assessment.run \
          <canonical_prompt_path> <workflow_manifest_path> [entrypoint] [workspace_root]
    """
    args = list(sys.argv[1:] if argv is None else argv)
    if len(args) < 2:
        raise SystemExit(
            "Usage: python -m agents.runner.runtime.assessment.run "
            "<canonical_prompt_path> <workflow_manifest_path> [entrypoint] [workspace_root]"
        )

    canonical = args[0]
    manifest = args[1]
    entrypoint = args[2] if len(args) > 2 else None
    workspace_root = args[3] if len(args) > 3 else "."

    try:
        final_state = run_assessment_from_canonical_prompt(
            canonical_prompt_path=canonical,
            workflow_manifest_path=manifest,
            workflow_entrypoint=entrypoint,
            repo_root=workspace_root,
        )

        if final_state.alignment_report is not None:
            print(final_state.alignment_report.model_dump_json(indent=2))
        else:
            print("ArchitectureAssessmentFlow completed (no alignment_report set).")
    except Exception as exc:  # pragma: no cover
        print(f"Error: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":  # pragma: no cover
    main()

