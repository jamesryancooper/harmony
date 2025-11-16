"""
Markdown and frontmatter parsing utilities for architecture assessment.

These utilities deterministically parse architecture documentation files
to extract structured inventory data, ensuring scope is confined to
docs/harmony/architecture and metadata captures evidence (path:line).
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any, Dict, List, Optional

import yaml

from .state import FileInventoryItem


def parse_frontmatter(content: str) -> tuple[Dict[str, Any], str]:
    """
    Parse YAML frontmatter from Markdown content.

    Returns:
        Tuple of (frontmatter dict, content without frontmatter).
    """
    frontmatter_pattern = r"^---\s*\n(.*?)\n---\s*\n(.*)$"
    match = re.match(frontmatter_pattern, content, re.DOTALL)
    if match:
        try:
            fm = yaml.safe_load(match.group(1)) or {}
            return (fm, match.group(2))
        except yaml.YAMLError:
            return ({}, content)
    return ({}, content)


def extract_headings(content: str) -> List[str]:
    """
    Extract H1 and H2 headings from Markdown content.

    Returns:
        List of heading texts (H1 and H2 only).
    """
    headings: List[str] = []
    for line in content.split("\n"):
        stripped = line.strip()
        if stripped.startswith("# "):
            headings.append(stripped[2:].strip())
        elif stripped.startswith("## "):
            headings.append(stripped[3:].strip())
    return headings


def extract_key_terms(content: str) -> List[str]:
    """
    Extract key terms from Markdown content.

    Looks for:
    - Bold/italic terms (e.g., **term**, *term*)
    - Terms in definition lists or after colons
    - Capitalized phrases that appear to be concepts

    Returns:
        List of potential key terms.
    """
    terms: List[str] = set()
    # Bold terms
    bold_pattern = r"\*\*([^*]+)\*\*"
    for match in re.finditer(bold_pattern, content):
        term = match.group(1).strip()
        if len(term) > 2 and term[0].isupper():
            terms.add(term)
    # Italic terms (less common for key terms)
    italic_pattern = r"\*([^*]+)\*"
    for match in re.finditer(italic_pattern, content):
        term = match.group(1).strip()
        if len(term) > 3 and term[0].isupper():
            terms.add(term)
    # Terms after colons (definitions)
    colon_pattern = r":\s*([A-Z][a-zA-Z\s-]+)"
    for match in re.finditer(colon_pattern, content):
        term = match.group(1).strip()
        if len(term) > 3:
            terms.add(term)
    return sorted(list(terms))


def extract_roles(content: str) -> List[str]:
    """
    Extract role names from content.

    Looks for patterns like "Role:", "Roles:", "Actor:", etc.
    """
    roles: List[str] = []
    role_patterns = [
        r"(?:Role|Roles|Actor|Actors):\s*([^\n]+)",
        r"([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)\s+\([Rr]ole\)",
    ]
    for pattern in role_patterns:
        for match in re.finditer(pattern, content, re.IGNORECASE):
            role_text = match.group(1).strip()
            # Split on commas/semicolons
            for role in re.split(r"[,;]", role_text):
                cleaned = role.strip()
                if cleaned:
                    roles.append(cleaned)
    return sorted(list(set(roles)))


def extract_processes(content: str) -> List[str]:
    """
    Extract process names or workflow steps from content.

    Looks for numbered lists, bullet lists with process-like language.
    """
    processes: List[str] = []
    # Numbered processes
    numbered_pattern = r"^\d+\.\s+([A-Z][^\n]+)"
    for match in re.finditer(numbered_pattern, content, re.MULTILINE):
        process = match.group(1).strip()
        if len(process) > 5:
            processes.append(process)
    # Bullet processes
    bullet_pattern = r"^[-*]\s+([A-Z][^\n]+)"
    for match in re.finditer(bullet_pattern, content, re.MULTILINE):
        process = match.group(1).strip()
        if len(process) > 5:
            processes.append(process)
    return processes


def extract_invariants(content: str) -> List[str]:
    """
    Extract invariants or constraints from content.

    Looks for patterns like "invariant:", "constraint:", "must:", "always:".
    """
    invariants: List[str] = []
    invariant_patterns = [
        r"(?:Invariant|Constraint|Must|Always|Never):\s*([^\n]+)",
        r"([A-Z][^\n]*\b(?:must|always|never|invariant|constraint)\b[^\n]*)",
    ]
    for pattern in invariant_patterns:
        for match in re.finditer(pattern, content, re.IGNORECASE):
            inv = match.group(1).strip()
            if len(inv) > 5:
                invariants.append(inv)
    return invariants


def extract_controls(content: str) -> List[str]:
    """
    Extract controls or policies from content.

    Looks for patterns like "control:", "policy:", "gate:", "guard:".
    """
    controls: List[str] = []
    control_patterns = [
        r"(?:Control|Policy|Gate|Guard):\s*([^\n]+)",
        r"([A-Z][^\n]*\b(?:control|policy|gate|guard)\b[^\n]*)",
    ]
    for pattern in control_patterns:
        for match in re.finditer(pattern, content, re.IGNORECASE):
            ctrl = match.group(1).strip()
            if len(ctrl) > 5:
                controls.append(ctrl)
    return controls


def extract_links(content: str) -> List[str]:
    """
    Extract Markdown links from content.

    Returns:
        List of link URLs (both [text](url) and <url> formats).
    """
    links: List[str] = []
    # Markdown link format [text](url)
    link_pattern = r"\[([^\]]+)\]\(([^)]+)\)"
    for match in re.finditer(link_pattern, content):
        url = match.group(2).strip()
        if url.startswith("./") or url.startswith("../") or not url.startswith("http"):
            links.append(url)
    # Direct URL format <url>
    url_pattern = r"<([^>]+)>"
    for match in re.finditer(url_pattern, content):
        url = match.group(1).strip()
        if not url.startswith("http"):
            links.append(url)
    return sorted(list(set(links)))


def extract_title_from_frontmatter(frontmatter: Dict[str, str]) -> Optional[str]:
    """Extract title from frontmatter."""
    return frontmatter.get("title")


def inventory_architecture_docs(
    workspace_root: str | Path, architecture_dir: str = "docs/harmony/architecture"
) -> List[FileInventoryItem]:
    """
    Build an inventory of all Markdown files under docs/harmony/architecture.

    Args:
        workspace_root: Root of the repository.
        architecture_dir: Relative path to architecture docs (default: docs/harmony/architecture).

    Returns:
        List of FileInventoryItem objects, one per Markdown file found.
    """
    root_path = Path(workspace_root)
    arch_path = root_path / architecture_dir

    if not arch_path.exists():
        return []

    inventory: List[FileInventoryItem] = []

    for md_file in sorted(arch_path.rglob("*.md")):
        relative_path = str(md_file.relative_to(root_path))
        content = md_file.read_text(encoding="utf-8")

        frontmatter, body = parse_frontmatter(content)
        title = extract_title_from_frontmatter(frontmatter) or md_file.stem

        item = FileInventoryItem(
            path=relative_path,
            title=title,
            frontmatter=frontmatter,
            headings=extract_headings(body),
            key_terms=extract_key_terms(body),
            roles=extract_roles(body),
            processes=extract_processes(body),
            invariants=extract_invariants(body),
            controls=extract_controls(body),
            links=extract_links(body),
        )

        inventory.append(item)

    return inventory

