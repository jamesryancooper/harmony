# Concept Coverage Matrix

| Concept | Current coverage | Packet action | Primary promotion target(s) | Validation focus |
|---|---|---|---|---|
| Environment-neutral worktree operating model | mostly covered in prose | preserve and make contract-backed | `/.octon/framework/agency/practices/standards/git-worktree-autonomy-contract.yml`, `git-autonomy-playbook.md`, `git-github-autonomy-workflow-v1.md` | plain Git lane and helper lane scenario parity |
| Explicit `ready_pr` closeout handling | partially covered | harden | `/.octon/instance/ingress/manifest.yml`, `/.octon/instance/ingress/AGENTS.md` | ingress parity plus ready-state scenario matrix |
| Author-side remediation history policy | partially covered and internally inconsistent | harden | `pull-request-standards.md`, remediation skill, remediation safety reference | stale-string sweep plus remediation execution scenario |
| Safe remediation tool boundary | under-specified | harden | remediation skill + safety reference | tool-permission and prose coherence check |
| Helper semantics are request-only, not proof of readiness | partially covered | harden | `git-pr-ship.sh`, workflow contract, playbook, workflow overview | explicit-action CLI tests and doc alignment |
| GitHub remains final merge gate | correctly covered | preserve | existing GitHub control-plane contract plus aligned docs | no helper or label path may mint merge authority |
| Reviewer-owned thread resolution | correctly covered in newer surfaces | preserve and remove stale drift | ingress/docs/skill + companion PR template | reviewer-thread scenario coverage |
| Drift detection for workflow surfaces | weak | add | new workflow contract + validator script/test | fail-closed alignment check |
