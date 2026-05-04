# Route-Neutral Main Ruleset Migration Packet

## Scope

This packet prepares the live GitHub ruleset migration needed to allow hosted
`branch-no-pr` landing under Change Lifecycle Routing. It does not mutate live
GitHub settings.

Ruleset under review:

- Repository: `jamesryancooper/octon`
- Ruleset ID: `12881449`
- Current name: `Main Branch Guardrails (PR + CI + Codex)`
- Current URL: `https://github.com/jamesryancooper/octon/rules/12881449`

## Current Live Evidence

Read-only exports show live `main` is still PR-required:

- `current-rulesets.json`
- `current-main-ruleset.json`
- `current-main-effective-branch-rules.json`

Current live `main` includes:

- `pull_request` rule with squash-only merge method and review-thread resolution.
- Universal status checks:
  - `AI Review Gate / decision`
  - `enforce-ci-efficiency-policy`
  - `PR Quality Standards`
  - `Validate autonomy policy`
  - `Validate branch naming`
- Protected-main controls:
  - deletion protection
  - non-fast-forward protection
  - required linear history
  - strict required status checks

Result: hosted `branch-no-pr` landing remains blocked until the live ruleset is
changed.

## Shadow Route-Neutral Evidence

The repo-local `Change Route Projection` workflow exists on default branch and
has passing shadow evidence:

- Run: `https://github.com/jamesryancooper/octon/actions/runs/25321965548`
- Source/head SHA: `b1a972f4a8d44f7e80fcfbe428ebc9adceec1ea9`
- Evidence file: `shadow-change-route-projection-run-25321965548-jobs.json`

Observed successful job contexts:

- `exact_source_sha_validation`
- `route_aware_autonomy_validation`
- `route_neutral_closeout_validation`
- `branch_naming_validation`

## Target Fixture

Target fixture:

- `target-route-neutral-main-ruleset.put.json`

The target fixture:

- Renames the ruleset to `Main Branch Guardrails (Change Route + CI)`.
- Removes the universal `pull_request` rule from protected `main`.
- Keeps deletion protection.
- Keeps non-fast-forward protection.
- Keeps required linear history.
- Keeps strict required status checks.
- Replaces universal PR-specific checks with route-neutral checks:
  - `route_neutral_closeout_validation`
  - `branch_naming_validation`
  - `route_aware_autonomy_validation`
  - `exact_source_sha_validation`

PR-specific checks remain PR-route behavior and are not universal `main`
requirements in this target fixture:

- `AI Review Gate / decision`
- `PR Quality Standards`
- PR auto-merge
- PR clean-state checks
- PR template checks
- unresolved PR conversation checks

## Exact Diff

Review:

- `ruleset-update.diff`

Notable diff:

- Removes live `pull_request` rule.
- Removes universal PR-specific required checks from `main`.
- Adds the four route-neutral required check contexts observed in shadow mode.
- Preserves deletion, non-fast-forward, required linear history, branch target,
  enforcement, conditions, and empty bypass actors.

## Maintainer Decision Required

Before live mutation, the maintainer must explicitly accept:

- current live PR-required evidence
- passing shadow route-neutral check evidence
- target ruleset fixture
- exact diff from current update body to target fixture
- rollback fixture and rollback procedure
- first hosted `branch-no-pr` landing procedure

Open decision:

- `enforce-ci-efficiency-policy` is currently a universal live required check,
  but the repo-local target route-neutral contract names only the four
  route-neutral contexts above. Keep it excluded unless maintainers decide to
  revise the target contract and validators before live migration.

## Proposed Live Update

Do not run until maintainer acceptance.

```bash
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  repos/jamesryancooper/octon/rulesets/12881449 \
  --input .octon/state/evidence/control/execution/github-rulesets/2026-05-04-route-neutral-main-migration/target-route-neutral-main-ruleset.put.json
```

## Rollback Procedure

Rollback fixture:

- `current-main-ruleset.update-body.json`

If post-migration validation fails or hosted no-PR landing evidence cannot be
proven, restore the prior ruleset body:

```bash
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  repos/jamesryancooper/octon/rulesets/12881449 \
  --input .octon/state/evidence/control/execution/github-rulesets/2026-05-04-route-neutral-main-migration/current-main-ruleset.update-body.json
```

## Post-Migration Validation

After accepted live mutation, validate live state:

```bash
.octon/framework/assurance/runtime/_ops/scripts/validate-github-main-ruleset-alignment.sh \
  --expect target-route-neutral \
  --strict-live
```

Then dispatch route-neutral checks against an exact pushed source SHA and record
the resulting check-run refs:

```bash
gh workflow run change-route-projection.yml --ref main -f source_sha=<exact-pushed-sha>
```

## First Hosted No-PR Landing Proof

Only after strict-live target validation passes, perform one small reversible
hosted `branch-no-pr` landing and retain durable receipt evidence:

- provider ruleset ref
- pushed source branch
- exact source SHA validation refs
- `integration_method=fast-forward`
- rollback handle
- cleanup status and disposition
- `target_post_ref == landed_ref`
- `origin/main == landed_ref`

