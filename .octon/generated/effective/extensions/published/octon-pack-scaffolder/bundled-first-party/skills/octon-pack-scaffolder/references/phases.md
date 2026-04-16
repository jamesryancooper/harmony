# Phases

1. Normalize the explicit scaffold request.
2. Enforce the additive write boundary under the target pack root.
3. Resolve the explicit `target` through `context/routing.contract.yml`.
4. Delegate to the matching leaf scaffold without inferring alternate routes.
5. Validate the resulting shape against `context/output-shapes.md`.
6. Return a created/skipped/blocked receipt.
