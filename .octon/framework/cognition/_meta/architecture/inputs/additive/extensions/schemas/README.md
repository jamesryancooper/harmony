# Additive Extension Input Schemas

| Schema | Canonical artifact |
| --- | --- |
| `extension-pack.schema.json` | `.octon/inputs/additive/extensions/<pack-id>/pack.yml` |
| `extension-routing-contract.schema.json` | `.octon/inputs/additive/extensions/<pack-id>/context/routing.contract.yml` |
| `extension-lifecycle-contract.schema.json` | `.octon/inputs/additive/extensions/<pack-id>/context/lifecycle.contract.yml` |

`octon-extension-pack-v5` requires explicit `capability_profiles` so validation
can fail closed on missing command, skill, prompt, routing, lifecycle,
template, or validation artifacts.
