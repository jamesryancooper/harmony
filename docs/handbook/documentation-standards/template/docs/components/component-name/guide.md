# {{component-name}} — Developer Guide

## What it is / When to use

<Describe the component’s purpose and scenarios where it adds value.>

## Interfaces & Contracts

- API endpoints: see OpenAPI (`packages/contracts/openapi.yaml`)
- Schemas: see JSON Schema (`packages/contracts/schemas/{{feature-name}}.schema.json`)

## Configuration

```yaml
enabled: true
mode: "standard"
limits:
  maxItems: 1000
```

## Outputs & Artifacts

- JSON response: conforms to `ExampleFeature` schema
- Logs/metrics: <list>
- Files: <list if any>

## Operational Notes

- Performance tips: <short bullets>
- Limits/quotas: <short bullets>

## Troubleshooting

- Symptom → Fix
- Error code 400 → Check schema conformance
- Timeouts → Verify upstream latency budgets
