# Research Projects

This registry tracks active, paused, and completed research projects.

---

## Active

| Project | Goal | Started | Last Activity |
|---------|------|---------|---------------|
| — | *No active projects* | — | — |

---

## Paused

| Project | Goal | Paused Reason |
|---------|------|---------------|
| — | *No paused projects* | — |

---

## Completed

| Project | Goal | Completed | Promoted To |
|---------|------|-----------|-------------|
| — | *No completed projects* | — | — |

---

## How to Use

### Starting a New Project

**Via command (works in any AI harness):**
```text
/research <slug>
```

**Manually:**
1. Copy `_template/` to `projects/<slug>/`
2. Fill in `project.md` with goal, scope, and key questions
3. Add entry to **Active** table above
4. Begin research, logging progress in `log.md`

See `.workspace/workflows/scratch/create-research-project/00-overview.md` for full workflow.

### During Research

- Update `log.md` with session notes
- Create additional files as needed (`sources.md`, `notes/`, etc.)
- Update `Last Activity` in registry

### Completing Research

1. Summarize findings in `project.md`
2. Use `workflows/promote-from-scratch.md` to publish insights
3. Move entry from **Active** to **Completed**
4. Note where findings were promoted

### Pausing Research

1. Document pause reason in `project.md`
2. Move entry from **Active** to **Paused**
3. Resume by moving back to **Active**
