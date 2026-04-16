# Phases

1. Normalize the explicit scaffold request.
2. Return the dispatcher overview when `target` is absent.
3. Enforce the additive write boundary under the target pack root.
4. Resolve the explicit `target` through `context/routing.contract.yml`.
5. Delegate to the matching leaf scaffold without inferring alternate routes.
6. Validate the resulting shape against `context/output-shapes.md`.
7. Return a created/skipped/blocked receipt.
