# Start Research Project `/research`

Create a new research project in `.workspace/.scratch/projects/`.

See `.workspace/workflows/scratch/create-research-project/00-overview.md` for full description and steps.

## Usage

```text
/research <slug>
```

**Example:**
```text
/research agent-memory-patterns
```

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `<slug>` | Yes | Project identifier (lowercase with hyphens) |

## Implementation

Execute the workflow in `.workspace/workflows/scratch/create-research-project/`.

Start with `00-overview.md` and follow each step in sequence.

## References

- **Workflow:** `.workspace/workflows/scratch/create-research-project/`
- **Registry:** `.workspace/.scratch/projects/registry.md`
- **Template:** `.workspace/.scratch/projects/_template/`
- **Documentation:** `docs/architecture/workspaces/scratch.md`
