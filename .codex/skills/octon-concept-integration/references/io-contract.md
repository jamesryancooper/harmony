# I/O Contract

## Inputs

- `source_artifact` - required URL, file path, or inline artifact
- `proposal_id` - optional override for the generated proposal id
- `selected_concepts` - optional narrowed execution subset
- `alignment_mode` - optional `auto`, `always`, or `skip`
- `include_execution_prompt` - optional boolean

## Outputs

- proposal packet directory under
  `/.octon/inputs/exploratory/proposals/architecture/<proposal_id>/`
- run log under
  `/.octon/state/evidence/runs/skills/octon-concept-integration/<run-id>.md`
- optional checkpoint directory under
  `/.octon/state/control/skills/checkpoints/octon-concept-integration/<run-id>/`

## Default Intermediate Artifact Paths

The pack should manage upstream stage outputs as artifacts under the current
run checkpoint root:

- `artifacts/source-artifact.md`
- `artifacts/concept-extraction-output.md`
- `artifacts/concept-verification-output.md`
- `artifacts/selected-concepts.md`
- `artifacts/executable-implementation-prompt.md`

When packetization succeeds, these should be copied or normalized into packet
support files under the proposal directory rather than left only in transient
conversation state.

## Expected Support Artifacts Inside The Packet

- source artifact capture or reference
- concept extraction output
- concept verification output
- generated executable implementation prompt when requested
