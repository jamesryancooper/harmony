# Acceptance Criteria

The inputs/additive/extensions architecture proposal is ready for promotion
when all of the following are true:

1. `inputs/additive/extensions/**` is explicitly defined as the only canonical
   raw extension-pack home.
2. The architecture explicitly states that raw pack payloads are
   non-authoritative source inputs only.
3. The architecture explicitly states that raw pack payloads do not become a
   second governance, runtime, policy, or state authority surface.
4. The architecture explicitly defines `instance/extensions.yml` as the single
   desired authored extension configuration file in v1.
5. The architecture explicitly requires `instance/extensions.yml` to contain
   `selection`, `sources`, `trust`, and `acknowledgements`.
6. The architecture explicitly defines `state/control/extensions/active.yml`
   as actual active operational truth.
7. The architecture explicitly defines
   `state/control/extensions/quarantine.yml` as mutable quarantine and
   withdrawal truth.
8. The architecture explicitly defines
   `generated/effective/extensions/**` as the only runtime-facing extension
   surface.
9. The architecture explicitly states that runtime and policy consumers may
   not read raw pack paths.
10. The architecture explicitly states that desired configuration, actual
    active state, quarantine state, and compiled outputs are four distinct
    layers.
11. The architecture explicitly requires publication to be treated as valid
    only when desired, active, quarantine, and compiled state are mutually
    consistent.
12. The architecture explicitly requires
    `state/control/extensions/active.yml` to record desired configuration
    revision, resolved active set, dependency closure, generation id,
    published output references, validation timestamp, and status.
13. The architecture explicitly requires
    `state/control/extensions/quarantine.yml` to record blocked packs,
    affected dependents, reason codes, timestamps, and acknowledgement or
    override markers when allowed.
14. The architecture explicitly requires
    `generated/effective/extensions/catalog.effective.yml`,
    `artifact-map.yml`, and `generation.lock.yml`.
15. The architecture explicitly states that generated effective outputs remain
    rebuildable and non-authoritative.
16. The architecture explicitly states that extension effective outputs are
    committed by default under the ratified generated-output policy.
17. The architecture explicitly defines one unified `pack.yml` contract for
    all pack origins.
18. The architecture explicitly requires `pack.yml` to include `pack_id`,
    `version`, `compatibility`, `dependencies`, `provenance`,
    `origin_class`, `trust_hints`, and `content_entrypoints`.
19. The architecture explicitly requires `origin_class`.
20. The architecture explicitly restricts `origin_class` to
    `first_party_bundled`, `first_party_external`, and `third_party`.
21. The architecture explicitly defines the allowed v1 content buckets:
    `skills/`, `commands/`, `templates/`, `prompts/`, `context/`, and
    `validation/`.
22. The architecture explicitly states that governance, practices,
    methodology, `agency/`, `orchestration/`, `engine/`, assurance authority,
    services, mutable operational state, and compiled effective indexes are
    disallowed pack content.
23. The architecture explicitly states that packs remain additive and
    subordinate only.
24. The architecture explicitly states that raw packs may not redefine root
    policy, runtime authority, or global routing defaults.
25. `repo_snapshot` is explicitly defined as behaviorally complete.
26. The architecture explicitly requires `repo_snapshot` to include enabled
    pack payloads plus transitive dependency closure.
27. The architecture explicitly states that there is no v1
    `repo_snapshot_minimal` profile.
28. The architecture explicitly requires snapshot export to fail closed when
    an enabled pack or dependency is missing.
29. `pack_bundle` is explicitly defined to include selected packs plus
    dependency closure.
30. The architecture explicitly states that `inputs/exploratory/**`,
    `state/**`, and `generated/**` remain excluded from `repo_snapshot`.
31. The architecture explicitly states that pack provenance travels with the
    pack in `pack.yml`.
32. The architecture explicitly states that repo trust overrides remain in
    `instance/extensions.yml`.
33. The architecture explicitly states that compatibility checks bind against
    root-manifest release and extension API version values.
34. Validators explicitly reject raw pack placement outside
    `inputs/additive/extensions/**`.
35. Validators explicitly reject invalid `pack.yml` shape.
36. Validators explicitly reject missing or invalid `origin_class`.
37. Validators explicitly reject disallowed bucket content or disallowed
    authority surfaces inside packs.
38. Validators explicitly reject unresolved dependency closure for enabled
    packs.
39. Validators explicitly reject incompatible packs.
40. Validators explicitly reject untrusted packs.
41. Validators explicitly reject active-state publication that does not match a
    fresh generated extension generation.
42. Validators explicitly reject publication when quarantine blocks the
    published set.
43. Validators explicitly reject runtime or policy dependencies on raw pack
    paths.
44. Validators explicitly reject stale generated extension outputs.
45. The fail-closed model explicitly quarantines invalid packs and affected
    dependents rather than silently ignoring them.
46. The fail-closed model explicitly permits publication of a coherent
    surviving set only when the surviving set remains valid.
47. The fail-closed model explicitly withdraws extension contributions and
    falls back to framework-plus-instance native behavior when no coherent
    surviving set exists.
48. The architecture explicitly states that raw pack payloads are optionally
    portable.
49. The architecture explicitly states that `instance/extensions.yml` is
    repo-specific by default.
50. The architecture explicitly states that
    `state/control/extensions/**` is never bootstrap-portable.
51. The architecture explicitly states that the legacy
    `.octon.extensions/` sidecar proposal is superseded and non-normative
    after Packet 8 promotion.
52. Teams no longer need to infer whether extension selection, trust,
    publication, runtime consumption, or snapshot completeness belong to the
    same surface because one ratified desired/actual/quarantine/compiled model
    defines the full extension pipeline.
