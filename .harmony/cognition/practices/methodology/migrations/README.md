---
title: Clean-Break Migrations
description: SSOT policy hub for clean-break migration doctrine, invariants, exceptions, CI gates, and banlist governance.
---

# Clean-Break Migrations

This directory defines migration policy and governance for how clean-break migrations are designed, executed, and verified in this repository.

## Purpose

Establish clean-break migrations by default: no transitional modes, no compatibility shims, and no dual systems unless an explicit exception is approved.

## Machine Discovery

- `index.yml` - canonical machine-readable index for migration governance doctrine artifacts.

## Scope

A change is a migration when it changes any of the following in a way that can affect consumers (humans, tools, or internal subsystems):

- Interfaces (APIs, CLIs, file formats, schemas, manifests)
- Runtime authority or decisioning (policy engines, evaluators, routing)
- Persistence or data shape
- Configuration keys or semantics
- Directory or domain ownership (SSOT moves)

## Default Policy

All migrations are CLEAN-BREAK unless an exception is approved under `exceptions.md`.

## Required Artifacts

Every migration must include:

- A runtime migration plan record at:
  - `/.harmony/cognition/runtime/migrations/<YYYY-MM-DD>-<slug>/plan.md`
  - based on `/.harmony/scaffolding/runtime/templates/migrations/template.clean-break-migration.md`
- Verification evidence (tests, logs, receipts) linked from the plan, stored under:
  - `/.harmony/output/reports/migrations/<YYYY-MM-DD>-<slug>/`
  - required bundle files:
    - `bundle.yml`
    - `evidence.md`
    - `commands.md`
    - `validation.md`
    - `inventory.md`
- Banlist updates in `legacy-banlist.md` when legacy identifiers, paths, or keys are removed

## Companion Documents

- `doctrine.md`
- `invariants.md`
- `exceptions.md`
- `ci-gates.md`
- `legacy-banlist.md`

## Runtime Migration Records

Canonical migration records and discovery index now live at:

- `/.harmony/cognition/runtime/migrations/README.md`
- `/.harmony/cognition/runtime/migrations/index.yml`
