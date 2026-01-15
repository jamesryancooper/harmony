---
# Identity
id: "prompt-refiner"
name: "Prompt Refiner"
version: "2.1.1"
summary: "Context-aware prompt refinement with persona assignment, anti-patterns, self-critique, and intent confirmation."
description: |
  Transforms rough, incomplete prompts into clear, actionable instructions
  with full codebase context awareness. Analyzes the repository to identify
  relevant files, patterns, and constraints. Assigns appropriate execution
  persona, defines negative constraints (what NOT to do), performs self-critique
  to catch gaps, and confirms intent with user before finalizing.
access: agent

# Provenance
author:
  name: "Harmony Workspace"
  contact: "workspace@harmony"
created_at: "2025-01-14"
updated_at: "2025-01-14"
license: "MIT"

# Invocation
commands:
  - /refine-prompt
explicit_call_patterns:
  - "use skill: prompt-refiner"
triggers:
  - "refine my prompt"
  - "improve this prompt"
  - "expand this prompt"
  - "spell check my prompt"
  - "clarify my prompt"
  - "analyze and improve my prompt"

# I/O Contract
inputs:
  - name: raw_prompt
    type: text
    required: true
    path_hint: "inline text or file path"
    schema: null
    description: "The raw prompt text to refine (inline or from file)"
  - name: execute
    type: boolean
    required: false
    path_hint: "flag"
    schema: null
    description: "Execute the refined prompt after saving (default: false)"
  - name: context_depth
    type: text
    required: false
    path_hint: "minimal/standard/deep"
    schema: null
    description: "How deep to analyze repository context (default: standard)"
  - name: skip_confirmation
    type: text
    required: false
    path_hint: "true/false"
    schema: null
    description: "Skip intent confirmation step (default: false)"

outputs:
  - name: refined_prompt
    type: markdown
    path: "outputs/prompts/<timestamp>-refined.md"
    format: "markdown"
    determinism: "stable"
    description: "The refined, improved prompt ready for execution"
  - name: run_log
    type: log
    path: "logs/runs/<timestamp>-prompt-refiner.md"
    format: "yaml-frontmatter-markdown"
    determinism: "stable"

# Dependencies
requires:
  tools:
    - filesystem.read
    - filesystem.write.outputs
    - filesystem.glob
    - filesystem.grep
  packages: []
  services: []
depends_on: []

# Safety Policies
safety:
  tool_policy:
    mode: deny-by-default
    allowed:
      - filesystem.read
      - filesystem.write.outputs
      - filesystem.glob
      - filesystem.grep
  file_policy:
    write_scope:
      - ".workspace/skills/outputs/**"
      - ".workspace/skills/logs/**"
    destructive_actions: never

# Behavior (structured for machine parsing)
behavior:
  phases:
    - name: "Context Analysis"
      steps:
        - "Analyze repository structure and tech stack"
        - "Identify scope: files and modules the prompt likely touches"
        - "Load project constraints from .workspace/context/constraints.md"
        - "Find existing patterns relevant to the request"
    - name: "Intent Extraction"
      steps:
        - "Parse raw prompt and identify core intent"
        - "Expand implicit goals into explicit requirements"
        - "Correct spelling, grammar, and formatting"
        - "Remove contradictions or flag for clarification"
    - name: "Persona Assignment"
      steps:
        - "Determine appropriate expertise level for the task"
        - "Assign execution persona (role, perspective, depth)"
        - "Set tone and style expectations"
    - name: "Reference Injection"
      steps:
        - "Add specific file paths the task will touch"
        - "Include relevant function/class names"
        - "Reference existing patterns to follow"
        - "Align with project naming and style conventions"
    - name: "Negative Constraints"
      steps:
        - "Identify anti-patterns to avoid"
        - "List forbidden approaches based on project rules"
        - "Surface common mistakes for this type of task"
        - "Define what NOT to do"
    - name: "Decomposition"
      steps:
        - "Break complex requests into ordered sub-tasks"
        - "Identify dependencies between sub-tasks"
        - "Order tasks by logical execution sequence"
    - name: "Validation"
      steps:
        - "Check feasibility given codebase state"
        - "Identify potential risks and breaking changes"
        - "Flag edge cases and dependencies"
        - "Define measurable success criteria"
    - name: "Self-Critique"
      steps:
        - "Review refined prompt for completeness"
        - "Check for missing context or ambiguity"
        - "Verify all assumptions are stated"
        - "Ensure success criteria are measurable"
        - "Fix any gaps found"
    - name: "Intent Confirmation"
      steps:
        - "Summarize understanding of the request"
        - "Present key decisions and assumptions"
        - "Ask user to confirm or correct"
        - "Incorporate feedback if provided"
    - name: "Output"
      steps:
        - "Structure refined prompt with all context"
        - "Save to outputs/prompts/<timestamp>-refined.md"
        - "Log execution to logs/runs/"
        - "Optionally execute the refined prompt"
  goals:
    - "Ground the prompt in actual codebase context"
    - "Determine the true intent behind the raw prompt"
    - "Assign appropriate execution persona"
    - "Fill gaps with codebase-informed assumptions"
    - "Inject specific references (files, patterns, conventions)"
    - "Define what NOT to do (anti-patterns, forbidden approaches)"
    - "Decompose complex requests into actionable sub-tasks"
    - "Validate feasibility and identify risks"
    - "Self-critique to catch gaps before finalization"
    - "Confirm intent with user to prevent wasted effort"
    - "Produce a clear, actionable, context-aware refined prompt"

# Validation
acceptance_criteria:
  - "Refined prompt exists in outputs/prompts/"
  - "Persona is assigned with clear role and expertise level"
  - "Context section includes relevant file paths"
  - "Negative constraints section lists what to avoid"
  - "Core intent is preserved and clarified"
  - "All spelling/grammar errors corrected"
  - "Complex requests are decomposed into sub-tasks"
  - "Risks and edge cases are identified"
  - "Success criteria are defined and measurable"
  - "Self-critique pass completed with no major gaps"
  - "Intent confirmed with user (unless skipped)"
  - "Run log captures input, context, and output"

# Examples (for testing and documentation)
examples:
  - input: "add caching to the api"
    invocation: "/refine-prompt 'add caching to the api'"
    output: "outputs/prompts/20250114-120000-refined.md"
    description: "Context-aware refinement with persona, anti-patterns, and self-critique"
  - input: "refactor the auth module"
    invocation: "/refine-prompt 'refactor the auth module' --context_depth=deep"
    output: "outputs/prompts/20250114-120100-refined.md"
    description: "Deep analysis refactoring with comprehensive risk assessment"
---

# Skill: prompt-refiner

## Mission

Transform rough, incomplete prompts into clear, actionable instructions by analyzing repository context, assigning execution persona, expanding intent, injecting specific references, defining negative constraints, decomposing complex tasks, validating feasibility, performing self-critique, and confirming intent with the user.

## Behavior

### Phase 1: Context Analysis

Before refining, understand the codebase:

1. **Analyze repository**
   - Detect tech stack (languages, frameworks, build tools)
   - Map directory structure and module boundaries
   - Identify architectural patterns in use

2. **Identify scope**
   - Find files/modules the prompt likely touches
   - Use keyword matching and semantic analysis
   - Note related files that may need updates

3. **Load constraints**
   - Read `.workspace/context/constraints.md` if present
   - Check for project-specific rules (testing requirements, style guides)
   - Note any "always" or "never" rules that apply

4. **Find prior art**
   - Locate similar patterns already in the codebase
   - Find related implementations to reference
   - Identify conventions to follow

### Phase 2: Intent Extraction

Parse and clarify the raw prompt:

1. **Parse intent**
   - Identify the core goal and desired outcome
   - Note implicit assumptions and unstated context
   - Distinguish between requirements and preferences

2. **Expand scope**
   - Convert implicit goals into explicit requirements
   - Add context that makes the prompt self-contained
   - Fill gaps with codebase-informed assumptions

3. **Correct errors**
   - Fix spelling mistakes
   - Correct grammar issues
   - Improve formatting and structure

4. **Resolve ambiguity**
   - Identify contradictory statements
   - Resolve contradictions using codebase context
   - Flag unresolvable conflicts for user input

### Phase 3: Persona Assignment

Define who should execute this prompt:

1. **Determine expertise level**
   - Junior: Simple, well-documented tasks
   - Mid-level: Standard features, moderate complexity
   - Senior: Architecture decisions, complex refactoring
   - Principal/Staff: Cross-cutting concerns, system design

2. **Assign role perspective**
   - Backend engineer, Frontend developer, DevOps, Security engineer, etc.
   - Full-stack if task spans multiple areas
   - Specialist if domain expertise needed

3. **Set execution style**
   - Thorough vs. quick iteration
   - Conservative vs. innovative
   - Verbose documentation vs. minimal comments

4. **Define success mindset**
   - What does "excellent" look like for this task?
   - What quality bar should be met?

### Phase 4: Reference Injection

Ground the prompt in specific codebase details:

1. **Add file references**
   - List specific files that will be modified
   - Include paths to related files for context
   - Note files that may need coordinated changes

2. **Include code references**
   - Name specific functions, classes, or modules
   - Reference line numbers for targeted changes
   - Include type signatures where helpful

3. **Reference patterns**
   - Point to existing implementations as examples
   - Note conventions to follow (naming, structure, style)
   - Include test patterns if tests are needed

4. **Align conventions**
   - Match project naming conventions
   - Follow existing code organization patterns
   - Respect architectural boundaries

### Phase 5: Negative Constraints

Define what NOT to do:

1. **Identify anti-patterns**
   - Common mistakes for this type of task
   - Anti-patterns present elsewhere in codebase to avoid replicating
   - Known problematic approaches

2. **List forbidden approaches**
   - Approaches that violate project constraints
   - Deprecated patterns or APIs
   - Security-sensitive operations to avoid

3. **Surface project-specific rules**
   - "Never" rules from constraints.md
   - Team conventions that must be followed
   - Architectural boundaries not to cross

4. **Define scope boundaries**
   - What's out of scope for this task
   - Related changes to explicitly NOT make
   - Future work to defer (not solve now)

### Phase 6: Decomposition

Break complex requests into manageable pieces:

1. **Identify sub-tasks**
   - Break the request into discrete, atomic tasks
   - Each sub-task should be independently completable
   - Aim for 2-7 sub-tasks depending on complexity

2. **Map dependencies**
   - Identify which tasks depend on others
   - Note shared resources or potential conflicts
   - Flag tasks that can run in parallel

3. **Order execution**
   - Sequence tasks by logical dependency
   - Group related changes together
   - Place validation/testing steps appropriately

### Phase 7: Validation

Verify the refined prompt is achievable:

1. **Check feasibility**
   - Verify referenced files exist
   - Confirm patterns being referenced are applicable
   - Check for missing dependencies or prerequisites

2. **Identify risks**
   - Flag potential breaking changes
   - Note files with many dependents
   - Identify security-sensitive areas

3. **Surface edge cases**
   - List scenarios that need handling
   - Note error conditions to consider
   - Identify integration points that may break

4. **Define success criteria**
   - Specify measurable "done" conditions
   - Include verification steps (tests, manual checks)
   - Define rollback criteria if applicable

### Phase 8: Self-Critique

Review the refined prompt before finalization:

1. **Completeness check**
   - Is all necessary context included?
   - Are there gaps in the requirements?
   - Would someone unfamiliar with the codebase understand this?

2. **Ambiguity check**
   - Are there any remaining unclear terms?
   - Could any requirement be interpreted multiple ways?
   - Are all assumptions explicitly stated?

3. **Feasibility check**
   - Is the scope realistic?
   - Are the success criteria measurable?
   - Are there any contradictions?

4. **Quality check**
   - Is the persona appropriate?
   - Are the negative constraints comprehensive?
   - Is the decomposition logical?

5. **Fix gaps**
   - Address any issues found
   - Add missing context
   - Clarify ambiguities

### Phase 9: Intent Confirmation

Verify understanding with the user:

1. **Summarize understanding**
   - State the core intent in one sentence
   - List the key requirements (3-5 bullets)
   - Note the most significant assumptions

2. **Present key decisions**
   - Highlight choices made during refinement
   - Explain reasoning for non-obvious decisions
   - Flag any areas of uncertainty

3. **Request confirmation**
   - Ask user: "Is this what you intended?"
   - Provide option to adjust or proceed
   - If `skip_confirmation=true`, skip this step

4. **Incorporate feedback**
   - If user provides corrections, update the prompt
   - Re-run self-critique if significant changes made
   - Document any changes from original refinement

### Phase 10: Output

Produce the final refined prompt:

1. **Structure output**
   - Organize with clear sections
   - Lead with persona, then context, then requirements
   - End with negative constraints and success criteria

2. **Save artifacts**
   - Write to `outputs/prompts/<timestamp>-refined.md`
   - Log to `logs/runs/<timestamp>-prompt-refiner.md`

3. **Execute (optional)**
   - If `--execute`, run the refined prompt
   - Report execution result

## Output Format

```markdown
# Refined Prompt

**Original:** [quoted original prompt]
**Refined:** [timestamp]
**Context Depth:** [minimal/standard/deep]
**Status:** [confirmed/pending confirmation]

---

## Execution Persona

**Role:** [e.g., Senior Backend Engineer]
**Expertise Level:** [Junior/Mid/Senior/Principal]
**Perspective:** [e.g., Focus on performance and maintainability]
**Style:** [e.g., Thorough, well-documented, conservative]

---

## Repository Context

**Tech Stack:** [detected languages, frameworks, tools]
**Relevant Modules:** [list of modules/directories in scope]

### Files in Scope

| File | Role | Action |
|------|------|--------|
| `path/to/file.ts` | [what it does] | [modify/create/reference] |
| ... | ... | ... |

### Existing Patterns to Follow

- **Pattern:** [name] in `path/to/example.ts:42`
  - [brief description of the pattern]

### Project Constraints

- [Constraint from .workspace/context/constraints.md]
- [Another constraint]

---

## Intent

[Clear statement of what the user wants to accomplish]

## Requirements

1. [Explicit requirement 1]
2. [Explicit requirement 2]
3. [...]

## Assumptions Made

- [Assumption 1: reasoning based on codebase context]
- [Assumption 2: reasoning]

## Clarifications

| Original | Resolution | Rationale |
|----------|------------|-----------|
| [ambiguity] | [resolution] | [why this choice] |

---

## Negative Constraints (What NOT To Do)

### Anti-Patterns to Avoid

- **Don't:** [anti-pattern 1]
  - Why: [reason this is problematic]
- **Don't:** [anti-pattern 2]
  - Why: [reason]

### Forbidden Approaches

- [Forbidden approach 1] — [reason]
- [Forbidden approach 2] — [reason]

### Out of Scope

- [Thing explicitly NOT to do as part of this task]
- [Related change to defer to future work]

---

## Sub-Tasks

### Task 1: [Name]

**Files:** `path/to/file.ts`
**Depends on:** None
**Description:** [what to do]

### Task 2: [Name]

**Files:** `path/to/other.ts`
**Depends on:** Task 1
**Description:** [what to do]

[...]

---

## Risks & Edge Cases

| Risk | Severity | Mitigation |
|------|----------|------------|
| [potential issue] | High/Medium/Low | [how to handle] |

### Edge Cases to Handle

- [ ] [Edge case 1]
- [ ] [Edge case 2]

---

## Success Criteria

- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Tests pass / build succeeds]
- [ ] [No regressions in related functionality]

---

## Self-Critique Results

| Check | Status | Notes |
|-------|--------|-------|
| Completeness | ✓/✗ | [notes] |
| Ambiguity | ✓/✗ | [notes] |
| Feasibility | ✓/✗ | [notes] |
| Quality | ✓/✗ | [notes] |

**Issues Found & Fixed:**
- [Issue 1: how it was resolved]
- [None if clean]

---

## Intent Confirmation

**Summary:** [One-sentence summary of what will be done]

**Key Decisions:**
1. [Decision 1 and reasoning]
2. [Decision 2 and reasoning]

**User Response:** [Confirmed / Adjusted: details / Pending]

---

## Refined Prompt

[The actual refined prompt text, ready for execution - self-contained with all context needed, including persona, requirements, negative constraints, and success criteria]

---
```

## Boundaries

- Never change the core intent of the original prompt
- Always preserve the user's explicit preferences
- State all assumptions - never silently assume
- Reference only files that actually exist
- Do not execute unless explicitly requested
- Write only to designated output paths
- If contradictions cannot be resolved, ask before proceeding
- Limit context analysis to reasonable scope (don't scan entire monorepo)
- Always perform self-critique before finalizing
- Always confirm intent unless explicitly skipped

## When to Escalate

- If the prompt has unresolvable contradictions, ask which option to prefer
- If the intent is completely unclear, ask one clarifying question
- If referenced files don't exist, ask for clarification
- If the request conflicts with project constraints, flag the conflict
- If the scope is too large (>20 files), suggest narrowing focus
- If domain expertise is needed to fill gaps accurately, note the limitation
- If self-critique reveals major issues, flag for user review
- If user rejects intent confirmation, iterate on refinement

## Context Depth Levels

| Level | Behavior |
|-------|----------|
| `minimal` | Skip repo analysis, basic intent expansion only |
| `standard` | Analyze immediate scope, find relevant patterns (default) |
| `deep` | Full repo analysis, dependency mapping, comprehensive risk assessment |

## Persona Selection Guide

| Task Type | Recommended Persona |
|-----------|---------------------|
| Bug fix (isolated) | Mid-level engineer, focused, minimal changes |
| New feature | Senior engineer, thorough, well-documented |
| Refactoring | Senior/Principal engineer, conservative, comprehensive testing |
| Performance optimization | Senior engineer with perf focus, data-driven |
| Security fix | Security-focused engineer, paranoid, thorough |
| Documentation | Technical writer perspective, clear, comprehensive |
| API design | Principal engineer, API design expertise, future-proof |

## Common Anti-Patterns by Task Type

| Task Type | Common Anti-Patterns |
|-----------|---------------------|
| Bug fix | Over-engineering, fixing unrelated code, missing root cause |
| New feature | Scope creep, premature optimization, insufficient error handling |
| Refactoring | Changing behavior, incomplete migration, breaking interfaces |
| Performance | Micro-optimizations, premature caching, sacrificing readability |
| Security | Security through obscurity, incomplete validation, logging secrets |

## Examples

### Example 1: API Caching (Full Refinement)

**Input:**
```text
/refine-prompt "add caching to the api"
```

**Refined Output:**
```markdown
# Refined Prompt

**Original:** "add caching to the api"
**Refined:** 2025-01-14T12:00:00Z
**Context Depth:** standard
**Status:** confirmed

---

## Execution Persona

**Role:** Senior Backend Engineer
**Expertise Level:** Senior
**Perspective:** Focus on performance, cache consistency, and maintainability
**Style:** Thorough, well-documented, follows existing patterns exactly

---

## Repository Context

**Tech Stack:** Node.js, Express, TypeScript, Redis (already configured)
**Relevant Modules:** `packages/api/src/`

### Files in Scope

| File | Role | Action |
|------|------|--------|
| `packages/api/src/middleware/cache.ts` | Existing cache middleware | Reference pattern |
| `packages/api/src/routes/users.ts` | User endpoints | Modify (add caching) |
| `packages/api/src/routes/products.ts` | Product endpoints | Modify (add caching) |
| `packages/api/src/config/redis.ts` | Redis configuration | Reference |

### Existing Patterns to Follow

- **Pattern:** Response caching in `packages/api/src/middleware/cache.ts:15`
  - Uses Redis with TTL, cache key based on route + query params
  - Includes cache invalidation on mutations

### Project Constraints

- All middleware must have unit tests
- Cache TTLs must be configurable via environment variables

---

## Intent

Add response caching to API endpoints to improve performance and reduce database load.

## Requirements

1. Implement caching for GET endpoints on users and products routes
2. Use existing Redis configuration and cache middleware pattern
3. Make TTL configurable per endpoint via environment variables
4. Implement cache invalidation on POST/PUT/DELETE

## Assumptions Made

- Using existing Redis instance (already configured in codebase)
- Following existing cache middleware pattern exactly
- Cache keys include user context for personalized responses
- Only GET endpoints should be cached (mutations always hit DB)

---

## Negative Constraints (What NOT To Do)

### Anti-Patterns to Avoid

- **Don't:** Implement a new caching mechanism
  - Why: Existing pattern in `cache.ts` is proven and consistent
- **Don't:** Cache POST/PUT/DELETE responses
  - Why: Mutations must always reflect current state
- **Don't:** Use hardcoded TTL values
  - Why: Project constraint requires env var configuration

### Forbidden Approaches

- Creating a new Redis connection — use existing `config/redis.ts`
- Caching user-specific data without user ID in cache key — causes data leaks
- Skipping cache invalidation — causes stale data bugs

### Out of Scope

- Caching at the CDN/edge level (future work)
- Cache warming strategies (not needed for initial implementation)
- Metrics/monitoring for cache hit rates (separate task)

---

## Sub-Tasks

### Task 1: Extend cache middleware

**Files:** `packages/api/src/middleware/cache.ts`
**Depends on:** None
**Description:** Add configurable TTL support and user-context cache keys

### Task 2: Add caching to user routes

**Files:** `packages/api/src/routes/users.ts`
**Depends on:** Task 1
**Description:** Apply cache middleware to GET /users and GET /users/:id

### Task 3: Add caching to product routes

**Files:** `packages/api/src/routes/products.ts`
**Depends on:** Task 1
**Description:** Apply cache middleware to GET /products and GET /products/:id

### Task 4: Add cache invalidation

**Files:** `packages/api/src/routes/users.ts`, `packages/api/src/routes/products.ts`
**Depends on:** Task 2, Task 3
**Description:** Invalidate relevant cache entries on mutations

### Task 5: Add tests

**Files:** `packages/api/src/middleware/__tests__/cache.test.ts`
**Depends on:** Task 1
**Description:** Unit tests for new cache middleware features

---

## Risks & Edge Cases

| Risk | Severity | Mitigation |
|------|----------|------------|
| Stale data after mutations | High | Implement cache invalidation in Task 4 |
| Cache key collisions | Medium | Include user ID in cache key |
| Redis connection failures | Low | Existing fallback returns uncached response |

### Edge Cases to Handle

- [ ] Paginated endpoints need page/limit in cache key
- [ ] Filtered queries need filter params in cache key
- [ ] Admin users may need separate cache or bypass

---

## Success Criteria

- [ ] Cache middleware supports configurable TTL via env vars
- [ ] GET endpoints return cached responses on subsequent calls
- [ ] Mutations invalidate relevant cache entries
- [ ] All new code has test coverage (>80%)
- [ ] No performance regression (response time <= before + 10ms)
- [ ] No stale data observed after mutations

---

## Self-Critique Results

| Check | Status | Notes |
|-------|--------|-------|
| Completeness | ✓ | All necessary context included |
| Ambiguity | ✓ | Requirements are specific and measurable |
| Feasibility | ✓ | All referenced files exist, pattern is applicable |
| Quality | ✓ | Persona appropriate, anti-patterns comprehensive |

**Issues Found & Fixed:**
- Added explicit note about user ID in cache key to prevent data leaks
- Clarified that only GET endpoints should be cached

---

## Intent Confirmation

**Summary:** Add Redis-based response caching to user and product GET endpoints, following the existing cache middleware pattern, with proper invalidation on mutations.

**Key Decisions:**
1. Using existing cache pattern (not creating new) — consistency
2. Cache keys will include user ID — prevents data leaks
3. TTLs via env vars — meets project constraint

**User Response:** Confirmed

---

## Refined Prompt

**Persona:** Act as a Senior Backend Engineer focused on performance and cache consistency. Be thorough and well-documented. Follow existing patterns exactly.

**Task:** Implement response caching for the API using the existing Redis configuration and cache middleware pattern.

**Context:**
- Redis config: `packages/api/src/config/redis.ts`
- Cache pattern: `packages/api/src/middleware/cache.ts:15`

**Requirements:**

1. Extend `packages/api/src/middleware/cache.ts`:
   - Add configurable TTL parameter (read from env vars)
   - Include user ID in cache key for personalized responses
   - Add cache invalidation helper function

2. Apply caching to routes:
   - `packages/api/src/routes/users.ts`: Cache GET /users (TTL: 5min), GET /users/:id (TTL: 10min)
   - `packages/api/src/routes/products.ts`: Cache GET /products (TTL: 15min), GET /products/:id (TTL: 30min)

3. Implement cache invalidation:
   - POST/PUT/DELETE on /users invalidates user cache
   - POST/PUT/DELETE on /products invalidates product cache

4. Add tests in `packages/api/src/middleware/__tests__/cache.test.ts`

**Do NOT:**
- Create a new caching mechanism (use existing pattern)
- Cache POST/PUT/DELETE responses
- Use hardcoded TTL values (must be env vars)
- Create new Redis connections (use existing config)
- Cache without user ID in key (causes data leaks)

**Success Criteria:**
- [ ] TTLs configurable via env vars
- [ ] Cached responses on repeated GET calls
- [ ] Cache invalidated on mutations
- [ ] Test coverage >80%
- [ ] No performance regression

---
```

## References

For detailed reference materials, see `reference/` directory.
For executable helpers, see `scripts/` directory.
