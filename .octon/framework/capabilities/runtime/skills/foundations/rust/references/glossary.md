# Rust Tool Architecture Glossary

- **thin shell**: executable edge that parses arguments, calls library code,
  prints results, and exits.
- **testable core**: pure or mostly pure library logic that can be exercised
  without spawning the CLI binary.
- **effect boundary**: module or adapter that owns filesystem, process,
  network, or other external side effects.
- **plan-before-mutate**: workflow where the tool computes and reviews intended
  changes before applying them.
- **single-package structure**: one Cargo package with `src/main.rs`, optional
  `src/lib.rs`, modules, and tests.
- **bin/lib split**: architecture where binary entrypoints are thin and shared
  behavior lives behind `src/lib.rs`.
- **workspace split**: multiple Cargo packages under one workspace, justified
  only by stable package boundaries or independent dependency/release needs.
- **repo-local automation**: internal tool used to maintain, validate, publish,
  or migrate the repository itself.
