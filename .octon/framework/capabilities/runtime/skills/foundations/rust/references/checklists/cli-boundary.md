# Checklist: CLI Boundary

- [ ] CLI parsing is isolated in `cli.rs` or equivalent
- [ ] `clap` structs are boundary types, not domain objects
- [ ] Subcommands map to command modules or app functions
- [ ] CLI flags are converted into typed config once
- [ ] Invalid flag combinations are detected early
- [ ] Business logic is not embedded in parser definitions
- [ ] Human logs use stderr
- [ ] Machine-readable output uses stdout
