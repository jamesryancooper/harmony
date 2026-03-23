# Validation Plan

Validation must prove the new controls work in practice, not only that new files exist.

## 1. Alignment Validation

### Local

- run the alignment dispatcher in dry-run mode for every declared profile
- run the alignment profile registry validator
- run the alignment profile test suite

### Negative test

Introduce a fixture or temporary test case that points at a retired top-level root such as `.octon/agency`. The validator must fail before execution.

## 2. Authoritative Markdown Trigger Validation

### Positive simulations

Simulate or stage a change in a declared authoritative Markdown file such as:

- an architecture specification
- a governance charter
- a bootstrap doc that defines required operator steps

Expected result: `main-push-safety.yml` or the equivalent safety gate runs.

### Negative simulations

Simulate or stage a change in narrative-only Markdown.

Expected result: the heavy safety workflow may skip, provided no authoritative-doc class is touched.

## 3. Dependency Hygiene Validation

### Dependabot coverage

Confirm the runtime Cargo workspace path is present in `.github/dependabot.yml`.

### PR review

Open or simulate a PR that changes `Cargo.toml` or a lockfile.

Expected result: the dependency review workflow runs and reports normally.

## 4. GitHub Action Pin Validation

### Positive test

Run the pin validator against the updated Tier 1 workflows.

Expected result: success when every third-party action uses a full SHA pin.

### Negative test

Change one pinned ref back to a mutable ref such as `@v4`.

Expected result: the validator fails and names the offending workflow line.

## 5. Runtime Target Parity Validation

### Matrix parity

Run the runtime target parity validator.

Expected result: the declared target matrix matches `run`, `run.cmd`, and `runtime-binaries.yml`.

### Strict packaging mode

Enable strict packaging mode in CI or a local simulation.

Expected result: missing packaged binaries for any declared `shippable_release=true` target produce failure even if local source fallback would otherwise succeed.

### Local developer mode

Disable strict packaging mode and run locally on a development machine.

Expected result: source fallback remains available where the target matrix allows local launch without a packaged binary.

## 6. Definition Of Done

The proposal is ready for archive only when all of the following are true:

- the new durable truth files exist
- validators are green
- blocking mode is enabled for the intended controls
- local docs no longer rely on proposal-local explanations
- generated proposal registry state is updated
