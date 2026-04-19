# Memory

Memory governance for execution roles.

## Canonical Rule

No execution role owns canonical memory.

- authored authority lives in `framework/**` and `instance/**`
- control truth lives in `state/control/**`
- continuity lives in `state/continuity/**`
- evidence lives in `state/evidence/**`
- generated cognition owns nothing authoritative

## Context Packs

Consequential execution must bind a context pack with:

- authoritative sources
- derived sources
- excluded sources
- hashes
- freshness checks
- authority labels
- generated-input labels
- omissions
- retrieval steps
- an evidence receipt

Generated cognition may appear only as labeled derived input. It may never
authorize, approve, override, publish, or satisfy evidence obligations.
