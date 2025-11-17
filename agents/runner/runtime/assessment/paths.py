from __future__ import annotations

from pathlib import Path


def resolve_repo_path(candidate_path: str | Path, repo_root: str | Path) -> Path:
    """
    Resolve a path that may be relative to the repository root.

    Args:
        candidate_path: Path-like value that can be absolute or repo-relative.
        repo_root: Base directory representing the workspace root.

    Returns:
        Absolute Path pointing to the candidate within the repository context.
    """
    path_value = Path(candidate_path)
    if path_value.is_absolute():
        return path_value
    return Path(repo_root) / path_value


def resolve_manifest_path(
    workflow_manifest_path: str | Path, repo_root: str | Path
) -> Path:
    """
    Resolve the workflow manifest path relative to the workspace root.

    Args:
        workflow_manifest_path: Absolute or repo-relative manifest location.
        repo_root: Base directory representing the workspace root.

    Returns:
        Absolute Path for the manifest.
    """
    return resolve_repo_path(workflow_manifest_path, repo_root)


