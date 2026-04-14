# Run Log: octon-concept-integration prompt bundle scenario proof

## Proof Harness

- command:
  `bash .octon/framework/assurance/runtime/_ops/tests/test-resolve-extension-prompt-bundle.sh`
- scope:
  isolated fixture-based proof of prompt bundle freshness resolution behavior

## Scenarios Proven

1. fresh published bundle + `alignment_mode=auto` -> allowed
2. stale prompt asset + `alignment_mode=auto` -> blocked
3. stale prompt asset + `alignment_mode=skip` -> degraded allow
4. prompt asset change followed by republish + `alignment_mode=auto` ->
   fresh allow with a new bundle digest

## Result

- status: success
- passed: 4
- failed: 0

## Relation To Packet

This proof receipt closes the scenario-proof gap called out by the
`octon-concept-integration-prompt-publication-and-freshness` packet’s
validation plan and acceptance criteria.
