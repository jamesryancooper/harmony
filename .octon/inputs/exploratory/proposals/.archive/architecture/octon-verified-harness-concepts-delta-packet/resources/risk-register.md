# Risk register

| Risk | Affected concept | Impact | Mitigation |
|---|---|---|---|
| Calibration artifacts accidentally treated as policy truth | Evaluator calibration | High | Keep disagreement bundles evidence-only; no control artifacts minted |
| Over-specializing distillation schema to one evaluator path | Evaluator calibration | Medium | Extend generic bundle with optional disagreement fields rather than inventing a new top-level family |
| Binding field added but not validated | Slice-to-stage binding | High | Extend existing runtime validator and scenario suite before declaring closure |
| Backfill misses retained mission-bound run bundles | Slice-to-stage binding | Medium | Use run-contract inspection + receipt checklist before closure |
| Reintroducing a mission-slice contract family | Slice-to-stage binding | High | Explicitly prohibit in conformance card |
| Creating a new mission-planning family despite existing proposal path | Terse-objective expansion | Medium | Treat as already covered; no new changes |
