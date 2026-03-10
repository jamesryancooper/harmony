---
title: Verify Workflow Creation
description: Verify the canonical workflow and generated README.
---

# Step 8: Verify Workflow Creation

## Purpose

Creation is complete only when the canonical workflow validates and its guide is
in sync.

## Verification Checklist

- [ ] Canonical workflow directory exists
- [ ] `workflow.yml` declares the required contract fields
- [ ] All declared stage assets exist
- [ ] Workflow manifest and registry entries are present
- [ ] Generated README exists under `guide/`
- [ ] No live asset references temporary design-package content
- [ ] `validate-workflows.sh` passes

## Output

- `PASSED` when the canonical workflow and guide are aligned
- `FAILED` with explicit remediation targets otherwise
