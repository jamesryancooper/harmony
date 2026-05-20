# Orchestrated Replan Loop Post-Mortem Prompt

## Persona

Act as a principal runtime engineer and governance systems investigator for
Octon. Your job is not to explain the failure narratively; it is to identify
the exact autonomy limiters, prove them from retained lifecycle evidence, and
define the smallest credible correction set that lets the program lifecycle
continue resolving blockers until it reaches a terminal outcome.

## Objective

Run a post-mortem for the most recent `proposal-program`
`orchestrated-replan-loop` execution attempt for:

`.octon/inputs/exploratory/proposals/architecture/governed-workflow-runtime-transition-program`

Use the newest applicable program run by current repository evidence. At the
time this prompt was written, the expected latest run is:

`lifecycle-proposal-program-1779030299251-bf643b7a`

If a newer matching run exists, use the newer run and state why it supersedes
that expected run.

## Primary Question

Identify exactly what prevented the loop from running under fully governed
autonomy until program completion, including closing out every required child
proposal packet. Then define the minimum sufficient corrections needed so
future agents and lifecycle executors keep resolving blockers until the program
reaches an allowed terminal lifecycle outcome.

## Required Evidence

Read and cite the relevant retained evidence before drawing conclusions:

- `.octon/state/control/execution/runs/<program-run-id>/program-lifecycle-checkpoint.yml`
- `.octon/state/control/execution/runs/<program-run-id>/program-events.ndjson`
- `.octon/state/evidence/runs/workflows/<program-run-id>/program-events.ndjson`
- `.octon/state/evidence/runs/workflows/<program-run-id>/children/**`
- `.octon/inputs/exploratory/proposals/architecture/governed-workflow-runtime-transition-program/proposal.yml`
- `.octon/inputs/exploratory/proposals/architecture/governed-workflow-runtime-transition-program/resources/child-packet-index.yml`
- `.octon/inputs/exploratory/proposals/architecture/effect-token-enforcement-coverage/support/*.md`
- `.octon/state/evidence/validation/proposals/effect-token-enforcement-coverage/**`

Also inspect the lifecycle implementation and validator surfaces needed to
explain controller behavior, route result interpretation, retryability, and
publication-drift classification. Start with:

- `.octon/framework/engine/runtime/crates/kernel/src/lifecycle_program.rs`
- `.octon/framework/engine/runtime/crates/lifecycle_executor/src/adapter.rs`
- `.octon/framework/engine/runtime/crates/lifecycle_executor/src/codex.rs`
- `.octon/framework/assurance/runtime/_ops/scripts/validate-support-envelope-reconciliation.sh`
- `.octon/framework/assurance/runtime/_ops/scripts/validate-run-health-read-model.sh`
- `.octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh`

Do not rely on chat history, generated summaries, or assumptions when retained
control/evidence files can answer the question.

## Investigation Steps

1. Resolve the latest matching program run and record run id, target,
   lifecycle id, execution strategy, executor, approval policy, max steps,
   child concurrency, timeout, final verdict, and terminal outcome.
2. Reconstruct the event timeline from the program event logs. Include planned
   step numbers, selected children, route ids, lock release, replan points, and
   the final no-dispatch or blocked state.
3. For each dispatched child route, compare:
   - adapter route status;
   - child lifecycle status;
   - observed receipts;
   - post-attempt validation result;
   - retryability as recorded by the route adapter;
   - retryability or unsafe classification as interpreted by the program
     controller.
4. Explain the apparent contradiction, if present, between a child route that
   reports `status: completed` and the parent program result that reports the
   child as failed/retryable or the program as `blocked-unsafe`.
5. Identify every limiting factor that stopped governed autonomy. Separate
   hard blockers from contributing causes. At minimum, evaluate:
   - publication-drift recovery classification;
   - stale generated support-envelope reconciliation;
   - run-health read-model digest or canonical-reference drift;
   - child route scope boundaries;
   - whether generated-output repair was outside the child route's approved
     promotion target or write scope;
   - executor timeout behavior and whether `completed-timeout-boundary` affected
     the loop;
   - dirty worktree or unrelated retained evidence residue;
   - max-step, max-concurrency, and approval-policy effects;
   - whether the controller had a safe next recovery route and why it did or did
     not dispatch it.
6. Trace each blocker back to the concrete source of control:
   lifecycle controller logic, executor adapter behavior, route contract,
   proposal program registry, child packet receipts, validator output, or
   constitutional/governance policy.
7. Define the minimum sufficient correction set. For each correction, state:
   - the exact behavior that must change;
   - the likely file or contract family to modify;
   - why it is necessary;
   - why it is sufficient when combined with the other corrections;
   - validation required to prove it;
   - rollback or safety concern;
   - whether it is a code change, route contract change, prompt change,
     validator change, generated-publication change, or operator procedure.
8. Define what should explicitly remain out of scope.
9. End with an operator-ready remediation plan that future agents can execute
   without guessing.

## Output Format

Produce a structured post-mortem with these sections:

1. `Executive Finding`
2. `Run Identity And Evidence`
3. `Timeline`
4. `Observed Stop Condition`
5. `Root Cause`
6. `Contributing Causes`
7. `Autonomy Boundary Analysis`
8. `Minimum Sufficient Corrections`
9. `Validation Plan`
10. `Risks And Non-Goals`
11. `Next Agent Prompt`

In `Minimum Sufficient Corrections`, use a table with columns:

- `id`
- `correction`
- `evidence`
- `target surface`
- `why necessary`
- `why sufficient`
- `validation`
- `risk`

In `Next Agent Prompt`, provide a concise follow-up prompt that asks the next
agent to implement only the approved minimum correction set and then rerun the
program lifecycle loop.

## Negative Constraints

- Do not implement fixes during the post-mortem unless explicitly instructed.
- Do not stage, commit, archive, promote, close out, or delete artifacts.
- Do not treat proposal paths, generated projections, chat history, or host UI
  state as authority.
- Do not weaken validation, skip publication freshness checks, or mark child
  proposals complete by assertion.
- Do not claim that increasing `--max-steps`, `--timeout-seconds`, or
  `--max-child-concurrency` is sufficient unless evidence proves the controller
  already had a safe next route and was limited only by that bound.
- Do not conflate route executor exit status with lifecycle completion.
- Do not overwrite or revert unrelated dirty worktree changes.
- Do not broaden child packet write scopes or promotion targets without
  identifying the governing authority that permits it.

## Success Criteria

The post-mortem is successful only if it:

- identifies the exact final stop condition and cites retained evidence;
- explains why the loop did not dispatch another recovery or child route;
- distinguishes executor success, child receipt failure, controller blocker
  classification, and program terminal outcome;
- defines a correction set small enough to be implementable but complete enough
  to let future lifecycle runs continue autonomously through blockers;
- includes concrete validation commands and evidence paths for proving the
  correction;
- gives the next agent an executable prompt with no ambiguous "keep trying"
  instruction.
