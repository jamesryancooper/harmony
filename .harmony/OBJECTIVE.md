---
schema_version: "objective-brief-v1"
objective_id: "harmony-governed-harness"
intent_id: "intent://harmony/harmony-governed-harness"
intent_version: "1.0.0"
owner: "Harmony governance"
approved_by: "Harmony governance"
generated_at: "2026-03-06T00:00:00Z"
---

# Objective: Harmony Governed Harness

## Workspace Goal

Use Harmony in `harmony` to evolve the harness itself as a portable,
system-governed engineering workspace with safe, reviewable, and verifiable
changes.

## What Harmony Should Optimize For

- correctness and coherence of the harness runtime, governance, and bootstrap model
- portability and self-containment across repositories and agent environments
- deterministic validation, safe autonomy boundaries, and clear operational evidence

## In Scope

- `.harmony/` runtime, governance, practices, and scaffolding surfaces in this repository
- harness tooling, validation, docs, workflows, and bootstrap behavior
- repo-local changes that materially improve Harmony's reliability, portability, or operator clarity

## Out of Scope

- unrelated product work outside the managed repository
- silent weakening of governance, assurance, or fail-closed behavior
- destructive or externally effectful actions without the required approval path

## Success Signals

- bootstrap and execution surfaces remain self-contained, discoverable, and internally consistent
- active docs, validators, and runtime behavior agree on the same authority model
- changes ship with enough evidence and verification to trust autonomous use of the harness

## Initial Focus

- keep authored governance surfaces canonical and generated ingress surfaces deterministic
- tighten validation whenever architecture or bootstrap paths change materially
- prefer the smallest robust refactor that reduces drift and preserves portability
