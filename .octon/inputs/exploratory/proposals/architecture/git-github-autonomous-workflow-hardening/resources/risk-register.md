# Risk Register

| Risk | Description | Likelihood | Impact | Mitigation |
|---|---|---:|---:|---|
| CLI surprise from `git-pr-ship.sh` hardening | operators may expect eager mutation from the current helper | medium | medium | make the new status-first behavior explicit and, if needed, keep a short deprecation warning path |
| Contract bloat | a new workflow contract could become a dumping ground for all Git/GitHub policy | low | medium | keep the contract narrowly scoped to workflow state, remediation policy, helper semantics, and validation scenarios |
| Tool-boundary mismatch persists | skill text and allowed-tools may drift again later | medium | high | add validator coverage that checks prose against allowed-tools |
| `.github/**` alignment lands late | durable `.octon/**` surfaces may change without companion host projections | medium | high | require same-branch companion alignment in acceptance criteria |
| Overfitting to helper lane | implementation may still prove only the Octon-script path | medium | high | require plain Git lane scenario proof before closure |
| Validator false positives | the new validator may flag legitimate wording variations too aggressively | medium | medium | prefer contract-key checks and narrow targeted string checks rather than loose prose heuristics |
