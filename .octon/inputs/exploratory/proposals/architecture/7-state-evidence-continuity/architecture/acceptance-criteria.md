# Acceptance Criteria

The state, evidence, and continuity architecture proposal is ready for
promotion when all of the following are true:

1. `state/**` is explicitly defined as the canonical class root for mutable
   operational truth and retained evidence.
2. The architecture explicitly requires `state/continuity/**`,
   `state/evidence/**`, and `state/control/**` as the three required Packet 7
   state subdomains.
3. `state/continuity/repo/**` is explicitly defined as the canonical home for
   repo-wide and cross-scope active work state.
4. `state/continuity/repo/log.md`,
   `state/continuity/repo/tasks.json`,
   `state/continuity/repo/entities.json`, and
   `state/continuity/repo/next.md` are explicitly defined as the canonical
   repo continuity artifact family.
5. `state/continuity/scopes/<scope-id>/**` is explicitly defined as the
   canonical scope continuity path.
6. The architecture explicitly states that scope continuity is illegal until
   locality registry and scope validation are live.
7. The architecture explicitly preserves the repo-before-scope continuity
   sequencing rule.
8. The architecture explicitly defines the one-primary-home rule for active
   detailed work state.
9. The architecture explicitly states that repo continuity owns repo-wide and
   cross-scope work.
10. The architecture explicitly states that scope continuity owns stable
    single-scope work only.
11. The architecture explicitly states that repo continuity may summarize or
    link scope work but must not duplicate the detailed scope ledger.
12. `state/evidence/**` is explicitly defined as the canonical retained
    evidence root.
13. `state/evidence/runs/**` is explicitly defined as the canonical home for
    run receipts, digests, and execution evidence.
14. `state/evidence/decisions/repo/**` and
    `state/evidence/decisions/scopes/<scope-id>/**` are explicitly defined as
    the canonical homes for operational decision evidence.
15. `state/evidence/validation/**` is explicitly defined as the canonical home
    for validation receipts and enforcement evidence.
16. `state/evidence/migration/**` is explicitly defined as the canonical home
    for migration receipts and rollback traceability.
17. The architecture explicitly states that retained evidence is
    append-oriented and retention-governed.
18. The architecture explicitly states that retained evidence is not active
    task state.
19. The architecture explicitly states that retained evidence is not
    rebuildable generated output.
20. `state/control/**` is explicitly defined as the canonical mutable
    control-state root.
21. `instance/extensions.yml` is explicitly defined as desired authored
    extension configuration.
22. `state/control/extensions/active.yml` is explicitly defined as actual
    active operational state.
23. `state/control/extensions/quarantine.yml` is explicitly defined as
    extension quarantine and withdrawal state.
24. `generated/effective/extensions/**` is explicitly defined as the compiled
    runtime-facing extension output set.
25. The architecture explicitly states that publication of
    `state/control/extensions/active.yml` and
    `generated/effective/extensions/**` must be atomic.
26. The architecture explicitly requires `state/control/extensions/active.yml`
    to reference a valid published generation.
27. `state/control/locality/quarantine.yml` is explicitly defined as the
    canonical mutable locality quarantine surface.
28. The architecture explicitly states that locality quarantine is current
    control truth, not scope-identity authority.
29. The architecture explicitly states that `state/**` is not an authored
    governance, runtime, or policy surface.
30. The architecture explicitly states that durable repo context remains under
    `instance/cognition/context/**`.
31. The architecture explicitly states that ADRs remain under
    `instance/cognition/decisions/**`.
32. The architecture explicitly states that memory policy remains under
    `.octon/framework/agency/governance/MEMORY.md`.
33. The architecture explicitly states that `generated/**` remains the
    rebuildable output class and never becomes source-of-truth.
34. The architecture explicitly states that raw `inputs/**` paths remain
    non-authoritative and may not become runtime or policy dependencies.
35. The architecture explicitly states that generated regeneration must never
    delete `state/**`.
36. The architecture explicitly states that ordinary working-state reset may
    clear continuity state but must not blindly purge retained evidence.
37. The architecture explicitly states that evidence cleanup and compaction
    must happen through explicit retention workflows.
38. The architecture explicitly states that `state/**` is excluded from
    `bootstrap_core`.
39. The architecture explicitly states that `state/**` is excluded from
    `repo_snapshot`.
40. The architecture explicitly states that `state/**` is preserved in
    full-fidelity repository clones.
41. The architecture explicitly states that trust policy remains authored
    outside `state/**`, including `instance/extensions.yml`.
42. Continuity artifacts are explicitly required to conform to canonical
    continuity schemas.
43. Evidence artifacts are explicitly required to conform to evidence schemas
    and retention rules.
44. Validators explicitly reject scope continuity for undeclared, invalid, or
    quarantined scopes.
45. Validators explicitly reject undeclared state write targets.
46. Validators explicitly reject invalid repo continuity shape.
47. Validators explicitly reject invalid scope continuity shape for the
    affected scope.
48. Validators explicitly reject invalid or stale extension active-state
    publication.
49. Validators explicitly reject invalid quarantine state rather than ignoring
    it.
50. Validators explicitly reject evidence written outside the canonical
    `state/evidence/**` surfaces.
51. The architecture explicitly requires runtime-vs-ops mutation policy to
    recognize the class-rooted `state/**` boundary rather than mixed legacy
    routing assumptions.
52. The architecture explicitly requires continuity and memory routing docs to
    distinguish continuity, evidence, control state, durable context, and ADR
    surfaces.
53. The architecture explicitly states that operational decision evidence is
    not an ADR surface.
54. The architecture explicitly states that scope continuity does not author
    scope identity or locality precedence.
55. The architecture explicitly states that later packets must consume
    stateful operational truth from `state/**` and desired repo authority from
    `instance/**` rather than inventing alternate mutable roots.
56. Teams no longer need to infer whether a mutable artifact belongs under
    continuity docs, generated outputs, or durable context because one
    ratified `state/**` contract defines continuity, evidence, and control
    placement.
