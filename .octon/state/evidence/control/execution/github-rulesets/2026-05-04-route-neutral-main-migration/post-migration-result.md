# Post-Migration Result

## Live Update

Applied accepted route-neutral main ruleset fixture on 2026-05-04.

- Repository: `jamesryancooper/octon`
- Ruleset ID: `12881449`
- Updated name: `Main Branch Guardrails (Change Route + CI)`
- Live ruleset URL: `https://github.com/jamesryancooper/octon/rules/12881449`
- Target fixture: `target-route-neutral-main-ruleset.put.json`
- Rollback fixture: `current-main-ruleset.update-body.json`

The applied live ruleset removes universal PR-required merging for `main` and
keeps:

- deletion protection
- non-fast-forward protection
- required linear history
- strict required status checks

Universal `main` checks after migration:

- `route_neutral_closeout_validation`
- `branch_naming_validation`
- `route_aware_autonomy_validation`
- `exact_source_sha_validation`

PR-specific checks remain scoped to `branch-pr` behavior and are not universal
`main` requirements.

## Durable Evidence

- Pre-migration ruleset export: `current-main-ruleset.json`
- Pre-migration effective branch rules: `current-main-effective-branch-rules.json`
- Exact reviewed update diff: `ruleset-update.diff`
- Post-migration ruleset export: `post-migration-main-ruleset.json`
- Post-migration effective branch rules: `post-migration-main-effective-branch-rules.json`
- Shadow workflow job evidence:
  `shadow-change-route-projection-run-25321965548-jobs.json`

## Validation

Passed:

```bash
.octon/framework/assurance/runtime/_ops/scripts/validate-github-main-ruleset-alignment.sh --strict-live
.octon/framework/assurance/runtime/_ops/scripts/validate-github-main-ruleset-alignment.sh --expect target-route-neutral --ruleset-json .octon/state/evidence/control/execution/github-rulesets/2026-05-04-route-neutral-main-migration/post-migration-main-effective-branch-rules.json
.octon/framework/assurance/runtime/_ops/scripts/validate-github-projection-alignment.sh
.octon/framework/assurance/runtime/_ops/scripts/validate-default-work-unit-alignment.sh
```

## Remaining Proof

Hosted `branch-no-pr` landing is now no longer blocked by a universal PR rule,
but the model still requires one small reversible hosted no-PR landing proof
before proposal closeout:

- pushed source branch
- exact source SHA validation refs
- provider ruleset ref
- fast-forward integration
- rollback handle
- cleanup disposition
- `target_post_ref == landed_ref`
- `origin/main == landed_ref`

