# Acceptance Criteria

The generated/effective/cognition/registry architecture proposal is ready for
promotion when all of the following are true:

1. `generated/**` is explicitly defined as the only class root for rebuildable
   outputs.
2. The architecture explicitly states that `generated/**` is never
   authoritative.
3. The architecture explicitly states that generated outputs may be deleted
   and rebuilt.
4. The architecture explicitly states that the final published generated
   families are `generated/effective/**`, `generated/cognition/**`, and
   `generated/proposals/**`.
5. The architecture explicitly states that runtime-facing generated outputs
   live only under `generated/effective/**`.
6. The architecture explicitly states that generated cognition outputs live
   only under `generated/cognition/**`.
7. The architecture explicitly states that proposal discovery lives only at
   `generated/proposals/registry.yml`.
8. The architecture explicitly defines
   `generated/effective/locality/scopes.effective.yml` as the canonical
   effective locality view.
9. The architecture explicitly defines
   `generated/effective/capabilities/routing.effective.yml` as the canonical
   target-state effective capability-routing view.
10. The architecture explicitly defines
    `generated/effective/extensions/catalog.effective.yml` as the canonical
    effective extension view.
11. The architecture explicitly requires every runtime-facing effective family
    to publish a primary effective view.
12. The architecture explicitly requires every runtime-facing effective family
    to publish `artifact-map.yml`.
13. The architecture explicitly requires every runtime-facing effective family
    to publish `generation.lock.yml`.
14. The architecture explicitly requires effective publication metadata to
    include source digests.
15. The architecture explicitly requires effective publication metadata to
    include generator version.
16. The architecture explicitly requires effective publication metadata to
    include schema version.
17. The architecture explicitly requires effective publication metadata to
    include generation timestamp.
18. The architecture explicitly requires effective publication metadata to
    include freshness or invalidation semantics.
19. The architecture explicitly requires effective publication metadata to
    include generation or publication identity.
20. The architecture explicitly states that runtime and policy consumers may
    use generated outputs only where a generated effective family is the
    designated compiled surface.
21. The architecture explicitly states that runtime and policy consumers must
    not read raw proposal paths where generated discovery or effective views
    are required.
22. The architecture explicitly states that runtime and policy consumers must
    not read raw extension-pack paths where generated effective views are
    required.
23. The architecture explicitly defines
    `generated/cognition/graph/**` as derived output only.
24. The architecture explicitly defines
    `generated/cognition/projections/definitions/**` as derived output only.
25. The architecture explicitly defines
    `generated/cognition/projections/materialized/**` as derived output only.
26. The architecture explicitly defines
    `generated/cognition/summaries/**` as derived output only.
27. The architecture explicitly states that generated cognition outputs may
    aid navigation, inspection, summarization, and tooling but may not replace
    authored or state authority.
28. The architecture explicitly states that `generated/proposals/registry.yml`
    is rebuildable.
29. The architecture explicitly states that `generated/proposals/registry.yml`
    is committed by default.
30. The architecture explicitly states that `generated/proposals/registry.yml`
    remains non-authoritative.
31. The architecture explicitly states that proposal manifests outrank the
    generated proposal registry.
32. The architecture explicitly defines the default commit policy for
    `generated/effective/**` as commit by default.
33. The architecture explicitly defines the default commit policy for
    `generated/effective/**/artifact-map.yml` as commit by default.
34. The architecture explicitly defines the default commit policy for
    `generated/effective/**/generation.lock.yml` as commit by default.
35. The architecture explicitly defines the default commit policy for
    `generated/cognition/summaries/**` as commit by default.
36. The architecture explicitly defines the default commit policy for
    `generated/cognition/projections/definitions/**` as commit by default.
37. The architecture explicitly defines the default commit policy for
    `generated/cognition/projections/materialized/**` as rebuild locally by
    default.
38. The architecture explicitly defines the default commit policy for
    `generated/cognition/graph/**` as rebuild locally by default.
39. The architecture explicitly states that committed generated outputs remain
    non-authoritative.
40. The architecture explicitly states that retained validation evidence does
    not belong in `generated/**`.
41. The architecture explicitly states that retained assurance evidence does
    not belong in `generated/**`.
42. The architecture explicitly identifies `state/evidence/validation/**` as
    the canonical home for retained validation and assurance evidence.
43. The architecture explicitly treats `generated/artifacts/**` as a
    migration-era bucket rather than a final top-level family.
44. The architecture explicitly treats `generated/assurance/**` as a
    migration-era bucket rather than a final top-level family.
45. The architecture explicitly treats `generated/effective/assurance/**` as
    non-final drift unless a later explicit architecture decision ratifies a
    destination.
46. The architecture explicitly rejects unexplained free-form top-level
    generated buckets after cutover.
47. The architecture explicitly rejects unexplained effective subfamilies
    after cutover.
48. The architecture explicitly states that generated outputs must reference
    canonical inputs only.
49. The architecture explicitly states that no authored or state surface may
    treat generated artifacts as source-of-truth.
50. The architecture explicitly states that stale runtime-facing effective
    outputs fail closed.
51. The architecture explicitly states that invalid runtime-facing effective
    publication blocks runtime or policy use of that family.
52. The architecture explicitly states that invalid proposal-registry output
    blocks proposal discovery workflows only.
53. The architecture explicitly states that stale cognition-derived outputs
    may remain visible only for non-operational inspection workflows.
54. The architecture explicitly states that stale cognition-derived outputs
    must show visible staleness.
55. Validation explicitly checks that every runtime-facing effective family
    includes the required publication triple.
56. Validation explicitly checks required generation metadata presence.
57. Validation explicitly checks freshness against current canonical inputs.
58. Validation explicitly checks that generated artifacts do not leak into
    authoritative class roots.
59. Validation explicitly checks that raw-input dependency violations fail
    closed where effective generated views are required.
60. Validation explicitly checks that migration-era generated buckets are
    empty, migrated, or explicitly tolerated during migration only.
61. The architecture explicitly states that `generated/**` is excluded from
    `bootstrap_core`.
62. The architecture explicitly states that `generated/**` is excluded from
    `repo_snapshot`.
63. The architecture explicitly states that generated outputs are not the
    portability unit even when some are committed by default.
64. The architecture explicitly identifies Packet 12 as the downstream packet
    that finalizes effective capability-routing publication.
65. The architecture explicitly identifies Packet 11 as the downstream packet
    that must keep memory summaries, projections, and graph outputs derived.
66. The architecture explicitly identifies Packet 14 as the downstream packet
    that must enforce stale-generation fail-closed behavior.
67. The architecture explicitly identifies migration from current generated
    drift as normalization work rather than a second root move.
68. Teams can explain clearly what is safe to delete and regenerate and what
    remains durable authority or retained evidence.
