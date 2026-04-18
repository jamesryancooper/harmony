# Cutover Checklist

- [ ] Workflow contract added under `/.octon/framework/agency/practices/standards/`
- [ ] Ingress manifest encodes explicit `ready_pr` handling
- [ ] Ingress `AGENTS.md` mirrors the same closeout states
- [ ] `pull-request-standards.md` no longer instructs history rewrite during remediation
- [ ] Remediation skill and safety reference agree with their allowed-tools boundary
- [ ] `git-pr-ship.sh` is status-first and explicit-action
- [ ] Playbook no longer claims `git-pr-open.sh` updates existing PRs
- [ ] Overview doc matches the hardened contract
- [ ] `.github/PULL_REQUEST_TEMPLATE.md` reflects reviewer-owned thread semantics
- [ ] Workflow-alignment validator added
- [ ] Validator tests added
- [ ] Plain Git lane scenario proof captured
- [ ] Helper-lane scenario proof captured
- [ ] Multi-worktree cleanup scenario rechecked
- [ ] Final drift sweep finds no stale `rebase and force-push cleanup` wording
