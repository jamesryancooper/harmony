# Octon Proposal Lifecycle

First-party additive extension pack for proposal lifecycle automation across
proposal packets and proposal programs.

This pack composes existing Octon proposal standards, proposal workflows,
concept-integration routes, impact-map routing, validators, publication
scripts, and host projection publishing into a governed operator flow. Packet
actions operate on one proposal packet. Program actions coordinate a parent
proposal program while preserving child packet authority.

## Scope

The pack owns reusable routes for:

- creating proposal packets from source context,
- explaining existing proposal packets,
- reviewing proposal packets with receipt-only verdict state,
- revising proposal packets through packet-local revision receipts,
- generating packet implementation, verification, correction, and closeout
  prompts,
- running packet verification and correction convergence loops,
- closing out individual proposal packets,
- creating, explaining, reviewing, revising, and operating proposal programs
  across canonical child packets,
- generating program implementation, verification, correction, and closeout
  prompts for parent-owned coordination surfaces.

## Authority Boundary

This pack is additive source. Runtime-facing discovery uses generated effective
extension and capability outputs after publication. Raw pack files, prompts,
generated support artifacts, proposal packets, generated proposal registries,
GitHub comments, labels, checks, chat history, browser state, tool
availability, and model memory do not become Octon authority, control truth,
runtime policy, or permission.

Proposal packet lifecycle authority remains local to each packet's
`proposal.yml`, subtype manifest, proposal standards, validators, declared
promotion targets, and retained evidence. This pack may generate support
artifacts and route lifecycle work; it may not replace the proposal system.

Proposal program authority is parent-owned coordination truth. Program routes
may sequence, gate, summarize, and close out parent coordination evidence, but
they do not satisfy child packet receipts, rewrite child manifests, or own
child promotion, validation, or archive truth.

## Entry Points

The composite command and skill are:

- `/octon-proposal`
- `octon-proposal-lifecycle`

Leaf routes are listed in `context/bundle-matrix.md` and governed by
`context/routing.contract.yml`.

## Naming Scheme

- Pack ID: `octon-proposal-lifecycle`.
- Composite command: `octon-proposal`.
- Route IDs use packet/program-qualified action names, for example
  `create-packet`, `review-program`, `generate-packet-implementation-prompt`,
  or `run-program-verification-and-correction-loop`.
- Leaf command IDs use `octon-proposal-<route-id>`.
- Skill and prompt set IDs use `octon-proposal-lifecycle-<route-id>`.
- Human labels use `Octon Proposal Lifecycle: <Action> Packet` or
  `Octon Proposal Lifecycle: <Action> Program`.

`/octon-proposal-run-packet-lifecycle` uses the shared lifecycle runner for
orchestration, gate checks, stale-review detection, evidence, checkpoints, and
resume. By default, non-mock executors stop at a gated `route-ready` handoff.
With `--execute-routes`, selected routes run through the shared lifecycle
executor adapter while prompt-bundle execution remains outside the lifecycle
runner itself.
For a missing proposal target, bind creation source context with
`--set-file source=<path>` or `--set source=<text>`; normalized inputs are
retained in the lifecycle checkpoint and evidence so creation can be retried
without losing context.
Durable implementation, promotion, and archival routes pause for explicit
approval by default. `--approval-policy unattended` is an explicit operator
override for one-run automation; the adapter records approval override evidence
before executing each approval-gated durable route under that policy.
Packet-local receipts such as `support/implementation-run.md` and
`support/proposal-closeout.md` advance later lifecycle handoffs without adding
new `proposal.yml` statuses.

`/octon-proposal-run-program-lifecycle` wraps
`octon lifecycle run --lifecycle proposal-program --target
<program-packet-path>`. It is an orchestration wrapper only, not a dispatcher
route or prompt bundle.

## Publication

After the pack is selected in `.octon/instance/extensions.yml`, publish with:

```bash
bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh
bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh
```

Then run the extension, capability, host projection, and pack-local validators.
