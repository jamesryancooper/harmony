# Program Creation

Given canonical child packet paths and an execution mode, `create-program`
creates a parent proposal packet with parent-owned coordination files only:
`resources/child-packet-index.yml`, `resources/child-packet-index.md`,
`architecture/packet-sequence.md`, `architecture/child-packet-contract.md`, and
`architecture/program-closeout-plan.md`.

The route writes parent-local `support/program-creation.md` with `creation_id`,
`created_at`, `creator`, `program_packet_path`, `child_packet_count`,
`execution_mode`, `child_registry_digest`, `child_authority_preserved`, and
`verdict`.

The receipt is proposal-local evidence only. It must not satisfy child receipts,
child promotion targets, child validation verdicts, child archive metadata, or
runtime truth.
