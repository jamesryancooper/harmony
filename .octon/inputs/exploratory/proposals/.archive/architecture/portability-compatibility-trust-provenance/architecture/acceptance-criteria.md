# Acceptance Criteria

The portability, compatibility, trust, and provenance proposal is ready for
promotion when all of the following are true:

1. `/.octon/octon.yml` is documented and validated as the authoritative root
   portability and compatibility contract.
2. The root manifest defines `versioning.harness.release_version`,
   `versioning.harness.supported_schema_versions`, and
   `versioning.extensions.api_version`.
3. `framework/manifest.yml` is required as the framework-scoped companion
   manifest for compatibility evaluation.
4. `instance/manifest.yml` is required as the instance-scoped companion
   manifest for compatibility evaluation.
5. Portability is defined as profile-driven rather than whole-tree copy.
6. The architecture explicitly classifies `framework/**` as portable authored
   core by default.
7. The architecture explicitly classifies `instance/**` as repo-specific by
   default.
8. The architecture explicitly classifies
   `inputs/additive/extensions/**` as optionally portable raw pack payload.
9. The architecture explicitly classifies `inputs/exploratory/**`,
   `state/**`, and `generated/**` as excluded from clean bootstrap and
   `repo_snapshot`.
10. `bootstrap_core` is defined as `octon.yml`, `framework/**`, and
    `instance/manifest.yml` only.
11. `bootstrap_core` explicitly excludes all `inputs/**`, all `state/**`, and
    all `generated/**`.
12. `repo_snapshot` is defined as the default behaviorally complete repo
    export.
13. `repo_snapshot` includes `octon.yml`, `framework/**`, and `instance/**`.
14. `repo_snapshot` includes every enabled pack payload referenced by
    `instance/extensions.yml`.
15. `repo_snapshot` includes the full transitive dependency closure of those
    enabled packs.
16. `repo_snapshot` explicitly excludes `inputs/exploratory/**`, `state/**`,
    and `generated/**`.
17. Snapshot export fails closed when an enabled pack payload or required
    dependency is missing.
18. The architecture explicitly rejects a v1 `repo_snapshot_minimal`.
19. `pack_bundle` is defined as selected packs plus dependency closure only.
20. `pack_bundle` explicitly excludes framework authority, repo-instance
    authority, exploratory inputs, state, and generated outputs.
21. `full_fidelity` is documented as advisory clone guidance rather than a
    synthetic export payload.
22. Compatibility is defined as rooted in `octon.yml`,
    `framework/manifest.yml`, `instance/manifest.yml`, and `pack.yml`.
23. Compatibility evaluation order is defined and validator-enforceable.
24. `pack.yml` exposes compatibility data sufficient to evaluate harness
    release compatibility and extensions API compatibility.
25. `pack.yml` exposes provenance data sufficient to identify source identity,
    origin class, and package lineage.
26. `instance/extensions.yml` remains the single desired-control surface in v1
    with `selection`, `sources`, `trust`, and `acknowledgements`.
27. Trust and provenance are explicitly separated between repo-authored policy
    and pack-authored metadata.
28. `origin_class` is required in `pack.yml`.
29. Allowed v1 `origin_class` values are exactly `first_party_bundled`,
    `first_party_external`, and `third_party`.
30. Trust policy may allow, deny, constrain, and acknowledge, but it may not
    elevate packs into framework or instance authority.
31. Incompatible packs do not publish effective outputs.
32. Untrusted packs do not publish effective outputs.
33. Missing or malformed required provenance blocks pack publication when the
    manifest contract requires it.
34. Publication continues to use the desired/actual/quarantine/compiled split
    with `instance/extensions.yml`, `state/control/extensions/{active,quarantine}.yml`,
    and `generated/effective/extensions/**`.
35. Publication of active state and compiled effective outputs remains atomic.
36. Generated effective extension outputs fail closed for runtime and policy
    use when stale.
37. Validators reject attempts to treat raw `inputs/**` paths as direct
    runtime or policy dependencies.
38. Documentation and workflow guidance describe profile-driven portability and
    behaviorally complete snapshot semantics consistently with the manifests.
39. The repo can explain, for each major artifact class, whether it is
    portable, repo-specific, optionally portable, mutable, or rebuildable.
