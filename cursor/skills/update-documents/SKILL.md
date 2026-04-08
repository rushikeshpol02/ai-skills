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

### Step 3: Build the Universal Document Registry

Before specifying scope, scan the project workspace to enumerate every document that could possibly be affected. Organize into a registry table covering all known document types:

| Document | Type | Found? | Decision | Reason |
|----------|------|--------|----------|--------|
| Stage1_Intake_Classification | Stage artifact | ✅ / ❌ | ✅ Update / ⬜ Skip / ❓ Verify | [one-line reason] |
| Stage2_Interpretation_Checkpoint | Stage artifact | ✅ / ❌ | ... | ... |
| Stage3_Variables_Constraints_Actors | Stage artifact | ✅ / ❌ | ... | ... |
| Stage4_Scenario_Matrix | Stage artifact | ✅ / ❌ | ... | ... |
| Stage5_Assumptions | Stage artifact | ✅ / ❌ | ... | ... |
| Stage6_User_Flows | Stage artifact | ✅ / ❌ | ... | ... |
| Stage7_[if exists] | Stage artifact | ✅ / ❌ | ... | ... |
| Stage8_Risk_Analysis | Stage artifact | ✅ / ❌ | ... | ... |
| Stage9_Document_Audit | Stage artifact | ✅ / ❌ | ... | ... |
| Feature-Requirements-[Feature] (Internal) | Internal FR | ✅ / ❌ | ... | ... |
| Client-Requirements-[Feature] | Client FR | ✅ / ❌ | ... | ... |
| Validation-Report-[Feature] | Report | ✅ / ❌ | ... | ... |
| Design description / Context Summary | Design artifact | ✅ / ❌ | ... | ... |
| project-context.md | Project knowledge | ✅ / ❌ | ... | ... |
| requirements-registry.md | Registry | ✅ / ❌ | ... | ... |

**Decision rules — apply to every row, no silent skips:**

| Change type | Stage1 | Stage2 | Stage3 | Stage4 | Stage5 | Stage6 | Stage8 | Stage9 | Internal FR | Client FR |
|---|---|---|---|---|---|---|---|---|---|---|
| Factual correction | ❓ | ✅ | ✅ | ❓ | ✅ | ✅ | ❓ | ❓ | ✅ | ✅ |
| Terminology change | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Scope change (add) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Scope change (remove) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| New information | ❓ | ✅ | ✅ | ❓ | ✅ | ✅ | ❓ | ⬜ | ✅ | ✅ |

Legend: ✅ = always update | ⬜ = always skip | ❓ = evaluate content (explain decision in Reason column)

For every `❓` row: read that document's relevant sections and determine if the change content appears, is implied, or has cascading effects. Record the outcome (✅ or ⬜) with a one-line reason. **No document may remain ❓ in the final registry.**

**Dependency order** (always update in this order, upstream first):
Stage1 → Stage2 → Stage3 → Stage4 → Stage5 → Stage6 → Stage8 → Stage9 → Internal FR → Client FR

If no Stage artifacts exist, sort by the dependency relationships present in the project.

Present the registry to the user for confirmation. This is **mandatory** — the user must agree to the ✅ / ⬜ decision for every document before proceeding. The user may promote ⬜ to ✅ or demote ✅ to ⬜.

---

### Step 3.5: Change Impact Classification (mandatory reasoning step)

**Before searching any document**, reason through the blast radius of each change. This step produces a section-level impact map that drives all subsequent searching — it replaces the pattern of "search first, then figure out what sections matter."

For each change (C1, C2, ...):

#### 3.5.1 — Classify the change's impact class

| Impact Class | Definition | Section blast radius |
|---|---|---|
| **CROSS-CUTTING** | Affects every document and every section type (e.g., terminology change, actor capability correction, major constraint change) | All sections in all documents |
| **REQUIREMENT-LEVEL** | Adds, removes, or modifies a specific capability or behavioral rule | Executive Summary, User Needs, Business Goals, User Flows, Visual States, Error Handling, Assumptions, Open Questions, Dependencies, Risk/Known Limitations, EXISTING/NEW classification, Scenario Matrix (Stage4), canonical user flows (Stage6) |
| **CONTEXTUAL** | Affects a bounded area — a specific actor, a specific data field, a specific flow — without changing the FR set | Sections whose content is directly about that actor / field / flow |
| **ADDITIVE-ONLY** | New content that does not correct or contradict anything existing | Contextually correct sections where the new content belongs; no deletions or corrections needed |

Assign one impact class per change. If a change spans multiple classes, split it into sub-changes.

#### 3.5.2 — Map the section blast radius

For each change, produce this table (fill in all rows — do not skip):

| Section | Relationship | Question to answer | Verdict |
|---|---|---|---|
| **Executive Summary** | DERIVED | Does the change affect the scope or capability description? | 🔴 Affected / ⬜ Clear |
| **User Needs / Business Goals** | DERIVED | Does the change affect what users need or what the product achieves? | 🔴 / ⬜ |
| **User Flows / UX Flows** (in FR doc) | DERIVED | Does the narrative of how the feature works need to change? | 🔴 / ⬜ |
| **Visual States** | DERIVED | Is there a new UI state, or is an existing state now obsolete? | 🔴 / ⬜ |
| **Error Handling** | DERIVED | Is there a new failure path, or is an existing one now invalid? | 🔴 / ⬜ |
| **Assumptions** | UPSTREAM | Does the change confirm, invalidate, or introduce an assumption? | 🔴 / ⬜ |
| **Open Questions** | UPSTREAM | Does the change resolve a `[TBD]` or introduce a new one? | 🔴 / ⬜ |
| **Dependencies** | UPSTREAM | Does the change introduce or remove a system/team/data dependency? | 🔴 / ⬜ |
| **Known Limitations** | DERIVED | Does the change add, remove, or alter a known limitation? | 🔴 / ⬜ |
| **Risk Analysis** | DERIVED | Does the change alter the risk profile? | 🔴 / ⬜ |
| **EXISTING/NEW Classification** | DERIVED | Does the change affect what's in scope vs. out of scope? | 🔴 / ⬜ |
| **Change History** | METADATA | Always update if the document has a changelog | 🔴 Always |
| **Stage4 Scenario Matrix** | Stage artifact | Does the change require new or modified scenarios? Are any scenarios now obsolete? | 🔴 / ⬜ |
| **Stage6 User Flows** | Stage artifact | Does the canonical flow artifact need updating to match? | 🔴 / ⬜ |

Only sections marked 🔴 are searched in Step 4. Sections marked ⬜ are skipped with no further action. This prevents the skill from either searching everything blindly or missing sections because they weren't obvious from the change wording.

#### 3.5.3 — Consolidate: produce a section-document matrix

Combine the document registry (Step 3) with the blast radius (Step 3.5.2) to produce a single matrix showing which section of which document is in scope for each change:

```
| Document | Section | Change IDs | Priority |
|---|---|---|---|
| Internal FR | Executive Summary | C1, C2 | HIGH |
| Internal FR | User Flows | C2 | HIGH |
| Internal FR | Visual States | C2 | MEDIUM |
| Stage6 | UF-1 | C2 | HIGH |
| Stage5 | Assumption M1 | C1 | MEDIUM |
| Client FR | Executive Summary | C1, C2 | HIGH |
...
```

This matrix is the search plan for Step 4. Only the listed (document, section) pairs are searched. Nothing outside this matrix is touched without explicit user instruction.

---

## Phase 2: Execute

### Step 4: Targeted search and intra-document consistency pass

Using the section-document matrix from Step 3.5.3 as the search plan:

#### Pass 1 — Intra-document consistency sweep (always first, before text search)

For each document marked ✅ in the registry, read the sections identified as 🔴 in the blast radius. For each of those sections, reason about consistency:

- Does this section describe a behavior, state, or premise that the change invalidates or extends?
- If a user flow is updated, does the visual states table have a matching entry?
- If a scope item is removed, does the executive summary still reference it?
- If a new dependency is introduced, does the dependencies section list it?
- If an assumption is confirmed, is it still marked as "unconfirmed" anywhere?

This sweep is purely reasoning — no text search needed. Its output is a list of **consistency gaps**: sections that are internally inconsistent with the change, even before searching for specific text matches.

#### Pass 2 — Text search for matches

For each (document, section) pair in the matrix, search for:

| Category | What to find |
|---|---|
| **DIRECT** | Text that explicitly states the incorrect information, uses the old term, or directly describes the feature/behavior being changed |
| **DERIVED** | Text that is based on or implies the incorrect information — a pain point, goal, or flow that only makes sense if the old fact is true |
| **CROSS-REFERENCE** | References to the affected section, document, or fact from other sections or documents |
| **CONSISTENCY GAP** | Sections identified in Pass 1 as internally inconsistent, even without a direct text match |

Categorize each finding:

| Category | Meaning | Action |
|---|---|---|
| DIRECT | Text explicitly contains the incorrect or outdated information | Will be updated |
| DERIVED | Text implies or builds upon the incorrect fact | Will be updated (rewritten to reflect correct fact) |
| CROSS-REFERENCE | A reference that will become stale after the primary change | Will be updated |
| CONSISTENCY GAP | Section is logically inconsistent with the change, even if it doesn't directly state the old fact | Will be updated or flagged for user decision |
| POTENTIAL | Text might be affected but intent is ambiguous — cannot determine automatically | Presented as a question to user in Step 5 |

Record each finding with: document path, section heading, current text, proposed replacement, category, and which change ID it traces to.

---

### Step 5: Change manifest and user review (MANDATORY STOP)

Present two sections: the registry decision summary, then the full change manifest.

```
## Document Registry Decision

| Document | Decision | Reason |
|----------|----------|--------|
| Stage1_Intake_Classification | ✅ Update | Source list references affected term |
| Stage2_Interpretation_Checkpoint | ✅ Update | Decision D20 derived from old fact |
| Stage3_Variables_Constraints_Actors | ⬜ Skip | No actor or variable references the changed content |
| Stage4_Scenario_Matrix | ✅ Update | Scenario MS-3 assumes old behavior |
| Stage5_Assumptions | ✅ Update | Assumption M1 status must be updated |
| Stage6_User_Flows | ✅ Update | UF-1 step 3 describes old behavior |
| Stage8_Risk_Analysis | ⬜ Skip | Risk profile unchanged |
| Stage9_Document_Audit | ⬜ Skip | No cross-refs affected |
| Internal FR | ✅ Update | Primary location of affected FRs |
| Client FR | ✅ Update | Downstream derivative of Internal FR |

[Documents not found in project are noted as ❌ Not found — no action.]

---

## Change Manifest

### Document: [path] (Update order: 1 of N)

| # | Section | Category | Current text | Proposed text | Change ID |
|---|---------|----------|-------------|---------------|-----------|
| 1 | ...     | DIRECT   | "..."       | "..."         | C1        |
| 2 | ...     | DERIVED  | "..."       | "..."         | C1        |
| 3 | ...     | CONSISTENCY GAP | "..." | "..."        | C2        |
| 4 | ...     | POTENTIAL | "..."      | "..." (?)     | C2        |

### Document: [path] (Update order: 2 of N)
...

**POTENTIAL items (need your decision):**
- Item 4 in [document]: [explain the ambiguity and why it might need updating] — Update? (Y/N)

**Skipped documents (no changes needed):**
- [document]: [one-line reason]

Total: [N] changes across [M] documents. [K] documents confirmed as not requiring changes.
Confirm to proceed, or adjust individual items.
```

**Do NOT apply any edits until the user approves both the registry decision and the manifest.**

If the user rejects or modifies items — including promoting a ⬜ Skip to ✅ Update or vice versa — update the registry and manifest and re-present before proceeding.

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

1. **Never update without user confirmation.** The change set (Step 2), the document registry (Step 3), and the change manifest (Step 5) are all mandatory stop gates. No edits happen without explicit approval at each gate.
2. **Never invent corrected text.** If the user hasn't provided the correct information for a finding, flag it as "needs user input" — do not guess or fabricate replacements.
3. **Preserve document voice.** Each document may have a different tone, format, and level of detail. Match it. Do not impose a uniform style across documents.
4. **Dependency order matters.** Always update in the established dependency order (upstream first, downstream last). Client FRs are always last.
5. **Domain-agnostic.** Do not assume a specific industry, document format, or technology. The skill works on any structured document.
6. **Additive by default.** When adding new information, place it in the contextually correct existing section rather than creating new sections — unless the document's structure genuinely requires a new section.
7. **Change history is not optional.** If a document has a version/changelog section, it must be updated. If it doesn't have one, skip it — do not add one.
8. **Read before editing.** Always read the full document before making changes. Never edit from memory or partial reads.
9. **One change at a time.** Apply changes sequentially within each document. Do not batch multiple edits into a single operation that would be hard to verify or undo.
10. **DERIVED requires judgment.** When rewriting derived text, the new text must be factually correct AND preserve the original intent of the section. If you cannot preserve both, flag it for user review instead of guessing.
11. **No document skipped silently.** Every document found in the project must appear in the registry with an explicit ✅ or ⬜ decision and a one-line reason. "I didn't check it" is not a valid reason. If a document's relevance is genuinely unclear, mark it ❓ and resolve it before finalizing the registry — never carry a ❓ into the manifest.
12. **Reason before searching.** Step 3.5 (Change Impact Classification) is never optional. The section-document matrix from Step 3.5.3 is the search plan — searching outside it requires explicit user instruction. This prevents both over-broad searching (touching unaffected documents) and under-broad searching (missing derived sections because they don't contain the exact changed text).
