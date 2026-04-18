# Concept Extraction Output

## Extracted hardening concepts

### `C1` Environment-neutral worktree contract

The workflow should be expressed in standard Git/worktree/GitHub terms so it
can be executed from any worktree-capable environment.

### `C2` Explicit ready-state closeout handling

`ready_pr` is already a declared context and needs authoritative behavior,
suppression, and status responses.

### `C3` New-commit remediation policy

Review remediation should be modeled as `fix + commit + push + reply` without
amend, rebase, or force-push during ordinary review work.

### `C4` Remediation capability/tool coherence

The remediation skill must either have the safe Git authority it claims to use
or stop promising that it commits and pushes.

### `C5` Helper semantics as request surfaces

Helpers should request transitions and report state, not silently imply that
readiness or mergeability has been proven.

### `C6` Drift detection

The repo needs a validator that fails on the exact cross-surface mismatches the
audit found.
