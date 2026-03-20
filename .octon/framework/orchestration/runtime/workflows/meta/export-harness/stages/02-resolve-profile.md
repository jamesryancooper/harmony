# Step 2: Resolve Profile Payload

## Actions

1. Read `/.octon/octon.yml` and validate the v2 root-manifest profile contract.
2. Read `/.octon/framework/manifest.yml`, `/.octon/instance/manifest.yml`, and `/.octon/instance/extensions.yml`.
3. For `repo_snapshot`, refresh extension publication and require
   `state/control/extensions/active.yml.status == published`.
4. For `repo_snapshot`, resolve the export payload from the published active
   state and dependency closure in `state/control/extensions/active.yml`.
5. For `pack_bundle`, resolve selected packs from the explicit `pack_ids`
   input and compute dependency closure from
   `inputs/additive/extensions/<pack-id>/pack.yml`.
6. Fail closed on missing payloads, dependency cycles, conflicts,
   compatibility mismatch, or quarantined repo-snapshot publication.

## Output

- resolved export payload set
- ordered dependency closure
- explicit failure receipt when closure cannot be resolved
