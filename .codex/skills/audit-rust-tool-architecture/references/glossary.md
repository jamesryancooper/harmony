# Audit Rust Tool Architecture Glossary

- **architecture classification**: the current Rust project shape selected from
  the supported vocabulary.
- **boundary finding**: issue where CLI, config, domain logic, effects, or
  output formatting are coupled in a way that blocks testing or safe evolution.
- **effect adapter**: boring wrapper for filesystem, process, network, or other
  side effects.
- **minimum sufficient fix**: smallest correction that resolves the architectural
  risk without preserving fragile structure.
- **overengineering boundary**: explicit point where a larger split, workspace,
  crate, or abstraction is not justified by evidence.
- **workspace advice**: recommendation for or against Cargo workspace splitting
  based on observed package boundaries.
