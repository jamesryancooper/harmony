# Acceptance Criteria

Acceptance is binary. There is no partial acceptance, no conditional acceptance, and no carry-forward remediation inside the attainment path.

## AC-001 — Constitutional source-of-truth parity

Accepted only if `framework/**` and `instance/**` are the sole authored authority surfaces and `V-SOT-001` is green.

## AC-002 — Ingress mirror discipline

Accepted only if root/tool-facing ingress mirrors are byte-parity or validated projections and `V-SOT-002` is green.

## AC-003 — Dual precedence enforcement

Accepted only if normative and epistemic precedence resolve through one effective precedence output and `V-PREC-001` is green.

## AC-004 — Objective stack legality

Accepted only if every workspace/mission/run/stage artifact is legal and `V-OBJ-001` and `V-OBJ-002` are green.

## AC-005 — Compatibility shim retirement

Accepted only if legacy objective shims and persona surfaces are not live-authoritative and `V-LEG-001` is green.

## AC-006 — Authority centralization

Accepted only if approvals/grants/leases/revocations/decisions are minted only from canonical authority surfaces and `V-AUTH-001`/`002` are green.

## AC-007 — Fail-closed routing

Accepted only if unsupported or under-approved routes terminate in deny, stage_only, or escalate and `V-AUTH-003` is green.

## AC-008 — Run-root completeness

Accepted only if every consequential run root contains the canonical lifecycle files and `V-RUN-001`/`002` are green.

## AC-009 — Evidence retention proof

Accepted only if tri-class evidence classification, hash linkage, and external replay restore drills are green.

## AC-010 — Intervention completeness

Accepted only if every manual touch is logged and `V-OBS-001` is green.

## AC-011 — Measurement and trace coverage

Accepted only if run bundles contain cost/latency/failure taxonomy summaries and trace pointers and `V-OBS-002` is green.

## AC-012 — Proof-plane completeness

Accepted only if all six proof planes exist, are non-cosmetic, and gate claims through `V-ASS-001`.

## AC-013 — Lab substance

Accepted only if the lab is populated with scenario/replay/shadow/fault/probe assets and `V-LAB-001` is green.

## AC-014 — Evaluator independence

Accepted only if held-out / independence policy exists and `V-LAB-002` is green.

## AC-015 — Support-target matrix enforcement

Accepted only if support-targets are binding for all runs, adapters, packs, and disclosures and `V-SUP-001` is green.

## AC-016 — Capability-pack governance

Accepted only if all packs are first-class governed artifacts and `V-CAP-001` is green.

## AC-017 — Run disclosure truth

Accepted only if every RunCard is regenerated from canonical artifacts and `V-DISC-001` is green.

## AC-018 — Harness claim truth

Accepted only if the final HarnessCard’s admitted universe equals the target universe and `V-DISC-002` is green.

## AC-019 — No second control plane

Accepted only if no host, proposal, generated, or mirror surface can originate authority or policy.

## AC-020 — No deferred work

Accepted only if every finding in the gap map is closed at cutover and no in-scope remediation is postponed.

## AC-021 — Blocking CI wiring

Accepted only if every validator in the validation plan is wired into blocking CI or certification workflows.

## AC-022 — Fresh workspace validation

Accepted only if a fresh worktree/bootstrap run passes the full validation stack.

## AC-023 — Dual-pass idempotence

Accepted only if the second full regeneration/validation pass produces no constitution-related diff.

## AC-024 — Archive lineage completeness

Accepted only if release lineage, closure manifest, closure certificate, and durable ADR closeout all exist.

## AC-025 — Proposal workspace normalization

Accepted only if this packet remains non-authoritative and the durable closeout decision lives in authored governance surfaces, not in the proposal packet.
