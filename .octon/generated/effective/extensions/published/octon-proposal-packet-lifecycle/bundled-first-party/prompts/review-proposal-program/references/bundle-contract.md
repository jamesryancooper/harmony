# Bundle Contract

This bundle creates or refreshes `support/proposal-review.md` for one parent
proposal program. It may update only the parent `proposal.yml#status` to
reflect the review verdict: `accepted`, `rejected`, or `in-review` for
`revision-required`.

The review is parent coordination only. It may review the parent
`proposal.yml`, child registry and index, sequence, child contract, validation
plan, closeout plan, and parent support artifacts. It must not edit child
manifests, child receipts, child promotion targets, child validation verdicts,
child archive metadata, runtime truth, or generated effective authority.
Parent review receipts never satisfy child receipts.
