# Program Structure Validation

Given a parent proposal program, the program structure validator checks
parent-only coordination structure before implementation, promotion,
verification prompt generation, closeout prompt generation, closeout, or
archive workflow entry.

It requires parent `proposal.yml`, `resources/child-packet-index.yml`,
`resources/child-packet-index.md`, `architecture/packet-sequence.md`,
`architecture/child-packet-contract.md`, and
`architecture/program-closeout-plan.md`. Child ids in `related_proposals`, the
YAML registry, the human index, and packet sequence must agree.

It fails on unsafe child paths, child packets nested under the parent program,
missing parent coordination files, mismatched child ids, dangling dependencies,
or parent-owned child authority surfaces such as child validation verdicts or
child archive metadata.
