# Packet 12 — Capability Routing and Host Integration

**Proposal design packet for ratifying, normalizing, and implementing scope-aware capability routing and host integration inside Octon's five-class Super-Root architecture.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Capability routing, generated routing views, scope-aware routing signals, host-adapter integration, extension-aware routing, and migration from the legacy single-location skills architecture
- **Implementation order:** 12 of 15 in the ratified proposal sequence
- **Primary outcome:** Deliver one deterministic, class-rooted, fail-closed routing architecture that compiles native framework capabilities, repo-native instance capabilities, validated extension contributions, path selectors, file/framework fingerprints, and scope metadata into canonical generated routing outputs consumed by runtime and host adapters
- **Dependencies:** Packet 6 — Locality and Scope Registry; Packet 8 — Inputs/Additive/Extensions; Packet 10 — Generated / Effective / Cognition / Registry
- **Migration role:** Move the repository from the current capability/host model anchored on legacy single-location skill surfaces and host symlink workflows into the ratified Super-Root model where routing is generated, scope-aware, and extension-aware
- **Current repo delta:** The current repo already ratifies the five-class Super-Root in `/.octon/README.md` and `/.octon/octon.yml`, but the live capabilities architecture still describes the legacy single-location skills model under `/.octon/capabilities/runtime/skills/` and host symlink exposure patterns. Packet 12 is the proposal that closes that gap and aligns capability routing with the ratified class-root architecture.

> **Packet intent:** Define how Octon discovers, ranks, validates, and publishes capability routing in a way that is deterministic, scope-aware, extension-aware, host-consumable, and never dependent on raw `inputs/**` paths.

## 1. Why this proposal exists

The ratified Super-Root architecture cleanly separates:

- portable framework authority
- durable repo-instance authority
- raw additive and exploratory inputs
- mutable operational truth
- rebuildable generated outputs

Capability routing has to respect those same boundaries.

Without a final routing contract, Octon risks falling back to one of the legacy or unsafe patterns that the Super-Root explicitly rejects:

- runtime discovery from raw pack fragments
- host adapters reading raw skill directories directly
- descendant-local routing metadata or sidecars
- ad hoc per-host routing logic
- implicit routing precedence instead of compiled precedence
- raw `inputs/**` paths becoming live dependencies

Packet 12 exists to ratify one final answer:

> capability routing is root-owned, compiled, scope-aware, extension-aware, and consumed only through generated routing views.

## 2. Problem statement

Octon needs a final routing and host-integration architecture that answers all of the following operationally:

- What are the canonical routing inputs?
- Which inputs are authoritative versus derived?
- How do framework-native and instance-native capabilities participate together?
- How do enabled extension packs contribute without becoming authority?
- How does scope metadata influence routing without becoming a local activation surface?
- What do runtime and host adapters consume?
- What is the generated routing output contract?
- How does Octon fail closed when routing inputs are stale, invalid, or ambiguous?
- How do current capability docs and host link workflows migrate into the Super-Root?

The architecture must preserve all already-ratified boundaries:

- `framework/**` and `instance/**` are authored authority
- `inputs/**` is never direct runtime authority
- `generated/**` is where routing views live
- locality remains root-owned
- there are no descendant-local harnesses or routing sidecars

## 3. Final target-state decision summary

- Capability routing remains **root-owned** and **compiled**.
- Framework-native capability definitions are authoritative under `framework/**`.
- Repo-native capability definitions are authoritative under `instance/**`.
- Extension contributions participate only through validated compiled extension views from `generated/effective/extensions/**`.
- Scope metadata influences routing through narrow, validated routing signals only.
- Canonical generated routing output is `generated/effective/capabilities/routing.effective.yml`.
- Runtime and host adapters consume the generated routing view; they do **not** read raw extension payloads or descendant-local routing files.
- There are no descendant-local activation surfaces, routing sidecars, or ancestor-chain capability overlays.
- Ambiguous or invalid routing inputs fail publication; stale routing views fail closed for runtime use.

## 4. Scope

This packet does all of the following:

- defines canonical routing inputs
- defines the generated routing view and its consumers
- defines the role of scope metadata in routing
- defines how extension contributions participate in routing
- defines how host adapters integrate with generated routing views
- defines validation and fail-closed rules for routing
- defines migration from the legacy skills/host-link model

## 5. Non-goals

This packet does **not** do any of the following:

- re-litigate the five-class Super-Root
- create descendant-local routing files or local sidecars
- move raw packs out of `inputs/additive/extensions/**`
- make scope metadata authoritative for capability definitions
- define a host-specific directory contract for every agent product
- create a second routing authority outside the super-root
- let raw `inputs/**` fragments become runtime-facing discovery surfaces
- reopen hierarchical scope inheritance

## 6. Canonical paths and artifact classes

| Artifact family | Canonical path | Class root | Authority status | Notes |
|---|---|---|---|---|
| Framework-native capability definitions | `framework/capabilities/runtime/**` | framework | authored authority | Base/native capabilities shipped with Octon core |
| Framework capability governance | `framework/capabilities/governance/**` | framework | authored authority | Capability contracts and validation rules |
| Repo-native capability definitions | `instance/capabilities/runtime/**` | instance | authored authority | Repo-specific capabilities not packaged as reusable additive packs |
| Locality/scope metadata | `instance/locality/**` | instance | authored authority | Scope routing hints are declared here |
| Raw extension pack capability content | `inputs/additive/extensions/<pack-id>/**` | inputs/additive | non-authoritative | Never consumed directly by runtime |
| Generated extension effective catalogs | `generated/effective/extensions/**` | generated | non-authoritative | Runtime-facing compiled extension view |
| Generated routing view | `generated/effective/capabilities/routing.effective.yml` | generated | non-authoritative | Canonical routing output |
| Generated routing artifact map | `generated/effective/capabilities/artifact-map.yml` | generated | non-authoritative | Maps effective ids to canonical inputs |
| Generated routing freshness receipt | `generated/effective/capabilities/generation.lock.yml` | generated | non-authoritative | Freshness/staleness contract |
| Host adapter outputs | consumed from generated routing view | generated | non-authoritative | Host integration reads compiled routing only |

## 7. Authority and boundary implications

- `framework/**` remains authoritative for portable capability definitions and capability governance.
- `instance/**` remains authoritative for repo-native capabilities and scope metadata.
- `inputs/additive/**` remains a raw additive input class only.
- `generated/effective/capabilities/**` is the only runtime-facing routing surface.
- Scope metadata may influence routing, but it does not define or override capability identity.
- Host adapters may project routing results into host-specific surfaces, but those projections are derived from generated routing views and must not become independent authority.
- Raw extension content and raw proposal content remain outside runtime and policy precedence.

## 8. Ratified routing and host-integration model

### 8.1 Routing inputs

Capability routing is compiled from these input families only:

1. **Framework-native capability manifests and registries**
2. **Repo-native instance capability manifests and registries**
3. **Validated generated extension effective catalogs**
4. **Repo-relative path selectors**
5. **File/framework fingerprints**
6. **Scope metadata from `scope.yml`**

No other routing input family is legal in v1.

### 8.2 Scope metadata allowed for routing

Allowed scope routing signals are intentionally narrow:

- `tech_tags`
- `language_tags`
- optional ranking hints
- optional preferred pack tags

These signals may filter or rank candidate capabilities. They do **not** author capability definitions, defaults, or runtime policy.

### 8.3 Generated routing output

Canonical generated routing output:

```text
generated/effective/capabilities/routing.effective.yml
```

It must minimally publish:

- routing generation id
- source digests
- schema version
- candidate capability ids
- precedence/ranking result
- capability origin classification (`framework`, `instance`, `extension`)
- artifact references via artifact map ids
- freshness linkage to `generation.lock.yml`

### 8.4 Routing artifact map

Canonical artifact map:

```text
generated/effective/capabilities/artifact-map.yml
```

The artifact map must resolve every effective capability or routing candidate id to the canonical authoritative or generated source from which it was compiled.

### 8.5 Host adapter integration

Host adapters do **not** discover capability definitions by walking raw directories.

They must consume the generated routing view and, where needed, any host-facing material derived from it. That means:

- no host adapter may read raw pack fragments directly
- no host adapter may infer routing from filesystem coincidence
- no host adapter may treat current symlink layout as authority

The current host-link model becomes a migration baseline only. Any host-visible projections, links, or adapter files must be regenerated from the canonical routing view.

### 8.6 Framework vs instance vs extension participation

The routing pipeline must preserve clear capability provenance:

- framework-native capabilities are base portable authority
- repo-native instance capabilities are repo-owned authoritative additions
- extension contributions are additive only and must come through generated effective extension catalogs

If a candidate from an enabled extension pack conflicts with framework or instance authority in a forbidden way, publication fails or the pack is quarantined according to Packet 14.

### 8.7 No local activation surfaces

There are no descendant-local routing manifests, no `.octon.local` routing files, no nearest-ancestor lookup, and no local capability sidecars.

Routing remains super-root owned, manifest-defined, and generated.

## 9. Schema / manifest / contract changes required

This proposal requires changes to:

- framework capability governance contracts
- framework capability runtime schemas and registries
- instance capability runtime schemas and repo-native capability contracts
- scope schema fields for routing hints
- generated routing view schema
- generated routing artifact map schema
- generated routing generation lock schema
- any host-adapter projection contract that currently assumes raw path discovery
- documentation that still describes the legacy single-location skills surface as the final routing model

## 10. Validation / assurance / fail-closed implications

Validators must enforce all of the following:

- raw `inputs/**` paths may not be consumed directly by runtime or host adapters
- routing publication fails if a required generated extension effective view is stale or invalid
- ambiguous routing inputs must block publication rather than degrade silently
- scope routing hints must match declared schema and allowed signal classes
- instance capability overlays may not shadow framework capabilities outside declared overlay rules
- artifact maps must resolve every published routing candidate deterministically
- generation locks must match the currently published routing view

Fail-closed implications:

- invalid routing inputs block publication of `routing.effective.yml`
- stale routing views may not be used by runtime or policy consumers
- invalid extension-derived routing inputs quarantine affected packs or withdraw extension contributions, not silently bypass them
- invalid scope bindings block scope-aware routing for the affected scope and quarantine locally when possible

## 11. Portability / compatibility / trust implications

- Framework-native routing contracts remain portable as part of `framework/**`.
- Repo-native capability definitions and scope routing hints are repo-specific by default.
- Extension contributions remain optionally portable only as pack payloads under `inputs/additive/extensions/**`.
- Compatibility between Octon core and extension contributions is checked through the root manifest and pack manifests before routing publication.
- Trust overrides remain governed by `instance/extensions.yml`; routing does not create a second trust surface.
- `repo_snapshot` is behaviorally complete, which means routing export includes the enabled pack dependency closure indirectly through the profile rules defined in Packet 2 and Packet 13.

## 12. Migration / rollout implications

Migration should proceed in this order:

1. Ratify super-root taxonomy and manifests.
2. Land locality registry and scope validation.
3. Land generated extension effective views.
4. Move framework-native and instance-native capability contracts into final class-root placements.
5. Add the generated routing view and artifact map contracts.
6. Update host adapters to consume generated routing views instead of raw paths.
7. Remove legacy routing assumptions tied to the old single-location skills model.

### Critical migration rule

Do **not** switch host adapters to the ratified routing model until generated extension effective views and scope validation are both live.

Otherwise adapters will either read stale compiled state or fall back to raw-path discovery, which the ratified architecture forbids.

## 13. Dependencies on other proposals

Hard dependencies:

- **Packet 6 — Locality and Scope Registry**
- **Packet 8 — Inputs/Additive/Extensions**
- **Packet 10 — Generated / Effective / Cognition / Registry**

Cross-packet contract sync:

- **Packet 4 — Repo-Instance Architecture**
- **Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness**
- **Packet 13 — Portability, Compatibility, Trust, and Provenance**

## 14. Suggested implementation order

Packet 12 should be implemented **12 of 15** in the ratified proposal sequence, after locality, extension, and generated output contracts already exist.

## 15. Acceptance criteria

This packet is complete when all of the following are true:

- framework-native and repo-native capability definitions have final class-root placements
- scope metadata allowed for routing is explicitly schema-bounded
- `generated/effective/capabilities/routing.effective.yml` is defined and published deterministically
- runtime and host adapters consume only generated routing views for routing decisions
- raw `inputs/**` paths are not used for live routing or host discovery
- extension-derived routing candidates come only from validated generated extension effective views
- ambiguous or invalid routing inputs fail publication
- documentation no longer presents the legacy raw-directory skills model as the final runtime routing model

## 16. Supporting evidence to reference

Reference these materials when drafting the full proposal:

- ratified Super-Root blueprint sections on capability routing, locality, generated outputs, and extensions
- current `/.octon/capabilities/_meta/architecture/architecture.md`
- current `/.octon/cognition/governance/principles/locality.md`
- current root manifest `/.octon/octon.yml`
- extension-pack baseline proposal material for disallowed raw-path runtime dependency patterns
- any existing host-link or host-adapter setup workflows that must be replaced or regenerated

## 17. Settled decisions that must not be re-litigated

- routing remains root-owned and compiled
- descendant-local activation surfaces are not introduced
- raw `inputs/**` paths do not become direct runtime dependencies
- extension contributions reach routing only through validated compiled views
- zero-or-one active `scope_id` per path remains the v1 locality rule
- one `scope_id` declares one `root_path` in v1
- proposals do not participate in runtime or policy routing

## 18. Remaining narrow open questions, if any

None.

This packet is fully ratified for proposal drafting and implementation planning.
