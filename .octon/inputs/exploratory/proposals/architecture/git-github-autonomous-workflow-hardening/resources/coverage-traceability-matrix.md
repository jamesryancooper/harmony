# Coverage Traceability Matrix

| Audit finding | Packet concept | Promotion target(s) | Validation proof |
|---|---|---|---|
| `F1` stale rebase/force-push remediation guidance | `C3` New-commit remediation policy | `pull-request-standards.md`, remediation skill, safety reference | stale-string sweep and remediation scenario |
| `F2` `ready_pr` declared but not handled | `C2` Explicit ready-state closeout handling | ingress manifest, ingress `AGENTS.md` | ingress parity plus ready-state scenario matrix |
| `F3` remediation skill promises commit/push beyond allowed-tools | `C4` Remediation capability/tool coherence | remediation skill, safety reference | tool-boundary validator and remediation scenario |
| `F4` playbook overstates `git-pr-open.sh` update semantics | `C5` Helper semantics as request surfaces | playbook, workflow overview | static validator for stale wording |
| `F5` `git-pr-ship.sh` eager defaults are easy to overuse | `C5` Helper semantics as request surfaces | `git-pr-ship.sh`, workflow contract, playbook | helper CLI scenario and explicit-action assertions |
| `F6` workflow should not be Codex-only | `C1` Environment-neutral worktree contract | workflow contract, playbook, workflow overview | plain Git lane and helper-lane proof |
