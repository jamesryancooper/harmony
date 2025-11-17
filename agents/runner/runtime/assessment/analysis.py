"""
Analysis utilities for building terminology maps, decision maps, and issue detection.

These utilities process the inventory to build normalized maps and detect
conflicts, duplications, ambiguities, and gaps according to Harmony's
architecture assessment requirements.
"""

from __future__ import annotations

import re
import posixpath
from collections import defaultdict
from pathlib import PurePosixPath
from typing import Dict, List, Optional, Set

from .state import (
    DecisionEntry,
    FileInventoryItem,
    Issue,
    IssueSeverity,
    IssueType,
    TerminologyEntry,
)


def build_terminology_map(
    inventory: List[FileInventoryItem],
) -> Dict[str, TerminologyEntry]:
    """
    Build a terminology map from the inventory.

    Groups terms by their definitions/usages across files and flags
    discrepancies or synonyms needing normalization.
    """
    term_map: Dict[str, TerminologyEntry] = {}
    term_files: Dict[str, Set[str]] = defaultdict(set)
    term_definitions: Dict[str, List[str]] = defaultdict(list)

    for item in inventory:
        for term in item.key_terms:
            term_files[term].add(item.path)
            # Try to find definition context (lines around the term)
            # For now, we'll use the file path as context

    for term, files in term_files.items():
        # Normalize term (lowercase for comparison)
        normalized = term.lower()
        if normalized not in term_map:
            term_map[normalized] = TerminologyEntry(
                term=term,
                aliases=[term],
                definitions=[],
                files=sorted(list(files)),
            )
        else:
            # Merge files/aliases
            existing = term_map[normalized]
            if term not in existing.aliases:
                existing.aliases.append(term)
            merged_files = set(existing.files)
            merged_files.update(files)
            existing.files = sorted(list(merged_files))

    return term_map


def build_decision_map(
    inventory: List[FileInventoryItem],
) -> List[DecisionEntry]:
    """
    Build an architectural decision map from the inventory.

    Identifies explicit and implied architectural decisions across files.
    """
    decisions: List[DecisionEntry] = []
    decision_id_counter = 1

    # Look for decision patterns in headings and content
    decision_keywords = [
        "pattern",
        "architecture",
        "strategy",
        "approach",
        "design",
        "principle",
        "policy",
        "standard",
        "paradigm",
    ]

    for item in inventory:
        # Check headings for decision-like content
        for heading in item.headings:
            heading_lower = heading.lower()
            if any(keyword in heading_lower for keyword in decision_keywords):
                decision_id = f"decision-{decision_id_counter}"
                decision_id_counter += 1
                decisions.append(
                    DecisionEntry(
                        id=decision_id,
                        description=heading,
                        files=[item.path],
                        status="clear",
                    )
                )

        # Check processes for decision-like content
        for process in item.processes:
            if any(keyword in process.lower() for keyword in decision_keywords):
                decision_id = f"decision-{decision_id_counter}"
                decision_id_counter += 1
                decisions.append(
                    DecisionEntry(
                        id=decision_id,
                        description=process,
                        files=[item.path],
                        status="clear",
                    )
                )

    return decisions


def detect_conflicts(
    inventory: List[FileInventoryItem],
    terminology_map: Dict[str, TerminologyEntry],
    decision_map: List[DecisionEntry],
) -> List[Issue]:
    """
    Detect conflicts and contradictions in the architecture docs.

    Looks for:
    - Contradictory statements
    - Diverging role names/scopes
    - Misaligned invariants/practices
    - Conflicting patterns/technologies
    """
    issues: List[Issue] = []
    issue_id_counter = 1

    # Check for role conflicts
    role_definitions: Dict[str, Set[str]] = defaultdict(set)
    for item in inventory:
        for role in item.roles:
            role_definitions[role.lower()].add(item.path)

    for role, files in role_definitions.items():
        if len(files) > 1:
            files_sorted = sorted(files)
            issues.append(
                Issue(
                    id=f"conflict-{issue_id_counter}",
                    type=IssueType.conflict,
                    severity=IssueSeverity.medium,
                    location=f"{files_sorted[0]}:0",
                    description=f"Role '{role}' defined in multiple files: {', '.join(files_sorted)}",
                    evidence=f"Files: {', '.join(files_sorted)}",
                )
            )
            issue_id_counter += 1

    # Check for invariant conflicts
    invariant_texts: Dict[str, Set[str]] = defaultdict(set)
    for item in inventory:
        for inv in item.invariants:
            # Normalize invariant text for comparison
            inv_normalized = inv.lower().strip()
            invariant_texts[inv_normalized].add(item.path)

    for invariant_text, files in invariant_texts.items():
        if len(files) > 1:
            files_sorted = sorted(files)
            issues.append(
                Issue(
                    id=f"conflict-{issue_id_counter}",
                    type=IssueType.conflict,
                    severity=IssueSeverity.medium,
                    location=f"{files_sorted[0]}:0",
                    description=(
                        f"Invariant '{invariant_text}' defined in multiple files: {', '.join(files_sorted)}"
                    ),
                    evidence=f"Files: {', '.join(files_sorted)}",
                )
            )
            issue_id_counter += 1

    return issues


def detect_duplications(
    inventory: List[FileInventoryItem],
) -> List[Issue]:
    """
    Detect duplicated or overlapping content across files.
    """
    issues: List[Issue] = []
    issue_id_counter = 1

    # Compare headings across files
    heading_files: Dict[str, Set[str]] = defaultdict(set)
    heading_display: Dict[str, str] = {}
    for item in inventory:
        for heading in item.headings:
            heading_normalized = heading.lower().strip()
            heading_files[heading_normalized].add(item.path)
            if heading_normalized not in heading_display:
                heading_display[heading_normalized] = heading

    for heading, files in heading_files.items():
        if len(files) > 1:
            files_sorted = sorted(files)
            issues.append(
                Issue(
                    id=f"duplication-{issue_id_counter}",
                    type=IssueType.duplication,
                    severity=IssueSeverity.low,
                    location=f"{files_sorted[0]}:0",
                    description=(
                        f"Heading '{heading_display.get(heading, heading)}' appears in multiple files: "
                        f"{', '.join(files_sorted)}"
                    ),
                    evidence=f"Files: {', '.join(files_sorted)}",
                )
            )
            issue_id_counter += 1

    return issues


def detect_ambiguities(
    inventory: List[FileInventoryItem],
) -> List[Issue]:
    """
    Detect ambiguous or underspecified statements.
    """
    issues: List[Issue] = []
    issue_id_counter = 1

    ambiguous_patterns = [
        r"\b(?:may|might|could|should|possibly|perhaps)\b",
        r"\b(?:TBD|TODO|FIXME|XXX)\b",
        r"\b(?:undefined|unspecified|TBA)\b",
    ]

    for item in inventory:
        # Check for ambiguous language across headings, processes, invariants, and controls.
        searchable_sections = [
            " ".join(item.headings),
            " ".join(item.processes),
            " ".join(item.invariants),
            " ".join(item.controls),
        ]
        content_lower = " ".join(searchable_sections).lower()
        for pattern in ambiguous_patterns:
            if re.search(pattern, content_lower):
                issues.append(
                    Issue(
                        id=f"ambiguity-{issue_id_counter}",
                        type=IssueType.ambiguity,
                        severity=IssueSeverity.low,
                        location=f"{item.path}:0",
                        description=f"Potentially ambiguous language found in {item.path}",
                        evidence=f"Pattern: {pattern}",
                    )
                )
                issue_id_counter += 1

    return issues


def detect_gaps(
    inventory: List[FileInventoryItem],
    expected_files: List[str],
) -> List[Issue]:
    """
    Detect missing files or coverage gaps.

    Args:
        inventory: Current inventory.
        expected_files: List of expected file paths (e.g., from canonical prompt).
    """
    issues: List[Issue] = []
    issue_id_counter = 1

    found_files = {item.path for item in inventory}
    missing_files = set(expected_files) - found_files

    for missing in missing_files:
        issues.append(
            Issue(
                id=f"gap-{issue_id_counter}",
                type=IssueType.gap,
                severity=IssueSeverity.medium,
                location=f"{missing}:0",
                description=f"Expected file not found: {missing}",
                evidence=f"File not present in inventory",
            )
        )
        issue_id_counter += 1

    return issues


def detect_cross_link_issues(
    inventory: List[FileInventoryItem],
    expected_cross_refs: Dict[str, List[str]],
) -> List[Issue]:
    """
    Detect missing cross-links between related files.

    Args:
        inventory: Current inventory.
        expected_cross_refs: Dict mapping file path to list of expected cross-reference paths.
    """
    issues: List[Issue] = []
    issue_id_counter = 1

    def normalize_reference_path(source_path: str, reference: str) -> Optional[str]:
        if not reference:
            return None
        candidate = reference.split("#", 1)[0].strip()
        if not candidate or candidate.startswith(("http://", "https://", "mailto:")):
            return None
        source = PurePosixPath(posixpath.normpath(source_path))
        ref_path = PurePosixPath(candidate)
        if ref_path.is_absolute():
            combined = ref_path
        else:
            combined = source.parent.joinpath(ref_path)
        normalized = posixpath.normpath(combined.as_posix())
        return normalized

    file_links: Dict[str, Set[str]] = {}
    for item in inventory:
        normalized_source = posixpath.normpath(item.path)
        normalized_links: Set[str] = set()
        for link in item.links:
            normalized = normalize_reference_path(normalized_source, link)
            if normalized:
                normalized_links.add(normalized)
        file_links[normalized_source] = normalized_links

    for file_path, expected_refs in expected_cross_refs.items():
        normalized_file_path = posixpath.normpath(file_path)
        if normalized_file_path not in file_links:
            continue
        actual_links = file_links[normalized_file_path]
        normalized_expected = {posixpath.normpath(ref) for ref in expected_refs}
        missing_refs = normalized_expected - actual_links
        for missing in sorted(missing_refs):
            issues.append(
                Issue(
                    id=f"cross-link-{issue_id_counter}",
                    type=IssueType.cross_link,
                    severity=IssueSeverity.low,
                    location=f"{normalized_file_path}:0",
                    description=f"Missing cross-link to {missing}",
                    evidence="Expected reference not found in links",
                )
            )
            issue_id_counter += 1

    return issues

