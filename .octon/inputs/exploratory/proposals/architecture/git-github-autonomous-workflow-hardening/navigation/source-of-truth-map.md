# Source of Truth Map

## Canonical authority hierarchy used by this packet

| Layer | Role | Current source(s) | Why it matters here |
|---|---|---|---|
| Constitutional kernel | Supreme repo-local control regime | `/.octon/framework/constitution/**` | Prevents the packet from inventing a second control plane or tool-specific authority |
| Workspace charter pair | Repo-wide objective layer | `/.octon/instance/charter/workspace.md`, `workspace.yml` | Confirms this hardening stays repo-local, pre-1.0, and atomic by default |
| Ingress contract | Canonical closeout and read-order contract | `/.octon/instance/ingress/manifest.yml`, `/.octon/instance/ingress/AGENTS.md` | Holds the current `branch_closeout_gate` and the missing `ready_pr` semantics |
| Practice standards | Human-readable workflow and remediation policy | `/.octon/framework/agency/practices/{git-autonomy-playbook.md,git-github-autonomy-workflow-v1.md,pull-request-standards.md,commits.md}` | These are the main surfaces currently drifting from one another |
| Machine-readable workflow standards | Stable contract layer to add in this packet | `/.octon/framework/agency/practices/standards/git-worktree-autonomy-contract.yml` (proposed) | Gives the workflow one durable contract that validators can check |
| GitHub control-plane contract | Merge-critical GitHub settings and checks | `/.octon/framework/agency/practices/standards/github-control-plane-contract.json` | Confirms GitHub stays the final merge authority rather than local helpers |
| Remediation capability boundary | Author-side review-fix execution contract | `/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/**` | This is the main source of commit/push/tool-boundary incoherence today |
| Local helper scripts | Optional execution accelerators | `/.octon/framework/agency/_ops/scripts/git/{git-wt-new.sh,git-pr-open.sh,git-pr-ship.sh,git-pr-cleanup.sh}` | Helpers must remain projections of the durable workflow, not its only valid expression |
| GitHub repo-local projections | Host-specific enforcement and operator prompts | `.github/PULL_REQUEST_TEMPLATE.md`, `.github/workflows/**` | These must mirror the durable contract in the same branch, but do not become the sole source of truth |
| Historical lineage | Prior normalization packet already implemented | `/.octon/inputs/exploratory/proposals/.archive/architecture/git-github-workflow/` | This packet is a hardening follow-up, not a repeat of the earlier normalization work |
| Source input | User-provided audit preserved as a proposal artifact | `resources/source-artifact.md`, `resources/source-audit.md` | Grounds the packet in the exact audit findings rather than informal paraphrase |

## Same-branch companion alignment surfaces

These surfaces are not manifest promotion targets because the proposal stays
`octon-internal`, but they must still align in the implementation branch.

| Path | Role in the hardening |
|---|---|
| `.github/PULL_REQUEST_TEMPLATE.md` | Reviewer-thread and author-action wording must match the hardened remediation policy |
| `.github/workflows/pr-quality.yml` | Should keep PR body expectations aligned with hardened workflow receipts |
| `.github/workflows/pr-autonomy-policy.yml` | Must remain consistent with autonomous vs manual lane semantics |
| `.github/workflows/pr-auto-merge.yml` | Must continue to treat GitHub as the final merge authority while consuming the hardened ready-state semantics |
| `.github/workflows/commit-and-branch-standards.yml` | Must not encourage history-rewrite behavior that the remediation policy forbids |

## Non-authoritative surfaces explicitly excluded from promotion targets

- `inputs/**` except this packet itself
- `generated/**` except the proposal registry projection refreshed by the
  canonical generator
- labels, comments, and UI host state
- app-specific behaviors or assistant-specific closeout phrasing that do not
  survive outside one host environment
