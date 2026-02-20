---
title: Clean-Break Migration Plan Template
description: Template for planning and verifying clean-break migrations with explicit removal and CI regression controls.
---

# Clean-Break Migration Plan (Template)

Copy this into `migrations/<YYYY-MM-DD>-<slug>/plan.md`.

## 1) Summary

- Name:
- Owner:
- Motivation:
- Scope:

## 2) What Is Being Removed (Explicit)

List the legacy SSOT, interfaces, schemas, paths, commands, config keys, and behavior.

## 3) What Is the New SSOT (Explicit)

Define where the new authority lives and what the new interfaces or contracts are.

## 4) Clean-Break Constraints (Affirm)

- [ ] No dual-mode execution
- [ ] No compatibility shims or adapters
- [ ] No transitional flags
- [ ] Legacy removed in the same change set

## 5) Removal Plan (MUST Be Concrete)

### Code

- Delete:
- Replace call-sites:
- Remove routing:

### Contracts

- Remove legacy schema or manifest keys:
- Add or adjust new schema or manifest keys:

### Docs

- Remove legacy docs:
- Update references:

### Tests

- Delete legacy tests:
- Add or adjust tests for new SSOT:

## 6) Replacement Plan

- New components or files:
- New entrypoints:
- New reason codes or enums (if applicable):

## 7) Verification (MUST)

### A) Static Verification

- [ ] No legacy identifiers remain (list searched patterns)
- [ ] No legacy paths remain

### B) Runtime Verification

- [ ] New path exercised end-to-end
- [ ] Old path is impossible (assertions or removed entrypoints)

### C) CI Verification

- [ ] CI gates updated or added to prevent legacy reintroduction

## 8) Definition of Done (MUST)

- [ ] Single authority only
- [ ] Legacy deleted (code, docs, contracts, tests)
- [ ] All call-sites updated
- [ ] CI gates pass
- [ ] Plan links to evidence (logs, test output, receipts)

## 9) Rollback

Clean-break rollback strategy (for example, revert commits or re-tag). No partial rollback modes.

