from __future__ import annotations

from enum import Enum
from typing import Any, Dict, List, Optional

from typing_extensions import TypedDict

from pydantic import BaseModel, Field


class IssueType(str, Enum):
    conflict = "conflict"
    duplication = "duplication"
    ambiguity = "ambiguity"
    gap = "gap"
    cross_link = "cross_link"


class IssueSeverity(str, Enum):
    high = "high"
    medium = "medium"
    low = "low"


class FileInventoryItem(BaseModel):
    """Inventory entry for a single architecture doc file."""

    path: str
    title: Optional[str] = None
    frontmatter: Dict[str, Any] = Field(
        default_factory=dict,
        description="Raw frontmatter metadata (kept structured for downstream analysis).",
    )
    headings: List[str] = Field(default_factory=list)
    key_terms: List[str] = Field(default_factory=list)
    roles: List[str] = Field(default_factory=list)
    processes: List[str] = Field(default_factory=list)
    invariants: List[str] = Field(default_factory=list)
    controls: List[str] = Field(default_factory=list)
    links: List[str] = Field(default_factory=list)


class TerminologyEntry(BaseModel):
    term: str
    aliases: List[str] = Field(
        default_factory=list,
        description="Distinct forms of the term encountered across the docs.",
    )
    definitions: List[str] = Field(default_factory=list)
    files: List[str] = Field(default_factory=list)
    notes: Optional[str] = None


class DecisionEntry(BaseModel):
    """Represents a single architectural decision and where it appears."""

    id: str
    description: str
    files: List[str] = Field(default_factory=list)
    status: str = "unspecified"  # e.g., "clear", "ambiguous", "partial"
    notes: Optional[str] = None


class Issue(BaseModel):
    id: str
    type: IssueType
    severity: IssueSeverity
    location: str  # relative/path.md:line
    description: str
    evidence: Optional[str] = None


class AlignmentDecision(BaseModel):
    id: str
    description: str
    files: List[str] = Field(default_factory=list)
    planned_changes: List[str] = Field(default_factory=list)
    open_question_id: Optional[str] = None


class EditRecord(BaseModel):
    file_path: str
    summary: str
    evidence_locations: List[str] = Field(default_factory=list)


class ValidationSummary(BaseModel):
    resolved_issue_ids: List[str] = Field(default_factory=list)
    residual_issue_ids: List[str] = Field(default_factory=list)
    notes: Optional[str] = None


class AlignmentReport(BaseModel):
    executive_summary: Optional[str] = None
    alignment_score: Optional[int] = Field(
        default=None, ge=0, le=100, description="0–100 alignment score."
    )
    key_misalignments: List[Issue] = Field(default_factory=list)
    normalized_glossary: Dict[str, List[str]] = Field(default_factory=dict)
    edits_by_file: Dict[str, List[str]] = Field(default_factory=dict)
    open_questions: List[str] = Field(default_factory=list)


class AssessmentState(BaseModel):
    """
    Shared state for the ArchitectureAssessmentFlow.

    This mirrors the structure described in the canonical architecture assessment prompt:
    inventory, terminology/decision maps, issues, alignment plan, edits, validation,
    and the final alignment report.
    """

    run_id: str
    workspace_root: str = "."  # Repo root (used for resolving relative paths)
    docs_path: str = "docs/harmony/architecture"

    # Analysis artefacts
    inventory: List[FileInventoryItem] = Field(default_factory=list)
    terminology_map: Dict[str, TerminologyEntry] = Field(default_factory=dict)
    decision_map: List[DecisionEntry] = Field(default_factory=list)
    issue_register: List[Issue] = Field(default_factory=list)

    # Alignment and edits
    alignment_plan: List[AlignmentDecision] = Field(default_factory=list)
    edits_applied: List[EditRecord] = Field(default_factory=list)

    # Validation and reporting
    validation_summary: Optional[ValidationSummary] = None
    alignment_report: Optional[AlignmentReport] = None

    # Assessment configuration (populated from manifest)
    expected_files: List[str] = Field(default_factory=list)
    expected_cross_refs: Dict[str, List[str]] = Field(default_factory=dict)
    thresholds: Dict[str, Any] = Field(default_factory=dict)


class AssessmentGraphState(TypedDict, total=False):
    """
    Data structure consumed by LangGraph nodes.

    This mirrors AssessmentState but keeps fields optional so nodes can emit
    incremental updates. Lists that accumulate data use reducer annotations so
    LangGraph can merge contributions from multiple nodes when necessary.
    """

    run_id: str
    workspace_root: str
    docs_path: str

    inventory: List[FileInventoryItem]
    terminology_map: Dict[str, TerminologyEntry]
    decision_map: List[DecisionEntry]
    issue_register: List[Issue]

    alignment_plan: List[AlignmentDecision]
    edits_applied: List[EditRecord]

    validation_summary: ValidationSummary
    alignment_report: AlignmentReport

    expected_files: List[str]
    expected_cross_refs: Dict[str, List[str]]
    thresholds: Dict[str, Any]
