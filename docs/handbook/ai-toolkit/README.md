# AI-ToolKit — The AI-Powered, Opinionated, Unified Toolset for Small Teams

A modular, local-first toolkit that lets a tiny team ship outsized results with AI. It’s opinionated where it matters (interfaces, safety, structure) and flexible everywhere else. Everything is a **kit** with a crisp purpose, clear inputs/outputs, and predictable integration points.

---

## The Problem with Multi-Agent Workflows

In today’s software-development landscape, small teams are under pressure to deliver ever more features, faster, and with higher reliability. At the same time, the rise of multi-agent AI workflows brings enormous promise — but also significant, often unaddressed risks.

- When multiple AI agents coordinate without strong structure, teams often encounter duplication of effort, circular loops or dead-locks in reasoning.
- The lack of clear role definitions, shared memory/context, and orchestration leads to brittle systems that break under pressure.
- Agents can complete tasks but still fail to resolve the correct intent, or produce technically plausible but contextually inappropriate results.
- Without guardrails and observability, multi-agent systems magnify risks of misalignment, cascading errors, non-deterministic outcomes, and reduced trust in AI-powered workflows.
- Complexity often dominates: tool proliferation, tangled interfaces, scattered data flows — resulting in slower development, harder debugging, and compromised speed or safety.

### Delivering on the Promise of Multi-Agent Workflows And AI-Accelerated Development

We envision a modular, local-first toolkit that empowers a tiny team to ship outsized results with AI. This vision rests on delivering **clear, predictable building blocks (kits)** that enforce structure where necessary, yet remain flexible elsewhere. Every element is aligned with the broader Harmony Framework — prioritising simplicity, safety-by-default, spec-first design, and rapid iteration. By transforming agentic workflows from fragile experiments into predictable, observable components, teams can scale AI-assisted development with confidence.

---

## The Purpose of the AI-Toolkit

The **AI-Toolkit** exists to accelerate software development through AI-powered automation, enabling small teams to deliver high-quality, safe, and reliable software at speed. It does this by equipping AI agents with deterministic, **guard-railed tools** — called **kits** — that bring structure, visibility, and repeatability into what would otherwise be loosely-controlled workflows.

Each kit embodies a single, crisp purpose, with clear inputs, outputs, and well-defined integration points. This ensures that AI agents operate in a **transparent, reproducible, and controlled** environment rather than drifting into undocumented or unpredictable behaviour. By guiding agents down **guarded paths**, the toolkit ensures safety, accuracy, quality, and speed — all while reducing cognitive and operational load for developers.

In alignment with Harmony’s principles of **simplicity over complexity**, **spec-first rather than ceremony**, and **flow over fluff**, the AI-Toolkit is opinionated where it matters (interfaces, safety, structure) and flexible everywhere else. It favours minimal viable complexity — only introducing additional layers when required by SLOs, compliance, or scale.

The AI-Toolkit addresses the core pitfalls encountered when implementing multiple AI agents within an automated workflow: ambiguous hand-offs, uncontrolled tool invocation, context fragmentation, cascading hallucinations or mis-reasoning, and difficulty in debugging or observing inter-agent interactions. By enforcing **deterministic tool boundaries**, **human checkpoints**, and **observability across all runs**, the toolkit transforms multi-agent complexity into measurable, predictable progress rather than uncontrolled autonomous behaviour.

In short: the AI-Toolkit is the **practical backbone** of Harmony’s promise — a modular, local-first framework that lets a tiny team ship outsized results, without sacrificing simplicity, safety, or correctness. It turns multi-agent chaos into structured, safe, high-velocity development — **fast, safe, and aligned by design**.

---

## How the kits are grouped

- **Core Workflows:** Do the work (docs, code, stack, retrieval)
- **Planning & Orchestration:** Decide *what* to do and *how* to run it
- **Knowledge & Retrieval:** Organize and query your knowledge base
- **Quality & Governance:** Keep outputs correct, consistent, and compliant
- **Automation & Delivery:** Ship changes and keep things moving
- **Development & Architecture Accelerators:** Move faster with safer scaffolds and refactors
- **Observability & Ops:** See what happened and learn
- **UI & Collaboration:** Lightweight surfaces for humans

> Notation: “Integrates with” lists the primary nearby kits; all kits log runs to **ObservaKit** and can be scheduled by **ScheduleKit**.

---

## Harmony Alignment (Lean AI-Accelerated Methodology)

Harmony is a lean, opinionated delivery method for tiny teams to ship quickly and safely on their chosen stack. It pairs spec‑first, agentic agile development in an AI‑driven IDE with a monorepo workflow and TypeScript/Python services, and bakes in SRE and DevSecOps practices. Harmony aligns with OWASP ASVS, NIST SSDF, and STRIDE, and adopts architectural principles from 12‑Factor, Monolith‑First, and Hexagonal—so you can ship fast, ship safe, and ship with confidence. For the full methodology and lifecycle overview, see apps/docs/src/content/docs/handbook/methodology/README.md.

This toolkit maps directly to Harmony. Use the kits as ready‑to‑run building blocks with AI‑driven quality, security, and reliability built in.

- **Spec‑first agentic agile, ADRs** → **SpecKit** + **PlanKit** + **Dockit**
- **Trunk‑Based Development, tiny PRs, previews** → **PatchKit** + **Vercel Previews**
- **Security by default** (OWASP ASVS v5, NIST SSDF, STRIDE) → **PolicyKit** + **EvalKit** + **GuardKit** + **VaultKit**
- **Architecture** (12‑Factor, Monolith‑First, Hexagonal) → **StackKit** + **ScaffoldKit** (+ contract tests via **TestKit**)
- **SRE guardrails** (SLIs/SLOs, error budgets) → **ObservaKit** + **BenchKit** (+ policies in **PolicyKit**)
- **Observability** (OpenTelemetry + structured logs) → **ObservaKit** (default instrumentation hooks)
- **Testing and contracts** (Playwright, Pact, Schemathesis) → **TestKit** (gates in CI)
- **Monorepo developer experience** → **Turborepo** (caching) + **ScaffoldKit** (monolith‑first template)

Harmony alignment notes are called out inline below in the relevant kits.

---

## Example Workflows

### 1) Daily Doc Refresh

1. **ScheduleKit** triggers → **PlanKit** builds “Doc Refresh”.
2. **AgentKit** runs: IngestKit → IndexKit → Dockit (PromptKit + QueryKit grounding).
3. **EvalKit** verifies structure/links/grounding/security; **TestKit** runs code blocks/contracts.
4. **PatchKit** opens PR; **NotifyKit** posts summary; **ObservaKit** stores traces.

### 2) Safe Refactor/Migration

1. Goal → **PlanKit** (analyze → codemod → validate → PR).
2. **AgentKit** executes: QueryKit (impact) → **CodeModKit** (AST changes) → DevKit (edge fixes/tests).
3. **EvalKit** runs tests/style/security (CodeQL/Semgrep/SBOM/secrets); **PatchKit** opens PR with Vercel Preview; **BenchKit** posts perf deltas; NotifyKit alerts.

### 3) New Service (from Stack Profile)

1. **StackKit** profile chosen/updated.
2. **ScaffoldKit** generates monolith-first service skeleton (Turborepo), CI, observability hooks.
3. **DevKit** implements endpoints; **SeedKit** seeds sample data.
4. **Dockit** writes how-tos; **DiagramKit** generates architecture diagrams.
5. **EvalKit** gates (contracts + security); **PatchKit** ships (preview → promote); **ReleaseKit** updates CHANGELOG.

### 4) Architecture Decision (ADR)

1. **SearchKit** pulls external evidence; **QueryKit** surfaces internal usage.
2. **StackKit** proposes decision; **DiagramKit** updates diagrams.
3. **Dockit** writes ADR; **PatchKit** opens PR; **PolicyKit/EvalKit/ComplianceKit** gate.

### 5) Incident → Postmortem

1. Incident logs collected in **ObservaKit** (OTel + structured logs).
2. **Dockit** drafts postmortem; **QueryKit** fetches timelines/PRs.
3. **PlaybookKit** runs remediation steps; **PolicyKit** adds guardrails (ASVS/SSDF tasks).
4. **PatchKit** ships fixes; **ReleaseKit** tags hotfix.

---

## Minimal, Small-Team Setup (Directory Layout)

```plaintext
/kits
  /dockit       /devkit        /stackkit
  /plankit      /agentkit      /toolkit
  /speckit      /testkit       /searchkit
  /ingestkit    /indexkit      /querykit
  /promptkit    /evalkit       /observakit
  /guardkit     /policykit     /cachekit
  /compliancekit /a11ykit      /headerskit
  /notifykit    /schedulekit   /costkit
  /codemodkit   /scaffoldkit   /playbookkit
  /diagramkit   /depkit        /benchkit
  /datasetkit   /modelkit      /releasekit
  /migrationkit /flagkit       /uikit
  /i18nkit      /seedkit       /vaultkit
/docs         (source)
/docs_out     (proposed outputs)
/ingest       (normalized sources)
/indexes      (search stores)
/runs         (traces + artifacts)
/policy       (yaml rules)
/prompts      (prompt templates)
/stack        (stack profiles)
/datasets     (goldens for RAG/eval)
```

---

## What to Build First (90/10 impact)

1. **Dockit + QueryKit + IndexKit** → instant doc quality w/ citations.
2. **EvalKit (basic)** → structure/style/links/hallucination checks.
3. **PatchKit + NotifyKit** → painless approvals and shipping (PR previews on Vercel).
4. **ObservaKit + CacheKit** → debuggability and speed; add OTel hooks early.
5. Add **SearchKit** (external docs) and **GuardKit** (redaction) next.
6. Then **DevKit** (code) and **CodeModKit** (safe refactors) with **Cursor**.
7. Finally **StackKit** + **ScaffoldKit** to productize architecture decisions (Turborepo + monolith-first + hexagonal).

---

## Quick Summary of Roles

| Kit          | Focus                       | Example Output             |
| ------------ | --------------------------- | -------------------------- |
| Dockit       | Docs improvement            | Markdown diffs, changelog  |
| DevKit       | Code-level assistance       | Refactors, tests, comments |
| StackKit     | Architecture & stack        | `stack.yml`, ADRs          |
| PlanKit      | Plans (bmad)                | `plan.json`                |
| SpecKit      | Spec-first + ADR            | Specs, ADRs                |
| AgentKit     | Execute plans               | Artifacts, run logs        |
| ToolKit      | Action wrappers             | Shell/Git/HTTP actions     |
| IngestKit    | Normalize                   | `ingest/*.jsonl`           |
| SearchKit    | External sources            | Fetched docs/evidence      |
| IndexKit     | Build stores                | `indexes/*`                |
| QueryKit     | Answers + evidence          | Citations, evidence pack   |
| PromptKit    | Prompts                     | Templates                  |
| TestKit      | Tests & contracts           | Reports, PR checks         |
| EvalKit      | Verification                | Reports, PR checks         |
| PolicyKit    | Guardrails                  | Policy YAML outcomes       |
| ComplianceKit| Standards & evidence        | Coverage reports           |
| GuardKit     | Safety/PII                  | Redacted logs              |
| HeadersKit   | Security headers/CSP        | CSP/headers config         |
| CacheKit     | Memoization/artifacts       | Cached runs                |
| ObservaKit   | Telemetry & artifacts       | Traces, logs               |
| PatchKit     | PRs & changelog             | PRs, RELEASE notes         |
| ScheduleKit  | Cadence                     | Job runs                   |
| NotifyKit    | Approvals                   | Slack/email summaries      |
| CodeModKit   | AST codemods                | Diffs, migration reports   |
| ScaffoldKit  | Project/feature skeletons   | New service repos          |
| DiagramKit   | Diagrams                    | .mmd/.puml/.svg            |
| DepKit       | Dependency mgmt             | Upgrade PRs                |
| BenchKit     | Performance                 | Benchmark deltas           |
| DatasetKit   | Goldens for RAG/eval        | `datasets/*.jsonl`         |
| ModelKit     | Model policy                | `models.yml`               |
| ReleaseKit   | Releases                    | CHANGELOG, GitHub release  |
| MigrationKit | Schema/data migrations      | Migrations, reports        |
| FlagKit      | Feature flags               | Flags, rollout plans       |
| i18nKit      | Localization                | Locale files               |
| UIkit        | Review UI                   | Approvals/search UI        |
| SeedKit      | Fixtures                    | Seeds/data                 |
| VaultKit     | Secrets                     | Masked env                 |

---

## Who Calls What

- **PlanKit** calls **AgentKit** with a plan (from **SpecKit**).
- **AgentKit** calls **ToolKit** wrappers; leverages **CacheKit** for memoization.
- **Dockit/DevKit/StackKit** call **QueryKit** for grounding; **QueryKit** reads **IndexKit** stores; **IndexKit** builds from **IngestKit**, which ingests from **SearchKit**.
- **EvalKit**, **TestKit**, **PolicyKit**, and **ComplianceKit** gate outputs and **PatchKit** PRs; **HeadersKit** and **A11yKit** contribute checks.
- **ReleaseKit** coordinates with **FlagKit** for progressive delivery and rollback; flags via **Vercel Flags** (Edge Config).
- **SearchKit** feeds **IngestKit** with external content.
- **DiagramKit**, **BenchKit**, **DepKit**, **MigrationKit**, **i18nKit** hang off the main flows as needed.
- **ScheduleKit** triggers **PlanKit → AgentKit**; **NotifyKit** informs humans; **ObservaKit** records everything; **GuardKit/VaultKit** keep it safe.

---

## ASCII Overview

```mermaid
[ScheduleKit] ─► [PlanKit] ─► [AgentKit] ─► [ToolKit] ─┬─► Dockit
                                                      ├─► DevKit ─┬─► CodeModKit
                                                      ├─► StackKit ─► ScaffoldKit ─► DiagramKit
                                                      ├─► PatchKit ─► ReleaseKit
                                                      └─► EvalKit & PolicyKit (gates)

SearchKit ─► IngestKit ─► IndexKit ◄─ QueryKit ◄──────────────┘
ObservaKit (traces) • GuardKit/VaultKit (safety) • NotifyKit (HITL) • CostKit/ModelKit (routing)
```

---

If you want, I can generate a **starter repo** scaffold with the directory layout, stubbed CLI commands, and minimal JSON schemas so you can run a full “Doc Refresh → PR” flow on day one.
