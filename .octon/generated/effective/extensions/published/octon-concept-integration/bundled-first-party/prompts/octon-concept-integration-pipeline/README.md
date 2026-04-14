# Octon Concept Integration Pipeline

This prompt set is a 4-step pipeline for turning external source artifacts into verified Octon integration proposals and then carrying approved proposal work through implementation and closeout.

The authored contract for this prompt set lives in `manifest.yml`.
That manifest is the source of prompt inventory, required repo anchors,
freshness invalidation rules, and alignment-policy defaults for the
`octon-concept-integration` pack.

## Prompt Order

1. `octon-implementable-concept-extraction.md`
   Use first. It extracts candidate concepts from a source artifact and assigns provisional `Adopt`, `Adapt`, `Park`, or `Reject` recommendations.
2. `octon-extracted-concepts-verification.md`
   Use second. It re-checks the extracted recommendations against the live Octon repository, corrects false positives or misses, and emits the corrected final recommendation set.
3. `selected-concepts-integration-and-proposal-packet.md`
   Use third. It turns the selected concepts, preferably from the verification output, into a repository-grounded architecture proposal packet.
4. `proposal-packet-implementation-and-closeout.md`
   Use fourth. It implements the approved packet scope in the live repository, runs validation, records evidence and residuals, and drives the work to a closeout-ready result.

## Pipeline Contract

- The extraction prompt is exploratory but repo-grounded. Its output is not the final integration basis.
- The verification prompt is the correction gate. When it is available, its corrected final recommendation set should be treated as the default upstream input to the proposal-packet prompt.
- The proposal-packet prompt should use raw extraction output directly only when verification output is unavailable, and it should then state that the resulting packet scope is provisional.
- The implementation-and-closeout prompt should use the proposal packet as the default execution basis and should treat raw extraction or verification outputs as supporting traceability inputs rather than substitutes for the packet.

## Default Inputs

- Source artifact: usually a URL or inline `<source_artifact>...</source_artifact>`
- Extraction output: by default, a capability-managed artifact produced by the
  extraction stage and retained under the current run checkpoint or copied into
  packet support files
- Verification output: by default, a capability-managed artifact produced by
  the verification stage and retained under the current run checkpoint or
  copied into packet support files
- Proposal packet: usually materialized under
  `/.octon/inputs/exploratory/proposals/**`
- Repository under evaluation: the live checked-out repository containing the
  active Octon harness, unless the user explicitly overrides repo or branch
  context

## Goal

The set should be used as a strict sequence: extract, verify, packetize, then implement and close out. Skipping the verification step is allowed only as an explicit fallback, not as the default path. Skipping the packet stage is not the default path for downstream implementation work.

When the set is used through the `octon-concept-integration` pack, upstream
stage outputs are expected to be managed by the capability itself as
checkpointed and packet support artifacts rather than provided manually by the
user.

## Maintenance Companion

Use `prompt-set-current-state-alignment-and-conflict-audit.md` when Octon has evolved and the prompt set itself needs to be re-aligned with live repo reality.

This maintenance prompt is not a fifth pipeline stage. It is a companion audit and repair tool for keeping the prompt set current and conflict-free.

## Prompt-Generation Companion

Use `proposal-packet-executable-implementation-prompt-generator.md` when you want a packet-specific executable implementation/integration prompt generated from the baseline execution prompt plus the actual proposal packet and user-supplied execution context.

This meta prompt is also not a pipeline stage. It is a companion tool for generating a customized execution prompt from the stage-4 baseline.
