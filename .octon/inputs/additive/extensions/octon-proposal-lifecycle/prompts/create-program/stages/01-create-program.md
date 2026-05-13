# Create Program

Create a normal manifest-governed parent proposal packet with child packet
references, child index, sequence contract, dependency gates, risk posture,
program evidence plan, and program closeout plan. Reject nested child proposal
package directories and require every child packet to remain independently
valid at its canonical active path.

Write parent-local `support/program-creation.md` with `creation_id`,
`created_at`, `creator`, `program_packet_path`, `child_packet_count`,
`execution_mode`, `child_registry_digest`, `child_authority_preserved`, and
`verdict`. This receipt is proposal-local evidence only. It may summarize the
parent registry that was created, but it never satisfies child receipts, child
promotion targets, child validation verdicts, child archive metadata, or
runtime truth.
