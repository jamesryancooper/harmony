# Validation

- [x] Kernel workflow runner compiles with the proposal-registry generator and
  new lifecycle operations.
- [x] Proposal standard validation covers lifecycle structure, generated
  artifact-catalog freshness, and registry drift.
- [x] Deterministic registry generation rejects orphaned/manual entries,
  invalid archive lineage, path/status mismatches, and legacy-unknown design
  imports in the main projection.
- [x] Workflow contracts exist for `validate-proposal`, `promote-proposal`,
  and `archive-proposal`.
- [x] Proposal workflow runner coverage passes in an isolated fixture after
  trimming the fixture runtime copy and using the fixture-local runner path.
- [x] The committed proposal registry matches the deterministic manifest
  projection after regeneration.
