# Source Of Truth Map

This map exists to stop the repo from solving the reviewed issues with isolated edits only. Each concern gets one durable truth surface, one main set of consumers, and one validator family.

| Concern | Current truth shape | Proposed durable truth | Primary consumers | Drift blocked |
| --- | --- | --- | --- | --- |
| Alignment profiles | Shell commands scattered in `alignment-check.sh` and workflow YAML | `/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml` plus a thin runner script | `alignment-check.sh`, `alignment-check.yml`, local validation docs, tests | old path vocabulary surviving in one entrypoint but not another |
| Authoritative Markdown | Architectural authority exists in Markdown, but workflows treat `.md` as cheap by extension | `/.octon/framework/cognition/_meta/architecture/contract-registry.yml` extended with authority-aware doc classification | `main-push-safety.yml`, doc-sensitive safety validators, future workflow filters | safety-significant docs bypassing checks |
| Dependency ecosystems | Cargo manifests live in the repo, but automated update hygiene is GitHub-Action-only | `.github/dependabot.yml` plus `.github/workflows/dependency-review.yml` | PR review, scheduled updates, release hygiene | runtime dependency drift outside the automation loop |
| GitHub Action trust refs | Workflow YAML is the only trust declaration and currently permits mutable refs | repo-owned pin policy plus `validate-github-action-pins.sh` | high-trust workflows first, then repo-wide | upstream action movement changing behavior without a repo commit |
| Runtime targets | launcher scripts and release workflow each imply support independently | `/.octon/framework/engine/runtime/release-targets.yml` | `run`, `run.cmd`, `runtime-binaries.yml`, release docs, parity validator | local-launchable and shippable targets drifting apart silently |

## Design Rule

For every concern above:

1. one durable truth surface owns the declaration
2. executable entrypoints are adapters, not second sources of truth
3. a validator fails closed when the executable view drifts from the declared view

## Expected Promotion Pattern

- declare the durable truth surface
- update the executable entrypoints to consume it or validate against it
- add a regression test or validator
- make the validator blocking once green in CI
