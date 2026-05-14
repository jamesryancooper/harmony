# Lifecycle Model

## Packet State Machine

```text
source-context
  -> packet-created
  -> packet-validated
  -> proposal-review
  -> revision-needed
  -> revised
  -> proposal-review
  -> accepted
  -> implementation-prompt-generated
  -> implementation-run
  -> implemented
  -> verification-prompt-generated
  -> verified
  -> corrections-needed
  -> corrected
  -> clean
  -> closeout-prompt-generated
  -> closeout-ready
  -> archived
```

Fail-closed or pause report outcomes:

- `blocked`
- `needs-packet-revision`
- `superseded`
- `explicitly-deferred`

Routes must refuse jumps that skip required packet validation, implementation
grounding, proposal review, revision, verification, correction, or closeout
gates. `blocked`,
`needs-packet-revision`, `superseded`, and `explicitly-deferred` are reported
outcomes for a lifecycle gate or route decision; they are not additional
proposal statuses.

## Execution Strategies

Lifecycle identity names the lifecycle contract, route contracts name the
eligible route surfaces, and `execution_strategy` names the runner shape. The
proposal packet lifecycle declares `route-progression`: one target plans the
next selected route, optionally dispatches it through the lifecycle executor
adapter, and replans from packet-owned manifests and receipts. The proposal
program lifecycle declares `orchestrated-replan-loop`: one parent orchestration
target repeatedly plans from live state, dispatches one selected parent route
or runnable child batch, replans from child-owned manifests and receipts, and
stops only at terminal, blocked, approval-paused, failure, cancellation, or
max-step exhaustion states.

`loops:` remains packet receipt-loop policy inside route progression.
`program.supported_execution_modes` remains program scheduler policy for child
batch selection. Neither field is interchangeable with `execution_strategy`.

Proposal review and revision are receipt-driven loops, not extra manifest
statuses. `support/proposal-review.md` records `accepted`,
`revision-required`, or `rejected`; `support/revisions/<revision-id>.md`
records packet-local revision passes. Implementation prompt generation,
implementation execution, and promotion require a fresh accepted review receipt
validated with strict implementation authorization.

Later lifecycle handoffs are also receipt-driven.
`run-packet-implementation` writes `support/implementation-run.md` and leaves
`proposal.yml#status` as `accepted`; `promote-proposal` consumes that receipt
and owns the rewrite to `implemented`. `closeout-packet` writes
`support/proposal-closeout.md`; `archive-proposal` consumes that receipt and
owns archival.

The generic lifecycle runner owns orchestration, gate evaluation, stale receipt
detection, loop bounds, evidence, checkpoints, and resume. By default, it stops
at a gated `route-ready` handoff. When invoked with `--execute-routes`, it
delegates selected routes to the shared lifecycle executor adapter, which owns
`mock`, `auto`, `codex`, and `claude` route execution outside the lifecycle
runner. Durable routes declare approval metadata in the lifecycle contract and
pause for explicit, resumable approval by default. `--approval-policy
unattended` is an explicit operator override for one-run automation; the adapter
records approval override evidence before executing an approval-gated route
under that policy. Non-execute handoffs do not consume loop iterations; executed
routes do consume bounded loop attempts.

Lifecycle stop evidence uses a shared vocabulary across packet and program
runs: planned handoff, adapter-dispatched route or child batch, terminal
completion, `blocked-human`, `blocked-recoverable`, `blocked-unsafe`,
`blocked-max-steps`, `failed`, `timed-out`, and `cancelled`. Packet
route-progression writes hash-chained `lifecycle-events.ndjson` traces;
program orchestration keeps its hash-chained `program-events.ndjson` replay
log. These traces improve observability but do not replace checkpoints,
manifests, receipts, promotion evidence, or closeout evidence.

Cancellation is a durable lifecycle stop condition. `octon lifecycle cancel
--run-id <run> --reason <text>` writes a retained cancellation marker and
updates the checkpoint to `final_verdict: cancelled`; `octon lifecycle program
cancel` remains a compatibility alias. Resume, retry, and execute-routes
checks must return `cancelled` with `route_execution_mode: none` once the
marker exists. Program child approval pauses should route operators through
program approval controls while preserving adapter-level approval enforcement
and explicit override evidence.

## Completion Invariants

- A route may complete only from route-specific evidence: expected receipt
  completeness, expected path existence, expected manifest status, target
  digest change, terminal outcome, or an explicit idempotent no-op.
- Existing unrelated receipts never satisfy route completion.
- Durable repository mutation must be approval-gated by default or explicitly
  authorized by a tested lifecycle contract exception. Unattended execution is
  recorded as an operator override, not as implicit durable authority.
- Stale or incomplete receipts must not unlock implementation, promotion,
  closeout, archive, or terminal success.
- Landing blockers are confined to concrete failures that can cause unsafe
  mutation, stale or incomplete evidence to unlock progress, runtime discovery
  from non-authoritative sources, route execution or resume corruption, failed
  required validation, or breach of the runner/adapter boundary.
- Deferred work is limited to improvements outside those blocker classes, such
  as richer diagnostics, live provider smoke tests, multi-target programs, and
  broader UX polish.

## Program State Machine

```text
program-source-context
  -> program-created
  -> program-review
  -> program-revision-needed
  -> program-revised
  -> program-review
  -> program-accepted
  -> child-packets-planned
  -> child-packets-created
  -> child-packets-validated
  -> program-implementation-prompt-generated
  -> children-implemented
  -> program-verification-prompt-generated
  -> program-verified
  -> child-corrections-needed
  -> child-corrections-resolved
  -> program-closeout-prompt-generated
  -> program-closeout-ready
  -> children-closed
  -> program-archived
```

Program routes coordinate child packets. They do not own child lifecycle truth,
child subtype manifest truth, child promotion targets, child validation
verdicts, or child archive metadata.

The generic program lifecycle runner follows the same executor boundary as the
packet runner. By default, `octon lifecycle run --lifecycle proposal-program`
plans the next runnable parent or child route, writes evidence and a checkpoint,
and stops at `program-route-handoff`. It does not execute child implementation.
When invoked with `--execute-routes`, it runs a bounded plan-execute-replan
loop: plan from live repository state, dispatch one selected parent route or
one runnable child batch through the shared lifecycle executor adapter, replan
from child-owned manifests and receipts, and continue until terminal
completion, blocked state, approval pause, failure, timeout, cancellation, or
max-step exhaustion. `--max-steps` counts adapter dispatch attempts, not pure
planning; one child batch is one step regardless of
`--max-child-concurrency`.

Parent program review and revision are receipt-driven loops, not extra
manifest statuses. `support/proposal-review.md` records `accepted`,
`revision-required`, or `rejected`; `support/revisions/<revision-id>.md`
records parent-local coordination revisions. The review may update only the
parent manifest status to `accepted`, `rejected`, or `in-review`; revision may
change only parent-local coordination files and must route back to
`review-program`.

Program implementation prompt generation requires a fresh accepted parent
review receipt validated by `validate-proposal-review-gate.sh`. It also has a
separate child-readiness gate. For every required, non-deferred child, the
child-readiness gate requires required child metadata including
`change_profile`, a passing implementation-grade completeness review, an
accepted fresh proposal-review digest, declared packet-specific completeness
coverage, coherent predecessor/successor constraints, and satisfied declared
cutover constraints. The child-readiness gate authorizes prompt generation
only; it does not prove durable implementation has completed.

Parent program promotion and archival use the existing `promote-proposal` and
`archive-proposal` workflow ids. Promotion is allowed only after an accepted
fresh parent review, generated program implementation prompt, and parent-local
`support/implementation-run.md` with `verdict: pass` and
`child_authority_preserved: yes`. Archival is allowed only after parent
`implemented` status and parent-local `support/proposal-closeout.md` with
`verdict: pass`, `archive_authorized: yes`, and
`child_authority_preserved: yes`.

Program controller runs also retain a parent-owned execution record: a
hash-chained v2 event log, checkpoint, scheduler decision, recovery evidence,
optional mutation evidence, optional scaffold evidence, and aggregate closeout
receipt. These surfaces coordinate and explain the parent program only. They do
not satisfy child receipts or rewrite child lifecycle authority.

Program approval grants are parent-run control evidence. A grant only unblocks
the named child route in that program run; route execution records
`program-approved` approval evidence before proceeding, and child receipts
remain child-owned. Recovery recipes are bounded by blocker class, retry budget,
preconditions, post-attempt validation, and live replanning. `unsafe-resume` and
`authority-boundary-ambiguous` remain fail-closed.

`program-atomic` is explicit opt-in and means staged barrier coordination with
declared stage, commit, rollback, or compensation routes. It is not universal
transactionality. Interrupted barriers are resumed from the event log; ambiguous
committed state or missing compensation fails closed as `blocked-unsafe`.
