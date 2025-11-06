# {{feature-name}} — Operations Runbook (1 page)

## SLOs & Alerts

- Availability: 99.9%
- p95 latency: <= 300ms
- Burn-rate alerts: <thresholds + links to dashboards>

## Validate (Preview or Prod)

- [ ] Healthcheck returns 200
- [ ] `/v1/{{feature-name}}` happy path passes with example payload
- [ ] Logs/metrics present and sane

## Rollback

- Command: `vercel promote <deployment-url>` (or your platform equivalent)
- Fallback: disable `flag.{{feature-name}}`

## Common Issues

- 4xx spikes → schema mismatch; validate requests against JSON Schema
- 5xx spikes → check upstreams and adapters; enable circuit breakers
- Latency regressions → profile hot paths; check bundle budgets (UI)

## Postmortem (blameless)

- Owner:
- Timeline:
- Impact:
- What worked / what didn’t:
- Follow-ups (create ADR if direction changes)
