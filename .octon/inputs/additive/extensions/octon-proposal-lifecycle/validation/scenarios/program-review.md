# Program Review Scenario

Given an `in-review` parent proposal program with child registry/index,
sequence, child contract, validation plan, closeout plan, and parent support
artifacts, `review-program` writes parent-local
`support/proposal-review.md` with the existing review fields and a deterministic
reviewed parent packet digest.

Accepted parent reviews set only the parent `proposal.yml#status` to
`accepted`; rejected parent reviews set only the parent status to `rejected`;
`revision-required` reviews leave or return only the parent status to
`in-review`.

The route never edits child manifests, child receipts, child promotion targets,
child validation verdicts, child archive metadata, runtime truth, or generated
effective authority. Parent review receipts never satisfy child receipts.
