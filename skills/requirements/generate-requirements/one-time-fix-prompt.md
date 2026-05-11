# One-Time Fix Prompt — Internal Feature Requirements

Apply this prompt to any existing `Feature-Requirements-*.md` file that was generated before the skill redesign (May 2026). This brings the internal document into alignment with the new 11-section template structure so that `client-ready-requirements` can process it correctly.

**Fixes 1–9** address FR tagging, scope grouping, phase gating, deduplication, and Figma URLs.
**Fixes 10–15** address structural changes from the internal template redesign: removing engineering-level sub-sections from FRs, removing obsolete tables from UX Context and Personas, deleting Technical Context and Stakeholders, and consolidating all constraint-related content into a single Section 9.

**How to use:** Paste the section below (starting at "---") into your AI assistant, followed by: "Apply this to `[path/to/Feature-Requirements-FeatureName.md]`."

---

## Instructions: Structural Fix for Feature-Requirements-*.md

Read the target `Feature-Requirements-*.md` file. Apply all fifteen fixes below in order. Save the updated file. Do not change any requirement content unless explicitly instructed by a fix item. Preserve all formatting, section order, and wording not targeted by these fixes.

---

### Fix 1 — Add FR Complexity Tag

For each `#### FR-N:` heading, classify the FR and add a `**Type:**` line immediately after the heading (before `**Description:**`).

**Classification rules:**

- **Simple** — all of the following are true:
  - 3 or fewer business rule bullets
  - No conditional branches in any rule (no "if/else", "when X then Y", "unless")
  - No external system integration required (no API call, no third-party service)
  - No failure path or error state specific to this FR
- **Complex** — any one of the above conditions is false

**Format to insert:**

```
#### FR-N: [Name]

**Type: Simple**
```

or

```
#### FR-N: [Name]

**Type: Complex**
```

Do not add a Type tag to FRs that already have one.

---

### Fix 2 — Add Phase Header to Deferred FRs

For each FR that is deferred to Phase 2 or Phase 3, add `**Phase: 2/3**` as a structured header field immediately after the `**Type:**` line (or after the FR heading if no Type tag yet — but Fix 1 runs first).

**Detection:** An FR is deferred if any of the following are true:
- The FR body contains a blockquote starting with `> Phase 2/3` or `> This requirement is deferred`
- The FR heading or description explicitly states "Phase 2", "Phase 3", or "deferred"
- The FR is listed in the Out of Scope table as a future phase item

**Format to insert:**

```
**Type: Complex**
**Phase: 2/3**
```

Do not add a Phase header to Phase 1 FRs.

---

### Fix 3 — Regroup In Scope Table by User-Facing Capability

Locate the **In Scope** table in the Scope section. If the table rows are a flat inventory of system elements (e.g., "Sign In button", "Language selector", "Error banner"), regroup them under bold capability header rows.

**Grouping rule:** A capability is something a user can **do** or **experience** (e.g., "Sign In", "Language Selection", "Error Recovery"). System elements and UI components nest under the capability they support.

**Format:**

```markdown
| Capability | Description | Source |
|---|---|---|
| **Authentication** | | |
| Sign-in button | Primary CTA for username/password login | SRC-1 |
| Biometric sign-in | Face ID / fingerprint login option | SRC-2 |
| **Language Selection** | | |
| Language selector | Allows officer to set display language | SRC-3 |
```

Rules:
- Capability header rows have a bold name in the first column, empty Description and Source cells
- Sub-rows are indented by content (not spaces — just listed under the header)
- Every existing row must appear under exactly one capability group — no rows dropped
- If all rows already belong to a single obvious capability, one group header is sufficient
- Do not change the column names or add/remove rows

---

### Fix 4 — Replace Cross-FR Duplicate Business Rules with Forward References

Scan every FR's Business Rules list. For each bullet, check whether the same rule (same fact, same condition) already appears in a different FR's Business Rules list.

**Rule:** Each business rule lives in exactly one FR — the FR that owns the behavior. If a rule logically belongs to FR-Y (because FR-Y is the authoritative owner of that behavior), the duplicate bullet in FR-X should be replaced with a forward reference.

**Forward reference format:**

```
- See FR-Y for [brief topic description].
```

**Examples:**
- If FR-3 states "System must support English, French, and Spanish" and FR-7 also states the same localization rule, keep it in the FR that owns localization and replace the other with "See FR-7 for language display rules."
- If FR-2 states "System must log all authentication events to the audit trail" and FR-6 also states the same audit logging rule, keep it in the FR that owns audit/compliance and replace the other.

**Do not** replace a rule with a forward reference if the rule in FR-X has additional conditions or specifics that don't appear in FR-Y — that is a distinct rule that should stay.

---

### Fix 5 — Remove Phase 2/3 Bullets from Phase 1 FRs

Scan every FR that does **not** have a `**Phase: 2/3**` header (i.e., Phase 1 FRs). For each business rule bullet that contains a "Phase 2/3 only:" prefix or equivalent marker, remove the bullet entirely.

**Detection patterns:**
- Bullet starts with `Phase 2/3 only:` or `Phase 2/3:`
- Bullet contains `(Phase 2/3)` or `(deferred)` as a qualifier on the rule itself
- Bullet states a behavior that is explicitly deferred (e.g., "Biometric re-authentication after session timeout — Phase 2")

**Action:** Delete the bullet. If the deferred behavior has its own Phase 2/3 FR, do not add a forward reference — the Phase 2/3 FR already covers it. If no corresponding Phase 2/3 FR exists, move the behavior to the Out of Scope table.

---

### Fix 5a — FR-2 Content Error (Login Landing specific)

**Only apply this fix to `Feature-Requirements-LoginLanding.md`.**

In FR-2's `**Description:**` field, locate any reference to a "promotional card" or "three navigable elements" that includes the promotional card.

Change:
> "three navigable elements: a primary sign-in action, a password recovery action, and a promotional card"

To:
> "two navigable elements: a primary sign-in action and a password recovery action"

The promotional card is a Phase 2/3 item and must not appear in the Phase 1 FR description.

---

### Fix 6 — Phase Consolidation (One Mention per Deferred Item)

For each feature that is deferred to Phase 2/3 (identified by having a `**Phase: 2/3**` FR header after Fix 2):

1. Confirm the deferred item has exactly one row in the **Out of Scope** table. If it is missing, add it. If the document has no Out of Scope table at all, note this as a structural gap but still remove the Phase 2/3 mentions below.
2. Scan every section below for additional mentions of that deferred item and apply the action specified.
3. The deferred item's Phase 2/3 FR body and the Out of Scope row are the only two permitted locations for any discussion of that item.

**Scope of scan and action per location:**

| Location | Action |
|---|---|
| **Business Goals / Business Context section** | Delete any blockquote or bullet that announces the deferral of this item (e.g., `> **Phase 2/3 deferred:** The marketing surface for career discovery is deferred...`). The Out of Scope table is the single source of truth — a separate announcement in Business Goals is redundant noise. |
| **Personas / User Context section** | If a persona sub-section is dedicated entirely to a Phase 2/3 feature (e.g., "Prospective Employee" whose only access path is through a deferred feature), reduce the full persona card to a one-liner: `> **Phase 2/3 only.** [Persona name] is not served in this release. See Out of Scope.` Delete all remaining content in that sub-section. |
| **UX Context screen content list** | Delete any list item that describes a Phase 2/3 feature — including items rendered as strikethrough (e.g., `~~"Explore Securitas" card~~ — NOT Phase 1. Phase 2/3.`). These items have no Phase 1 meaning and add noise. |
| **Phase 1 FR Business Rules** | Replace any bullet prefixed with `Phase 2/3 only:` with `(Phase 2/3 — see Out of Scope)` or delete entirely if the sentence has no other content. |
| **User Flow tables** | Remove any row whose Outcome column starts with `(Phase 2/3` or explicitly names a deferred feature as the destination. |
| **Visual States table** | Remove rows where the State column describes a state that exists ONLY because the Phase 2/3 feature is active (e.g., "Explore Securitas card expanded"). **KEEP** rows that document Phase 1 behavior in response to an absent Phase 2/3 feature — these are Phase 1 states, not Phase 2/3 states (e.g., "Explore Securitas card hidden — Phase 1: card is always hidden" must stay). |
| **Future Enhancements section** | Delete all bullets. The section itself will be removed by Fix 15. |
| **Known Limitations** | Replace any bullet that discusses a deferred item's future behavior with `(Phase 2/3 — see Out of Scope)` or delete if the sentence has no other content. |

**Do not** modify:
- The deferred FR's own body (it will be compressed by the client-ready skill)
- The Out of Scope table row for the deferred item
- The Phase 2/3 FR heading
- Visual States rows that document Phase 1 behavior in response to a suppressed Phase 2/3 feature

---

### Fix 7 — Known Limitations Dedup Against Dependencies

Locate the **Known Limitations** section and the **Assumptions & Dependencies** table (or equivalent Dependencies table).

For each bullet in Known Limitations, check whether the same fact is already captured as a row in the Dependencies table — same system, same team, same unresolved status.

**Rule:** If the Known Limitation and the Dependency row describe the same unresolved constraint (same owner, same blocking condition), delete the Known Limitations bullet. The Dependencies table is the authoritative home for items with an owner and a delivery status.

**Keep** the Known Limitations bullet if:
- It describes an accepted trade-off being shipped (not a blocking item with an owner)
- It has no corresponding Dependencies row
- It describes a capability gap (something the system intentionally will not do) rather than a delivery dependency

---

### Fix 8 — Add Complexity and Size Classification Tag to Document Header

Read the document header (the block of metadata fields at the top: Version, Date, Status, Feature type, Platform, etc.).

**Add the following line to the header block, immediately after `**Feature type:**`:**

```
**Complexity: [Simple | Medium | Complex] | Size: [Small | Medium | Large]**
```

**Classification guide — choose based on these signals in the document itself:**

| Axis | Simple | Medium | Complex |
|---|---|---|---|
| **Complexity** | 1 actor, ≤5 scenarios, 0 external systems, no Phase 2/3 FRs | 2 actors OR 6–15 scenarios OR 1 external system | 3+ actors OR 16+ scenarios OR 2+ external systems |

| Axis | Small | Medium | Large |
|---|---|---|---|
| **Size** | ≤3 user flows | 4–7 user flows | 8+ user flows |

**How to count:**
- **Actors:** Count distinct user types or systems that initiate an action (e.g., Officer, System, Admin each count as 1).
- **Scenarios:** Count rows in User Flow tables + distinct error states in Error Handling tables.
- **External systems:** Count third-party services or APIs the feature calls (e.g., Okta = 1, CDN = 1).
- **User flows:** Count numbered flow rows in the User Flows section (F1, F2, F3 … = 3 flows).

**Examples:**
- Login Landing: 1 actor (Officer), 7 flows (F1–F7), 1 external system (Okta) → **Medium / Medium** *(7 flows = Medium size per the table above; if this document was previously tagged `Medium / Small`, correct it to `Medium / Medium` before re-running the client-ready skill)*
- Clock-In Flow: 1 actor, 12+ flows, 2 external systems → **Medium / Medium**

**Do not add this tag if it already exists in the header.**

---

### Fix 9 — Replace Figma Node Reference with a Proper Hyperlink

**Why:** The `client-ready-requirements` skill copies the Figma link from the internal document into Section 4 (Design reference) and Section 8 (References). The Phase 1.2 cleaning rules strip node ID suffixes from existing URLs — but they cannot construct a URL from a file ID code. If the internal document stores the Figma reference as a backtick-formatted file ID (e.g., `` Figma — MyConnect 2026, node `37234:15449` (File: `GPiSba9PGgk2wKyNVO1jMU`) ``), the client-ready document will not contain a working hyperlink.

**What to find:** Look for lines in the following formats anywhere in the document:

```
**Design asset:** Figma — [Name], node `N:N` (File: `FILE_ID`) ...
- **Figma design:** [Name], node `N:N` (File: `FILE_ID`)
```

**Replace with proper markdown hyperlinks:**

```
**Design asset:** [Display Name](https://www.figma.com/design/FILE_ID)
- **Figma design:** [Display Name](https://www.figma.com/design/FILE_ID)
```

**Rules:**
- Construct the URL as `https://www.figma.com/design/FILE_ID` using the file ID found in the backtick-formatted `(File: ...)` reference
- Use a human-readable display name (e.g., `MyConnect 2026: Login Landing`) — not the raw file ID
- Remove the node ID entirely — no `node N:N` or `Figma node N:N` should remain in the line
- Also strip any `*(Source: SRC-N)*` citation from the line (these are removed in Phase 1.2 cleaning anyway)
- If the line already contains a proper `https://` markdown hyperlink, skip this fix for that line

**After the fix, the lines should look like:**
```
**Design asset:** [MyConnect 2026: Login Landing](https://www.figma.com/design/GPiSba9PGgk2wKyNVO1jMU)
- **Figma design:** [MyConnect 2026: Login Landing](https://www.figma.com/design/GPiSba9PGgk2wKyNVO1jMU)
```

---

### Fix 10 — Remove Inputs, Outputs, and Validation Sub-sections from FRs

For every FR, scan for the following sub-section labels and delete them along with their content:

- `**Inputs:**` (and all bulleted lines under it)
- `**Outputs:**` (and all bulleted lines under it)
- `**Validation:**` (and all bulleted lines under it, including any `Frontend:` / `Backend:` sub-labels)

**Rules:**
- Before deleting, scan each `**Validation:**` block for any rule that is a genuine business constraint (e.g., "password must be 8+ characters", "session expires after 15 minutes of inactivity"). If such a rule is not already present in the `**Business Rules:**` list for that FR, move it there before deleting the Validation block.
- `**Description:**`, `**Business Rules:**`, and `**Source:**` are **not** touched.
- If an FR has no Inputs, Outputs, or Validation blocks, skip it.

---

### Fix 11 — Remove Responsive Design and Key Interactions Tables from UX Context

Locate the **UX Context** section (may be titled "UX Context", "User Experience", or "Design Context").

**Part A — Responsive Design table:** If a table titled "Responsive Design", "Responsive Behavior", or equivalent exists in this section, remove it entirely. Before deleting, scan each row for a hard constraint that applies at runtime (e.g., "portrait orientation only", "minimum tap target 44px per WCAG"). If such a constraint is not already captured in the Constraints or Compliance & Constraints section, add it as a new bullet there first.

**Part B — Key Interactions / User Action table:** If a table titled "Key Interactions", "User Actions", "User Action / System Response", or equivalent exists in this section, remove it entirely. These interactions are fully captured in the FR Business Rules and User Flow tables — no content migration is needed.

**Keep:** The design reference link, user flow table, and any Visual States / Error Handling appendix callout lines in UX Context.

---

### Fix 12 — Remove High-Level User Journey from User Context / Personas Section

Locate the section titled "User Context", "Personas", "Users", or equivalent (the section listing who uses the feature).

If that section contains a subsection titled "High-Level User Journey", "User Journey", "Journey Steps", or a numbered list of journey steps (e.g., "1. Officer opens app → 2. Sees landing screen → …"), remove that subsection entirely.

**Why:** User flows are fully defined in the UX Context section. The journey summary in the Personas section duplicates that content and adds maintenance overhead.

**Keep:** Persona descriptions, goals, pain points, usage patterns, and quotes.

---

### Fix 13 — Remove Technical Context Section

Locate any section titled "Technical Context", "Technical Background", "Tech Stack", or equivalent.

Before deleting, scan each bullet or row for a non-negotiable hard constraint (e.g., "must use iOS Keychain for credential storage", "CDN serves assets — cannot guarantee cache freshness"). If such a constraint is not already present in the Constraints or Compliance & Constraints section, add it as a new Hard Constraint bullet there first.

Delete the Technical Context section entirely after migrating any hard constraints.

---

### Fix 14 — Remove Stakeholders Table from Business Context

Locate the **Business Context** or **Business Goals** section. If it contains a **Stakeholders** table or list (names, roles, responsibilities), remove it entirely.

**Why:** Stakeholder tracking belongs in the project RACI or sprint planning docs, not in the feature requirements. It adds noise and requires ongoing maintenance.

**Do not** remove the Business Goals, success metrics, or persona references from this section — only the Stakeholders table/list.

---

### Fix 15 — Consolidate Scattered Constraint Sections into Section 9

This is the largest structural fix. The new internal template consolidates all constraint-related content into a single **Section 9: Constraints, Risks, and Open Items** with five sub-buckets. Apply this fix after all previous fixes.

**Step 1 — Collect.** Scan the document and collect every fact destined for Section 9 from these source locations:

| Source location | Collect what |
|---|---|
| Section 2 Constraints sub-section (if present) | All bullets |
| Section 7 Compliance & Constraints (if present) | All rows / bullets |
| Section 11 Known Limitations (if present) | All bullets |
| Section 13 Assumptions & Dependencies (if present) | All table rows |
| Section 15 Open Questions / TBD Items (if present) | All rows |
| Inline constraint callouts in FRs (e.g., "Note: requires WCAG 2.1 AA") | Move to Section 9 and delete the inline callout |

**Step 2 — Classify.** For each collected fact, assign it to exactly one sub-bucket using these rules:

| Sub-bucket | Assign when |
|---|---|
| **Hard Constraints** | Non-negotiable rule — legal, compliance, platform policy, or security mandate. Cannot be changed without external approval. |
| **Dependencies** | A deliverable the team is waiting on from another team, vendor, or system before this feature can ship. Has an owner and a delivery date/status. |
| **Assumptions** | A fact the team is treating as true without confirmation. If wrong, the requirement changes. |
| **Known Limitations** | An accepted trade-off being shipped. The system intentionally will not do something, and stakeholders have acknowledged it. |
| **Open Questions** | An unresolved question that must be answered before or during development. No answer yet. |

**Tiebreaker rules:**
- If a fact has both a constraint nature AND an unresolved element → Open Question (because it blocks a decision)
- If a fact is "we assume X is true" AND X is unverified → Assumption
- If a fact is "we know X will not work" AND stakeholders have accepted it → Known Limitation
- If the same fact appears in two source sections → keep it in the higher-priority sub-bucket (order above is highest to lowest priority); delete the duplicate

**Step 3 — Write Section 9.** After the last existing numbered section and before any appendices, insert the new consolidated section:

```markdown
## Section 9: Constraints, Risks, and Open Items

### Hard Constraints

- [List each hard constraint as a bullet]

### Dependencies

| Dependency | Owner | Status | Needed by |
|---|---|---|---|
| [System or deliverable] | [Team / person] | [Pending / Confirmed] | [Sprint or date] |

### Assumptions

- [List each assumption as a bullet]

### Known Limitations

- [List each known limitation as a bullet]

### Open Questions

| ID | Question | Owner | Target date |
|---|---|---|---|
| OQ-1 | [Question text] | [Owner] | [Date or sprint] |
```

**Step 4 — Delete old sections.** Delete the original source sections collected in Step 1 (Section 2 Constraints sub-section, Section 7 Compliance & Constraints, Section 11 Known Limitations, Section 13 Assumptions & Dependencies, Section 15 Open Questions) after their content has been migrated to Section 9. Do not delete Section 2's Business Goals content — only the Constraints sub-section within it.

**Step 5 — Renumber.** If deleting sections leaves gaps in the section numbering, renumber to keep them sequential (skip numbers are not permitted in the final document).

---

### Verification After Applying All Fixes

Before saving, confirm:

**Fixes 1–9 (original)**
- [ ] Every FR has a `**Type:**` field (Simple or Complex)
- [ ] Every deferred FR has a `**Phase: 2/3**` field immediately after `**Type:**`
- [ ] In Scope table has at least one capability group header row
- [ ] No business rule bullet appears in more than one FR (or has been replaced with a forward reference)
- [ ] No Phase 1 FR contains a bullet with a "Phase 2/3 only:" prefix
- [ ] FR-2 description does not mention the promotional card (Login Landing only)
- [ ] Each deferred item appears in Out of Scope and nowhere else in the document body (except inside its own Phase 2/3 FR)
- [ ] No Known Limitations bullet restates a Dependencies row
- [ ] Document header contains a `**Complexity: X | Size: Y**` tag
- [ ] Every Figma reference in the document is a proper markdown hyperlink (`[Name](https://www.figma.com/design/FILE_ID)`) — no backtick-formatted file IDs or node IDs remain

**Fixes 10–15 (template redesign)**
- [ ] No FR contains an `**Inputs:**`, `**Outputs:**`, or `**Validation:**` sub-section
- [ ] UX Context section contains no Responsive Design table or Key Interactions / User Action table
- [ ] User Context / Personas section contains no High-Level User Journey sub-section or journey step list
- [ ] No Technical Context section exists anywhere in the document
- [ ] No Stakeholders table or list exists in the Business Context / Business Goals section
- [ ] A single **Section 9: Constraints, Risks, and Open Items** exists with five sub-buckets: Hard Constraints, Dependencies, Assumptions, Known Limitations, Open Questions
- [ ] No standalone Compliance & Constraints, Known Limitations, Assumptions & Dependencies, or Open Questions sections exist outside Section 9
- [ ] Section numbering is sequential with no gaps

Save the file. The document is now ready to be processed by `client-ready-requirements`.
