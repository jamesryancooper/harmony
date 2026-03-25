---
title: Validate Mission Request
description: Validate create-mission inputs and preconditions.
---

# Validate Mission Request

Validate the requested mission creation inputs before any repo mutation.

## Checks

1. Confirm `mission_id` is lowercase kebab-case.
2. Confirm `mission_title`, `mission_class`, and `owner_ref` are non-empty.
3. Confirm `mission_class` is one of:
   `observe`, `campaign`, `reconcile`, `maintenance`, `migration`, `incident`,
   `destructive`.
4. Confirm no existing authority, control, continuity, or generated mission
   roots already exist for the same `mission_id`.
5. Confirm the mission scaffold template and mission registry exist.

## Fail Closed

- Stop if any required input is missing or malformed.
- Stop if the mission already exists anywhere in canonical mission roots.

