# Product Roadmap

This directory is Octon's central planning catalog for cross-surface product
follow-up work.

The roadmap answers four questions for agents and maintainers:

- what follow-up work has been suggested
- which product feature it relates to
- why it remains deferred
- what acceptance and validation evidence would close it

## Files

- `catalog.yml`: machine-readable follow-up index.
- `<feature-id>.md`: human-readable roadmap notes for feature-specific
  follow-ups.

## Non-Authority Posture

This roadmap is planning-only. It does not create runtime discovery,
publication authority, support-target admission, policy authority, work queues,
or durable execution evidence. Generated outputs remain derived-only, raw
inputs remain non-authoritative, and proposal-local receipts remain evidence
only.

## Update Rule

When adding or changing a roadmap item, update `catalog.yml`, add or update the
matching feature roadmap note when helpful, and run:

```sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-product-roadmap.sh
```
