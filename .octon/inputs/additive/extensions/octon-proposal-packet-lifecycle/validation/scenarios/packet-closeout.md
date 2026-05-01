# Packet Closeout

## Target Kind

`generate-closeout-prompt` and `closeout-proposal-packet`

## Expected Behavior

The route covers proposal archival, registry regeneration when safe,
housekeeping, packet receipts, durable evidence, final hygiene, and any
route-required staging, commit, PR, CI, review resolution, merge, branch
cleanup, or sync gates.

The route must delegate repository-wide PR, CI, review, merge, branch cleanup,
and sync behavior to the Git/worktree autonomy contract when the selected route
uses a PR or branch lane. It must not claim closeout complete while required
packet receipts fail, route-required checks are red, route-required review
conversations or author action items are unresolved, final hygiene is
incomplete, or route-required PR/merge/branch cleanup/origin sync gates remain
unfinished unless the result is explicitly reported as blocked or deferred.

Red required checks trigger remediation, not waiting: inspect every failing
check, job, and script; fix according to Octon's target architecture and current
repo state; validate locally when reproducible; commit and push when the route
uses a branch lane; and re-check.
