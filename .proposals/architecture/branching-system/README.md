# Branching-System Research Handoff Packet

This directory contains a portable, self-contained handoff packet for a downstream architectural research agent evaluating whether Octon should adopt descendant-local sidecar directories.

Status:

- non-canonical
- proposal support material only
- intended to inform later architecture selection, not define it

## Recommended Handoff Order

1. `research-agent-prompt.md`
2. `context-packet.md`
3. `constraints-and-invariants.md`
4. `extensions-interplay-brief.md`
5. `artifact-placement-matrix-seed.md`
6. `source-digest.md`
7. `implementation-documentation-brief.md`

## Packet Contents

- `research-agent-prompt.md`
  - Fully self-contained prompt for the downstream research agent.
- `context-packet.md`
  - Distilled current-state architecture, proposal landscape, tensions, and open questions.
- `source-digest.md`
  - Portable digest of the important repository sources, including authority level and why each matters.
- `constraints-and-invariants.md`
  - What must remain true, what must not be violated, and where ambiguity still exists.
- `extensions-interplay-brief.md`
  - Focused framing for the relationship between `/.octon/`, `/.extensions/`, and any descendant-local sidecar concept.
- `artifact-placement-matrix-seed.md`
  - Seed matrix to help the downstream agent reason about what belongs centrally, locally, or only as a derived surface.
- `implementation-documentation-brief.md`
  - Checklist of documentation and contract surfaces the downstream agent should specify in its recommendation.

## Reading Notes

- Canonical authority remains in `/.octon/**`, not in this directory.
- Proposal material is explicitly labeled as proposal material.
- Conflicting repository signals are surfaced intentionally; they are not resolved here.
