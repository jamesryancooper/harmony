# Routing Guide

`octon-pack-scaffolder` uses an explicit published dispatcher contract.

## Source Of Truth

- `context/routing.contract.yml`

## Resolver Example

```bash
bash .octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-route.sh \
  --pack-id octon-pack-scaffolder \
  --dispatcher-id octon-pack-scaffolder \
  --inputs-json '{"target":"pack","pack_id":"demo-pack"}'
```

## Expected Behavior

- `target=pack` -> `create-pack`
- `target=prompt-bundle` -> `create-prompt-bundle`
- `target=skill` -> `create-skill`
- `target=command` -> `create-command`
- `target=context-doc` -> `create-context-doc`
- `target=validation-fixture` -> `create-validation-fixture`
- missing `target` -> `dispatcher-overview`
- unsupported `target` -> blocked route result

The dispatcher is explicit by design. It does not infer routes from partial
shape alone.
