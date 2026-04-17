# Rejection Ledger

| Rejected move | Why it is rejected here |
|---|---|
| Codex-app-specific workflow rules | user explicitly required an environment-neutral, worktree-capable workflow |
| Replace GitHub as the merge host | outside the scope of the audit and the current repo architecture |
| Create a new authority layer outside existing ingress/practice/capability families | unnecessary for the defects identified |
| Keep helper defaults eager and rely only on better documentation | the audit already showed that prose-only hardening is not enough |
| Preserve force-push or rebase as ordinary remediation guidance | conflicts with reviewer-owned thread confirmation and branch-local evidence |
| Treat labels, comments, or helper output as merge authority | conflicts with the constitutional and GitHub control-plane model already in place |
