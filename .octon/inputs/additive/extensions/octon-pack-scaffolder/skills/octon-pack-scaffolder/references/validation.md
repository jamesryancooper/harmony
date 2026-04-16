# Validation

Success means:

- `target` maps to exactly one supported leaf scaffold
- missing `target` returns the dispatcher overview without selecting a leaf
- missing or unsupported `target` values block via the dispatcher contract
- no write escapes the target pack root
- created files match the documented output shape
- rerunning against matching content is idempotent
- conflicting content blocks the run explicitly
