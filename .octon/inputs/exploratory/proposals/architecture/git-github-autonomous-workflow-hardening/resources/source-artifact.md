# Source Artifact Register

## Source metadata

- **Title:** Git + GitHub Autonomous Workflow Audit
- **Author:** user-provided audit artifact
- **Date:** 2026-04-17
- **Type:** repository-grounded architecture/workflow audit
- **Source delivery:** user-provided in prompt context
- **Full preserved artifact:** `resources/source-audit.md`

## Source claims retained in this packet

- the current workflow shape is mostly correct but not honestly complete
- hardening is required at the authoritative layer, not only in helper prose
- the target workflow must stay worktree-native and portable across any
  worktree-capable environment
- review remediation should be `fix + commit + push + reply`, while
  reviewer-owned thread resolution stays with reviewer or maintainer
- GitHub rulesets and required checks remain the final merge authority

## Source claims explicitly not promoted

- any Codex-app-only interpretation of the workflow
- replacing GitHub with a host-agnostic merge authority in this packet
- creating a new control plane from labels, helper output, or generated
  summaries
