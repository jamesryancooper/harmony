# External Evidence Index

`state/evidence/external-index/**` stores content-addressed retained indexes for
replay-heavy artifacts whose immutable payloads are kept outside the Git tree.

## When To Use This Root

Use this root when canonical run evidence points at a replay payload that is:

- too large or high-volume to keep Git-inline
- immutable and content-addressed
- still required for replay, disclosure, or forensic reconstruction

## Rules

- the canonical run evidence root must still retain the pointer
- every external payload pointer must have an index entry with a stable digest
- absence of an index entry means the external pointer is not valid canonical
  replay evidence
