---
title: Closeout Change I/O Contract
---

# I/O Contract

Inputs:

- Optional `change_id`
- Optional `route`
- Optional `lifecycle_outcome`
- Optional `include_paths`
- Optional `exclude_paths`
- Optional `receipt_ref`

Outputs:

- Change closeout report under
  `/.octon/state/evidence/validation/analysis/{{date}}-change-closeout-{{run_id}}.md`
- Skill execution log under
  `/.octon/state/evidence/runs/skills/closeout-change/{{run_id}}.md`
- Change receipt conforming to
  `.octon/framework/product/contracts/change-receipt-v1.schema.json`

Receipt outputs must record selected route, lifecycle outcome, integration
status, publication status, cleanup status, durable history, rollback handle,
and cleanup evidence or deferred-cleanup evidence when cleanup is claimed.
