# Generate Implementation Prompt

Re-read the packet, manifests, promotion targets, acceptance criteria,
validation plan, risk register, and support artifacts. Generate an executable
prompt that implements only the declared durable targets, records evidence,
runs validation, handles blockers fail-closed, and avoids broadening the packet
beyond its promotion targets.

The implementation prompt must be complete enough for direct execution: state
the target end state, in-scope and out-of-scope surfaces, ordered workstreams,
owned file families, required generated/runtime publications, validation
commands, evidence outputs, rollback posture, and terminal criteria. If the
packet declares atomic or clean-break migration, require one coherent migration
that avoids partial live states and runs post-cutover validation before
claiming success.

The implementation prompt must also make the post-implementation gates
executable. It must require the implementer to create or update
`support/implementation-conformance-review.md` after durable changes land, run
`validate-proposal-implementation-conformance.sh --package <proposal_path>`,
then create or update `support/post-implementation-drift-churn-review.md` and
run `validate-proposal-post-implementation-drift.sh --package <proposal_path>`.
It must preserve promotion targets, declared validation, retained evidence,
rollback notes, generated outputs, downstream references, and explicit
exclusions. It must refuse implemented, closeout, or archive-ready claims while
either post-implementation receipt is missing, failing, unresolved, or blocked.

When the user or packet explicitly authorizes delegated implementation, the
prompt may split work across bounded agents or workers with disjoint write
scopes and an integration owner. Otherwise, keep delegation optional and do not
make subagents a control requirement. In all cases, blockers must be resolved
inside the packet target architecture or reported as a blocked gate outcome
with evidence; the prompt must not invent new authority, widen support claims,
or use proposal-local support files as implementation proof.
