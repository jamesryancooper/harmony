# Acceptance Criteria

## Packet-level criteria

- `AC-01` A canonical workflow contract exists under
  `/.octon/framework/agency/practices/standards/` and defines the workflow in
  standard Git/worktree/GitHub terms rather than in host-app-specific terms.
- `AC-02` The hardened workflow remains valid for any environment that supports
  linked worktrees and GitHub PR operations; validation proves both plain Git
  and helper-lane execution.
- `AC-03` GitHub remains the final merge authority through rulesets, checks,
  and reviewer or maintainer confirmation; no helper or label path mints
  independent merge authority.

## Closeout criteria

- `AC-04` `/.octon/instance/ingress/manifest.yml` explicitly handles
  `ready_pr`.
- `AC-05` Ingress `AGENTS.md` remains in parity with the manifest for all
  closeout contexts.
- `AC-06` Ready PR states report status instead of asking another closeout
  question.

## Remediation criteria

- `AC-07` No authoritative or supporting workflow surface instructs rebase,
  amend, or force-push during ordinary review remediation.
- `AC-08` The remediation skill's promised behavior matches its allowed-tools
  boundary.
- `AC-09` Reviewer-owned threads are never resolved programmatically by the
  author-side remediation path.

## Helper criteria

- `AC-10` `git-pr-open.sh` is documented as a create-oriented helper; later PR
  updates are described as push-to-same-branch behavior.
- `AC-11` `git-pr-ship.sh` exposes a non-mutating status mode and requires
  explicit action flags for ready or auto-merge requests.
- `AC-12` Helper output explicitly states that GitHub remains the final merge
  gate.

## Validation criteria

- `AC-13` A dedicated workflow-alignment validator exists and passes.
- `AC-14` The validator fails on the exact drift classes identified in the
  audit.
- `AC-15` Companion `.github/**` surfaces are aligned in the same branch as the
  durable `.octon/**` changes.
