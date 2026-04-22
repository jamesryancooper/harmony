# Acceptance Criteria

## Packet acceptance criteria

- [ ] Packet lives under `/.octon/inputs/exploratory/proposals/architecture/octon-architecture-10of10-target-state-transition/`.
- [ ] `proposal.yml`, `architecture-proposal.yml`, `README.md`, `navigation/source-of-truth-map.md`, and `navigation/artifact-catalog.md` are present.
- [ ] Architecture artifacts include target architecture, gap map, implementation plan, validation plan, acceptance criteria, file-change map, cutover plan, and closure checklist.
- [ ] Complete evaluation and supporting analysis live under `resources/`.
- [ ] Packet does not claim authority and does not instruct runtime/policy/support consumers to read proposal files.

## Architecture acceptance criteria

- [ ] Authored authority remains under `framework/**` and `instance/**`.
- [ ] `state/**` remains mutable control/evidence/continuity state, not authored doctrine.
- [ ] `inputs/**` remain non-authoritative and cannot directly feed runtime/policy.
- [ ] `generated/**` remain generated/read-model/runtime-effective outputs and cannot mint authority.
- [ ] Generated/effective runtime-facing outputs are consumed only through resolver-verified handles.
- [ ] Route-bundle and pack-route locks use explicit freshness modes, not fake far-future freshness.
- [ ] Every material side-effect path is discovered or registered and covered by `authorize_execution` or denied/stage-only.
- [ ] Runtime grants fail closed on route bundle drift, stale pack routes, stale extension publication, support mismatch, or retired projection use.
- [ ] Capability-pack routing is simplified into framework contracts, instance governance, and generated/effective runtime routes.
- [ ] `instance/capabilities/runtime/packs/**` is frozen/retired as a compatibility projection and cannot be used as steady-state runtime authority.
- [ ] Extension selection, activation, quarantine, and publication states are cleanly separated and validated.
- [ ] Support claims are bounded by live/stage-only/unadmitted/retired partitions and backed by executable proof bundles.
- [ ] Operator read models are traceable, freshness-aware, generated-only, and never consumed as authority.
- [ ] Architecture-health v2 passes at closure-grade depth.

## Proof acceptance criteria

- [ ] Executable proof bundles include scenario, command/harness invocation, input/output digests, evaluator version, pass/fail criteria, negative controls, trace/replay refs, support tuple, and claim effect.
- [ ] Support dossiers downgrade or fail when proof is stale, shallow, missing, or inconsistent.
- [ ] Publication receipts link to source hashes and generated artifact hashes.
- [ ] Negative controls prove fail-closed behavior for stale route bundles, widened pack routes, quarantined extensions, retired projection consumption, and generated read-model misuse.

## Cutover acceptance criteria

- [ ] Promotion is staged and reversible.
- [ ] Regenerated artifacts have matching locks and receipts.
- [ ] Runtime selector points to refreshed generated/effective artifacts.
- [ ] Compatibility projections are registered, frozen, or retired.
- [ ] Final closure certificate is retained under `state/evidence/validation/architecture/10of10-target-transition/closure/`.
