# FILES

Final QGE layout under `/Users/jamesryancooper/Projects/harmony/.harmony/quality/`.

```text
.harmony/quality/
├── CHARTER.md                         # Canonical Quality Charter (source of truth)
├── README.md                          # QGE entrypoint and lifecycle (Charter -> Weights -> Scores -> Gates -> Outputs)
├── weights/
│   ├── weights.yml                    # Policy weights + charter machine contract + changelog
│   ├── weights.md                     # Human guidance for policy model
│   └── inputs/context.yml             # Active context defaults for resolver runs
├── scores/
│   └── scores.yml                     # Measurement scores + evidence pointers
├── policy/
│   ├── SUBSYSTEM_OVERRIDE_POLICY.md   # Repo-over-subsystem override governance
│   ├── subsystem-classes.yml          # Control-plane/productivity strictness model
│   └── overrides.yml                  # Explicit deviation declarations
├── _ops/
│   ├── scripts/
│   │   ├── compute-quality-score.sh   # Shell entrypoint to resolver
│   │   ├── quality-gate.sh            # Shell entrypoint to gate
│   │   └── alignment-check.sh         # Alignment profile runner (includes charter args)
│   └── state/
│       ├── active-weight-context.lock.yml
│       └── effective-weights.lock.yml
└── ... (existing quality baseline docs)
```

Runtime implementation:

- `/Users/jamesryancooper/Projects/harmony/.harmony/runtime/crates/quality_tools/src/main.rs`

Generated artifacts:

- Effective matrix: `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/effective/<context>.md`
- Weighted results: `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/results/<context>.md`
- Deviations report: `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/policy/deviations/<context>.md`
