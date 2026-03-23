# Review Findings This Proposal Addresses

This resource is intentionally direct. It explains the current problems in plain language so the implementation work stays anchored to real gaps instead of drifting into generic cleanup.

## Current Problem Summary

| Problem | Current live signal | Why it matters |
| --- | --- | --- |
| Alignment dispatcher drift | `alignment-check.sh` still contains old-style top-level path assumptions such as `.octon/agency`, `.octon/orchestration`, `.octon/capabilities`, and `.octon/assurance`. | A validator that checks the wrong tree can produce false confidence or false failures. |
| Authoritative Markdown blind spot | `main-push-safety.yml` ignores `**/*.md` even though some Markdown files are declared architectural authority. | A real contract change can bypass a safety workflow simply because the file extension is `.md`. |
| Narrow dependency hygiene | `.github/dependabot.yml` updates GitHub Actions only, while the runtime has a real Cargo workspace. | The repo automates updates for workflow dependencies but not for the Rust dependency graph that powers the engine runtime. |
| Mutable GitHub Action refs | High-trust workflows still use moving refs such as `@v4`, `@v3`, and `@stable`. | A workflow can change behavior without an Octon commit because the upstream ref moved. |
| Split runtime target truth | The launcher maps several local platform binaries, while `runtime-binaries.yml` publishes a different subset and local source fallback can mask missing packaged targets. | Developers can think packaging is healthy because local fallback succeeds, even when the release surface is incomplete or inconsistent. |

## Detailed Findings

### 1. Alignment dispatcher drift

The five-class super-root says the only canonical class roots are `framework/`, `instance/`, `inputs/`, `state/`, and `generated/`. Even so, the current `alignment-check.sh` still hardcodes old top-level paths in some profiles. That means one of the repo's main self-check entrypoints has not fully moved to the same topology described elsewhere.

**Practical risk**

- a profile can silently point at a retired path shape
- local and CI validation can disagree
- future contributors have to remember which path vocabulary is "really" current

**Required correction**

Move profile dispatch to one declared registry or, at minimum, add a path validator and tests that fail on retired top-level roots.

### 2. Authoritative Markdown blind spot

The architecture spec is Markdown and is explicitly authoritative. `main-push-safety.yml` currently ignores all Markdown files. That is too broad. Some Markdown is narrative; some Markdown is contract.

**Practical risk**

- a contract or spec change can skip a safety workflow
- teams get a false mental model that `.md` always means "docs only"
- trust depends on file extension instead of authority class

**Required correction**

Replace extension-based ignore rules with authority-aware change classification. Safety-significant Markdown must trigger safety checks.

### 3. Narrow dependency hygiene

The runtime uses Cargo, but automated dependency update coverage stops at GitHub Actions. This is a scope mismatch.

**Practical risk**

- Rust dependencies can drift without the same visibility or cadence
- workflow tooling gets more hygiene than runtime code
- supply-chain review is incomplete by default

**Required correction**

Extend `.github/dependabot.yml` to include Cargo for the runtime crate workspace and add PR-time dependency review.

### 4. Mutable GitHub Action refs in high-trust workflows

Several safety- or release-relevant workflows still use mutable upstream refs. That is normal in many repos, but it is weak for a governance-first harness.

**Practical risk**

- upstream action changes can alter Octon CI behavior unexpectedly
- a workflow can become harder to audit after the fact
- reproducibility is weaker than the rest of Octon's policy posture suggests

**Required correction**

Pin third-party actions by full commit SHA in high-trust workflows first, then expand repo-wide. Add a validator so this does not regress.

### 5. Split runtime target truth

The launcher currently knows about local platform binaries that the release workflow does not publish, while the release workflow publishes Windows output that the Unix launcher does not describe. None of that is inherently wrong by itself. The problem is that the distinction is not declared in one machine-checked place, and source fallback can hide missing packages.

**Practical risk**

- developers cannot easily tell which targets are intentionally local-only versus shippable
- release artifacts can drift from launcher expectations
- missing packaged binaries can be hidden by `cargo run` fallback

**Required correction**

Declare one canonical runtime target matrix and validate the launcher, release workflow, artifact names, and strict packaging behavior against it.

## What This Proposal Deliberately Does Not Solve

These are good follow-on concerns, but they are not required to close the five issues above:

- full SBOM and artifact attestation rollout
- repo variable and secret preflight capture for all live control-plane assumptions
- repo-wide workflow ref pinning for every workflow in the first pass
- a full redesign of release automation

Those items can be proposed later once the current trust surfaces have one coherent truth each.
