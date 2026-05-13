# Program Closeout

Given a parent program whose required children are implemented, archived,
rejected, superseded, or explicitly deferred with evidence, program closeout
requires passing aggregate conformance and drift receipts before writing
parent-local `support/proposal-closeout.md`.

The parent closeout receipt must include `verdict`, `closed_at`,
`archive_authorized`, and `child_authority_preserved`. It may record
`archive_authorized: yes` only when parent closeout evidence is complete and
child-owned manifests, receipts, promotion targets, validation verdicts,
archive metadata, and terminal outcomes remain child-owned.

`archive-proposal` may archive the parent status only. It must not archive child
packets or satisfy child closeout receipts.
