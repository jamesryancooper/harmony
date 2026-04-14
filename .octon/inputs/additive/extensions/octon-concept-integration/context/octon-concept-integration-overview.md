# Octon Concept Integration Overview

This pack internalizes the concept-integration prompt set as a reusable Octon
capability.

## Purpose

Turn a source artifact into:

1. extracted candidate concepts
2. verified final recommendations grounded in the live repository
3. a manifest-governed architecture proposal packet
4. a packet-specific executable implementation prompt

## Invocation Model

- reusable core: `octon-concept-integration` composite skill
- stable v1 entrypoint: `/octon-concept-integration` command wrapper

## Important Boundary

The pack-local prompts are the runtime source for this capability.
The former root prompt-set copy has been superseded by the pack-local prompt
assets and should not be used as a live dependency.
