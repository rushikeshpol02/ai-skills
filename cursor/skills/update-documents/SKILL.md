---
name: update-documents
description: "Propagates corrections, new information, terminology changes, and scope changes across multiple related documents. Structures changes, verifies with user, performs impact analysis, presents a change manifest for approval, applies edits preserving each document's format and tone, and runs document-audit as a final consistency check. Use when a fact, assumption, or decision changes and multiple documents need updating, or when new information (e.g., from a design review, stakeholder feedback, or discovery session) must be reflected across a document set."
---

# Update Documents — Cross-Document Change Propagation

## Purpose

Propagates verified corrections and new information across a set of related documents. Ensures every affected document is updated consistently, in the correct order, with user approval at two mandatory checkpoints.

**When to use:**
- A fact or assumption was wrong and multiple documents reference it
- New information (design, stakeholder input, discovery) must be reflected across existing docs
- Terminology is changing across a document set
- A feature or scope item is being added, deferred, or removed

**Domain-agnostic.** Works on any document type — requirements, PRDs, meeting notes, design specs, technical docs.

---

## Phase 1: Intake

### Step 1: Receive and structure the change set

Gather the corrections or new information from the user. For each change, capture:

| Field | Description |
|-------|-------------|
| **ID** | Sequential identifier (C1, C2, ...) |
| **Type** | One of: Factual correction, Terminology change, Scope change, New information |
| **What is wrong / missing** | The current incorrect or absent content |
| **What is correct / new** | The verified replacement or addition |
| **Source / evidence** | Why the new information is correct — user statement, design file, meeting, data |

#### Change type reference

| Type | Propagation pattern | Search strategy |
|------|---------------------|-----------------|
| **Factual correction** | Any section that assumed the wrong fact — personas, pain points, user flows, assumptions, goals, constraints, dependencies | Search for the incorrect fact AND for statements derived from it |
| **Terminology change** | All occurrences of the old term across all documents | Context-aware find-and-replace — match singular/plural, capitalization, possessive forms |
| **Scope change** | Scope sections, feature lists, future enhancements, assumptions, success metrics | Search for the feature/item name in scope tables, requirement lists, and roadmap references |
| **New information** | Additive — new content in contextually correct sections, new rows in tables, new references | Identify which sections in each document should contain the new information |

If the user provides changes informally, reformat them into the structured table before proceeding.

---

### Step 2: User verification checkpoint (MANDATORY STOP)

Present the structured change set back to the user:

```
## Change Set for Review

| ID | Type | What is wrong / missing | What is correct / new | Source |
|----|------|------------------------|-----------------------|-------|
| C1 | ...  | ...                    | ...                   | ...   |
| C2 | ...  | ...                    | ...                   | ...   |

Is this complete and correct? Any changes to add, modify, or remove?
```

**Do NOT proceed until the user confirms the change set.**

If the user adds or modifies changes, update the table and re-present for confirmation.

---

### Step 3: Identify document scope and dependency order

1. User specifies which folder(s) or file(s) are in scope.
2. List all documents found. For each, note:
   - Document name and path
   - Document type (meeting summary, stage artifact, requirements doc, design doc, etc.)
   - Position in dependency chain (if any)
3. If documents have a dependency chain (e.g., "Stage 2 informs Stage 5 which informs the requirements doc"), establish the update order: **upstream first, downstream last.**
4. If no dependency chain exists, order alphabetically or by the user's preference.
5. **Proactively scan for derived artifacts.** For every `Feature-Requirements-*.md` (or equivalent internal requirements doc) in scope, check whether a corresponding `Client-Requirements-*.md` (or client-ready derivative) exists in the same or a sibling folder. If found, add it to the dependency chain as the **last** downstream document. A client-ready doc is always downstream of its internal source — changes to the internal doc must propagate there last.

Present the document list and proposed update order to the user for confirmation. This is informational — not a mandatory stop — but the user may adjust scope.

---

## Phase 2: Execute

### Step 4: Impact analysis and search

For each change in the change set:

1. **Determine affected section types.** Based on the change type, identify which kinds of sections could be affected:
   - Factual correction → personas, pain points, user needs, business goals, user flows, assumptions, constraints, dependencies, known limitations, error handling
   - Terminology change → all sections (full document scan)
   - Scope change → executive summary, scope, feature lists, requirements, future enhancements, assumptions, success metrics
   - New information → depends on content; identify the most contextually appropriate sections

   **Intra-Document Section Consistency Sweep (mandatory when any FR is added, modified, or removed):**

   A requirements document is not a collection of independent sections. Every section is a view of the same feature and must tell a consistent story. When any Functional Requirement is touched, run this sweep across the same document before moving on to other documents:

   | Section | Relationship to FRs | Check |
   |---------|---------------------|-------|
   | **User Flows / UX Flows** | DERIVED — narrative of how FRs play out | Does it describe the new or changed behavior? Does it reflect removed behavior? |
   | **Visual States** | DERIVED — UI states for each FR | Does it have a state entry for the new condition? Is any state now obsolete? |
   | **Error Handling** | DERIVED — failure modes of FRs | Does it cover the new failure path? Is any row now outdated? |
   | **Executive Summary** | DERIVED — scope description | Does it still accurately represent the full feature? Did scope expand or contract? |
   | **Assumptions** | UPSTREAM / BIDIRECTIONAL — premises FRs rest on | Does the new FR rest on a new unrecorded assumption? Does it invalidate or confirm an existing one? |
   | **Open Questions** | UPSTREAM / BIDIRECTIONAL — unresolved decisions FRs depend on | Does the new FR resolve a `[TBD]` or OQ? Does it introduce a new one? |
   | **Dependencies** | UPSTREAM / BIDIRECTIONAL — what the FR requires to exist | Does the new FR introduce a new system, team, or data dependency not yet listed? |
   | **Risk Analysis / Known Risks** | DERIVED — what could go wrong | Does the change alter the risk profile? Add or remove a risk? |

   For each section found in the document, add it as DERIVED (if it needs updating to reflect the FR change) or flag it as POTENTIAL (if the need is ambiguous) in the change manifest. Do not silently skip any section.

   Also check the following stage artifacts, if in scope or if they exist in the project:
   - **Stage4 Scenario Matrix** — does the new FR have scenario coverage?
   - **Stage6 User Flows** — does the canonical user flow artifact reflect the change?

2. **Search all in-scope documents** for:
   - **DIRECT matches** — text that explicitly states the incorrect information or uses the old term
   - **DERIVED statements** — text that is based on or implies the incorrect information, even if it doesn't contain the exact words (e.g., a pain point that only makes sense if the wrong fact is true)
   - **CROSS-REFERENCES** — references to the incorrect information from other documents or sections

3. **Categorize each finding:**

| Category | Meaning | Action |
|----------|---------|--------|
| DIRECT | Text explicitly contains the incorrect information | Will be updated |
| DERIVED | Text is based on / implies the incorrect fact | Will be updated (rewritten to reflect correct fact) |
| POTENTIAL | Text might be affected but intent is ambiguous | Presented as a question to user in Step 5 |

4. Record each finding with: document path, section heading, line reference, current text, proposed replacement, category.

---

### Step 5: Change manifest and user review (MANDATORY STOP)

Present all planned changes, grouped by document in dependency order:

```
## Change Manifest

### Document: [path] (Update order: 1 of N)

| # | Section | Category | Current text | Proposed text | Change ID |
|---|---------|----------|-------------|---------------|-----------|
| 1 | ...     | DIRECT   | "..."       | "..."         | C1        |
| 2 | ...     | DERIVED  | "..."       | "..."         | C1        |
| 3 | ...     | POTENTIAL | "..."      | "..." (?)     | C2        |

### Document: [path] (Update order: 2 of N)
...

**POTENTIAL items (need your decision):**
- Item 3 in [document]: [explain why this might need updating] — Update? (Y/N)

Total: [N] changes across [M] documents.
Confirm to proceed, or adjust individual items.
```

**Do NOT apply any edits until the user approves the manifest.**

If the user rejects or modifies items, update the manifest and re-present.

---

### Step 6: Apply changes

Apply approved changes in dependency order (upstream documents first).

**For each document:**

1. **Read the full document** before editing — understand its structure, tone, and conventions.
2. **Apply changes** using the edit tool:
   - Preserve the document's existing format, heading hierarchy, and section structure
   - Match the writing style of surrounding text (bullet style, sentence length, voice, level of detail)
   - For table updates: match column format, alignment, and row style
   - For new content: place it in the contextually correct section — do not create new sections unless the document structure requires it
   - For removals: remove cleanly without leaving orphaned references or empty sections
3. **Update change history** — if the document has a version/changelog section, add a new entry:
   - Date, author (from the change set source), one-line summary of what changed
   - If the document has no changelog, skip — do not add one

**After each document is updated,** briefly confirm the edit was applied before moving to the next document.

---

## Phase 3: Verify

### Step 7: Run document-audit on all modified documents

Invoke the `document-audit` skill on each modified document. Focus the audit on:

- **Contradictions introduced by the changes** — does the updated text now conflict with an un-updated section?
- **Broken cross-references** — did a section rename or content removal break internal references?
- **Stale markers resolved** — did the new information answer a `[TBD]` or `[PENDING]` that was previously unresolvable?
- **Terminology inconsistencies** — are there sections that still use old terminology alongside updated sections?
- **Cascading staleness** — did updating an upstream document make a downstream document's reference or quote stale?

If the audit is being run across many documents (5+), prioritize auditing the most downstream documents first — they are most likely to have inconsistencies.

---

### Step 8: Report and close

Present a final summary:

```
## Update Summary

**Documents updated:** [N]
**Total changes applied:** [M]
**Change history entries added:** [K]

### Changes by document:
| Document | Changes applied | Audit status |
|----------|----------------|-------------|
| [path]   | [N]            | Clean / [N] findings |

### Audit findings requiring attention:
[List any HIGH or MEDIUM findings from document-audit]

### Resolved during audit:
[List any findings that were auto-fixed]
```

- If HIGH-confidence audit findings exist, fix them immediately and re-audit the affected document.
- If MEDIUM findings exist, present them to the user for decision.
- LOW findings are reported but not acted on unless the user requests.

---

## Critical Rules

1. **Never update without user confirmation.** Both the change set (Step 2) and the change manifest (Step 5) are mandatory stop gates. No edits happen without explicit approval.
2. **Never invent corrected text.** If the user hasn't provided the correct information for a finding, flag it as "needs user input" — do not guess or fabricate replacements.
3. **Preserve document voice.** Each document may have a different tone, format, and level of detail. Match it. Do not impose a uniform style across documents.
4. **Dependency order matters.** If Document A is cited by Document B, update A first so B's references remain valid during the update process.
5. **Domain-agnostic.** Do not assume a specific industry, document format, or technology. The skill works on any structured document.
6. **Additive by default.** When adding new information, place it in the contextually correct existing section rather than creating new sections — unless the document's structure genuinely requires a new section.
7. **Change history is not optional.** If a document has a version/changelog section, it must be updated. If it doesn't have one, skip it — do not add one.
8. **Read before editing.** Always read the full document before making changes. Never edit from memory or partial reads.
9. **One change at a time.** Apply changes sequentially within each document. Do not batch multiple edits into a single operation that would be hard to verify or undo.
10. **DERIVED requires judgment.** When rewriting derived text, the new text must be factually correct AND preserve the original intent of the section. If you cannot preserve both, flag it for user review instead of guessing.
