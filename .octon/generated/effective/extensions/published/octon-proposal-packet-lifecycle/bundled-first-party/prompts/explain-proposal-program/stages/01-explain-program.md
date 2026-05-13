# Explain Program

Read the parent `proposal.yml`, subtype manifest, `resources/child-packet-index.yml`,
`resources/child-packet-index.md`, `architecture/packet-sequence.md`,
`architecture/child-packet-contract.md`, `architecture/program-closeout-plan.md`,
validation plan, source-of-truth map, and support artifacts. Explain the parent
proposal program in repository-grounded terms and distinguish proposal-local
coordination from durable promoted outputs, generated projections, runtime
control state, retained evidence, and child-owned proposal authority.

The explanation must cover: the parent problem and scope; required and deferred
children; execution mode; child registry shape; sequence, phases, dependency
gates, and allowed parallelism; readiness gates; aggregate evidence posture;
closeout posture; rollback or deferral posture; and what follow-on work is
prepared but not implemented. State which surfaces are parent-owned coordination
surfaces and which surfaces remain child-owned.

Do not collapse child authority into the parent. Child `proposal.yml` files,
subtype manifests, receipts, validation verdicts, promotion targets, acceptance
criteria, terminal lifecycle outcomes, and archive metadata remain child-owned.
Parent evidence may summarize child outcomes, but it never satisfies child
receipts, child promotion targets, child validation verdicts, or child archive
metadata.
