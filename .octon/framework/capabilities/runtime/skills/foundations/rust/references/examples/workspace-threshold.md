# Example: Workspace Threshold

## Do not workspace yet

```text
my-tool/
├── Cargo.toml
└── src/
    ├── main.rs
    ├── cli.rs
    ├── config.rs
    └── many_modules.rs
```

A large module tree alone does not justify a workspace.

## Workspace justified

```text
tools/
├── Cargo.toml
├── crates/
│   ├── repo-tool-cli/
│   ├── repo-tool-core/
│   ├── repo-tool-fs/
│   └── repo-tool-test-support/
└── xtask/
```

Justified when:

- `repo-tool-core` is used by multiple binaries
- `repo-tool-fs` has distinct dependencies and tests
- `xtask` is repo automation with separate lifecycle
- `test-support` avoids polluting production dependencies
