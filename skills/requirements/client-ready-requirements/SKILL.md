---
name: client-ready-requirements
description: "Transforms an internal feature requirements document into a VP/Director-ready Securitas client requirements document. Produces an 11-section (or 10-section for net-new features without What's Changing) document aligned with the Securitas feature requirements generation rules. Adds Personas (Section 2) and User Goals (Section 3) from the internal doc, applies VP filter and anti-inflation check to constraints/risks/OQs, relocates overflow bullets and detailed flows to appendices. Use when asked to: produce a Securitas client requirements doc, streamline requirements for Lauren/Securitas review, create a focused version of a feature spec, or prepare requirements for Securitas stakeholder review."
---

# Securitas Client-Ready Requirements

Transforms an internal requirements document into a VP/Director-ready version for Securitas. Produces an 11-section document aligned with the Securitas feature requirements generation rules: who the users are (Personas, User Goals), what they can do (Flows, Requirements), what's changing (What's Changing, Known Limitations), and what's still open or risky (Constraints/Risks/Assumptions, Open Questions).

**Design principle:** 95% copy-and-relocate, 5% templated assembly. Every sentence in the output must be traceable to a specific sentence in the input. No synthesis, no paraphrasing, no inferred content.

---

## Inputs Required

| Input | Required | Notes |
|-------|----------|-------|
| Internal requirements document | Yes | Path to `Feature-Requirements-*.md` |
| Stage 1 intake file | Yes | Filename contains "Stage1" or "Intake_Classification" for SRC code mapping |

**Finding the Stage 1 file:** Search in this order:
1. `[feature-folder]/../../_runs/*/stage_output/Stage1-Intake.md` — walk all run folders under `_runs/` and use the first match
2. Ask the user to point to it if not found. If unavailable, proceed and use raw filenames in the References section.

---

## Output Structure: 11 Sections

The output document has exactly this structure. Section 5 (What's Changing) is conditional — include only for features modifying an existing product experience. The Appendix is always present.

| # | Section | Content | Transformation type | Source in internal |
|---|---------|---------|---------------------|--------------------|
| 1 | Overview | Narrative paragraph — business problem, capabilities, priority and launch date | TEMPLATE (narrative assembly) | Section 1 Overview |
| 2 | Personas | Behavioral-state personas table | COPY verbatim | Section 2 Personas |
| 3 | User Goals | "As a [persona], I want..." bullets | COPY verbatim | Section 3 User Goals |
| 4 | Scope | In Scope + Out of Scope tables | COPY verbatim | Section 4 Scope |
| 5 | What's Changing | Current state vs new capabilities | COPY verbatim (conditional) | Section 5 What's Changing |
| 6 | User Flows | Flows summary table; Appendix A and B callouts | COPY verbatim | Section 6 User Flows |
| 7 | Functional Requirements | All FRs with business rules; VP filter per bullet (C/H/M → FR body; Low → Appendix E) | COPY + VP filter per bullet | Section 7 FRs |
| 8 | Known Limitations | Day-one and accepted trade-off impacts | COPY verbatim | Section 8 Known Limitations |
| 9 | Risks, Constraints & Assumptions | Constraints → Risks → Assumptions, VP-filtered (3 rows per subsection max) | RELOCATE + VP filter | Section 9.1 Constraints, Section 9.2 Risks, Section 9.3 Assumptions |
| 10 | Open Questions | Critical and High priority only; resolved removed; Medium/Low → Appendix G | COPY + filter | Section 10 Open Questions |
| 11 | References | Figma links, related docs, source materials | COPY + RELOCATE | Section 11 References |
| — | Appendix A | Visual States | COPY verbatim | Appendix A (already in v2 source) |
| — | Appendix B | Error Handling | COPY verbatim | Appendix B (already in v2 source) |
| — | Appendix D | Detailed User Flows (alt paths, failure paths) | COPY verbatim | Appendix D (already in v2 source, conditional) |
| — | Appendix E | Field-level specs (Low decision-impact FR bullets) | COPY from Low-impact FR bullets if present | Appendix E (conditional — only if Low-impact bullets exist) |
| — | Appendix G | Medium/Low OQs and Section 9 overflow | RELOCATE from Section 9/Section 10 filtering | Section 9/Section 10 overflow |

---

## Phase 1: Clean

Apply all cleaning rules FIRST, before any restructuring. Work on a mental copy of the source document.

### 1.1 Build Source Registry

Read the Stage 1 intake file. Map every SRC code to its display name, date, and type:

| SRC | Display Name | Date | Type |
|-----|-------------|------|------|
| SRC-N | [from Stage 1] | [date] | Meeting Record / Discovery Session / Client Document / Design Reference / Existing Draft |

Only register SRC codes that appear in the requirements document.

### 1.2 Apply Cleaning Rules

| Find | Replace With |
|------|-------------|
| `(Source: SRC-N)`, `(Source: SRC-N, D-N)`, any SRC citation | Remove entirely |
| `(Source: User-confirmed)`, `(Source: User-confirmed, YYYY-MM-DD)` | Remove |
| `(Figma node 3244:28360)` etc. — node ID in parentheses | Replace with `(current app design)` |
| `, Figma node [digits]:[digits]` — node ID as suffix after a link | Remove entirely |
| `Figma node [digits]:[digits]` — standalone node ID not in parentheses | Remove entirely |
| Stage artifact references: `Context-Summary-FigJam-SRC18`, `Stage 1`, `Stage 4`, stage filenames | Remove the reference; keep the fact |
| `> **Engineering Note:** [text]` block inside any FR | Remove entirely. If the note contains a fact the client must know to understand the requirement, convert it to a business rule bullet before removing. |
| `> **Implementation Note:** [text]` block inside any FR | Remove entirely. Apply identical logic: if the note contains a client-relevant fact (e.g., a constraint that affects user experience or a fallback behavior), convert it to a business rule bullet before removing. If the note is purely technical implementation detail, remove without replacement. |
| `> **Direction ([Name]):** [text]` block inside any FR | Remove. The directional decision must already be reflected in the requirement text; if not, add it as a business rule bullet before removing the block. |
| `[Display layout, Design Decision]`, `[Design Decision]`, `[TBD - Design]` annotation tags inline in business rules | Remove the tag. Keep the business rule fact unchanged. |
| Business rule bullet identical or near-identical to a Hard Constraint already listed in Section 9 | Remove the FR-level bullet. The constraint is stated once in Section 9. Applies universally to payroll non-blocking and any other document-wide rules. |
| **Generation Summary block** — a block appearing between the document header table and `## 1.` that contains lines starting with `**Pipeline Mode:**`, `**Input Quality:**`, `**Functional Requirements:**`, `**TBDs:**`, `**Assumptions:**`, `**Stage 8 Risks:**`, or a key gaps checklist | Remove the entire block including its surrounding blank lines. This is internal pipeline metadata, not client content. |
| **Section 5 What's Changing section** — a standalone two-column table (`## 5. What's Changing`) | **Do NOT remove.** This section is copied verbatim in Phase 2. Apply Phase 1 cleaning only (SRC codes, NC codes, OQ qualifiers stripped per rules above; section heading and table content preserved). |
| `*(See Risk R-x)*` in any FR bullet | Remove entirely |
| `*(OQ-x)*` in any FR bullet — where this OQ appears in the §10 Blocks column for that FR | Remove from bullet; add one-line blockquote immediately after the entire FR block: `> *(Copy/design unconfirmed — see OQ-N.)*` using the OQ's renumbered client-facing number |
| `*(OQ-x)*` in any FR bullet — where this OQ does NOT appear in the §10 Blocks column for that FR | Remove entirely |
| `*(See Assumption A-N)*` in any FR bullet | Keep — this is a traceability pointer, not an internal cross-reference |
| Risk/OQ emoji: `🔴`, `🟡`, `🟠`, `🟢` in Impact or Priority columns | Replace with plain text: Critical / High / Medium / Low |
| `#### FR-` header | Promote to `### FR-` — safety net for pre-fix pipeline documents |
| Source horizontal metadata table (row 1: column headers; row 2: values — e.g., `\| Feature \| Version \| Date \| Owner \| Status \|`) | Before stripping: record the values (Feature name, Version, Date, Owner, Status) — these are needed for Phase 2 Section 1 header assembly. Then strip the entire table. The Section 1 template assembly in Phase 2 replaces it with the vertical `\| Field \| Value \|` format. |
| Risk table with a `Risk ID` column and/or a `Type` column | Reconstruct as 5 columns: `\| Risk \| Probability \| Impact \| Owner \| Mitigation \|`. Map `Description` → `Risk`; drop `Risk ID` and `Type` values. Rebuild each row with the 5-column values only. |
| `[VP-OVERFLOW — Appendix E]` tag on any FR bullet; `**Additional rules:**` sub-label preceding such bullets | Remove the `[VP-OVERFLOW — Appendix E]` tag from each bullet. Remove the `**Additional rules:**` sub-label. Keep all bullets in the FR body — they remain as FR content. The VP filter (below) then applies. |

**Section 7 VP filter (applies per bullet after tag removal):**
Low decision-impact bullets are identified by the `[Low]` tag at the end of the bullet (format: `- [bullet text] [Low] (Source: ...)`). All other bullets — those tagged [Critical], [High], [Medium], or untagged — stay in the FR body.
- Bullet tagged `[Low]` → remove from FR body; add to Appendix E as Field-Level Specs (strip the `[Low]` tag before adding)
- Bullet tagged `[Critical]`, `[High]`, `[Medium]`, or untagged → keep in FR body; strip the impact tag before outputting
- Bullet untagged and source is pipeline-generated → keep in FR body AND flag in the transformation summary as a malformed bullet (pipeline docs must always have impact tags; untagged bullets indicate a quality gate miss)

Maintain the original bullet sequence for bullets that remain in the FR body — do not reorder. Section 7 transform type: COPY + VP filter per bullet.

**Known Limitations blockquote (applies after copying §8 verbatim):**
Apply `>` prefix to the Known Limitation that has an unresolved dependency — an open OQ or `[TBD]` reference in the same limitation text. If multiple qualify, apply to the first one listed. If none have explicit dependencies, apply `>` to the first Known Limitation listed. Guard: if the limitation already starts with `>`, skip — do not nest blockquotes. Additional guard: if §8 contains exactly one Known Limitation and it has no unresolved dependency (no OQ reference, no [TBD]), omit the `>` prefix entirely — do not apply blockquote styling when there is no dependency to signal.

### 1.3 Collect SRC codes for References

Record every unique SRC code found in the document before removing them. This list drives the References section in Phase 2.

---

## Phase 1.5: Spot-Check for Duplicates

The pipeline's Stage 9.0 runs a full within-document deduplication pass before the internal doc is finalized. For pipeline-generated documents, the Section 9 sub-sections (Constraints, Risks, Assumptions) and top-level sections (Known Limitations, Open Questions) are already clean.

Perform a quick scan only — do not re-run the full deduplication algorithm:

- Scan Section 9.1, 9.2, 9.3 and Section 8 Known Limitations for any item that visibly belongs in a different section or appears in two sections simultaneously. If found, note it.
- Check that no Assumption row has status "Confirmed" — confirmed assumptions should have been deleted or moved to Known Limitations by Stage 9.0.
- If the document was NOT generated by the pipeline (manually authored or pre-pipeline), run the full deduplication pass using the tiebreaker rules in Stage 9.0 of the requirements pipeline before proceeding.

Record the count of any duplicates found and resolved. If zero, note "Section 9 clean — no duplicates found (pipeline Stage 9.0 applied)."

---

## Phase 2: Restructure

Build the output document section by section. For each section, the instruction specifies the transformation type. Follow it exactly.

### Section 1: Overview

**Transformation type: NARRATIVE ASSEMBLY**

This is the ONLY section where text is assembled (not copied verbatim). Write a short narrative paragraph by extracting and connecting specific phrases from the source. Do not write new prose — every clause must be traceable to the source.

```
# [Feature Name]

**Version:** [from source header]
**Date:** [today's date]
**Owner:** [from source header]
**Status:** [from source header]

> **Audience:** Business, Product, UX, Technology, Executive

## 1. Overview

[Sentence 1: the business problem or compliance driver — extracted from Section 1 Overview. State the cost of not having this feature, or the legal/operational obligation. Do NOT open with the feature name.]

[Sentence 2: what the feature delivers, stated in terms of officer/DM outcomes — extracted from Section 1 Overview. Name the primary actors and the core capabilities they gain.]

[Sentence 3: priority order (if source defines one) + launch date — copied from source priority line and timeline constraint.]
```

**Sequence rules — enforce in this order:**
1. **Open with the problem.** Sentence 1 must state what is broken today or what compliance obligation exists — not what the feature does. Extract from Section 1 Overview.
2. **State outcomes, not capabilities.** Sentence 2 names what officers/DMs gain, not what the system does. Extract from Section 1 Overview.
3. **Close with priorities and date.** Sentence 3 states the priority order and launch date. Copy from source — do not invent.

**Content checks (apply before writing):**
- Can you point to a specific source sentence for every clause? If not, do not include that clause.
- Does Sentence 1 contain the feature name as its subject? If yes, rewrite — the problem must lead, not the feature.
- Does Sentence 2 describe a system capability ("the system checks...") rather than an officer/DM outcome? If yes, rewrite in terms of what the user gains.
- Is the priority order present in Sentence 3 only if the source defines one? If source has no priority ranking, omit it.

**Other rules:**
- No label prefixes (`For:`, `Why:`, `What:`). Plain prose only.
- 3–5 sentences. Cover: (1) business problem or friction point, (2) what is changing in this release (new screen, redesign, net-new feature, etc.), (3) capabilities officers/DMs gain, (4) priority and launch date if defined in source. Scope boundary is NOT in the overview — it is fully covered by Section 2.
- If Section 5 What's Changing includes a critical day-one impact on officers (e.g., all officers must re-sign-in after install, a prior feature is being replaced), fold that impact into Sentence 1 or 2 as context. Example: "...replacing the existing sign-in screen; all officers will need to sign in again on first launch of the new app."
- If Section 1 Overview mentions a Measurement/Mixpanel event, add one line after the paragraph: `**Measurement:** [event name or metric]`. If none mentioned, omit entirely.
- Do NOT include Business Goals bullets, Success Metrics table, or Stakeholders table.

---

### Section 2: Personas

**Transformation type: COPY verbatim**

```
---

## 2. Personas

[Copy the Personas table from Section 2 Personas verbatim — identical rows and columns.]
```

**Rules:**
- Copy the table exactly as it appears in the cleaned source
- Strip internal sub-labels (e.g., `#### Personas`, `#### User Goals`) — these are internal doc labels, not client doc headings
- If the source has a prose-format persona section instead of a table, convert: one row per distinct persona with columns Persona | Description | Primary Need
- Do not add, remove, or rephrase any persona

---

### Section 3: User Goals

**Transformation type: COPY verbatim**

```
---

## 3. User Goals

[Copy User Goals bullets from Section 3 User Goals verbatim.]
```

**Rules:**
- Copy bullets exactly as they appear in the cleaned source
- Strip the `#### User Goals` sub-label — it is an internal label
- Do not rephrase, reorder, or add bullets

---

### Section 4: Scope

**Transformation type: COPY verbatim**

```
---

## 4. Scope

### In Scope

[Copy In Scope table from source -- identical rows, identical columns]

### Out of Scope

[Copy Out of Scope table from source -- identical rows, identical columns]
```

**Rules:**
- Tables copied exactly as they appear in the cleaned source
- Do not add, remove, or rephrase any rows

---

### Section 5: What's Changing (CONDITIONAL)

**Transformation type: COPY verbatim**

**Source:** Section 5 What's Changing.

**Include this section ONLY IF** the source document contains a Section 5 What's Changing section.

```
---

## 5. What's Changing

| Current State | What's New |
|---|---|
[Copy the two-column table from source Section 5 What's Changing verbatim.]
```

**Rules:**
- Both columns must describe what the user experiences — not what the system does internally. If a row contains technical terms ("session token", "OS-native", "isolated secure storage"), restate in user-observable terms.
- Apply Phase 1 cleaning to each cell: strip NC codes, OQ qualifiers ("pending Design sign-off, OQ-N"), and pipeline tracking references ("NC5 resolved YYYY-MM-DD").
- **For net-new features with no Section 5 What's Changing content:** Omit this section entirely. All subsequent sections shift up by one number.

---

### Section 6: User Flows

**Transformation type: COPY verbatim**

```
---

## 6. User Flows

**Design reference:** [Figma link(s) from source Design Assets subsection — clean link only, no node IDs]

[Copy the flow summary table from source Section 6 User Flows — filtered:]
- Flow table rows (Trigger → Outcome) — verbatim, with exceptions below

Visual states: Appendix A. Error handling: Appendix B. If source Appendix D contains at least one alt path, failure path, or step-by-step flow row, add: Detailed failure paths: Appendix D. If source Appendix D is absent or empty, omit this line.
```

**Rules:**
- **Include:** design reference link, flow table rows, plain-text appendix callouts
- **Remove Phase 2/3 flow rows:** any flow table row whose Outcome column starts with `(Phase 2/3:` is not a Phase 1 flow — remove it. The deferred item is already documented in Out of Scope and as a one-liner FR.
- **Remove trivial OS handoff flows:** do not include flow rows whose entire outcome is a single-action OS handoff with no app state change (e.g., tap → `tel:` URI phone call, tap → `mailto:` email, tap → share sheet). These are button behaviors fully covered by FR business rules, not flows.
- Appendix callout lines must be plain text — no markdown hyperlinks (`[Appendix A: Visual States](#...)` format is not used).
- Appendix A and Appendix B are copied directly from source Appendix A and Appendix B — no relocation needed. See Appendix section below.

---

### Section 7: Functional Requirements

**Transformation type: COPY verbatim**

```
---

## 7. Functional Requirements

[Copy FR content from source Section 7 Functional Requirements:]
- Cross-cutting display rules (e.g., overnight shifts) precede the FR list
- Each FR: heading, description sentence, business rule bullets

v2 FRs contain a description sentence and business rule bullets only — no Inputs, Outputs, Validation, or Performance subsections. Phase 1 cleaning removes (Source: SRC-N) citations. The FR body is then copied verbatim.

[For any FR that contains an Audit Trail table:]
- Keep the business rule bullet that states where audit data is stored (e.g., "All audit trail events are stored in BI/Snowflake")
- Replace the full audit trail table with: > See [Appendix C: Audit Trail Lifecycle](#appendix-c-audit-trail-lifecycle) for the complete event table.
```

**Rules:**
- **ZERO changes to requirement content.** Every FR description, business rule bullet, and engineering note must be word-for-word identical to the cleaned source. Exception: FR bullets identified as Low decision-impact during Phase 1.2 VP filtering are relocated to Appendix E and do not appear in the FR body — this is the one permitted departure from word-for-word fidelity.
- Cross-cutting rules that precede FRs in the source stay in the same position
- Descoped FRs (struck-through in source) are included as-is for decision trail
- Engineering Notes (`> **Engineering Note:**`) and Implementation Notes (`> **Implementation Note:**`) are stripped from all FRs in the client version. Convert any client-relevant fact to a business rule bullet before stripping.
- Cross-FR constraint deduplication: remove business rule bullets that restate a Hard Constraint already defined in Section 5. Do not repeat document-wide rules (e.g., payroll non-blocking) in individual FRs.
- **Renumber FRs sequentially** (FR-1, FR-2, FR-3, ...) if the source has gaps from a feature split. Gaps confuse client readers. Update ALL cross-references (Regional Applicability, business rule bullets, risk mitigations) to use the new numbers. Internal-to-client FR mapping is implicit; no mapping table needed.
- Audit trail tables move to Appendix C. The inline callout bullet referencing the table destination is kept in the FR where the table originally appeared.

---

**Simple FR rendering (reads Type tag):**

If an FR header contains `**Type: Simple**`, collapse Description and Business Rules into a bullet list instead of sub-labeled sections:

```
### FR-N: [Name]

- [Rule or fact 1]
- [Rule or fact 2]
- [Rule or fact 3]
```

Rules for Simple FR rendering:
- No `**Description:**` / `**Business Rules:**` sub-labels
- Every distinct business rule from the source must be represented as a separate bullet — no omissions
- Bullets are short and factual; do not combine unrelated rules into one bullet
- Do not add prose introductions or summary sentences

Do not use bullet rendering for Complex FRs. If a `**Type:**` tag is absent, treat the FR as Complex (keep sub-labeled structure).

---

**Phase 2/3 FR compression (reads Phase tag):**

If an FR header contains `**Phase: 2/3**` OR the FR body opens with a blockquote matching `> Phase 2/3` or `> This requirement is deferred`, replace the entire FR body with a one-line note:

```
### FR-N: [Name]

*Deferred to Phase 2/3. Not in scope for this release.*
```

The one-line note is the complete representation of this FR in the document. Do not generate Appendix D. Do not copy the full FR content anywhere — not in the main body, not in any appendix.

---

**Phase: 1 label stripping:**

Remove `**Phase: 1**` lines from FR headers. Phase 1 is the default — if an FR appears in the main Requirements section (not compressed to a one-liner), it is implicitly Phase 1. The label adds noise.

Remove `**Phase: 2/3**` lines from FR headers in the main Requirements section after they have been used to trigger compression above — the one-line note and Appendix D reference make the phase status clear.

---

### Section 8: Known Limitations

**Transformation type: COPY verbatim**

**Source:** Section 8 Known Limitations.

```
---

## 8. Known Limitations

[Copy all Known Limitations bullets from source Section 8 verbatim.]
```

**Rules:**
- Copy bullets exactly as they appear in the cleaned source
- Do not include this section if source Section 8 is empty

---

### Section 9: Risks, Constraints & Assumptions

**Transformation type: RELOCATE + VP filter**

Apply the VP filter to every item before placing it in this section: "Does a VP/Director need this item to decide whether to approve the feature for design and development?" If no → Appendix G. If uncertain → Appendix G.

Apply the anti-inflation check: if no items in any subsection rank Low priority, re-examine rankings and demote at least 20% of items to Appendix G before proceeding.

Cap: 3 rows per subsection. Overflow → Appendix G.

```
---

## 9. Risks, Constraints & Assumptions

### Constraints
[Collect from: Section 9.1 Constraints — VP-filtered. Max 3 rows.]

| Constraint | Imposed By |
|---|---|
[bullet/row copied verbatim from source]

### Risks
[Collect from: Section 9.2 Risks — Critical and High only, must have owner. Max 3 rows.]

| Risk | Probability | Impact | Owner | Mitigation |
|---|---|---|---|---|
[rows copied verbatim from source]

### Assumptions
[Collect from: Section 9.3 Assumptions — unconfirmed/open items only, VP-filtered. Max 3 rows.]

| Assumption | Impact if Wrong |
|---|---|
[rows copied from source]
```

**Rules:**
- Each subsection order: Constraints → Risks → Assumptions
- Every bullet and table row must be traceable to a specific bullet or row in the source
- Do not combine, split, or rephrase any item
- Remove struck-through items (already resolved)
- Constraints: state the boundary only. Do not add implementation detail. Source = Section 9.1.
- Risks: Critical and High only. Must have an owner — exclude if no owner. Source = Section 9.2.
- Assumptions: business-risk assumptions only — where being wrong affects users or delivery. Confirmed assumptions must be removed. Source = Section 9.3.
- Items that do not pass the VP filter → Appendix G
- Items exceeding the 3-row cap → Appendix G

---

### Section 10: Open Questions

**Transformation type: COPY + filter**

Include Critical and High priority OQs only. Medium and Low priority OQs are relocated to Appendix G.

```
---

## 10. Open Questions

| # | Question | Blocks | Priority | Owner | Target Date |
|---|----------|--------|----------|-------|-------------|
[Copy Critical and High priority rows from source Open Questions table — open rows only]
```

**Rules:**
- Include Critical and High priority OQs only. Medium and Low → Appendix G with note: "Medium/Low open questions in Appendix G."
- Remove resolved OQs entirely — their resolution must already be absorbed into the relevant FR bullet or Known Limitation. Do not carry resolved OQs to the client doc.
- Remove any OQ row whose question exclusively pertains to a deferred Phase 2/3 FR
- Remove internal codes from question text (e.g., `(H2, C9)`) but keep the plain English question
- Keep columns: #, Question, Blocks, Priority, Owner, Target Date
- Every OQ must have an Owner and a Target Date — exclude rows missing either (not actionable)
- Renumber all remaining open questions sequentially as OQ-1, OQ-2, OQ-3... in the order they appear. Update all cross-references to OQ codes in FR business rules, Known Limitations, and notes to use the new sequential numbers.

---

### Section 11: References

**Transformation type: COPY + RELOCATE**

```
---

## 11. References

### Design Assets
- [Figma link(s) from source, with display text]

### Related Documents
[Copy any non-internal document rows from source Section 11 References]

### Source Materials
The following inputs were used to develop this requirements document.
- [Display Name] ([Type], [Date])
- [Display Name] ([Type], [Date])
```

**Rules:**
- Figma links from the source "Design Assets" subsection go here
- Related Documents: copy from source Section 11 References. Keep only rows with external links (Figma, etc.). Remove rows referencing internal `.md` file paths.
- Source Materials: use the SRC registry built in Phase 1. Group by type (Meeting Records, Discovery Sessions, Client Documents, Design References, Existing Drafts). Format: `[Display Name] ([Type], [Date])`. Omit any group with no entries.
- Do not include internal stage artifact files (Stage 1-8)
- **Figma URL formatting:** Any raw Figma URL must be formatted as a labeled hyperlink: `[Screen/Feature Name] — Design File (Figma)`. Strip the `?node-id=...` query parameter from the URL before wrapping. Derive the screen/feature name from the nearest section header, FR name, or feature name used throughout the document.

---

### Appendix (Always Present)

**Transformation type: COPY verbatim + RELOCATE**

The Appendix is always the last section. Add it after References. It contains tables that are supporting detail for reviewers who need them, but are not required to review or approve the main requirements.

```
---

## Appendix

> These sections contain supporting detail. They are not required to review or approve the requirements above. Move to a sub-page as needed.

---

### Appendix A: Visual States

[Copy the full Visual States table from source Appendix A, verbatim]

---

### Appendix B: Error Handling

[Copy the full Error Handling table from source, verbatim. If the source has multiple separate error tables (e.g., one per flow), combine them under this single heading.]

---

### Appendix C: Audit Trail Lifecycle

[Only include this appendix if the source document contains an Audit Trail table or audit event lifecycle table.]

[Copy the full Audit Trail / audit event lifecycle table from the source, verbatim, including any notes below the table]

---

### Appendix D: Detailed User Flows

[Include if source Appendix D contains alternative paths, failure paths, or edge case flows.]

[Copy verbatim from source Appendix D: all alt paths tables, failure path tables, and step-by-step flow breakdowns.]

---

### Appendix E: Field-Level Specs

[Include only if Low decision-impact FR bullets were demoted during Phase 1.2 VP filter, or if the source Appendix E contains field-level specs. Copy verbatim.]

[Group by FR if sourced from FR bullets. Use sub-heading `### FR-N: [Name] — Field-Level Specs` for each FR that had Low-impact bullets demoted.]

---

### Appendix G: Medium/Low Risks & Open Questions

[Include if Section 10 OQ filtering relocated any Medium or Low priority OQs, or if Section 9 VP filter relocated any items.]

[Copy Medium and Low OQs in the same table format as Section 10. Copy Section 9 overflow items under their respective subsection headers (Constraints / Risks / Assumptions).]

---

```

**Rules:**
- Always include Appendix A (Visual States) and Appendix B (Error Handling)
- Only include Appendix C (Audit Trail) if the source has an audit trail table
- Only include Appendix D (Detailed User Flows) if the source has alt paths, failure paths, or edge case flow content beyond the happy-path summary
- Only include Appendix E (Field-Level Specs) if Low decision-impact FR bullets were demoted during Phase 1.2 VP filter, or if the source Appendix E has field-level spec content
- Only include Appendix G (Medium/Low OQs) if Section 10 filtering or Section 9 VP filter relocated any items
- Each table is copied verbatim from source. No modifications, no additions.
- If the source has a "Known Issues" table inside Constraints, it stays in Section 9 under Constraints (not in the Appendix)

---

## Phase 3: Spot-Check

The pipeline's Stage 9.0 and Stage 9.1 validation runs before the internal doc is finalized. For pipeline-generated documents, cleanup (SRC codes, internal markers, section scaffolding) and deduplication are already done. Do not re-run the full verification checklist.

Run only these eight targeted checks — the ones most likely to catch issues introduced during Phase 2 transformation:

- [ ] **FR completeness:** Scan each FR in the output. Count business rule bullets and confirm the count matches the cleaned source. If any FR has fewer bullets than the source (excluding the HC-duplicate bullets you removed), fix before saving.
- [ ] **FR content fidelity:** Spot-check 2–3 FRs: read each business rule bullet in the output against the source word-for-word. Flag any paraphrase or addition.
- [ ] **HC-duplicate removal:** Confirm each bullet removed as an HC duplicate in Phase 1.2 has a corresponding Hard Constraint in Section 9 that covers it. If no matching HC exists, restore the bullet.
- [ ] **Overview check:** First sentence opens with the problem (not the feature name). Overview is 3–5 sentences. No label prefixes (`For:`, `Why:`, `What:`). Every clause is traceable to a source sentence.
- [ ] **Appendix placement:** Appendix A copied from source Appendix A. Appendix B copied from source Appendix B. Detailed flows in Appendix D (if source Appendix D had content). Section 6 has plain-text callouts to Appendix A and B.
- [ ] **No em dashes** in any section except inside quoted requirement content strings.
- [ ] **Section count:** 10 numbered sections + Appendix (no Section 5 "What's Changing" for net-new features) OR 11 numbered sections + Appendix (Section 5 present). Numbering is sequential.
- [ ] **What's Changing:** Section 5 two-column table is present if source Section 5 had content; absent if source Section 5 was absent.
- [ ] **Personas and User Goals:** Section 2 Personas table is present and copied verbatim from source Section 2. Section 3 User Goals bullets are present and copied verbatim from source Section 3.
- [ ] **Known Limitations:** Section 8 Known Limitations is present if source Section 8 had content.
- [ ] **VP filter applied:** Section 9 has ≤3 rows per subsection (Constraints, Risks, Assumptions). Overflow items are in Appendix G.
- [ ] **Open Questions:** Section 10 contains only Critical and High priority OQs. Resolved OQs are removed. Medium/Low OQs are in Appendix G. No OQ rows were silently dropped — confirm Medium/Low appear in Appendix G.
- [ ] **Appendix E:** Present only if Low decision-impact FR bullets were demoted or source has field-level spec content. No `[VP-OVERFLOW — Appendix E]` tags or `**Additional rules:**` sub-labels remain anywhere in FR bodies.
- [ ] **Zero inline cross-references in FR bullets** — no `*(See Risk R-x)*` or `*(OQ-x)*` remaining; blocking OQs replaced with `>` blockquote after the FR; `*(See Assumption A-N)*` intact if present
- [ ] **All FR headers are `###` (h3)**, not `####` (h4)
- [ ] **§6 has no `### Visual States` or `### Error Handling` subsections** — single reference line only
- [ ] **Risk table has 5 columns** (Risk / Probability / Impact / Owner / Mitigation) — no Risk ID column, no Type column, no emoji in Impact column
- [ ] **`## 1. Overview` header present** after the Audience line and before the Overview narrative
- [ ] **At least one Known Limitation has `>` blockquote prefix** (first one with an unresolved dependency, or first one listed if none have explicit dependencies)

If the document was NOT generated by the pipeline (manually authored or pre-pipeline), run the full verification checklist below before saving.

<details>
<summary>Full verification checklist (non-pipeline documents only)</summary>

### Quality Dimensions (apply to every section)

- [ ] **Accuracy:** Content matches source. No additions, no misattributions, no distortions.
- [ ] **Clarity:** A reader unfamiliar with the internal doc understands without ambiguity.
- [ ] **Completeness:** Full scope of the source material for that section is represented.
- [ ] **Format:** Section adheres to its transformation type (COPY, RELOCATE, or NARRATIVE ASSEMBLY).

### Content Integrity Checks

- [ ] **FR diff:** Every FR heading and every business rule bullet in the output exists word-for-word in the cleaned source.
- [ ] **Scope diff:** In Scope and Out of Scope tables are identical to source.
- [ ] **Visual States diff:** Visual States table is identical to source.
- [ ] **User Flow diff:** Every numbered flow step and every alternative path row is identical to source.
- [ ] **Open Questions count:** All source rows present (open and struck-through).
- [ ] **Constraints count:** Every source fact represented exactly once across Constraints, Risks, Assumptions, Known Limitations, or Open Questions.
- [ ] **Dependencies count:** Matches source minus struck-through rows and items reclassified as OQs.

### Cleanup Checks

- [ ] Zero remaining `SRC-N` codes anywhere
- [ ] Zero remaining `(Source: Implicit)` or `(Source: User-confirmed)` markers
- [ ] Zero remaining internal stage file references in body text
- [ ] Zero struck-through text anywhere except descoped FRs in Section 5 and resolved rows in Section 7
- [ ] Zero remaining `(Assumption H2)` or similar internal codes
- [ ] No Change History section exists
- [ ] No standalone Success Metrics table exists
- [ ] No Stakeholders table exists
- [ ] No Personas/User Context section exists
- [ ] No Business Context section exists
- [ ] No standalone Sources section exists
- [ ] No Generation Summary block exists

### FR Verbosity Checks

- [ ] Zero Engineering Note blocks in Section 5 FRs
- [ ] Zero Implementation Note blocks in Section 5 FRs
- [ ] Zero stakeholder direction blocks in Section 5 FRs
- [ ] Zero inline annotation tags in FR business rules
- [ ] Zero FR business rule bullets that duplicate a Hard Constraint
- [ ] Zero intra-FR duplicate bullets
- [ ] Zero Simple FRs rendered with sub-labels
- [ ] Zero `**Phase: 1**` or `**Phase: 2/3**` tag lines remaining in FR headers

### Deduplication Checks

- [ ] Zero items appear in more than one subsection of Constraints and Risks
- [ ] Zero items appear in both Constraints and Risks AND Open Questions
- [ ] All cross-references are current after any renumbering

### Structure Checks

- [ ] Document has correct section count (7 or 8 numbered sections + Appendix)
- [ ] Section numbering is sequential and correct
- [ ] `Audience:` field set to `Business, Product, UX, Technology, Executive`
- [ ] Overview opens with problem, not feature name; 3–5 sentences; no label prefixes
- [ ] Scope boundary not mentioned in Overview
- [ ] Visual States in Appendix A; Error Handling in Appendix B; Audit Trail (if present) in Appendix C
- [ ] No Appendix D exists
- [ ] Section 3/4 has plain-text callouts to Appendix A and B
- [ ] Section 3/4 contains no screen element inventories, responsive behavior notes, or User Action tables
- [ ] No Phase 2/3 flow rows in the flow table
- [ ] No trivial OS handoff flows in the flow table

</details>

---

## Phase 3.5: Word Count Enforcement

After Phase 3 verification passes, check whether the client document meets the length target for its feature classification.

### Read the Classification

Look for the `**Complexity: X | Size: Y**` tag in the source document header. If the tag is absent, infer from document signals:
- Count user flows in Section 6 → map to Size
- Count FRs and check for external systems → map to Complexity
- If still unclear, default to Medium/Medium and note it in the report

### Apply the Ceiling

| | Small (≤3 flows) | Medium (4–7 flows) | Large (8+ flows) |
|---|---|---|---|
| **Simple** | 300–600 words | 600–1,000 words | 1,000–1,500 words |
| **Medium** | 700–1,200 words | 1,500–2,500 words | 2,500–3,500 words |
| **Complex** | 1,200–2,000 words | 2,500–4,000 words | 4,000–6,000 words |

**Measure:** Count words in Sections 1–9 only. Exclude Section 10 (Open Questions), Section 11 (References), and all Appendix content. Open Questions and References are metadata — they inflate word count based on feature maturity, not requirement content volume.

### Apply Reduction Hierarchy (if over ceiling)

Work through priorities in order. Stop as soon as the document is within the ceiling.

**Priority 1 — Remove (zero information loss):**
- Cross-FR duplicate rules → should already be removed upstream; scan and remove any that remain
- Implementation Notes → should already be stripped in Phase 1.2; scan for any remaining
- Phase: 1 labels → should already be stripped; scan for any remaining
- FR blockquote callouts inside Phase 1 FRs that duplicate a Dependencies table row → remove from FR body

**Priority 2 — Relocate to Appendix (zero main-body loss):**
- Any Visual States or Error Handling content still in Section 6 body → move to Appendix A/B
- Any Phase 2/3 full specs still in Section 7 body → compress to one-line note only

**Priority 3 — Condense structure:**
- Simple FRs still rendered with sub-labels → convert to bullet list (should be done in Phase 2; scan for any remaining)
- Single-item sections where the heading + one bullet could be merged into the Overview or Constraints section → collapse

**Priority 4 — Compress prose:**
- FR descriptions that restate the FR heading word-for-word → shorten description to add new information only
- Business rule bullets that state a self-evident consequence of another rule → fold into the parent rule

**Priority 5 — Never cut:**
- Testable business rules with no other home in the document
- [TBD] items with stakeholder routing
- Blockers and critical dependencies
- Open questions requiring decisions
- Phase boundaries and deferred item markers

### Report

If within ceiling after Phase 2 transformations (before reduction hierarchy): no action needed. Report the word count in the transformation summary.

If reduction hierarchy was applied: report which priority level was needed.

If the document is still over ceiling after exhausting Priority 4: do NOT cut Priority 5 content. Report:
> ⚠️ Word count [N] exceeds ceiling [M] for [Complexity/Size] classification after Priority 4 reduction. Recommend reclassifying to [next tier]. No requirement content was removed.

---

## Step: Determine Output Folder

The pipeline defines that client-ready documents live in a `client-ready/` folder parallel to `Internal/`. This skill is responsible for checking and creating that folder.

1. Let `input_dir` = the directory containing the input document.
2. If `basename(input_dir)` is `Internal`:
   - Set `output_dir` = `input_dir/../client-ready/` (sibling of `Internal`).
3. Otherwise:
   - Set `output_dir` = `input_dir/client-ready/`.
4. If `output_dir` does not exist, create it (`mkdir -p`).

## Step: Save and Report

Save the transformed document as:
```
[output_dir]/Securitas-Client-Requirements-[Feature].md
```

Report the transformation summary:
```
Securitas client-ready document saved: Securitas-Client-Requirements-[Feature].md

Structure: [N] sections (down from [M] in source)
Lines: [N] (down from [M] in source)

Sections:
1. Overview (narrative paragraph: problem → outcomes → priorities + launch date)
2. Personas (copied verbatim from Section 2)
3. User Goals (copied verbatim from Section 3)
4. Scope (copied verbatim from Section 4)
5. What's Changing (copied verbatim from Section 5) [or "Omitted -- net-new feature"]
6. User Flows (copied verbatim from Section 6; Appendix A and B callouts added)
7. Functional Requirements (COPY + VP filter per bullet -- [N] FRs; [N] Low-impact bullets → Appendix E; Audit Trail → Appendix C)
8. Known Limitations (copied verbatim from Section 8) [or "Omitted -- no known limitations"]
9. Risks, Constraints & Assumptions (VP-filtered from Section 9.1, 9.2, 9.3; overflow → Appendix G)
10. Open Questions ([N] Critical/High items; [M] resolved removed; [P] Medium/Low → Appendix G)
11. References ([N] source materials)
Appendix A: Visual States ([N] rows)
Appendix B: Error Handling ([N] rows)
[Appendix C: Audit Trail ([N] events) -- if present]
[Appendix D: Detailed User Flows ([N] flows) -- if present]
[Appendix E: Field-Level Specs ([N] rows) -- if present]
[Appendix G: Medium/Low OQs + Section 9 overflow -- if present]

Verification:
- FR content: identical to source
- Simple FRs rendered as prose: [N]
- Phase 2/3 FRs compressed to one-liners: [N]
- Open questions: [N] Critical/High / [M] Medium/Low → Appendix G / [P] resolved removed
- Section 9 VP filter: [N] items included / [M] overflow → Appendix G
- Appendix E: [N] field-level spec rows (if present); [N] Low-impact bullets demoted from FR bodies
- Cleaning: [N] SRC codes removed, [N] internal markers removed
- Word count: [N] words ([Complexity/Size] ceiling: [range]) [Within limit / Priority [X] reduction applied / Reclassification recommended]
```

---

## Critical Rules

1. **Never change requirement content.** FR headings, descriptions, business rules, and engineering notes must be word-for-word identical to the cleaned source. Exception: FRs tagged `**Type: Simple**` may be rendered as a faithful prose summary (2–4 sentences covering all business rules). The prose must not add, remove, or distort any rule — every fact from the source must be present in the summary. Word-for-word sub-labeled structure is not required for Simple FRs.
2. **Never remove [TBD] items.** These are still open and the client needs to see them.
3. **Never synthesize or paraphrase.** Every sentence in the output (except the Overview) must exist verbatim in the source. If you cannot point to the source sentence, do not write it.
4. **Overview: problem first, outcomes second, priorities third.** The Overview opens with the business problem or compliance driver, states what is changing in Sentence 2, names officer/DM outcomes, and closes with priorities and launch date. No label prefixes. No scope boundary (Section 2 covers it). 3–5 sentences. Every clause must be traceable to the source.
5. **Relocate, do not merge.** When consolidating constraints/risks from multiple sections, copy each bullet individually. Do not combine two bullets into one.
6. **Keep "What's Changing" when the feature modifies an existing screen.** This section is valuable to the client and is explicitly requested.
7. **No Change History** in client documents. This is internal revision tracking.
8. **No Success Metrics** unless a specific Mixpanel event or metric is identified in the source.
9. **No Stakeholders table.** The client knows who the stakeholders are.
10. **Personas and User Goals are included as Section 2 and Section 3.** Copy verbatim from Section 2 Personas and Section 3 User Goals. Do not generate or rewrite them. Do not include a separate Business Context, User Context, or Stakeholders section — those are internal sections removed entirely.
11. **Visual States, Error Handling, and detailed flows go in the Appendix**, not in the main body. Add plain-text callouts in Section 6 pointing to Appendix A (Visual States), Appendix B (Error Handling), and Appendix D (detailed flows). This keeps the flows section readable while preserving detail for reviewers who need it.
12. **Preserve descoped items** (struck-through FRs) for decision trail. Preserve struck-through rows in Open Questions for record keeping. Only remove struck-through items from Assumptions and Dependencies.
13. **No em dashes.** Replace with a comma, colon, or rewrite. Exception: em dashes inside quoted notification text (that is requirement content) are preserved exactly.
14. **One pass.** Apply all transformations before saving. Do not create intermediate versions.
