Re-read the published prompt bundle manifest and required repo anchors before
execution.

- use `alignment_mode` exactly as defined by
  `resolve-extension-prompt-bundle.sh`
- stop if `alignment_mode=auto` or `always` and the bundle is stale
- only continue in a degraded posture when `alignment_mode=skip` explicitly
  allows it
- do not redefine prompt freshness semantics inside this bundle
