# Artifact Placement Matrix Seed

This matrix is a thinking aid for the downstream research agent. It is not a recommendation.

Legend:

- `Current`
- `Candidate local`
- `Keep central`
- `Derived only`
- `Open`

| Artifact class | Current canonical home | Descendant-local sidecar candidate? | `/.extensions/` candidate? | Likely notes/questions |
| --- | --- | --- | --- | --- |
| Repo-wide governance contracts | `/.octon/*/governance/**` | Keep central | No under current proposal | Governance centralization is a strong current invariant. |
| Runtime execution contracts | `/.octon/*/runtime/**` | Open | No direct authority under current proposal | Local executable content would need a strict runtime/effective-resolution story. |
| Operating practices | `/.octon/*/practices/**` | Open | No under current proposal | Could local guidance exist without becoming competing normative practice? |
| Local domain conventions/reference docs | `/.octon/cognition/runtime/context/*.md` today | Candidate local or root-local partitioned | Possibly pack reference docs only | Need decision on local authority vs local projection. |
| ADR-grade architectural decisions | `/.octon/cognition/runtime/decisions/**` | Open | No | If localized, are they globally authoritative, locally scoped, or continuity evidence? |
| Routing/approval/block evidence | `/.octon/continuity/decisions/**` | Candidate local state/evidence | No | Could local continuity evidence exist without fragmenting auditability? |
| Active work state | `/.octon/continuity/**` | Candidate local | No | Strong candidate for locality if isolated correctly. |
| Knowledge graph source contracts | `/.octon/cognition/runtime/knowledge/**` | Open | No | Derived graph material may be easier to localize than source contracts. |
| Knowledge graph materializations | `/.octon/cognition/runtime/knowledge/graph/**` | Candidate local derived | No | Likely derived-only if localized. |
| Projections/read models | `/.octon/cognition/runtime/projections/**` | Candidate local derived | No | Fits derived/local-cache thinking more than canonical-authority thinking. |
| Skills metadata and definitions | `/.octon/capabilities/runtime/skills/**` | Open | Yes under current `/.extensions/` proposal, additively | Need to decide whether local capability authoring exists or whether locality is projection-only. |
| Commands metadata/content | `/.octon/capabilities/runtime/commands/**` | Open | Yes under current `/.extensions/` proposal, additively | Same question as skills. |
| Templates | `/.octon/scaffolding/**` today | Open | Yes under current `/.extensions/` proposal | Templates are additive by nature, but local scope may matter. |
| Prompts | `/.octon/scaffolding/practices/prompts/**` today | Open | Yes under current `/.extensions/` proposal | Need to distinguish repo-wide prompts from local task guidance. |
| Validation assets | various `/.octon/**` plus assurance | Open | Yes under current `/.extensions/` proposal for pack-local validation assets | Need guardrails so validation assets do not become shadow governance. |
| Mutable operational state | `_ops/state/**` under `/.octon/**` | Candidate local `_ops` only if governed | No under current proposal | Local mutable state is plausible, but only with strict `_ops` and allowlist rules. |
| Effective compiled indexes | `/.octon/engine/_ops/state/**` | Derived only | No | Strong current signal: runtime-facing effective views belong to Octon-owned derived surfaces. |
| Local memory summaries / handoff notes | mostly `continuity/**` and `context/**` today | Candidate local | No | Probably needs clear routing across continuity vs context vs decisions. |
| Specialized agents | `/.octon/agency/runtime/agents/**` | Open | No under current proposal | High-risk class because agency content is currently excluded from `/.extensions/` and central today. |

## Matrix Use

The downstream agent should turn this seed into a defended placement model with:

- allowed local classes
- forbidden local classes
- central-only classes
- derived-only classes
- precedence rules
- validation/fail-closed rules per class
