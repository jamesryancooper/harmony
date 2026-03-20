# Extension Trust And Compatibility

## Compatibility

- Extension compatibility is checked against
  `octon.yml.versioning.harness.release_version`.
- Extension API compatibility is checked against
  `octon.yml.versioning.extensions.api_version`.

## Trust

- Pack provenance travels with `pack.yml`.
- Repo trust decisions remain in `instance/extensions.yml`.
- `first_party_bundled` defaults to `allow`.
- `first_party_external` defaults to `require_acknowledgement`.
- `third_party` defaults to `deny`.

## Publication

- Invalid or denied packs quarantine locally under
  `state/control/extensions/quarantine.yml`.
- A coherent surviving set may publish with quarantine recorded.
- If no coherent surviving set remains, extension contributions are withdrawn.
