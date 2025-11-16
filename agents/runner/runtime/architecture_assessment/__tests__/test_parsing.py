"""
Tests for architecture assessment parsing utilities.
"""

from pathlib import Path

import pytest

from ..parsing import (
    extract_headings,
    extract_key_terms,
    inventory_architecture_docs,
    parse_frontmatter,
)


def test_parse_frontmatter():
    """Test frontmatter parsing."""
    content = """---
title: Test Document
description: A test
---
# Content here
"""
    frontmatter, body = parse_frontmatter(content)
    assert frontmatter["title"] == "Test Document"
    assert "Content here" in body


def test_extract_headings():
    """Test heading extraction."""
    content = """# H1 Title
## H2 Section
### H3 Subsection (ignored)
## Another H2
"""
    headings = extract_headings(content)
    assert "H1 Title" in headings
    assert "H2 Section" in headings
    assert "Another H2" in headings
    assert "H3 Subsection (ignored)" not in headings


def test_extract_key_terms():
    """Test key term extraction."""
    content = """This document discusses **Harmony** and *FlowKit*.
The **Architecture Assessment** is important.
"""
    terms = extract_key_terms(content)
    assert "Harmony" in terms
    assert "Architecture Assessment" in terms


def test_inventory_architecture_docs(tmp_path: Path):
    """Test inventory building."""
    # Create a temporary architecture directory structure
    arch_dir = tmp_path / "docs" / "harmony" / "architecture"
    arch_dir.mkdir(parents=True)

    # Create a test markdown file
    test_file = arch_dir / "test.md"
    test_file.write_text(
        """---
title: Test Architecture Doc
---
# Test Document
## Section One
**KeyTerm**: Definition here
"""
    )

    inventory = inventory_architecture_docs(tmp_path, "docs/harmony/architecture")
    assert len(inventory) == 1
    assert inventory[0].path == "docs/harmony/architecture/test.md"
    assert inventory[0].title == "Test Architecture Doc"
    assert "Test Document" in inventory[0].headings
    assert "Section One" in inventory[0].headings

