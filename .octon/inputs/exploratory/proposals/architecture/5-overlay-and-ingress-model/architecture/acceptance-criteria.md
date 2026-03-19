# Acceptance Criteria

The overlay and ingress architecture proposal is ready for promotion when all
of the following are true:

1. `framework/overlay-points/registry.yml` is explicitly defined as the
   canonical framework-authored overlay registry.
2. `framework/manifest.yml` is defined to bind the canonical overlay registry.
3. `instance/manifest.yml#enabled_overlay_points` is explicitly defined as the
   canonical repo-side overlay enablement surface.
4. Canonical internal ingress is explicitly located at
   `instance/ingress/AGENTS.md`.
5. `AGENTS.md`, `CLAUDE.md`, and `/.octon/AGENTS.md` are explicitly treated as
   thin adapters only and not as separate authority surfaces.
6. Overlay-capable instance surfaces are explicitly distinguished from
   instance-native surfaces.
7. The architecture explicitly lists the instance-native surfaces that do not
   rely on overlay semantics.
8. The architecture explicitly lists the overlay-capable instance surfaces
   that are legal only at declared enabled overlay points.
9. The architecture states that overlay-capable repo-local surfaces live under
   `instance/**`, not under `framework/**`, `state/**`, `generated/**`, or
   `inputs/**`.
10. The architecture states that there is no blanket shadow-tree model for
    `instance/**`.
11. The architecture explicitly requires each overlay registry entry to define
    `overlay_point_id`, `owning_domain`, `instance_glob`, `merge_mode`,
    `validator`, and `precedence`.
12. The allowed v1 merge modes are explicitly bounded to
    `replace_by_path`, `merge_by_id`, and `append_only`.
13. The architecture explicitly lists the canonical v1 overlay points, their
    instance globs, merge modes, precedence values, and artifact kinds.
14. `instance-governance-policies` is defined with
    `.octon/instance/governance/policies/**`, `replace_by_path`, and
    precedence `10`.
15. `instance-governance-contracts` is defined with
    `.octon/instance/governance/contracts/**`, `replace_by_path`, and
    precedence `20`.
16. `instance-agency-runtime` is defined with
    `.octon/instance/agency/runtime/**`, `merge_by_id`, and precedence `30`.
17. `instance-assurance-runtime` is defined with
    `.octon/instance/assurance/runtime/**`, `append_only`, and precedence
    `40`.
18. The architecture states that overlay artifacts are legal only when a
    matching overlay point exists and the instance manifest enables it.
19. The architecture states that overlay artifacts outside the declared
    `instance_glob` are invalid.
20. The architecture states that undeclared or disabled overlay artifacts fail
    closed.
21. The architecture states that invalid merge modes fail closed.
22. The architecture states that failed validators fail closed.
23. The architecture states that overlay-capable artifacts may not target
    forbidden framework surfaces such as `framework/engine/runtime/**`.
24. The architecture explicitly defines the overlay resolution order from
    framework manifest through published runtime view.
25. The architecture explicitly defines the semantics of `replace_by_path`.
26. The architecture explicitly defines the semantics of `merge_by_id`.
27. The architecture explicitly defines the semantics of `append_only`.
28. The architecture states that repo-root adapters may redirect, project, or
    scaffold canonical ingress only.
29. The architecture states that repo-root adapters may not introduce new
    runtime or policy authority.
30. The architecture states that repo-root adapters may not override canonical
    ingress content.
31. Validators reject schema-invalid overlay registries.
32. Validators reject `enabled_overlay_points` values not declared by the
    framework registry.
33. Validators reject overlay points that use unsupported merge modes.
34. Validators reject overlay registry entries whose validators do not resolve.
35. Validators reject overlay points that escape `.octon/instance/**`.
36. Validators reject overlay-capable artifacts outside enabled overlay-point
    roots.
37. Validators reject canonical ingress drift away from `instance/ingress/**`.
38. Validators reject repo-root ingress adapters that become authoritative.
39. Validators reject raw `inputs/**` paths used as direct runtime or policy
    dependencies.
40. The architecture states that `framework/overlay-points/registry.yml` is
    portable with the framework bundle.
41. The architecture states that `instance/manifest.yml`, overlay artifacts,
    and canonical internal ingress are repo-specific by default.
42. The architecture states that canonical internal ingress is included in
    `repo_snapshot` through `instance/**`.
43. The architecture states that overlay enablement is preserved across normal
    framework updates unless an explicit migration contract says otherwise.
44. The architecture states that framework overlay-point changes require
    explicit schema, version, or migration handling.
45. The architecture states that repo-root ingress adapters may be regenerated
    from canonical internal ingress.
46. Later packets are constrained to inherit this overlay and ingress contract
    and may not reintroduce ad hoc overlay paths or root-ingress authority.
