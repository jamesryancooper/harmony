# Program Revision Scenario

Given a parent proposal program with a latest parent review verdict of
`revision-required`, `revise-program` applies only parent-local
coordination changes needed to address selected findings and writes
`support/revisions/<revision-id>.md`.

Allowed changes are limited to parent coordination files such as the parent
manifest, child registry and index, sequence, child contract, validation plan,
closeout plan, and parent support artifacts. The route keeps or returns the
parent `proposal.yml#status` to `in-review` and routes back to
`review-program`.

The route never edits child manifests, child receipts, child promotion targets,
child validation verdicts, child archive metadata, runtime truth, or generated
effective authority. Parent revision receipts never satisfy child receipts.
