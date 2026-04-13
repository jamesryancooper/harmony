# Cutover checklist

## Pre-promotion
- [ ] Reconfirm live repo baseline against `main`
- [ ] Confirm the archived prior packet remains archived and implemented
- [ ] Confirm no narrower selected subset overrides the current scope
- [ ] Confirm current proposal packet remains non-authoritative

## Evaluator disagreement distillation
- [ ] Extend distillation bundle schema
- [ ] Extend failure-distillation workflow overlay
- [ ] Add disagreement bundle authoring script
- [ ] Add disagreement bundle validator
- [ ] Wire validator into architecture conformance
- [ ] Generate one real disagreement bundle
- [ ] Generate one non-authoritative summary

## Slice-to-stage binding
- [ ] Extend stage-attempt-v2 schema
- [ ] Extend mission runtime validator
- [ ] Extend mission autonomy scenario coverage
- [ ] Backfill any mission-bound retained run bundles
- [ ] Emit binding receipt(s)
- [ ] Verify no new mission-slice contract family was introduced

## No-change concept
- [ ] Reconfirm proposal-packet-backed objective expansion remains already covered
- [ ] Record no-change proof in closure package

## Final cutover gates
- [ ] Two consecutive validation passes are clean
- [ ] No unresolved blockers remain
- [ ] Closure evidence is complete
