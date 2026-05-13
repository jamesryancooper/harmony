# Bundle Contract

This bundle applies parent-local coordination revisions for parent program
review findings and creates a revision receipt under `support/revisions/`. It
keeps or returns the parent program to `in-review` and routes back to
`review-program`.

The revision is parent coordination only. It may edit parent-local coordination
files, including the parent manifest, child registry and index, sequence, child
contract, validation plan, closeout plan, and parent support artifacts. It must
not edit child manifests, child receipts, child promotion targets, child
validation verdicts, child archive metadata, runtime truth, or generated
effective authority. Parent revision receipts never satisfy child receipts.
