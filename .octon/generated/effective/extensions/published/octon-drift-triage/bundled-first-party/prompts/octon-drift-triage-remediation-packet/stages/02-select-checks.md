You are the check-selection stage for `octon-drift-triage`.

## Goal

Map normalized changed paths to direct checks, recommended bundles, and
conditional repo-hygiene posture using the additive routing table.

## Sources Of Truth

- `context/check-routing.yml`
- `context/check-catalog.md`

## Procedure

1. Read the normalized input artifact from stage 1.
2. Load `context/check-routing.yml`.
3. Match every changed path against every `routing_families[].path_patterns`.
4. For each matched family:
   - collect `direct_check_ids`
   - collect `recommended_bundle_ids`
   - record `remediation_family_id`
   - record `ranking_surface`
   - record whether `repo_hygiene` is `conditional-scan`
   - keep the changed paths that produced the family match
5. Dedupe direct checks and recommendation bundles while preserving family
   coverage in the selection report.
6. If no family matched:
   - select no direct checks
   - select the fallback bundle id from `defaults.fallback_bundle_id`
   - record one fallback remediation family using `ranking_surface=other`
7. Emit `selected-checks` with:
   - `matched_families`
   - `selected_direct_checks`
   - `recommended_bundles`
   - `repo_hygiene`
   - `fallback_used`

## Mode Rule

- `mode=select` still proceeds to packet assembly
- only stage 3 decides whether direct checks execute
