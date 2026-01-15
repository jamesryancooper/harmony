# Harmony Primitives

This document explains the core building blocks in Harmony and when to use each.

## Quick Reference

| Primitive | Purpose | Invocation | State |
|-----------|---------|------------|-------|
| **Skill** | Composable capability with I/O contract | `/command`, `use skill:`, triggers | Stateless |
| **Command** | Lightweight entry point | `/command` | Stateless |
| **Workflow** | Multi-step procedure with checkpoints | Referenced by command or direct | Stateful |
| **Assistant** | Persona-based specialist | `@mention` | Stateless |
| **Checklist** | Quality gate for verification | Referenced at checkpoints | Stateless |
| **Prompt** | Task template with structured I/O | Copy/paste or direct reference | Stateless |
| **Template** | Scaffolding for new structures | Copied to target location | N/A |

---

## Skills

**Location:** `.harmony/skills/<skill-id>/SKILL.md`

**Purpose:** Reusable, composable capabilities with explicit input/output contracts.

### Characteristics

- Full `SKILL.md` specification with inputs, outputs, dependencies
- Invoked via `/command`, `use skill: <id>`, or natural language triggers
- Stateless and portable (symlinked to harness directories)
- Writes only to `.workspace/skills/outputs/**` and `logs/**`
- Can be chained into pipelines via registry

### When to Use

- Task is reusable across projects or sessions
- Clear discrete inputs → outputs
- You want pipeline composition (chain skills together)
- The capability should be portable to other repositories

### Examples

- `research-synthesizer`: notes → synthesis document
- `prompt-refiner`: rough prompt → context-aware refined prompt

### Template

See `.harmony/skills/_template/SKILL.md`

---

## Commands

**Location:** `.harmony/commands/<command>.md`

**Purpose:** Lightweight entry points—often gateways to workflows or simple operations.

### Characteristics

- Minimal frontmatter: `description`, `access` (human/agent)
- Often delegates to a workflow for implementation
- Access control: `human` (has IDE wrapper) or `agent` (agent-only)
- Symlinked to harness command directories

### When to Use

- Simple atomic operation with lightweight docs
- Quick interface to a complex workflow
- Access control between humans and agents matters
- One-off session task that doesn't need full skill spec

### Examples

- `/refactor` → delegates to `.harmony/workflows/refactor/`
- `/recover` → error recovery procedures
- `/validate-frontmatter` → check markdown metadata

---

## Workflows

**Location:** `.harmony/workflows/<workflow-name>/`

**Purpose:** Multi-step procedures with progression gates, checkpoints, and idempotent execution.

### Structure

```
workflow-name/
├── 00-overview.md      # Problem, prerequisites, step list, verification gate
├── 01-first-step.md    # Input, actions, idempotency check, checkpoint
├── 02-second-step.md
├── ...
└── NN-verify.md        # Final verification gate (mandatory)
```

### Characteristics

- **Stateful:** Maintains progress across sessions
- **Checkpointed:** Can pause and resume at specific steps
- **Idempotent:** Each step detects if already complete; safe to re-run
- **Gated:** Cannot proceed until verification passes
- **Continuity-aware:** Historical records are append-only

### When to Use

- Complex multi-step procedure that might need to pause/resume
- Idempotent re-execution is important (safe to re-run any step)
- Progress tracking and checkpoint recovery needed
- Mandatory verification gates required
- Audit trail / historical continuity matters

### Examples

- `refactor/`: define scope → audit → plan → execute → verify → document
- `create-mission/`: scaffold missions with isolated progress tracking
- `create-workspace/`: validate → analyze → gather → copy → customize → verify

### Template

See `.harmony/workflows/_template/`

---

## Assistants

**Location:** `.harmony/assistants/<assistant-name>/assistant.md`

**Registry:** `.harmony/assistants/registry.yml`

**Purpose:** Persona-based specialists with defined missions, rules, and output formats.

### Characteristics

- Invoked via `@mention` aliases (e.g., `@reviewer`, `@docs`)
- Has a defined mission, operating rules, and boundaries
- Produces structured output in a consistent format
- Can escalate to other assistants or humans when appropriate
- Registered in `registry.yml` with aliases

### When to Use

- Task benefits from a specialized persona/role
- Consistent output format is important
- You want delegation between specialists
- The "who" matters as much as the "what"

### Examples

- `@reviewer` / `@rev`: Code review for quality, style, correctness, security
- `@refactor` / `@ref`: Code improvement specialist
- `@docs` / `@doc`: Documentation clarity and completeness

### Structure

```yaml
# registry.yml entry
- name: reviewer
  path: reviewer/
  aliases: ["@review", "@rev"]
  description: "Code review specialist..."
```

```markdown
# assistant.md sections
- Mission
- Invocation
- Operating Rules
- Output Format
- Boundaries
- When to Escalate
```

---

## Checklists

**Location:** `.harmony/checklists/<checklist>.md`

**Purpose:** Quality gates and verification criteria for specific checkpoints.

### Characteristics

- Used at defined points (task completion, session exit, etc.)
- Contains actionable checkbox items
- Often includes common failure modes and prevention
- Referenced by workflows at verification steps

### When to Use

- Ensuring consistent quality at checkpoints
- Preventing common failure modes
- Standardizing "definition of done"
- Session boundaries (start/exit)

### Examples

- `complete.md`: Definition of done for any task
- `session-exit.md`: Checklist before ending a session

### Structure

```markdown
## Before [Action]

- [ ] Criterion 1
- [ ] Criterion 2

## Quality Criteria

### For [Category]
- [ ] Specific check

## Common Failure Modes

| Failure | Prevention |
|---------|------------|
| Mode 1  | How to avoid |
```

---

## Prompts

**Location:** `.harmony/prompts/<prompt>.md` or `.harmony/prompts/<category>/<prompt>.md`

**Purpose:** Task templates with structured context, instructions, and expected output.

### Characteristics

- Frontmatter with `title`, `description`, `access`
- Context section (1-2 sentences)
- Numbered instructions
- Defined output format/template
- Less formal than skills (no I/O contract, no safety policy)

### When to Use

- Common task that benefits from structure
- You want consistent output format
- Task doesn't need full skill machinery
- Quick-start templates for sessions or research

### Examples

- `bootstrap-session.md`: Quick-start a new agent session
- `research/analyze-sources.md`: Analyze research sources
- `research/synthesize-findings.md`: Synthesize research findings

### Structure

```markdown
---
title: Prompt Name
description: What this prompt does
access: human
---

# Prompt Name

## Context
[1-2 sentence setup]

## Instructions
1. Step one
2. Step two

## Output
[Expected format or template]
```

---

## Templates

**Location:** `.harmony/templates/<template-name>/`

**Purpose:** Scaffolding for creating new structures (workspaces, projects, etc.).

### Characteristics

- Directory structure copied to target location
- Contains placeholder files to be customized
- Often used by workflows (e.g., `create-workspace` workflow)
- Not executed—just copied and modified

### When to Use

- Creating new workspaces
- Bootstrapping project structures
- Ensuring consistent initial structure
- Providing starting-point files

### Examples

- `workspace/`: Base workspace structure
- `workspace-docs/`: Documentation-focused workspace variant
- `workspace-node-ts/`: Node.js + TypeScript workspace variant

### Structure

```
templates/
├── workspace/           # Base template
│   ├── START.md
│   ├── scope.md
│   ├── conventions.md
│   ├── catalog.md
│   ├── context/
│   └── progress/
├── workspace-docs/      # Variant for docs projects
└── workspace-node-ts/   # Variant for Node+TS projects
```

---

## Decision Matrix

| Situation | Choose | Reason |
|-----------|--------|--------|
| Reusable task with clear I/O | **Skill** | Composable, portable, pipelines |
| Quick interface to complex work | **Command** | Lightweight gateway |
| Multi-step with possible interruption | **Workflow** | Checkpoints, resumption |
| Needs mandatory verification | **Workflow** | Gates prevent incomplete work |
| Task benefits from specialist persona | **Assistant** | Mission, rules, escalation |
| Quality gate at checkpoint | **Checklist** | Consistent verification |
| Common task needing structure | **Prompt** | Template without full skill spec |
| Bootstrapping new structure | **Template** | Copy and customize |
| One-off session task | **Command** | No persistence needed |
| Cross-project reuse | **Skill** | Symlinked, versioned |
| Access control (human vs agent) | **Command** | `access` field support |

---

## Conceptual Groupings

### By Question Answered

| Question | Primitive |
|----------|-----------|
| What reusable capability? | **Skill** |
| What action to take? | **Command** |
| What multi-step procedure? | **Workflow** |
| Who does this work? | **Assistant** |
| Is this done correctly? | **Checklist** |
| How do I start this task? | **Prompt** |
| What structure do I copy? | **Template** |

### By Lifecycle Phase

| Phase | Primitives |
|-------|------------|
| **Setup** | Template, Prompt (bootstrap) |
| **Execution** | Skill, Command, Workflow, Assistant |
| **Verification** | Checklist, Workflow (verify step) |

---

## Example Scenarios

### "Consolidate research notes from multiple files"

→ **Skill** (`research-synthesizer`)

Discrete input (notes), discrete output (synthesis doc), reusable across projects.

### "Run a refactor that might take multiple sessions"

→ **Workflow** (`refactor/`)

Checkpointed, idempotent, verification gate ensures completeness before marking done.

### "Quick way to validate markdown frontmatter"

→ **Command** (`/validate-frontmatter`)

Atomic operation, simple interface, no state needed.

### "Get a code review with consistent format"

→ **Assistant** (`@reviewer`)

Persona with defined output format, operating rules, and escalation paths.

### "Ensure task meets quality standards before marking done"

→ **Checklist** (`complete.md`)

Verification gate with actionable criteria and failure mode prevention.

### "Start a new research task with structure"

→ **Prompt** (`research/analyze-sources.md`)

Template with context, instructions, and expected output format.

### "Create a new workspace for a subproject"

→ **Template** (via `create-workspace` workflow)

Scaffolding copied and customized for the new workspace.

### "Chain prompt refinement → research synthesis"

→ **Skills pipeline**

Registry supports `pipelines` section for skill composition without manual orchestration.

---

## Related Resources

| Primitive | Registry | Template |
|-----------|----------|----------|
| Skills | `.harmony/skills/registry.yml` | `.harmony/skills/_template/` |
| Commands | — | — |
| Workflows | — | `.harmony/workflows/_template/` |
| Assistants | `.harmony/assistants/registry.yml` | `.harmony/assistants/_template/` |
| Checklists | — | — |
| Prompts | — | — |
| Templates | — | `.harmony/templates/` |
