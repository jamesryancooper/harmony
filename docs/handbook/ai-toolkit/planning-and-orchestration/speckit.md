# SpecKit — Spec-First + ADRs (BMAD SDD)

- **Purpose:** Wraps GitHub SpecKit to author and validate Harmony‑aligned specs/ADRs; seeds PlanKit with clear, contract‑first goals.
- **Responsibilities:** scaffolding/validating specs via GitHub SpecKit, normalizing YAML front matter and required fields, capturing API/UI contracts/SLOs/micro‑threats, delegating publishing to Dockit and diagrams to DiagramKit.
- **Harmony alignment:** Advances Interoperability and Evidence‑First by enforcing consistent spec/ADR contracts and governance hooks for reviewable, auditable outputs.
- **Integrates with:** PlanKit (seeds plans), Dockit (publishes specs/ADRs), DiagramKit (renders diagrams).
- **I/O:** reads `docs/specs/**`; emits updated `docs/specs/**` and `docs/adr/**` (Markdown with YAML front matter).
- **Wins:** One‑path spec/ADR flow; faster plan seeding and consistent, auditable contracts across kits.
- **Implementation Choices (opinionated):**
  - GitHub SpecKit: authoritative spec/ADR templates and validation; drives scaffolding and contract shape.
  - python-frontmatter: reliable read/write of YAML front matter for spec/ADR files.

## Minimal Interfaces (copy/paste scaffolds)

### SpecKit (spec + ADR skeleton)

```yaml
title: "Feature X — One-Page Spec"
problem: "What problem, who for, why now"
scope:
  in: ["happy paths", "MVP UI"]
  out: ["admin UI", "edge cases Y"]
contracts:
  api:
    - name: GET /v1/foo
      request: {query: {id: string}}
      response: {200: Foo}
  ui:
    - view: FooList
      states: [empty, loading, loaded, error]
slos:
  - name: p95_api_latency_ms
    target: 250
non_functionals: ["observability hooks", "a11y baseline"]
threat_model:
  stride:
    - threat: XSS on Foo page
      mitigations: ["CSP nonces", "escape output"]
standards:
  asvs_v5_controls: ["2.1.1", "5.1.4"]
  nist_ssdf_activities: ["PS.2", "PW.3"]
acceptance_criteria:
  - "User can view Foo list with pagination"
  - "Contract test passes for GET /v1/foo"
adr:
  decision: "Monolith-first in Turborepo; Next.js + Postgres"
  rationale: "Simplicity and speed; hexagonal boundaries via contracts"
```