# Self-Audit And Release Hardening Cutover Evidence (2026-03-23)

## Scope

Single-promotion atomic migration implementing
`self-audit-and-release-hardening`:

- add a machine-readable alignment profile registry and thin-runner validation
- classify authoritative Markdown changes explicitly for main-push safety
- extend dependency hygiene to the runtime Cargo workspace and add PR-time
  dependency review
- pin Tier 1 GitHub workflows to immutable third-party Action SHAs
- declare one canonical runtime target matrix and enforce strict packaging mode
- archive the implemented proposal package and refresh proposal discovery

## Cutover Assertions

- Alignment profile ids, labels, entrypoints, required paths, and CI/local
  usage now terminate at `alignment-profiles.yml`.
- `main-push-safety.yml` no longer hides authoritative docs behind a blanket
  Markdown ignore and now classifies changed files through the contract
  registry.
- Tier 1 workflows now use immutable third-party Action SHAs and are enforced
  by a repo-owned validator.
- Dependabot and PR dependency review now cover the runtime Cargo workspace in
  addition to GitHub Actions.
- `release-targets.yml` now drives launcher expectations and release artifact
  planning for five shipped runtime targets with strict packaging mode support.
- The harness alignment gate passed after an elevated host-projection refresh
  resolved the sandbox-only `.codex/**` projection failure mode.

## Receipts And Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/062-self-audit-and-release-hardening-atomic-cutover.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-23-self-audit-and-release-hardening-cutover/plan.md`
- Archived proposal package:
  `/.octon/inputs/exploratory/proposals/.archive/architecture/self-audit-and-release-hardening/`
