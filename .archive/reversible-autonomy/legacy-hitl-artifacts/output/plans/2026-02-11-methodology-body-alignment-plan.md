# Methodology Body Alignment Pass

## Context

The Harmony methodology statement (lines 1-16 of `docs/methodology/README.md`) was evolved through a collaborative analysis between Claude Opus 4.6 and GPT-5.3-Codex. The header now declares Harmony as "AI-native, human-governed", "lean in ceremony and rich in capability", "stack-, host-, and environment-agnostic", with "risk-tiered human governance." The principles files (`docs/principles/README.md`, `docs/principles/hitl-checkpoints.md`) were also updated.

However, the **body** of `docs/methodology/README.md` (lines 17-720) and several companion files still contain old language that contradicts the evolved header — prescribing specific tools (Cursor, Vercel, Turborepo) as mandatory, coupling to BMAD/SpecKit wrappers at the methodology level, and using outdated terminology ("AI-accelerated", "agents propose, humans approve").

This plan aligns the body with the header across three commits.

## Design Decisions

1. **Turborepo/Vercel/Cursor** remain as operational detail where they describe a real stack, but get a "Reference Implementation" callout making clear they are examples, not prescriptions.
2. **BMAD/SpecKit/PlanKit** are replaced at the methodology level with generic Harmony-native terms. A one-time note acknowledges PlanKit implements via BMAD as a transparent adapter.
3. **"Where the AI-Toolkit Fits"** section is reframed (not extracted) — heading becomes "Kit Architecture and Stage Mapping" and "AI-Toolkit" proper-noun references become "Harmony's kit layer."
4. **Primary scope:** `docs/methodology/README.md` body (Commit 1). **Secondary scope:** companion files (Commit 2). **File rename + cross-refs:** `spec-first-bmad.md` → `spec-first-planning.md` (Commit 3).

---

## Commit 1: `docs/methodology/README.md` body alignment

All edits target `docs/methodology/README.md`. ~35 line-level edits + 4 reference-implementation callout insertions across 11 batches.

### Batch 1 — SpecKit note + AI-Toolkit section (lines 55-156)

| Line | Old | New |
|------|-----|-----|
| 55 | `"SpecKit" refers to our AI‑Toolkit kit (code speckit) that wraps GitHub's Spec Kit. Mentions of the upstream tool explicitly use "GitHub's Spec Kit".` | `"SpecKit" (speckit) wraps GitHub's Spec Kit. Mentions of the upstream tool use "GitHub's Spec Kit" explicitly. PlanKit implements its planning kernel via BMAD; this adapter is transparent to methodology consumers.` |
| 61 | `PlanKit (BMAD)` | `PlanKit (planning kernel)` |
| 70 | `## Where the AI‑Toolkit Fits` | `## Kit Architecture and Stage Mapping` |
| 72 | `The AI‑Toolkit provides the kit‑level building blocks...see "Harmony Alignment" in docs/services/README.md#harmony-alignment-lean-ai-accelerated-methodology. In practice, use FlagKit for feature gating and progressive delivery (Vercel Flags via Edge Config)...` | `Harmony's kit layer provides the building blocks...see "Harmony Alignment" in docs/services/README.md#harmony-alignment. In practice, use FlagKit for feature gating and progressive delivery...` |
| 107 | `This mirrors the mental model used in the AI‑Toolkit README and architecture docs:` | `This mirrors the mental model used in docs/services/README.md and the kit architecture docs:` |
| 156 | `the AI‑Toolkit's invariants` | `Harmony's kit-layer invariants` |

Insert after line 66 (after Pillars→Practices table):

```markdown
> **Reference implementation.** Specific platforms above (Turborepo, Vercel) reflect Harmony's reference stack. Substitute your own build system and deployment platform. Harmony's principles and gates are stack-, host-, and environment-agnostic.
```

### Batch 2 — Methodology Map + Frameworks tables (lines 160-247)

| Line | Old | New |
|------|-----|-----|
| 164 | `Spec-first + BMAD workflow, templates, and Cursor workflow.` | `Spec-first planning workflow, templates, and AI IDE integration.` |
| 186 | `Harmony's BMAD → CI → Postmortem loop` | `Harmony's Spec → CI → Postmortem loop` |
| 195 | `instant **Vercel previews**` | `instant **preview deploys**` |
| 196 | `Harmony's **Turborepo monolith-first stack**` | `Harmony's **monolith-first stack** (e.g., Turborepo)` |
| 198 | `Harmony's BMAD step #2 ("Shape")` | `Harmony's shaping step` |
| 200 | `a **modular monolith** in **Turborepo**` | `a **modular monolith** (e.g., in Turborepo)` |
| 219 | `Central to Harmony's **modular monolith** design` | `Supports Harmony's **modular monolith** design` |
| 247 | `Cursor prompts even reference them by name` | `AI IDE prompts reference them by name` |

Insert before Platforms & Platform Controls table (before line 208):

```markdown
> **Reference implementation.** The platforms below are used in Harmony's reference stack. Substitute equivalents as appropriate.
```

### Batch 3 — Section 6 heading + mermaid diagram (lines 292, 375-397)

| Line | Old | New |
|------|-----|-----|
| 292 | `(Deterministic Agent Loops & HITL)` | `(Deterministic Agent Loops & Risk-Tiered Governance)` |
| 379 | `A["Spec (SpecKit) + ADR"]` | `A["Spec + ADR"]` |
| 380 | `C["BMAD Story (context + plan + AC)"]` | `C["Feature Story (context + plan + AC)"]` |
| 384 | `D["Dev in Cursor (human checkpoints)"]` | `D["Dev in AI IDE (risk-tiered checkpoints)"]` |
| 385 | `E["PR -> Vercel Preview (flagged)"]` | `E["PR -> Preview Deploy (flagged)"]` |

### Batch 4 — Spec-First + BMAD section (lines 447-451)

| Line | Old | New |
|------|-----|-----|
| 447 | `## Spec‑First + BMAD (step‑by‑step)` | `## Spec-First Planning (step-by-step)` |
| 449 | `starts with a SpecKit one‑pager and BMAD story, then runs through a Cursor-assisted loop...with human checkpoints.` | `starts with a spec one-pager and feature story (structured context + agent plan + acceptance criteria), then runs through an AI-assisted loop...with risk-tiered human checkpoints.` |
| 451 | `the full SpecKit one-pager template, BMAD story pattern, and Cursor workflow.` | `the full spec one-pager template, feature story pattern, and AI IDE integration guide.` |

### Batch 5 — Branching & Release (lines 453-464)

Insert after `---` before `## Branching & Release Model`:

```markdown
> **Reference implementation.** The branching and release details below use Vercel as the deployment platform. The principles (preview-per-PR, guarded promotion, instant rollback, server-evaluated feature flags) are platform-agnostic.
```

Vercel-specific operational content stays as-is under this framing note.

### Batch 6 — Architecture summary (line 534)

| Line | Old | New |
|------|-----|-----|
| 534 | `in Turborepo with Hexagonal boundaries` | `with Hexagonal boundaries` |

### Batch 7 — Playbook + Snippets (lines 540-630)

| Line | Old | New |
|------|-----|-----|
| 540 | `## Cursor‑Native Playbook (ready prompts)` | `## AI IDE Prompt Library` |
| 542 | `Use these **verbatim** in Cursor.` | `Use these prompts verbatim in your AI IDE or terminal agent.` |
| 630 | `## Cursor Prompt Snippets Library` | `## Prompt Snippets Library` |

### Batch 8 — Tooling Map (lines 567-575)

| Line | Old | New |
|------|-----|-----|
| 567 | `## Tooling Map (GitHub/Vercel/Turborepo)` | `## Tooling Map` |
| 571 | `templates for Spec/BMAD/bug` | `templates for Spec/Story/bug` |

Insert after line 569:

```markdown
> **Reference implementation.** The tooling below reflects Harmony's reference stack. Substitute your own equivalents as needed.
```

### Batch 9 — Worked Example + Extras (lines 606-658)

| Line | Old | New |
|------|-----|-----|
| 615 | `**BMAD story → Cursor**:` | `**Feature story → AI IDE**:` |
| 650 | `Cursor diff review` | `AI IDE diff review` |
| 654 | `Spec/BMAD → small PR #1` | `Spec/Plan → small PR #1` |

### Batch 10 — Quick-Start Page (lines 662-676)

| Line | Old | New |
|------|-----|-----|
| 670 | `**Spec → BMAD → PR flow**:` | `**Spec → Plan → PR flow**:` |
| 672 | `Write **BMAD spec one‑pager** + **ADR**.` | `Write **spec one-pager** + **ADR**.` |
| 673 | `Convert to **BMAD story**.` | `Convert to **feature story** (context + plan + AC).` |
| 674 | `Use **Cursor** to propose plan/diffs/tests with checkpoints.` | `Use **AI IDE** to propose plan/diffs/tests with risk-tiered checkpoints.` |
| 675 | `**Vercel Preview**` | `**preview deploy**` |

### Batch 11 — HITL checkpoint + References (lines 350, 710)

| Line | Old | New |
|------|-----|-----|
| 350 | `SpecKit one‑pager + micro‑STRIDE` | `spec one-pager + micro-STRIDE` |
| 710 | `**Delivery platform**:` | `**Delivery platform (reference implementation)**:` |

---

## Commit 2: Secondary file alignment

### `docs/GLOSSARY.md` (~line 15)

- `"lean, AI-accelerated approach where human developers orchestrate AI agents"` → `"AI-native, human-governed approach where developers orchestrate AI agents"`

### `docs/services/README.md` (~lines 184-186)

- Heading: `## Harmony Alignment (Lean AI-Accelerated Methodology)` → `## Harmony Alignment`
- Body: `"Harmony is a lean, opinionated delivery method for tiny teams..."` → `"Harmony is an AI-native, human-governed methodology for solo builders — lean in ceremony and rich in capability..."`

### `docs/methodology/sandbox-flow.md` (~line 105)

- `### D — Dev in Cursor (Guided Implementation)` → `### D — Dev in AI IDE (Guided Implementation)`

### `docs/methodology/adoption-plan-30-60-90.md` (~lines 23-27, 60)

- `Spec → BMAD → PR Flow` → `Spec → Plan → PR Flow`
- `BMAD spec one-pager` → `spec one-pager`
- `Use **Cursor** to propose` → `Use **AI IDE** to propose`
- `Spec/BMAD → small PR #1` → `Spec/Plan → small PR #1`

### `docs/pillars/README.md` (~line 209)

- `PlanKit (BMAD)` → `PlanKit (planning kernel)` in Kit Maturity table

### `docs/.harmony/.index/agent-system-design/harmony-methodology-and-principles-summary.md` (~line 3)

- `"lean AI-accelerated"` → `"AI-native, human-governed"`

### `docs/methodology/tooling-and-metrics.md` (~line 12)

- `templates for Spec/BMAD/bug` → `templates for Spec/Story/bug`

---

## Commit 3: File rename + cross-reference fixup

### Rename

`docs/methodology/spec-first-bmad.md` → `docs/methodology/spec-first-planning.md`

### Content updates within renamed file

- Title: `"Spec-First + BMAD Workflow"` → `"Spec-First Planning Workflow"`
- `"Cursor/IDE Integration"` → `"AI IDE Integration"`
- Replace methodology-level "BMAD" with "feature story" / "planning kernel" (keep "BMAD" where it describes PlanKit's internal adapter)

### Cross-reference updates (all files referencing old filename)

- `docs/methodology/README.md` lines 164, 451
- `docs/pillars/direction.md` ~line 144
- `docs/methodology/templates/README.md` ~line 111
- `docs/methodology/risk-tiers.md` ~line 1004
- Files under `docs/methodology/.harmony/.index/`

### Anchor fixup

- `docs/methodology/README.md` line 72: `#harmony-alignment-lean-ai-accelerated-methodology` → `#harmony-alignment` (must match Commit 2's heading change in `docs/services/README.md`)

---

## Verification

1. **Grep sweep after Commit 1:** `grep -rn "BMAD\|Cursor\|AI.Toolkit\|AI-accelerated\|lean.*opinionated" docs/methodology/README.md` — should return zero hits outside line 55 adapter note
2. **Grep sweep after Commit 2:** Same patterns across `docs/` — remaining hits only in `spec-first-bmad.md` (renamed in Commit 3), `.harmony/.index/` caches, and implementation-level BMAD in `implementation-guide.md`
3. **Link check after Commit 3:** `grep -rn "spec-first-bmad" docs/` — should return zero
4. **Anchor check:** Verify `#harmony-alignment` resolves in `docs/services/README.md`
5. **Mermaid rendering:** Preview updated lifecycle diagram in markdown viewer
6. **Read-through:** Full top-to-bottom skim of `docs/methodology/README.md` for consistency

## Risks

- **Broken cross-references from file rename** — mitigated by atomic commit (rename + all ref updates together)
- **Anchor change** — mitigated by updating anchor reference in same commit as heading change
- **Temporary inconsistency** between primary and secondary files — mitigated by landing Commits 1-2 in quick succession
- **`.harmony/.index/` cached summaries** — low-visibility reference material; update when encountered
