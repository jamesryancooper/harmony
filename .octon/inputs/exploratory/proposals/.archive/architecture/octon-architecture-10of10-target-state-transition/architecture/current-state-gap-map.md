# Current-State Gap Map

Current assessed architecture score: **8.0 / 10**.

Current architecture is strong and should be preserved, but it cannot credibly reach 10/10 until runtime-effective consumption, freshness semantics, proof maturity, pack-route simplification, compatibility retirement, non-authority registration, and architecture-health depth are hardened.

| Area | Current state | Target state | Gap class | Required change |
|---|---|---|---|---|
| Authority model | Strong class-root and constitutional model | Same, preserved | None/core strength | Preserve unchanged; update docs only where needed. |
| Runtime-effective route bundle | Compiled bundle exists with lock and receipt | All generated/effective runtime-facing files consumed through a single verified handle API | Focused gap | Add handle contract, runtime resolver API, validator, and negative tests. |
| Freshness | Lock contains source hashes and invalidation conditions, but also `fresh_until: 2099-12-31` | Explicit `freshness.mode` with digest/TTL/receipt semantics | Structural gap | Replace fake TTL with schema-supported freshness modes and validators. |
| Runtime authorization boundary | Execution authorization spec, inventory, coverage, and implementation exist | Every material path auto-proved against inventory and denied when uncovered | Maturity gap | Auto-discover runtime entrypoints and cross-check coverage. |
| Proof plane | Strong proof categories; some proof reports are summary-like | Executable, falsifiable, negative-control-backed proof bundles | Proof maturity gap | Add proof-bundle executability schema/validator and upgrade support proof artifacts. |
| Architecture health | Aggregates many validators | Depth-aware closure-grade health gate | Enforcement gap | Add validator-depth taxonomy and fail closure-grade when only existence checks pass. |
| Capability packs | Framework, instance governance, compatibility runtime projection, generated pack routes | Framework contract + instance governance + generated/effective pack routes only | Complexity/transition gap | Freeze/retire runtime pack projection and remove steady-state authority ambiguity. |
| Extensions | Desired/active/quarantine/published lifecycle exists | Same lifecycle, with handle-based generated/effective consumption and stronger no-raw-input proof | Focused gap | Register published effective catalog as derived runtime handle and deepen validators. |
| Non-authority register | Covers several claim-adjacent projections, not all runtime-facing generated/effective handles | Covers all generated/effective handles and operator projections | Boundary gap | Add derived-runtime-handle class and complete entries. |
| Operator read models | Contract exists; maps/summaries incomplete | Generated architecture, runtime route, pack route, support, and retirement maps with traceability | Legibility gap | Publish traceable generated cognition maps. |
| Support dossiers | Partitioned support state and dossiers exist | Dossiers downgrade automatically when proof is stale, shallow, or missing negative controls | Proof/support gap | Add dossier sufficiency validator and proof maturity fields. |
| Compatibility posture | Retirement register is strong; projections still visible | Compatibility surfaces retained only with deauthorization, review, and no runtime consumption | Moderate restructuring | Cut over runtime consumers, freeze projections, retire when safe. |

## Current strengths to preserve

- Constitutional kernel and precedence hierarchy.
- Five class roots.
- Fail-closed obligations and evidence obligations.
- Engine-owned execution authorization boundary.
- Run contract as atomic consequential execution unit.
- Mission as continuity container.
- Bounded support-target claim architecture.
- Generated/effective publication receipts and locks.
- Extension desired/active/quarantine/published lifecycle.
- Non-authority and retirement registers.
- Architecture-health gate concept.

## Current weaknesses requiring actual change

- Freshness semantics are partially decorative until fake far-future freshness is replaced by explicit modes.
- Runtime-effective generated/effective files are safe only when all runtime reads route through verified handles.
- Capability-pack route layers still require too much mental reconciliation.
- Architecture-health breadth exceeds depth.
- Proof-plane evidence is not consistently executable or falsifiable.
- Operator navigation requires too much repo spelunking.
