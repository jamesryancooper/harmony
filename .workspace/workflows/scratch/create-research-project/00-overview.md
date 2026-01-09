---
title: Create Research Project
description: Scaffold a new research project in .scratch/projects/.
access: human
---

# Create Research Project

Scaffold a new research project with isolated scope, memory, and continuity.

## Usage

```text
/research <slug>
```

**Example:**
```text
/research agent-memory-patterns
```

## Prerequisites

- Project slug must be lowercase with hyphens (e.g., `auth-patterns`)
- No existing project with the same slug in `.scratch/projects/`

## Steps

1. **Validate slug**
   - Must be lowercase with hyphens only (`^[a-z][a-z0-9-]*$`)
   - Must not already exist in `.scratch/projects/`
   - If invalid → STOP, report error with valid format

2. **Copy template**
   - Copy `.scratch/projects/_template/` to `.scratch/projects/<slug>/`

3. **Initialize project.md**
   - Replace `[topic]` with the slug (human-readable form)
   - Set `started:` to today's date (YYYY-MM-DD)
   - Set `last_activity:` to today's date

4. **Initialize log.md**
   - Replace `[topic]` with the slug
   - Add creation entry with today's date

5. **Update registry**
   - Add row to **Active** table in `.scratch/projects/registry.md`:
     ```markdown
     | [<slug>](.<slug>/) | [Pending goal] | YYYY-MM-DD | YYYY-MM-DD |
     ```
   - Remove placeholder row if present

6. **Prompt for goal** (interactive)
   - Ask: "What is the goal of this research?"
   - Update Goal section in `project.md` with response
   - Update registry entry with goal summary

7. **Confirm**
   - Report: "Created research project: `<slug>`"
   - List files created
   - Suggest next steps

## Output

A new research project directory ready for work:

```text
.scratch/projects/<slug>/
├── project.md     # Ready for scope/questions definition
└── log.md         # Creation entry logged
```

## Next Steps After Creation

1. Refine the goal in `project.md`
2. Define scope (in/out of scope)
3. Add key questions to answer
4. Begin research, logging progress in `log.md`

## Related

- [Scratch Area](../../../docs/architecture/workspaces/scratch.md) — Full documentation
- [Registry](.scratch/projects/registry.md) — Project tracking
- [Promote from Scratch](../promote-from-scratch.md) — Publishing findings
