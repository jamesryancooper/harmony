# Validation Plan

## Structural validation

Required checks:

- Proposal package path matches `/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`.
- `proposal.yml` has valid proposal id, kind, status, lifecycle, scope, and all promotion targets are under `.octon/`.
- Exactly one subtype manifest exists: `architecture-proposal.yml`.
- `navigation/source-of-truth-map.md` and `navigation/artifact-catalog.md` exist.
- `PACKET_MANIFEST.md` and `SHA256SUMS.txt` match on-disk contents.
- All new schemas parse and are registered where required.
- Overlay registry, instance manifest, and README overlay description agree.
- Support-target file is valid against support-target schema.
- Cognition runtime index matches actual implemented runtime surfaces.

## Governance validation

Required checks:

- No durable target reads proposal paths as authority.
- No raw `inputs/**` path is a runtime or policy dependency.
- No `generated/**` path is treated as authority, approval, policy, or support truth.
- All material action classes route through `authorize_execution`.
- Risk/materiality classification is present for material actions.
- Support-target tuple admission exists before live support claim.
- Capability packs agree with support targets and exclusions.
- Browser/API actions fail closed unless authority route, runtime service, replay evidence, and support dossier are present.

## Runtime validation

Required checks:

- Run control root exists before side effects.
- Run evidence root exists before side effects.
- Execution requests bind context pack, materiality, requested capabilities, side effects, and rollback posture where required.
- Grants contain decision, reason codes, scope constraints, granted capabilities, policy mode, receipt requirements, and evidence obligations.
- Receipts exist for every material attempt, including denials and escalations.
- Replay pointers and trace pointers are retained.
- Rollback/compensation handles are present when required.
- Control directives, leases, and circuit breakers are exercised and evidenced.

## Support-target validation

Required checks:

- Support mode vocabulary is schema-valid.
- Broad support classes do not imply support without tuple admission.
- Every live tuple has admission ref and support dossier ref.
- Every support dossier has required evidence, conformance criteria, and disclosure coverage.
- Adapters do not claim unsupported tiers.
- Experimental adapters remain quarantined/stage-only.
- Generated support matrix is freshness-checked and non-authoritative.

## Behavior validation

Required scenario suites:

1. Observe-and-read reference-owned English repo-shell run.
2. Repo-consequential English repo-shell mutation with rollback posture.
3. Support denial for unsupported tuple.
4. Stale generated cognition rejected as authority.
5. Context pack with generated summaries used only as derived input.
6. Workflow categorized as thinking-only and demoted without breaking governance path.
7. Optional verifier activated only for materiality/separation-of-duties trigger.

## Recovery validation

Required drills:

- Mid-run tool failure.
- Repo mutation rollback.
- API partial failure compensation.
- Browser pre-submit pause/intervention.
- Human directive pause/narrow/revoke/safing.
- Circuit breaker trip/reset.
- Mission pause/resume with continuity handoff.
- Stale context-pack rejection and rebuild.

## Evidence validation

Required checks:

- Evidence classification is complete.
- RunCard generated from receipts/traces/replay/checkpoints/context-pack/rollback evidence.
- HarnessCard generated from support dossier/lab/benchmark evidence.
- Disclosure artifacts include capability pack set and support tuple.
- Evidence roots are retained under `state/evidence/**`, not `generated/**`.
- Validation receipts are retained under `state/evidence/validation/**`.

## Comparative benchmark validation

Compare the same tasks across:

1. Raw frontier model with same allowed repo context.
2. Raw frontier model plus thin tool wrapper.
3. Octon-governed execution with one orchestrator.
4. Octon-governed execution with optional verifier.
5. Degraded/local model profile.

Metrics:

- Task success.
- Unauthorized action prevention.
- False block/false escalation rate.
- Evidence completeness.
- Replayability.
- Rollback/compensation success.
- Intervention latency and safe-boundary quality.
- Cost, wall-clock time, and token/tool budget usage.
- Support-claim correctness.
- Disclosure quality.

## Closure certification

Certification requires:

- all P0/P1 validators pass;
- accepted support claims are dossier-backed;
- reference runs produce complete RunCards;
- support tuple HarnessCard exists for at least the retained reference tuple;
- browser/API claims are either stage-only or fully proof-backed;
- no durable promoted file references this proposal path as authority.
