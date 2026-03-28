# Instance Ingress

This is the canonical internal ingress surface for this repository's
super-rooted Octon harness.

## Behavioral Contract

- default agent: `.octon/framework/agency/manifest.yml`
- constitutional charter: `.octon/framework/constitution/CHARTER.md`
- constitutional manifest: `.octon/framework/constitution/charter.yml`
- normative precedence: `.octon/framework/constitution/precedence/normative.yml`
- epistemic precedence: `.octon/framework/constitution/precedence/epistemic.yml`
- fail-closed obligations: `.octon/framework/constitution/obligations/fail-closed.yml`
- evidence obligations: `.octon/framework/constitution/obligations/evidence.yml`
- ownership roles: `.octon/framework/constitution/ownership/roles.yml`
- constitutional contract registry:
  `.octon/framework/constitution/contracts/registry.yml`
- agency constitutional application:
  `.octon/framework/agency/governance/CONSTITUTION.md`
- delegation: `.octon/framework/agency/governance/DELEGATION.md`
- memory: `.octon/framework/agency/governance/MEMORY.md`
- subordinate execution profile:
  `.octon/framework/agency/runtime/agents/orchestrator/AGENT.md`
- objective brief: `.octon/instance/bootstrap/OBJECTIVE.md`
- active intent contract:
  `.octon/instance/cognition/context/shared/intent.contract.yml`

## Read Order

1. `.octon/framework/constitution/CHARTER.md`
2. `.octon/framework/constitution/obligations/fail-closed.yml`
3. `.octon/framework/constitution/precedence/normative.yml`
4. `.octon/framework/constitution/precedence/epistemic.yml`
5. `.octon/instance/bootstrap/START.md`
6. `.octon/instance/bootstrap/scope.md`
7. `.octon/instance/bootstrap/conventions.md`
8. `.octon/instance/bootstrap/catalog.md`
9. `.octon/framework/cognition/_meta/architecture/specification.md`
10. `.octon/framework/cognition/governance/principles/README.md`
11. `.octon/state/continuity/repo/log.md`
12. `.octon/state/continuity/repo/tasks.json`
13. `.octon/state/continuity/scopes/<scope-id>/{log.md,tasks.json}` when the
   current work is primarily owned by a declared scope

## Super-Root Topology

- `framework/` holds portable authored Octon core.
- `instance/` holds repo-specific durable authored authority.
- `inputs/` holds non-authoritative additive and exploratory inputs.
- `state/` holds operational truth and retained evidence.
- `generated/` holds rebuildable outputs only.

Only `framework/**` and `instance/**` are authored authority surfaces. Raw
`inputs/**` must never become direct runtime or policy dependencies.
`framework/constitution/**` is the supreme repo-local control regime within
those authored authority surfaces.

## Human-Led Zone

`/.octon/inputs/exploratory/ideation/**` is human-led. Autonomous access is
blocked unless a human explicitly scopes the request.

## Execution Profile Governance

Before planning or implementation:

1. select exactly one `change_profile`
2. record `release_state`
3. emit a `Profile Selection Receipt`

For this repository, `pre-1.0` defaults to `atomic` unless a hard gate requires
`transitional`.

## Branch Closeout Gate

After any turn that changes files, ask exactly:

`Are you ready to closeout this branch?`
