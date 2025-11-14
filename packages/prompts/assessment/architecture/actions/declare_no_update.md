---
title: Architecture – Declare No Update
description: Action prompt for explicitly declaring that no architecture updates are required.
meta:
  type: assessment
  mode: action
  action: declare_no_update
  subject: architecture
  step_index: 9
---

# Architecture – Declare No Update

<!-- Placeholder: define the no-update declaration step for architecture assessments. -->

*** Add File: packages/prompts/assessment/workflows/architecture-assessment-workflow.md
---
title: Architecture Assessment Workflow
description: Workflow prompt that orchestrates the Architecture assessment actions (inventory → analyze → map → detect issues → align → edit → validate → summarize → declare no update).
meta:
  type: assessment
  mode: workflow
  subject: architecture
  flow: architecture_assessment_v1
---

# Architecture Assessment Workflow

Use this workflow prompt to orchestrate the Harmony Architecture assessment as a sequence of composable actions. Each step delegates to a dedicated action prompt under `assessment/architecture/actions`.

## Steps (in order)

1. `inventory` — enumerate relevant files and artifacts and their basic structure.  
   - Prompt: `assessment/architecture/actions/inventory.md`

2. `analyze` — read content in detail against goals and criteria.  
   - Prompt: `assessment/architecture/actions/analyze.md`

3. `map` — build terminology, decision, and process maps across files.  
   - Prompt: `assessment/architecture/actions/map.md`

4. `detect_issues` — find conflicts, duplications, gaps, ambiguities, and misalignments.  
   - Prompt: `assessment/architecture/actions/detect_issues.md`

5. `align` — design how to normalize terms, decisions, and cross-links.  
   - Prompt: `assessment/architecture/actions/align.md`

6. `edit` — apply minimal, targeted changes directly to the source docs.  
   - Prompt: `assessment/architecture/actions/edit.md`

7. `validate` — re-check consistency, coverage, and coherence after edits.  
   - Prompt: `assessment/architecture/actions/validate.md`

8. `summarize` — report findings, decisions, and changes (or lack thereof).  
   - Prompt: `assessment/architecture/actions/summarize.md`

9. `declare_no_update` — explicitly state that no edits are needed and stop.  
   - Prompt: `assessment/architecture/actions/declare_no_update.md`

## Orchestration Notes

- Use `meta.step_index` from each action’s frontmatter to enforce execution order.
- This workflow should stop after step 9, or earlier if the `declare_no_update` condition is met according to your runner’s logic.

