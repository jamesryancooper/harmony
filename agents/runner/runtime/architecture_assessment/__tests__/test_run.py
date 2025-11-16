from __future__ import annotations

from pathlib import Path

import pytest

from ..run import run_from_canonical_prompt, validate_canonical_prompt

REPO_ROOT = Path(__file__).resolve().parents[5]
CANONICAL_PROMPT = (
    REPO_ROOT / "packages/prompts/assessment/architecture/architecture-assessment.md"
)


def test_validate_canonical_prompt_resolves_manifest_path() -> None:
    meta = validate_canonical_prompt(CANONICAL_PROMPT, repo_root=REPO_ROOT)

    assert (
        meta["workflow_manifest_path"].endswith("architecture-assessment.yaml")
    ), "Manifest path should resolve relative to the canonical prompt"
    assert meta["entrypoint"] == "architecture-inventory"


def test_validate_canonical_prompt_errors_when_manifest_missing(tmp_path: Path) -> None:
    prompt_path = tmp_path / "prompt.md"
    prompt_path.write_text(
        """---
meta:
  workflow:
    path: missing/workflow.yaml
---
"""
    )

    with pytest.raises(ValueError):
        validate_canonical_prompt(prompt_path, repo_root=tmp_path)


def test_run_from_canonical_prompt_produces_alignment_report() -> None:
    state = run_from_canonical_prompt(
        canonical_prompt_path=CANONICAL_PROMPT,
        repo_root=REPO_ROOT,
    )

    assert state.alignment_report is not None
    assert state.issue_register is not None

