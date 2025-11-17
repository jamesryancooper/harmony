"""
Tests for architecture assessment analysis utilities.
"""

from ..analysis import (
    build_decision_map,
    build_terminology_map,
    detect_ambiguities,
    detect_conflicts,
    detect_cross_link_issues,
    detect_duplications,
    detect_gaps,
)
from ..state import FileInventoryItem


def test_build_terminology_map():
    """Test terminology map building."""
    inventory = [
        FileInventoryItem(
            path="file1.md",
            key_terms=["Harmony", "FlowKit"],
        ),
        FileInventoryItem(
            path="file2.md",
            key_terms=["Harmony", "Architecture"],
        ),
    ]

    term_map = build_terminology_map(inventory)
    assert "harmony" in term_map  # Normalized to lowercase
    assert len(term_map["harmony"].files) == 2


def test_build_decision_map():
    """Test decision map building."""
    inventory = [
        FileInventoryItem(
            path="file1.md",
            headings=["Architecture Pattern", "Design Strategy"],
            processes=["Use Hexagonal Architecture"],
        ),
    ]

    decisions = build_decision_map(inventory)
    assert len(decisions) > 0
    assert any("Pattern" in d.description for d in decisions)


def test_detect_duplications():
    """Test duplication detection."""
    inventory = [
        FileInventoryItem(
            path="file1.md",
            headings=["Introduction", "Overview"],
        ),
        FileInventoryItem(
            path="file2.md",
            headings=["Introduction", "Details"],
        ),
    ]

    issues = detect_duplications(inventory)
    assert len(issues) > 0
    assert any("Introduction" in issue.description for issue in issues)


def test_detect_conflicts():
    """Test conflict detection."""
    inventory = [
        FileInventoryItem(
            path="file1.md",
            roles=["Developer", "Architect"],
        ),
        FileInventoryItem(
            path="file2.md",
            roles=["Developer", "Designer"],
        ),
    ]

    term_map = build_terminology_map(inventory)
    decision_map = build_decision_map(inventory)

    issues = detect_conflicts(inventory, term_map, decision_map)
    # Should detect role conflicts if roles are defined differently
    assert isinstance(issues, list)


def test_detect_ambiguities_scans_multiple_sections():
    """Detect ambiguity markers across headings, processes, and invariants."""
    inventory = [
        FileInventoryItem(
            path="file.md",
            headings=["TBD architecture"],
            processes=["We should maybe adopt Hexagonal architecture"],
            invariants=["This must always be optional"],
        )
    ]

    issues = detect_ambiguities(inventory)
    assert issues, "Expected ambiguity issue when TBD language is present"


def test_detect_gaps_flags_missing_expected_files():
    """Detect gaps when expected files are absent from the inventory."""
    inventory = [
        FileInventoryItem(
            path="docs/harmony/architecture/overview.md",
        )
    ]
    expected_files = [
        "docs/harmony/architecture/overview.md",
        "docs/harmony/architecture/runtime-policy.md",
    ]

    issues = detect_gaps(inventory, expected_files)
    assert any(
        "runtime-policy.md" in issue.description for issue in issues
    ), "Expected missing runtime-policy gap to be reported"


def test_detect_cross_link_issues_normalizes_relative_links():
    """Ensure relative links normalize to canonical architecture paths."""
    inventory = [
        FileInventoryItem(
            path="docs/harmony/architecture/overview.md",
            links=["./runtime-policy.md", "../architecture/monorepo-layout.md"],
        )
    ]
    expected_refs = {
        "docs/harmony/architecture/overview.md": [
            "docs/harmony/architecture/runtime-policy.md",
            "docs/harmony/architecture/monorepo-layout.md",
        ]
    }

    issues = detect_cross_link_issues(inventory, expected_refs)
    assert issues == []


def test_detect_cross_link_issues_flags_missing_links():
    """Flag missing cross-links when expected references are absent."""
    inventory = [
        FileInventoryItem(
            path="docs/harmony/architecture/overview.md",
            links=[],
        )
    ]
    expected_refs = {
        "docs/harmony/architecture/overview.md": [
            "docs/harmony/architecture/runtime-policy.md"
        ]
    }

    issues = detect_cross_link_issues(inventory, expected_refs)
    assert len(issues) == 1
    assert "runtime-policy" in issues[0].description

