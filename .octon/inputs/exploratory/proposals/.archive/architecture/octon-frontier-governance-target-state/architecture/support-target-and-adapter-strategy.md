# Support-Target and Adapter Strategy

## Strategy statement

Octon should optimize first for a **frontier-native governed tier**, then define explicit degraded/local profiles. It should not claim broad portability until tuple-level support dossiers prove the claim.

## Current issue

The current support-target file declares `support_claim_mode: bounded-admitted-live-universe`, while the schema allows `bounded-admitted-finite` and `global-complete-finite`. The charter language also uses globally complete finite terminology. This is a P0 authority drift issue because support claims are governance facts.

## Operational support truth

The operational support truth should be finite admitted tuples:

```text
(model tier, workload tier, language/resource tier, locale tier, host adapter, model adapter, capability pack set)
```

Broad model/workload/context/locale/adapter lists are planning taxonomy only. They do not imply support without tuple admission and support dossier.

## Frontier-native tier

Frontier-native support should assume:

- large context windows;
- native tool/computer use;
- multimodal perception/action where admitted;
- stronger planning and instruction following;
- longer-horizon execution;
- deterministic context packs rather than token-era retrieval scaffolding;
- strict authority, evidence, rollback, and intervention requirements.

Default route: escalate for boundary-sensitive and repo-consequential actions until proof-backed support exists.

## Degraded/local tier

Degraded/local support should assume:

- smaller context windows;
- stricter context pack budgets;
- smaller run slices;
- more human review;
- more verifier usage;
- narrower capability packs;
- reduced support claims;
- stronger generated summary freshness checks.

Default route: allow read-only reference-owned work if tuple-admitted; escalate or deny material work unless proof exists.

## Adapter strategy

Host/model adapters remain valuable as **projection and evidence boundaries**, not as generic vendor-routing abstractions.

Each adapter declaration should include:

- support status;
- authority mode;
- replaceability;
- supported tuple subset;
- conformance suite;
- known limitations;
- contamination/reset posture for model adapters;
- disclosure obligations;
- evidence requirements;
- failure/denial behavior.

## Experimental adapters

Experimental adapters may exist only in a quarantined/stage-only surface. They must not appear as live support and must not be routable by default. The `experimental-external` adapter should be moved out of active discovery or explicitly validated as stage-only.

## Browser/API support posture

Browser/API packs should remain **designed but not live by default** until:

- runtime service is active in `services/manifest.runtime.yml`;
- contract and implementation exist;
- negative tests pass;
- replay/event ledger evidence is retained;
- egress/connector leases exist for API;
- support tuple and support dossier exist;
- RunCard/HarnessCard generation covers the pack.

## Support certification artifacts

Each admitted tuple should have:

- admission record;
- support dossier;
- adapter conformance evidence;
- capability-pack evidence;
- lab scenario evidence;
- benchmark evidence;
- disclosure evidence;
- HarnessCard.

## Acceptance gate

A support claim is valid only if all of the following are true:

1. schema-valid support target;
2. tuple admission exists;
3. support dossier exists;
4. runtime services exist for referenced packs;
5. evidence roots contain proof;
6. generated support matrix is fresh and non-authoritative;
7. no retired/experimental tier participates in a live claim.
