# Current-state gap map

| Concept | Current coverage | Why current state is not yet enough (or is enough) | Gap type | Packet-time disposition |
|---|---|---|---|---|
| Evaluator calibration by disagreement distillation | Partial | Evaluator evidence, finding/disposition records, generic failure-distillation workflow, and one retained distillation bundle already exist, but they do not yet define a reusable disagreement-specific calibration loop that links evaluator misses to future calibration candidates. | `extension_needed` | `adapt` |
| Slice-to-stage binding refinement for mission-bound runs | Partial | Mission action slices and mission classification are present, but stage attempts do not yet carry an explicit action-slice binding in the v2 schema or the retained example path. This leaves mission-bound work slice-aware at mission control but not yet slice-explicit at stage-attempt execution. | `extension_needed`, `migration_needed` | `adapt` |
| Proposal-packet-backed expansion of terse objectives | Full | Proposal packets, mission classification, fail-closed proposal requirements, and run-contract proposal refs are already present and usable. A specialized mission-planning packet family is not required to make the capability real. | `none` | `already_covered` |
