# Phases

## Phase 1 - Intake

- normalize source location and packet id intent
- determine whether explicit selected-concepts input narrows scope

## Phase 2 - Prompt Alignment Preflight

- use the pack-local alignment companion when pack-local prompt assets or repo
  authority anchors have drifted
- otherwise proceed with the last aligned pack-local prompt revision

## Phase 3 - Extraction

- run `octon-implementable-concept-extraction.md` from the pack-local prompt set
- materialize the result into the current run checkpoint as
  `artifacts/concept-extraction-output.md`

## Phase 4 - Verification

- run `octon-extracted-concepts-verification.md` from the pack-local prompt set
- use the checkpointed extraction artifact as the default upstream input
- materialize the result into the current run checkpoint as
  `artifacts/concept-verification-output.md`

## Phase 5 - Packetization

- run `selected-concepts-integration-and-proposal-packet.md`
- materialize a manifest-governed architecture proposal packet
- use checkpointed verification output as the default packetization input
- copy extraction and verification artifacts into packet support files

## Phase 6 - Implementation Prompt Generation

- run `proposal-packet-executable-implementation-prompt-generator.md`
- attach the result as proposal support material

## Phase 7 - Validation

- validate the emitted packet with the standard proposal validators
- retain run evidence and any residual blockers
