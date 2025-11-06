# Update Documentation Set

You are updating our documentation set.

## INPUT

    - NEW_INFO: New information is added in the `NEW_INFO` section.
    - DOCS_DIR: @apps/docs/src/content/docs/

## OBJECTIVE

Ensure `NEW_INFO` is fully and accurately reflected in `DOCS_DIR` by updating existing documents where appropriate and creating new documents where necessary—without introducing redundancy.

## SCOPE & RULES

    - Prefer updating an existing page over creating a new one if the topic clearly fits.
    - If multiple pages partially cover the same topic, consolidate into a single canonical location and replace the others’ overlapping sections with brief summaries that link to the canonical page.
    - Do not duplicate content. Use concise cross-links (relative paths) to the canonical source.
    - Do not invent facts. If something is ambiguous, add a short “Notes / Open Questions” section at the end and clearly mark what needs confirmation.
    - Style: Markdown only, clear headings (#, ##, ###), short paragraphs, bullets for steps, tables for structured data, fenced code blocks for commands/examples.
    - File naming: kebab-case, `.md`. One H1 per file. Start with an H1 title that matches the filename intent.
    - Internal linking: use relative links and, when useful, heading anchors (e.g., `#getting-started`).
    - Keep content DRY and task-oriented. Favor procedures and examples over prose.
    - Front matter: every Markdown file in DOCS_DIR MUST start with YAML front matter that follows the Front Matter schema below. Update existing files to add missing fields; include front matter when creating new files.
    - Perform real file operations. Create/update files under DOCS_DIR and do not print full document contents to chat. After saving, provide only a concise change summary.

## FRONT MATTER (required)

    Every Markdown file must begin with YAML front matter containing, at minimum, these keys:

    - `title` (string): Human-readable title. Must match the file's H1.
    - `scope` (enum): One of `project` | `shared`.
    - `owner` (string): Team or role responsible (e.g., "engineering").
    - `related` (array of relative paths): Cross-links to closely related docs.
    - `version` (semver string): Document version, e.g., `1.0.0`.

    Optional keys (use when known):

    - `status` (enum): `draft` | `active` | `deprecated`.
    - `lastReviewed` (ISO date): Last review date, e.g., `2025-10-24`.
    - `tags` (array of strings): Search keywords.

    Example:

    ```yaml
    ---
    title: Working Agreement
    scope: shared
    owner: engineering
    related:
      - ../project/vision.md
      - ../handbook/architecture-principles.md
    version: 1.0.0
    status: active
    lastReviewed: 2025-10-24
    tags:
      - process
      - collaboration
    ---
    ```

## PROCESS

    1) **Extract Topics**: Summarize NEW_INFO into a bullet list of discrete topics and required changes.
    2) **Audit**: Map each topic to existing files in DOCS_DIR (if any). Identify gaps and overlaps.
    3) **Plan**: For each topic, decide: UPDATE existing file, CREATE new file, or CONSOLIDATE duplicates.
    4) **Apply Changes**:
          - **UPDATE**: Merge missing details into the most relevant existing file. Integrate smoothly with current structure.
          - **CREATE**: Write a new file only if no suitable home exists. Include context, prerequisites, steps, examples, and troubleshooting.
          - **CONSOLIDATE**: Move canonical content to the best location; in other files replace duplicated sections with a brief pointer link.
          - **FRONT MATTER**: For each touched file, add or update YAML front matter to satisfy the required schema. Ensure `title` matches H1, `related` use relative paths, and `version` is a valid semver.
          - **WRITE TO DISK**: Persist the updates by writing the actual files under DOCS_DIR. Do not echo file contents into the chat.
    5) **Navigation**: If applicable, update any index/overview pages or tables of contents so the new/updated pages are discoverable.
    6) **Validate**: Check headings order, link targets, anchors, and cross-references. Validate front matter keys/values and remove dead or redundant content.
    7) **Report**: After saving all changes, output a concise summary of updates to the chat (see Output Format). Do not print full file contents.

## OUTPUT FORMAT (strict)

- Perform all changes by creating/updating actual files under `DOCS_DIR`. Do not print the file contents to chat.
- After changes are saved, provide a compact Markdown change log table summarizing what changed:

        ```markdown

        ## CHANGE LOG TABLE
        | Path | Action | Rationale (1–2 lines) | Related | Breaking? |
        |------|--------|------------------------|---------|-----------|

        ## NOTES / OPEN QUESTIONS
        - If there are any "Notes / Open Questions," list them briefly after the table.

        ```

## ACCEPTANCE CHECKLIST

    - [ ] Every NEW_INFO topic appears exactly once in DOCS_DIR (with cross-links as needed).
    - [ ] No duplicated paragraphs across files; overlapping content replaced with links.
    - [ ] All links are relative and valid; headings are hierarchical.
    - [ ] Each file is readable end-to-end and task-focused, with examples where relevant.
    - [ ] Added a short “Notes / Open Questions” section only where clarification is truly needed.
    - [ ] Every Markdown file begins with valid YAML front matter that meets the schema: required keys present; `title` matches H1; `scope` is `project` or `shared`; `owner` is set; `version` is valid semver; `related` paths are relative and resolve.
    - [ ] Changes are saved to disk in DOCS_DIR; only a concise change summary is printed to chat (no full file contents).
