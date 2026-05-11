# Workflow 2: Generate Requirements Documents

**Called from:** `workflows/01-synthesize.md` after user approves Context Summary
**Next step:** `workflows/03-validate.md` after documents are generated
**Reads:** `[output-folder]/Context-Summary-[Feature-Name].md`
**Outputs:**
- `[output-folder]/Generated/Internal/Feature-Requirements-[Feature-Name].md`

> `[output-folder]` is the path provided by the user during SKILL.md intake. It is NOT a hardcoded path.

## NON-NEGOTIABLE (read first)
1. Every FR describes WHAT (capability), never HOW (implementation) or WHAT IT LOOKS LIKE (UI).
2. Every (Source: SRC-N) citation must be verified against the actual source content.
3. Save generated document to file before presenting. Chat is ephemeral.
4. Each item lives in exactly one section. Zero cross-section duplicates.
5. Wait for user approval before proceeding to validation.

## Critical Rules

| Do | Don't |
|-------|---------|
| Save the file before presenting | Display only in chat |
| Run inline quality check before presenting | Present documents with known failures |
| Flag all TBDs with stakeholder routing | Leave TBDs without context |
| Keep within word limits | Write exhaustive documents beyond limits |
| Wait for user feedback at the end | Auto-proceed to validation |

---

## 🎯 Purpose

Convert the validated Context Summary into a polished Feature Requirements document.
The document is saved as a file. Mode and scope were determined in SKILL.md.

---

## 🔧 Execution Mode Rules

| Mode | Analysis Depth | Attribution |
|------|---------------|------------|
| **Quick** | 3 contexts (Business, Product, UX) | Tier 1 only |
| **Comprehensive** | 6 contexts (+ Persona, Technical, Compliance) | Tier 1 + Tier 2 (60%+) |

---

## 📖 Step 1: Read Context Summary

Read the saved Context Summary file:
```
[output-folder]/Context-Summary-[Feature-Name].md
```

Validate before proceeding:
- [ ] All required contexts are present (3 for Quick, 6 for Comprehensive)
- [ ] Mode is clearly stated
- [ ] Source coverage meets threshold (Tier 1 minimum)
- [ ] EXISTING vs NEW classification present (if applicable)

If the file is missing or incomplete, ask the user to re-run Workflow 1 or provide missing context.

---

## 📊 Step 2: Confirm Scope

This workflow generates one document: **Feature Requirements**. The depth of analysis depends on the mode (Quick: 3 contexts, Comprehensive: 6 contexts) determined in SKILL.md.

> **Note:** API Contracts and System Flows are generated separately after requirements are finalized, using dedicated skills (`rest-api-contract-generator`, etc.).

State upfront which documents you'll generate:
```
📄 Documents to generate:
1. Feature Requirements ✅ (always)
2. API Contract ✅ / ❌ — [reason]
3. System Flow ✅ / ❌ — [reason]
```

---

## 📊 Step 2.5: Classify Feature Complexity and Size (Pass 2)

This is Pass 2 of the two-pass classification system. Pass 1 is the user-confirmed estimate captured at Stage 3.5 of the pipeline. Pass 2 auto-calculates from the artifacts now available.

**Calculate from the Context Summary:**

| Signal | Count |
|---|---|
| User flows (numbered flows in Context Summary) | |
| Distinct scenarios (happy path + alternative paths) | |
| External systems / integrations | |
| High-risk assumptions (H-tier) | |

**Apply the classification:**

| | Small | Medium | Large |
|---|---|---|---|
| **Flow count** | ≤3 flows | 4–7 flows | 8+ flows |

| | Simple | Medium | Complex |
|---|---|---|---|
| **Actor count** | 1 actor | 2 actors | 3+ actors |
| **Scenario count** | ≤5 scenarios | 6–15 scenarios | 16+ scenarios |
| **External systems** | 0 | 1 | 2+ |

Combine the two axes to produce a classification: e.g., `Complexity: Medium | Size: Small`.

**Write the classification to the document header** (below the Version/Date/Owner/Status block):

```
**Complexity: [Simple | Medium | Complex] | Size: [Small | Medium | Large]**
```

**Divergence check:** If Pass 2 classification differs from Pass 1 (Stage 3.5 user-confirmed estimate) by more than one tier on either axis, flag it:

```
⚠️ Classification divergence: Stage 3.5 estimated [X/Y], Pass 2 calculated [A/B].
   Proceeding with Pass 2 result. Confirm or override before generating client-ready document.
```

If called outside the pipeline (no Stage 3.5 estimate exists), skip the divergence check and use Pass 2 result directly.

---

## 📊 Step 2.5b: Set Word Budget

Using the Complexity × Size classification from Step 2.5, look up the word budget for this document. Record it before generating — this is the target, not a post-generation trim trigger.

**Sections excluded from word count** (write to completeness — do not count toward limit):
- Header block + Generation Summary
- Appendix B: Error Handling
- Section 10: Open Questions
- Section 11: References
- Appendix A, D, E

**Complexity-scaled word limits (budgeted sections only):**

| Pipeline Mode | Complexity | Size | Word Limit |
|---|---|---|---|
| Express / Quick | Simple | Small | 1,000–1,500 |
| Standard / Quick | Simple–Medium | Small–Medium | 1,500–2,500 |
| Standard / Comprehensive | Medium | Medium | 2,500–3,500 |
| Full / Comprehensive | Complex | Medium | 3,500–4,500 |
| Full / Comprehensive | Complex | Large | 4,000–5,000 |

**If this feature doesn't match a row exactly** (e.g., Simple/Large or Complex/Small): use the nearest row by Complexity first, then Size. Flag the approximation in the Generation Summary.

**Record the target budget:**
```
📊 Word budget: [lower]–[upper] words (budgeted sections only) | Complexity: [X] | Size: [Y] | Mode: [Quick/Comprehensive]
```

This line is for your working record only — it does not appear in the document. Proceed to Step 3.

---

## 📝 Step 3: Generate Feature Requirements (ALWAYS)

**Template:** `templates/feature-requirements.md`

**Language rules (enforce strictly):**
- ✅ "System must generate the report within 60 seconds" — factual requirement
- ❌ "System should consider performance optimization" — opinion
- ✅ Plain English only
- ❌ No code snippets, SQL, class names, or implementation details
- ✅ "As a [persona], I need [capability] so that [outcome]" for user-facing requirements
- ❌ No vague words: "should", "probably", "might", "could"

**Requirement purity rules (enforce strictly):**
- ✅ Requirements describe WHAT (capability or constraint). HOW (implementation) and WHAT IT LOOKS LIKE (UI pattern) are out of scope for this document.
- ❌ "Cache schedule data locally for offline access" — this is a SOLUTION. Reframe: "Schedule must remain viewable when offline"
- ❌ "Organize schedule as Past | This Week | Future tabs" — this is a DESIGN DECISION. Reframe: "User can navigate across past, current, and future time periods"
- ✅ If a statement prescribes an implementation approach, reframe it as the underlying need and add an **Implementation Note** callout
- ✅ If a statement prescribes a UI pattern or layout, move it to **Open Questions / Design Decisions** unless the user explicitly confirmed the design
- ✅ When citing `(Source: SRC-N)`, the source must actually contain the claimed information — do not attribute content to a source that does not say it

**Language register rules (enforce strictly):**

Every FR description sentence and business rule bullet must be written from the user's point of view. The subject of every sentence is the user, or what the user sees, does, or experiences — never the system processing something internally.

**Principle:** Before finalising any user-facing sentence, ask: "Would the person this feature is for recognise what just happened to them?" If not, rewrite it.

**Six anti-patterns to eliminate from all FR body text:**

| Anti-pattern | Example of the problem | Rewrite rule |
|---|---|---|
| **System-as-subject** — system acts, user is invisible | "The system validates the record and submits it to the backend" | Rewrite with user or user-visible outcome as subject: "The record is saved" / "User sees a confirmation" |
| **Technical name in user outcome** — API name, endpoint name, field name, error code, named protocol or standard | "The `data.endpoint` returns a 404" / "Token is invalid" / "The OIDC flow fails" | Replace with what the user experiences: "The app can't load the data" / "User is asked to sign in again" / "Sign-in fails" |
| **Protocol or framework name** in a user-facing sentence | "The OAuth token expires" / "WebSocket disconnects" / "The auth library fails" | Replace with user-visible effect: "User is signed out" / "Live updates stop" / "Sign-in fails" |
| **Process verb instead of outcome** — system fetches, queries, syncs, polls, caches | "The app queries the backend to fetch data" | Replace with what appears: "User's data loads" / "[Feature] becomes available" |
| **Passive navigation** — user is acted on by the system | "User is navigated to" / "User is redirected to" | Replace with active: "[Screen] appears" / "User returns to [screen]" |
| **Internal state as outcome** — system state the user doesn't observe | "Session is active" / "Record state is PENDING" / "Cache is invalidated" | Replace with user-observable state: "User is signed in" / "Request is waiting" / "Data reloads" |

**Tone — enforce throughout:**
- Business register — written for a VP or Director, not an engineer or designer.
- No jargon without a plain-language explanation immediately following. Includes: API names, architecture terms, infrastructure concepts, internal screen names, component names, design file labels, product codenames.
- No passive constructions that obscure ownership ("it was determined" → state who determined it).
- Present tense for what the feature does. Past tense only in Section 5 What's Changing (current state description).
- No hedging. State what the feature does, not what it might or could do.

**VP ranking — apply to every item in every section before writing:**

Ask: "Does a VP/Director need this item to decide whether to approve the feature for design and development?"
- Yes → rank High
- Adds context but not decision-critical → rank Medium
- Useful for design/dev but not for VP approval → rank Low

Rank all candidate items within a section before writing any of them. Place High items first, Medium next, Low last. All items stay in the internal doc — ranking is the signal the client-ready skill uses to decide what moves to appendix.

**Anti-inflation check (mandatory):** After ranking each section, if no items rank Low — re-examine. You must demote at least 20% of items before writing. LLMs over-inflate priority; this check is not optional.

**Source contamination rule:**
Stage 4–6 pipeline outputs use their own internal formatting — column names, platform tags ([iOS]/[Android]), sub-numbered IDs (FR-N.N, UF-L-N), multi-condition scenario rows. Do not carry any of these into the output document. Apply the output format rules defined here exclusively, regardless of how source documents are structured.

**Language bar — apply to every sentence in every section:**
Write at the level of the user's daily experience, not at the level of how the software is built.

A term is permitted if it appears in the product's own UI, help documentation, or marketing — the user has already encountered it.
A term is prohibited if it describes how the software works internally.

| Prohibited (internal) | Permitted (user-facing) | Principle |
|---|---|---|
| OAuth token / access token / token TTL | signing in / staying signed in | Token is internal; the experience is signing in |
| Keystore / Keychain / secure storage mechanism | saved securely on your device | Storage mechanism vs. user-observable outcome |
| Background sync / cache invalidation | information updates automatically | Implementation vs. what the user observes |
| OS callback / delegate / handler / listener | phone prompts you / you're asked to confirm | Dev pattern vs. user experience |
| OS-native / OS-managed / platform-specific | your phone handles / the device manages | Architecture label vs. observable behavior |
| Session timeout / expiry window / TTL | you're signed out after inactivity | Server concept vs. what the user experiences |
| Webhook / polling / event bus | you're notified when... / updates appear | Infrastructure vs. user-observable trigger |
| API name / SDK class name / framework name | the feature / the app / [product name] | Internal reference vs. product surface |

**Test before writing any sentence:** "Would a non-technical smartphone user understand this?" If no — rewrite. If the term is the product's branded UI label (e.g., Face ID, Okta), it is permitted. If it is the internal implementation behind that label (e.g., LAContext, OIDC flow), it is prohibited.

**Face ID trademark rule:** Face ID is an Apple trademark. Apply this rule at the FR level, not the feature level: an FR is cross-platform if it covers both iOS and Android behavior in its bullets; an FR is iOS-only if its heading contains `(iOS)` or all its bullets are explicitly scoped to iOS.
- iOS-only FR → "Face ID" is correct and permitted (even in a cross-platform feature)
- Android-only or cross-platform FR → use "biometric sign-in" or "biometric authentication" instead of "Face ID"

**Section boundaries — after completing all sections, scan for violations:**

| Information type | Belongs in | Must NOT appear in |
|---|---|---|
| Current state / before-state | Section 5 What's Changing | Section 1 Overview |
| Capability list | Section 4 Scope In | Section 3 User Goals, Section 7 FRs |
| User motivation | Section 3 User Goals | Section 4 Scope |
| Error states | Appendix B | Section 7 FRs |
| Failure/alt user flows | Appendix D | Section 6 User Flows main table |
| Technical rationale | Appendix B/F | Section 5 What's Changing, Section 1 Overview |

**Document header — exactly 5 fields:**
| Feature | Version | Date | Owner | Status |

No other fields. Do NOT include: Platform, Pipeline Stage, Product, Complexity/Size in the header block. The `Complexity/Size` tag from Step 2.5 goes immediately BELOW the header block, not inside it.

**Document preamble rule:**
The document begins with the 5-field header table, then `**Complexity: [X] | Size: [Y]**`, then Section 1 Overview. Nothing else appears before Section 1. Do not include: Generation Summary blocks, classification notes (including blockquoted classification analysis such as "Stage 3.5 estimated..."), word budget records, pipeline mode annotations, or any other workflow-internal output. Classification results are working memory only — they inform how you write each section but never appear as document content.

**Chunked generation rule — mandatory:**
Do not pre-plan the full document content before writing. Generate sections one at a time. Before writing any section, output this todo list and work through it in order:

```
Todo — Feature Requirements generation:
- [ ] Section 1 Overview
- [ ] Section 2 Personas
- [ ] Section 3 User Goals
- [ ] Section 4 Scope
- [ ] Section 5 What's Changing
- [ ] Section 6 User Flows
- [ ] Section 7 Functional Requirements
- [ ] Section 8 Known Limitations
- [ ] Section 9 Constraints, Risks & Assumptions
- [ ] Section 10 Open Questions
- [ ] Section 11 References
- [ ] Appendix A — Visual States
- [ ] Appendix B — Error Handling
- [ ] Appendix D — Detailed User Flows
- [ ] Appendix E — Field-Level Specs (conditional — include only if Low decision-impact bullets exist)
```

**How to execute:**
1. Output the todo list above before writing the first word of Section 1.
2. Complete each section fully before moving to the next — no partial sections.
3. For Section 7, generate each FR individually: complete FR-1 (description + all bullets) before starting FR-2. Do not outline all FRs before writing any.
4. After completing each section, check it off in the todo: `- [x] Section N complete`.
5. Write directly to the output file after each section — do not buffer the entire document before saving.

**Why this matters:** Outlining the entire document before writing produces 300+ second thinking loops that hold the full document in memory at once, increasing hallucination risk and section bloat. Chunked generation keeps each section independent.

---

**Sections to generate (v2 structure — 11 sections + appendices):**

### 1. Overview

**FORMAT:** Exactly 3 sentences in order: (1) user problem the feature solves. (2) what the feature enables for the user. (3) operational impact on day one.

**PRINCIPLE:** No technical terms. No architecture names. No "frontend-only", "backend-unchanged", "platform-specific" or similar implementation rationale. A director reading only this section should understand why the feature exists and what it changes for users. Read aloud test: if it takes more than 30 seconds, rewrite.

### 2. Personas

**Source:** Derive personas from the Stage 6 Persona Table (Step 6.5 — the synthesis step at the end of Stage 6 flows). Do not use Stage 3 actor-state combinations — that list is an exhaustive brainstorm tool for scenario coverage, not a curated persona definition. If the Stage 6 Persona Table is absent, derive from the Actor field across Stage 6 flow cards: which actors appear in flows with a distinct trigger or distinct outcome?

**Compression rule:** Platform variants that share the same flow and outcome are one persona, not two. Only split into separate rows if the flows, rules, or product behaviors are substantively different.

**Platform naming prohibition:** Platform names (iOS, Android) must not be the primary or leading identifier in a persona name. The name must state the behavioral state first — what the user has configured or what situation they are in. When iOS and Android require separate personas because the UX is genuinely different, use a behavioral qualifier as the name and put the platform context in the Description column only.
❌ "iOS officer" — platform label, not behavioral state
❌ "Android officer managing login methods" — platform leads
✅ "Officer managing Face ID permission" — behavioral state
✅ "Officer with no biometrics configured" — situation

Behavioral-state focus. Each row represents a distinct usage state that produces different product behavior or different user needs — not a job title.

**Format:**

| Persona | Description | Primary Need |
|---|---|---|
| [Name — reflects behavioral state or usage context, not job title] | [Situational context: device state, usage stage, or prior configuration. Does not restate the persona name.] | [What the user needs to achieve, from their own perspective. Not a system action.] |

**Rules:**
- Include only personas whose needs produce different product behavior (different flows, rules, or outputs).
- If two personas experience the feature identically, merge into one row.
- Only human users — do NOT list operating systems, platforms, or automated systems as personas.
- Tier 1 attribution required for persona info.

### 3. User Goals

One entry per distinct user need, as a bullet: `- As a [persona], I want [goal] so that [outcome].`

**Rules:**
- Use the persona name from the Personas table when the goal applies to a specific persona.
- "Want" clause: what the user wants to achieve — no implementation method or system name.
- "So that" clause: mandatory. Must describe what the user gains beyond the immediate action.
- One goal per distinct need. Do not bundle two needs into one statement.

**"So that" clause precision:** States exactly one outcome in one clause — the single most important reason. Remove conjunctions ("and", "without also") that join two reasons into one bullet.
❌ "so that I can use the sign-in method that works best for my current device and shift routine" — two reasons joined by "and"
✅ "so that I can access the app faster"

**No source citations in Section 3:** User goals have no source attribution. Remove any `*(Source: ...)` annotation from user goal bullets.

### 4. Scope

**In Scope (This Phase)** — Single-column capability table:

| Capability |
|---|
| [User-facing capability the feature includes] |

**Out of Scope (This Phase)** — Two-column table:

| Capability | Reason |
|---|---|
| [Deferred or excluded item] | [Why it's out of scope] |

**Rules:**
- In Scope: user-facing capabilities only. Not sub-functions, UI elements, or system mechanisms.
- Out of Scope: must include a Reason column — never an out-of-scope list without reasons.
- No Future Enhancements section. Deferred items belong in Out of Scope only.

**Capability granularity:** Each in-scope item is a feature-level capability stated as a noun phrase — no mechanism, no platform qualifier, no sub-function, no colon-separated description. Test: "Can a VP understand this as one top-level thing the feature does?"
❌ "Enable Face ID login on Android with device biometric verification" — mechanism ("with device biometric verification") and platform ("on Android") both prohibited
✅ "Face ID login management"
❌ "Return-from-setup flow: confirm biometrics are ready and activate with one tap (Android)" — reads as a flow, not a scope item
✅ "Guided recovery after device setup"

**Item cap:** Target 4–8 in-scope items. If listing more than 8, consolidate by grouping platform variants of the same capability into one item.

**Constraint deduplication:** Any capability that already appears verbatim in Section 9.1 Constraints (e.g., localization requirements, platform policy restrictions) must not appear in Section 4 In Scope. Constraints are non-negotiable rules — they are not capabilities to deliver.

### 5. What's Changing *(include only if EXISTING feature is being modified — skip for net-new)*

If skipped, omit entirely. Do not include a placeholder.

**FORMAT:** Two-column table only:

| Current State | What's New |
|---|---|
| [What the user experiences today] | [What the user will experience after the update] |

- Rank rows by user impact — most visible change first.
- **Completeness rule:** Generate one row per user-observable behavioral change. Before writing §5, scan Stage 4 functional areas for every scenario that documents a new behavior replacing a current behavior. Do not stop after the two most visible changes — enumerate all. If the prior behavior is unknown, note the new behavior only and mark the Current State cell as "Not confirmed from prior version."
- Both columns: user-observable language only. Prohibited: "session token", "OS-native", "codebase", "isolated secure storage", any architecture/SDK/infrastructure term.
- If a row's technical cause belongs to Known Limitations (Section 8), write only the user-observable change here and add *(See Section 8: [title])* — do not re-explain.

**Cell length:** Each cell is one sentence or phrase — never two sentences. If a row needs more context, create two rows. Do not expand cells.

**Pipeline tracking codes:** Internal tracking codes (NC5, NC6, "resolved YYYY-MM-DD" notes, "Stage 5 reclassification") must not appear in table cells. These are workflow artifacts — a document reader cannot interpret them and they break trust. Strip all such references before writing.

**OQ qualifiers:** Unresolved design flags ("pending Design sign-off, OQ-1") and platform qualifiers ("Android only") must not be embedded in table cells. If a What's Changing row is affected by an open question, note the OQ in the relevant Section 7 FR where it blocks a behavior — not in Section 5.

### 6. User Flows

**Source format rule:** Stage 6 flow documents use `Actor`, `Summary`, and `UF-L-N` ID columns. Ignore these entirely. Use only the columns defined here: `Flow | Trigger | Outcome`. Do not carry Stage 6 column names, flow IDs, or row structure into this table.

**Flow Inventory table:**

| Flow | Trigger | Outcome |
|---|---|---|

- **Trigger column:** User's situation when the flow begins — not a system event. "User opens app and isn't signed in" not "App opened with no valid session."
- **Outcome column:** What the user sees at the end — not what the system processed. "Signed in, home screen" not "session established."
- **Happy paths only** in this table — failure paths and alt paths → Appendix D (reference inline: "Failure paths — see Appendix D").
- Row order: happy paths → lifecycle transitions → system gates → edge cases.
- Flow names must remain accurate after launch — no transient context like "First install", "Post-migration reset".
- **Trigger must be a user action:** System-initiated state changes (session expiry, inactivity timeout, forced sign-out, background sync completion) are not user flows. They belong as capability bullets within the relevant FR block. Remove any row whose Trigger column describes a system event with no user action initiating it.

**Trigger cell precision:** One user action or situation — no embedded preconditions, no platform branches within a single trigger cell.
❌ "Officer activates Face ID control on Android while Face ID is enrolled on their device" — "while Face ID is enrolled" is a precondition, not the trigger
✅ "Officer activates Face ID on Android"

**Outcome cell precision:** One result at the end of the flow — no branching within a single outcome cell.
❌ "Login method controls visible; Face ID and PIN controls reflect current device status (Android), or Biometric Login and Change Password rows visible (iOS)" — two platform outcomes in one cell
✅ Split into two rows: one for Android outcome, one for iOS outcome

### 7. Functional Requirements

Use one of two formats based on complexity. No sub-labels in either format.

**Simple FR** — heading + flat bullets. Use when: ≤3 rules, no conditional branches, no external system calls, no failure paths.

```
### FR-[N]: [Requirement Name]

- [Rule 1] (Source: [reference])
- [Rule 2] (Source: [reference])
```

**Complex FR** — heading + one-line description + bullets. Use when: 4+ rules, conditional logic (if/when/else), external system calls, or explicit failure paths.

```
### FR-[N]: [Requirement Name]

[One sentence describing what this requirement enables — user value, not system behavior.]

**Description line test (run before writing — if it fails any check, do not write the description):**

1. **Uniqueness:** Does this sentence say something no individual bullet says? Read bullets 1 and 2. If the description is a prose merger of those two bullets, it fails. Delete it.
2. **Value type:** A description earns its place only by providing one of:
   - The PURPOSE of the FR — why this capability exists for the user, not a restatement of how it works
   - A UNIFYING RULE that applies to every bullet equally and that no single bullet states alone
3. **OQ consistency:** Does the description make a claim about behavior where an Open Question is still unresolved? If an OQ asks "in-app or browser?" the description must not say "without leaving the app." Remove the premature claim or rewrite as neutral framing.

A description that fails any of these three tests must be deleted. A missing description is always correct; a redundant or misleading description is always a quality failure.

- [Rule 1] (Source: [reference])
- [Rule 2] (Source: [reference])
- [Rule 3 — conditional: if/when X, then Y] (Source: [reference])
```

---

**FR sub-numbering prohibition:**

Do not use sub-numbered FR IDs (FR-1.1, FR-1.2, FR-2.3). Each FR has one heading (`### FR-N: [Name]`) and flat bullets beneath it. If a capability requires sub-items, create a separate FR with its own heading.

---

**FR opening sentence:**

One sentence in capability format: who can do what. Subject is the persona; predicate is the capability the user gains.

- Does not describe the screen, the mechanism, or the implementation approach.
- Does not preview or summarize bullet content — each bullet must add information the opening sentence does not state.

✅ "Officers sign in using their Okta credentials on every unsigned-in visit."
✅ "The sign-in screen is the officer's entry point to the app on every unsigned-in visit."
❌ "The Okta sign-in flow provides a secure authentication path." — describes mechanism, not user capability.

**Second test — system-action check:** After writing the description, scan for any clause that describes what the system does (corrects, verifies, validates, loads, detects, checks, processes, syncs) rather than what the officer gains or can do. System-action clauses embedded in an officer-subject sentence still fail.
❌ "Officers on Android see Face ID and PIN login method controls that always reflect what the device currently supports, with any outdated status corrected automatically before the screen appears." — "corrected automatically before the screen appears" is a system-action clause embedded in an otherwise officer-subject sentence
✅ "Officers can view and manage their Face ID and PIN login methods from a single screen." — pure capability statement
Remove any clause containing system-action verbs (corrects, verifies, validates, checks, detects, syncs, loads, processes). The description reads as a capability grant — something the officer can now do.

---

**FR bullet language:**

Use **must** for all mandatory behavior. Use **may** only for behavior explicitly described as optional in the source. Do not use "should", "will", "can", or "would."

✅ "Initiating sign-in must open Okta in the phone's browser."
✅ "The officer may dismiss the update prompt and proceed to sign in."
❌ "Officers can tap the support number to call." → rewrite: "The officer must be able to call a support number."

**Platform tag prohibition:**

Do not prefix bullets with `[iOS]` or `[Android]` platform tags. Where behavior is identical across platforms, write one platform-agnostic bullet. Where behavior differs substantively and requires independent testing, create separate FRs (e.g., FR-3: Sign In with Device Passcode (iOS) and FR-4: Sign In with PIN (Android)). Never use inline tags as a substitute for either of these two approaches.

---

**FR writing style:**

Write bullets as short, direct declarative statements. Each bullet states one behavior — not two joined by a semicolon.

Four patterns to eliminate before writing:

- **Redundant trailing phrases:** Remove any phrase that restates what the bullet already implies. "The preference must be saved for future sign-in sessions" → "The preference must be saved." Saving for future sessions is the only reason to save.
- **Compound bullets:** A bullet with a semicolon contains two requirements. Split it. ❌ "Status must be verified; if enrolled, the control must switch to active." ✅ Two bullets: (1) "Biometric status must be verified on activation." (2) "If Face ID is enrolled, the control must switch to active."
- **Double negatives:** Rewrite into a positive statement or a single clear prohibition. ❌ "No conflict warning or prompt to disable the existing method must appear." ✅ "Enabling one method while the other is active must not trigger a conflict warning."
- **Verbose conditional openers:** Lead with the condition, then the outcome — drop preamble words. ❌ "When an officer activates the Face ID control, biometric status must be verified." ✅ "On Face ID activation, biometric status must be verified."

**Before / after example — apply all four patterns:**

❌ Verbose:
```
### FR-3: Notification Preferences

Officers can manage which notification types they receive from the app at any time, and changes are applied immediately without requiring a restart or sign-out.

- When an officer opens the Notification Preferences screen, the current notification settings stored for that officer's account must be loaded and displayed so that the officer can see what is currently enabled or disabled. (Source: SRC-2)
- When an officer toggles a notification type on or off, the preference change must be saved to the officer's account and applied to future notifications so that the officer does not have to reconfigure preferences each time they sign in; no confirmation step is required before the preference is saved. (Source: SRC-2, Stage 4 S-B1)
- If the officer has no notification types enabled, the screen must display normally with no warning prompt or message urging the officer to enable notifications, since having no notifications enabled is a valid state for the officer to be in. (Source: Stage 4 S-D2)
```

✅ Clean:
```
### FR-3: Notification Preferences

Officers can enable or disable each notification type from a single screen.

- The screen must display the officer's current notification settings. (Source: SRC-2)
- On toggle, the preference must be saved immediately — no confirmation step required. (Source: SRC-2, Stage 4 S-B1)
- All notifications off is a valid state — no re-enable prompt must appear. (Source: Stage 4 S-D2)
```

What changed: description trimmed to one capability statement; bullet 1 dropped the restated purpose; bullet 2 split and the trailing phrase removed; bullet 3 rewritten from double-negative to direct statement; conditional openers shortened throughout.

---

**FR bullet priority and decision-impact:**

Every FR bullet must carry a decision-impact level: Critical, High, Medium, or Low. Decision-impact reflects whether a client stakeholder needs this information to make a go/no-go, prioritization, or scoping decision.

There is no bullet count cap — an FR may have any number of bullets. Rank bullets by decision-impact (highest first — the behavior the PM most needs to know comes first), then by logical reading order within the same impact level (condition → display → primary behavior → edge case → recovery).

**Decision-impact label format:** Append the impact level in square brackets at the end of each bullet, before the (Source: SRC-N) citation. Use exactly: [Critical], [High], [Medium], or [Low]. Example: `- The officer may dismiss the prompt. [Low] (Source: SRC-2)`. Every FR bullet must have exactly one impact label. Bullets without a label fail the quality gate.

Do not tag any bullet with `[VP-OVERFLOW — Appendix E]`. Do not emit `**Additional rules:**` sub-labels. The client-ready skill applies the impact filter during transformation — Low decision-impact bullets move to Appendix E; Critical/High/Medium stay in the FR body.

---

**Bullet brevity:**

Each bullet must contain at most one condition and one outcome. Write in the shortest form that is unambiguous.

✅ "On successful biometric check, the officer must go directly to the home screen."
✅ "On failure or cancellation, the officer must be offered standard sign-in as fallback."
❌ "Before any controls are shown, the biometric status must be verified; if Face ID was previously active but is no longer enrolled, the Face ID control must display as inactive — this check and correction must complete before the officer sees any controls." → Split into two bullets: (1) "Before controls are shown, the device's biometric status must be verified." (2) "If Face ID was active but is no longer enrolled, the Face ID control must correct to inactive before the officer sees any controls."

If a bullet contains a semicolon joining two requirements, split it. If a bullet contains a dash `—` introducing a second clause that is itself a separate requirement, split at the dash.

---

**Cross-reference prohibition in FR bullets:**

Never embed `*(See Risk R-x)*` or `*(OQ-x)*` in an FR bullet. These belong in §9 and §10 respectively, not in FR content. Exception: `*(See Assumption A-N)*` is permitted only when the FR bullet behavior would not exist if the assumption were false — i.e., the assumption is the sole basis for this requirement being in scope. Do not add assumption pointers for indirect or contextual relationships.

Test: scan each FR bullet — if it contains `*(See Risk` or `*(OQ-` that is a violation; `*(See Assumption` is allowed.

---

**Implementation Note blocks prohibited:**

`**Implementation Note:**` blocks must not appear in FR bodies. When a Stage 5 assumption has a technical detail relevant to an FR, the cross-reference `*(See Section 9.3 Assumption A-N)*` at the end of the relevant bullet is sufficient traceability — do not repeat the assumption's prose content inside the FR.

- Confirmed technical constraint that changes user-observable behavior → rewrite as a rule bullet.
- Unconfirmed technical constraint → belongs in Section 9.3 only; one cross-reference in the FR is the link.

---

**Error state separation:**

Error states must not appear as FR bullets. If a behavior describes a failure mode, offline state, error condition, or error-recovery action — it belongs in Appendix B — Error Handling, not in Section 7 FR bullets.

Test: "Does this describe what happens when something goes wrong?" Yes → Appendix B.

❌ FR bullet: "If the device is offline when the officer taps sign-in, an error message is shown." → move to Appendix B — Error Handling.
✅ FR bullet: "The sign-in button must be tappable without a network connection." → capability rule (what the feature must support regardless of network state).

The distinction: an FR bullet states what the feature must support. An error state describes what happens when a precondition fails or a capability limit is reached.

**Fallback capability vs. error copy:**

One fallback-capability bullet per failure mode is allowed in Section 7. It states what the user gets when something fails — not what went wrong or what message appears.

✅ Allowed in Section 7: "On failure or lockout, the officer must be offered Okta sign-in as fallback."
❌ Appendix B only: specific error message text, OS callback types, lockout-type distinctions (temporary vs. permanent), or multiple error-state bullets per condition.

The test: does this bullet describe a user capability (what the user can do) or an error outcome (what message appears)? Capabilities stay in Section 7. Outcomes go to Appendix B — even if Stage 4 scenarios or Stage 5 assumptions define them inline as numbered requirements.

---

**Phase 2/3 FRs** — mark inline in the heading. Phase 1 is the default; no marker needed.

```
### FR-[N]: [Requirement Name] *(Phase 2/3)*

- [Rule] (Source: [reference])
```

**FR Title Rules (apply before writing any FR heading):**

A good FR title names the user action or user capability — not the screen, the system behavior, or a bare noun.

| Test | Failing example | Fix |
|---|---|---|
| Does the title name what the USER does or gets — not what the system does? | "App Version Check" — the app checks, not the user | Rename to the user experience: "Version Gate at Launch" or "Update Required Before Sign-In" |
| If two or more FRs cover the same broad action, does each title uniquely identify its specific path? | "Sign In" when another FR is also a sign-in path | Add the distinguishing qualifier: "Standard Sign In (via Okta)", "Quick Sign In (Biometric or Passcode)" |
| Could a PM reading only the FR titles reconstruct the feature's main user journeys without opening the bullets? | "No Connection" gives no journey context | Rewrite as a user-state or user-action title: "Signing In Without Internet" |

**Forbidden title patterns:**
- Lone system states without user action: "No Connection", "Error State", "Timeout"
- Generic action verbs shared across parallel FRs: "Sign In" when multiple sign-in paths exist — always qualify
- Screen names for interaction FRs: "Sign-In Screen" is valid only for an FR that defines screen content, not for an FR that describes an interaction on that screen

---

**FR ordering rule:**

Order FRs within Section 7 by user visibility and flow sequence:

1. **User-facing happy paths** — the screens and actions a user takes in the success scenario, in the order the user encounters them
2. **User-facing recovery and lifecycle** — error recovery flows, sign-out, and session-related transitions the user triggers
3. **System gates** — conditions the system checks before or during access (version gates, connectivity checks), ordered by when they fire in the user journey
4. **Environmental and edge cases** — device state errors, platform-specific edge cases, low-frequency failure modes

Within each group, order by frequency of use (most common first). Phase 2/3 FRs always appear last regardless of group.

**First-time journey anchor:** When a feature has both a first-time user journey and a returning user journey that follow different FR sequences, the first-time journey is the ordering anchor. A user encountering the feature for the first time encounters FRs in the order they are numbered. Returning users who skip early setup steps encounter the post-setup FRs (higher numbers) and should find them in the expected position.

**Rules:**
- No sub-labels anywhere: "Description:", "Business Rules:", "Source:", "Type:", "Phase:" must not appear inside an FR body.
- Source citations stay inline within bullets: `(Source: SRC-N)` at the end of the bullet they support.
- If a rule requires a nested sub-bullet, re-classify the FR as Complex and restructure as conditional bullets at the same indent level.
- Deferred behaviors belong in a Phase 2/3 FR, not as bullets inside a Phase 1 FR.

**Format selection signals (internal — do not write into the document):**

| Signal | Format |
|---|---|
| ≤3 rules, no conditionals, no external system, no failure path | Simple |
| 4+ rules, OR any conditional branch, OR external system call, OR explicit failure path | Complex |

### 8. Known Limitations

Confirmed gaps being shipped as accepted trade-offs. Each bullet leads with the user-observable limitation.

**FORMAT:** Each bullet — (1) plain-English header: the user-observable limitation; (2) why it exists — one sentence; (3) recommended action or communication.

**Rules:**
- Lead with user impact, not technical cause. Technical cause in parentheses after the plain statement — never before.
- Only limitations visible to the end user OR relevant to PM scope, timeline, or launch decisions.
- Do NOT include technical implementation details with no user-visible effect.
- If a limitation is actually an unresolved decision, move it to Section 10 Open Questions.

### 9. Constraints, Risks & Assumptions

Three subsections only, in order:

#### 9.1 Constraints

Non-negotiable rules (regulatory, legal, system boundary, timeline). Table format:

| Constraint | Imposed By |
|---|---|
| [Non-negotiable rule — user-observable consequence if violated] | [Regulatory body, legal requirement, platform policy, or timeline] |

**Before writing any Constraint, apply this test:**
- Is this a standard professional practice any competent team would follow without being told? → Do not add (it is a dev standard, not a product constraint).
- Does following this constraint require a PM decision? No → Do not add (dev owns it entirely).
- Does this constrain a product-level behavior, scope, timeline, or compliance requirement the PM must know about? Yes → include.

#### 9.2 Risks

Populated by Stage 8 — Risk Analysis. Table: `| Risk | Probability | Impact | Owner | Mitigation |` (5 columns). Use the risk description text as the `Risk` column value. Do not include Risk ID or Type columns.

**Risk cell length:** Maximum 2 sentences. Sentence 1: what could happen. Sentence 2: the consequence for the user or the project. Do not use `→` chains. Remove conditional sub-clauses — those belong in the Mitigation column.

**Impact scale:** Use exactly: `Critical`, `High`, `Medium`, or `Low`. Do not use `Important`, `Severe`, `Tiger`, `Major`, or any other value. Stage 8 uses a Tiger/Paper Tiger/Elephant pre-mortem classification internally; map to this scale before writing: Critical Tiger → `Critical`; Important Tiger or Paper Tiger → `High`; Low-probability Tiger → `Medium`.

**Appendix G forward reference (added by client-ready skill, not at generation time):** If items are relocated to Appendix G, the client-ready skill adds a reference note at the bottom of the relevant §9 sub-section: `[N] additional Medium/Low risks are documented in Appendix G.`

Leave empty at generation time; Stage 8 fills it. Do not pre-populate.

*Mitigation column (when Stage 8 fills it):* Additive-only — write only what is not already tracked in Section 10 Open Questions, Section 9.1 Constraints, or an existing FR. Three patterns:
- **Additive:** specific technical spec, verification step, process action, or cross-feature consequence not tracked elsewhere → write in full
- **OQ cross-reference:** if mitigation is "resolve OQ-N" → write `"→ OQ-N."` One sentence maximum for any consequence beyond the pointer
- **Constraint restatement:** if mitigation repeats a Section 9.1 Constraint → write `"→ 9.1 Constraints."` Do not repeat the constraint

Sorted by impact (Critical first, then High, Medium, Low).

#### 9.3 Assumptions

Unconfirmed beliefs with risk if wrong. Table format:

| # | Assumption | Status | Impact if Wrong |
|---|---|---|---|
| A-N | [What the team believes to be true — plain English first, technical detail in parentheses after] | Not confirmed / Confirmed | [What changes if this assumption is wrong — FR, scope, or timeline] |

**Before including any Assumption:**
- Is being wrong about this LOW priority AND does it change no FR, OQ, scope, or timeline? → Omit.
- Is it genuinely unconfirmed AND does being wrong affect at least one FR, OQ, scope item, or timeline? → Include.

Sorted by impact (highest first).

### 10. Open Questions

Stakeholder decisions needed before proceeding. Table format:

| # | Question | Blocks | Priority | Owner | Target Date |
|---|---|---|---|---|---|
| OQ-N | [Plain question directed at the listed owner — answerable without a glossary. Technical detail in parentheses after the main question.] | [FR or section blocked] | Critical / High / Medium / Low | [Who must decide] | [Date] |

**Before registering any Open Question:**
- Is the answer already available from existing inputs? → Look it up now. Do not register an OQ for something already answered.
- Is this a technical or implementation decision the dev team owns entirely, with no product behavior consequence? → Do not register. Route to dev team or Implementation Note.
- Does this require a business, product, or UX decision only a PM, stakeholder, or designer can answer? → Yes → include.

Sorted: Critical first, then High, Medium, Low.

**Question column discipline:** The Question column contains the question only — one sentence stating what decision is needed. Do not embed context, background, or resolved information in the question cell.
❌ "What is the copy for the inline banner? Format confirmed as inline banner; direction copy is 'Biometrics set up — tap to enable.' Design to finalise full spec." — only the first sentence is the question; the rest is context
✅ "What is the copy, display duration, and dismissal behavior for the inline banner shown when the officer returns from device setup?"
If the owner needs context to answer, provide it in a direct follow-up — it does not belong in the table.

### 11. References

**Design Assets:**
- [Display Name](figma-url) — [type: design/prototype/flow]

**Source Materials:**
- [filename] — [doc type]

---

### Appendix A — Visual States *(Frontend/Mobile only)*

Design reference table:

| State | Description | Design Status |
|---|---|---|
| [State name — user-observable state, not internal system state] | [What the user sees in this state] | ✅ Confirmed / ⚠️ Behavior confirmed; design TBD / ❌ Not designed / 🔴 Blocked |

Referenced from Section 6 User Flows when a flow has multiple distinct visual states.

### Appendix B — Error Handling

Full error catalog for engineers, QA, and UX/Design. Columns: Error Type | Cause | User Experience | System Behavior | Design Status | Applies To.

**Purpose:** Standalone test matrix and design brief. QA must be able to write a test case for every row without opening any FR. UX/Design must be able to identify every undesigned state from the Design Status column alone. Redundancy with FRs is intentional.

**FORMAT:** Group rows under bold capability header rows. Group order matches FR ordering — happy-path capabilities first, recovery/lifecycle, system gates, edge cases last.

**Row inclusion test:** A row belongs here if QA needs to test it OR Design needs to cover it.

**Cross-group deduplication rule:** If the same error applies across multiple groups, write it once and list all FRs in the Applies To column.

**Cause column:** Populate only when Cause adds precision not in the Error Type name. If Cause would simply rephrase the Error Type, write "—".

**Two-audience column rule:**
- **User Experience column:** What the user sees, reads, or can do — in the user's words. If the user would not see or feel it, it does not belong here.
- **System Behavior column:** What the system does that the user cannot observe — technical language permitted. Write "—" if it would restate the User Experience. Write "OS-managed" for OS-managed errors.

**Design Status values:** ✅ Confirmed | ⚠️ Behavior confirmed; design TBD | ❌ Not designed — [OQ reference if applicable] | 🔴 Blocked — [OQ reference]

This appendix is kept in full in both the internal document and the client-ready output.

### Appendix D — Detailed User Flows

Alt paths, failure paths, and step-by-step flow narratives. Narrative Flow Card format.

Referenced from Section 6 User Flows with inline note: "Failure paths — see Appendix D."

### Appendix E — Field-Level Specs

Include validation rules, character limits, exact UI labels, picker behavior, and other Low decision-impact detail that does not belong in FR bodies. Populate from source material if available. If no Low decision-impact detail exists, omit this appendix.

---

**STOP BEFORE SAVING — Compound bullet check (mandatory):**
Scan every FR bullet for a semicolon. A bullet with a semicolon is two requirements — split it before saving. A bullet with a `—` dash introducing a second independent clause is also two requirements — split at the dash. Do not save the document until zero compound bullets remain.

**Save file:** `[output-folder]/Generated/Internal/Feature-Requirements-[Feature-Name].md`

---

## Step 3.5-4: Quality Gate

After generating all sections, run the deduplication and quality checks inline.

---

### Step 3.5: Cross-Section Deduplication

After generating all sections, scan the document for items that appear in more than one section. Each item gets exactly one home based on what it **is**:

| Classification | Definition | It is NOT also... |
|---|---|---|
| **Hard Constraint** | Non-negotiable system rule (regulatory, legal, timeline) | a dependency or limitation |
| **Dependency** | Deliverable another team must provide before we can build | an assumption or limitation |
| **Assumption** | Something we believe but haven't confirmed; carries risk if wrong | a dependency (if it has an owner and delivery status, it's a dependency) |
| **Known Limitation** | Confirmed gap we are shipping with (accepted trade-off) | a dependency (if it's blocking and has an owner, it's a dependency) |
| **Open Question** | Stakeholder decision needed before proceeding | an assumption or dependency (if it needs a decision, the OQ owns it) |

**Scan these sections for overlap:**
- Section 1 Overview (sentence 3 names a trade-off or risk; check that it does not expand what Section 8 Known Limitations fully explains)
- Section 5 What's Changing (check for re-narration of Section 8 Known Limitations content)
- Section 7 Functional Requirements (business rule bullets that restate a constraint)
- Section 8 Known Limitations
- Section 9.1 Constraints
- Section 9.3 Assumptions
- Section 10 Open Questions

**Tiebreaker rules (apply in order):**

1. **Assumption + Dependency overlap:** Keep the Dependency row (it has owner + status). Delete the Assumption row.
2. **Known Limitation + Dependency overlap:** Keep the Dependency row. Delete the Known Limitation bullet.
3. **Constraint + Dependency overlap:** Keep the Constraint only if there is a non-negotiable rule to state (e.g., "payroll must never be blocked"). If the constraint bullet is just restating the dependency, delete it.
4. **Assumption + Open Question overlap:** Keep the Open Question. Delete the Assumption row. The OQ is the primary artifact for items needing decisions.
5. **Dependency + Open Question overlap:** Keep both ONLY IF the OQ asks a different question than "will this be delivered?" If the OQ is just "can X team provide Y?", keep the dependency row and delete the OQ. If the OQ asks a design/policy question dependent on the deliverable, keep both.
6. **Two OQs on the same topic at different scopes:** Merge into one OQ. Absorb the sub-question into the primary question text.
7. **Two Constraint bullets stating the same rule:** Keep one. Prefer the version with more specificity.
8. **Confirmed assumptions are not assumptions.** If status is "Confirmed," delete. If the confirmed fact creates a trade-off, move it to Known Limitations.
9. **When deleting a duplicate, absorb useful context** (risk consequence, impact description) into the surviving instance.
10. **Update all cross-references** after deduplication. If Assumption #3 becomes #2, update any FR business rules that reference "Assumption #3."
11. **Section 5 + Section 8 overlap:** Section 8 Known Limitations is the authoritative owner of accepted trade-offs. Section 5 What's Changing must not re-narrate Section 8 content. If both sections describe the same impact: keep the full explanation in Section 8; trim Section 5 to the user-observable before/after pair with *(See Section 8: [title])* reference only.

**After this pass, every constraint/assumption/OQ/limitation in the document must appear in exactly one home: Section 8 Known Limitations, Section 9.1 Constraints, Section 9.3 Assumptions, or Section 10 Open Questions. The Section 9.2 Risks sub-section is intentionally empty at generation — Stage 8 populates it.**

---

### Step 3.5b: Cross-FR Business Rule Deduplication

Scan all FR Business Rules lists for rules that appear in more than one FR.

**Rule:** Each business rule lives in exactly one FR — the FR that owns the behavior. If the same rule (same fact, same condition) appears in FR-X and FR-Y:
1. Determine which FR is the authoritative owner of that behavior.
2. Keep the full rule in the owning FR.
3. Replace the duplicate bullet in the non-owning FR with: `- See FR-[N] for [brief topic].`

**Common patterns to scan for:**
- Localization / language display rules appearing in multiple FRs
- Audit logging rules appearing in both a functional FR and a compliance FR
- Session / authentication rules repeated across FRs that touch auth state
- Accessibility rules (WCAG) stated inside individual FRs instead of once in Compliance

Do not replace a bullet if the FR-X version has additional conditions or specifics that FR-Y does not have — that is a distinct rule that stays.

**Cross-flow outcome ownership:** If a behavioral rule is the outcome of ALL paths through a feature (e.g., "after sign-out, failure, or cancellation, the user always returns to screen X with no contextual message"), one FR must own it — typically the FR that handles session state or the terminal screen.

- The owning FR states the full rule: outcome + policy (e.g., "no message explaining why").
- Other FRs state their flow's terminal outcome in a single outcome clause only: "the officer returns to the sign-in screen." They do not re-state the policy (e.g., "with no message," "with no error") — that restates the owning FR's rule.
- Test: if removing the policy clause from a non-owning FR bullet would lose no information (because the owning FR already states it) — remove the clause.

---

### Step 3.5c: FR Bullet vs. Hard Constraint Deduplication

After deduplicating within Section 7, scan all FR bullets against Section 9.1 Constraints.

**Rule:** If an FR bullet states the same non-negotiable rule as a Hard Constraint — even in user-friendly language — remove the FR bullet. The Hard Constraint is the authoritative source. The FR bullet adds no testable behavior beyond what the HC already guarantees.

**Test for equivalence:** Ask "does this FR bullet add any testable behavior beyond what the Hard Constraint already states?" If no — remove. If yes — keep.

**Common patterns to catch:**
- HC states a capability must always be available → FR bullet says the same in user terms ("'X' is always available as an option")
- HC states an action must work without network → FR bullet says "tapping [action] works even without internet"
- HC states biometric flows are OS-managed → FR bullet says "the phone manages retry limits — the app does not"

Note: Stage 9 Step 9.0b performs this same check at validation time. This step catches the issue at generation time.

---

### Step 3.5d: Phase Consolidation

For each FR whose heading contains `*(Phase 2/3)*`, enforce the rule that the deferred item has exactly one mention outside its own FR body: its Out of Scope table row.

1. Confirm the deferred item has exactly one row in the **Out of Scope** table (Section 4). Add it if missing.
2. Scan every section below for additional mentions and apply the action specified:

| Location | Action |
|---|---|
| **Section 2 Personas** | If a persona row is dedicated entirely to a Phase 2/3 feature, reduce to a one-liner: `> **Phase 2/3 only.** [Persona name] is not served in this release. See Out of Scope.` Delete all remaining persona content for that row. |
| **Section 6 User Flows** | Remove any row whose Outcome column starts with `(Phase 2/3` or names a deferred feature as the destination. |
| **Appendix A — Visual States** | Remove rows where the State describes a state that exists ONLY because the Phase 2/3 feature is active. **KEEP** rows that document Phase 1 behavior in response to an absent Phase 2/3 feature — these are Phase 1 states (e.g., "card always hidden in Phase 1" is a Phase 1 visual state). |
| **Section 7 — Phase 1 FR Business Rules** | Replace any bullet prefixed with `Phase 2/3 only:` with `(Phase 2/3 — see Out of Scope)` or delete entirely. |
| **Section 8 Known Limitations** | Replace any bullet discussing a deferred item's behavior with `(Phase 2/3 — see Out of Scope)` or delete if no other content. |

**Do not** modify the Phase 2/3 FR body, the Out of Scope row, the Phase 2/3 FR heading, or Visual States rows that document Phase 1 behavior in response to a suppressed Phase 2/3 feature.

**Purpose:** Prevents Phase 2/3 scope from inflating the document and signals to the client-ready skill that Out of Scope is the single authoritative location for deferred item status.

---

### Step 3.5d: Constraint Classification

After all sections are generated, scan every fact destined for Section 8, Section 9, or Section 10. Classify each into exactly one home using the definitions and tiebreaker rules below. Reject duplicates before saving — no fact may appear in more than one location. (Section 9.2 Risks is left empty here; Stage 8 populates it.)

**Classification definitions:**

| Type | Home | Definition |
|---|---|---|
| **Constraint** | Section 9.1 | Non-negotiable system rule — regulatory, legal, or system boundary. A rule that cannot be changed regardless of who asks. |
| **Assumption** | Section 9.3 | Something the team believes but has not confirmed; carries risk if wrong. |
| **Known Limitation** | Section 8 | A confirmed gap the team is shipping with — an accepted trade-off. The gap is known; the decision to ship with it is made. |
| **Open Question** | Section 10 | A stakeholder decision needed before proceeding. If it needs a decision, the OQ owns it — not an Assumption. |

**Tiebreaker rules (apply in order when an item fits two buckets):**

1. **Assumption + Open Question overlap:** Keep the Open Question. Delete the Assumption row. If it needs a decision, the OQ owns it.
2. **Known Limitation + Open Question overlap:** Keep the Known Limitation only if the decision is already made and the trade-off is accepted. If the decision is still open, move to Section 10 OQs.
3. **Two OQs on the same topic:** Merge into one OQ. Absorb the sub-question into the primary question text.
4. **Two Constraint bullets stating the same rule:** Keep one. Prefer the version with more specificity.
5. **Confirmed assumption:** If an assumption status is "Confirmed," delete it. If the confirmed fact creates an accepted trade-off, move it to Section 8 Known Limitations.
6. **When deleting a duplicate:** Check if the removed instance has useful context (risk consequence, impact) that should be absorbed into the surviving instance before deleting.
7. **After classification:** Update all cross-references. If OQ numbers changed, update any FR business rules or Section 8 bullets that reference old OQ codes.

**After this pass, every constraint/assumption/limitation/OQ in the document must appear in exactly one home: Section 8, Section 9.1, Section 9.3, or Section 10.**

---

Proceed to Step 4.

---

### Step 4: Inline Quality Check

Before presenting the document to the user, run these checks:

**Document Length:**
- [ ] Count the approximate word total of the **budgeted sections only** (exclude: Header + Gen Summary, Appendix B Error Handling, Section 10 Open Questions, Section 11 References, Appendix A/D/E)
- [ ] Compare against the budget set in Step 2.5b
- [ ] If the budgeted word count **exceeds the upper bound by more than 20%**, it is a quality failure — trim before presenting:
  - Shorten description sentences in Complex FRs to one tight sentence
  - Collapse Simple FRs with more than 3 nearly-identical bullets into one bullet with examples
  - Verify Section 1 Overview is exactly 3 sentences — trim if longer
  - Move any implementation detail in business rule bullets to the Implementation Notes callout
- [ ] If the budgeted word count is **below the lower bound**, flag it: thin documents may indicate inputs were insufficient or key scenarios were dropped

**Completeness:**
- [ ] All required sections present
- [ ] No [TBD] without explanation and stakeholder routing
- [ ] Source attribution meets threshold (Tier 1 = 100%, Tier 2 = 60%+ target)

**Clarity:**
- [ ] Plain English throughout (no code, no jargon without explanation)
- [ ] All requirements are specific and testable ("System must X within Y seconds")
- [ ] No vague language ("should consider", "might", "probably")

**Language Register:**
- [ ] **Subject test:** In every FR description sentence and business rule bullet, the subject is the user, a user-visible element, or a user-observable outcome — not a system process, API, or internal state. Scan every sentence where the subject is "the system," "the app," "the backend," "the API," or a named service without a visible user result following. Rewrite to surface the user outcome.
- [ ] **Technical name test:** No API names, endpoint names, field names, error codes, protocol names, or framework names in FR body text. If present, describe the user-visible effect instead and move the technical detail to System scope or Implementation Notes.
- [ ] **Passive navigation test:** No "user is navigated to" / "user is redirected to." Replace with "[screen] appears" or "user returns to [screen]."
- [ ] **Process verb test:** No "fetches," "queries," "polls," "syncs," "caches," "submits to," "validates against" in user-facing bullets. Replace with the outcome the user sees.
- [ ] **FR ordering:** user-facing happy paths → user-facing recovery/lifecycle → system gates → environmental edge cases.

**Requirement Purity:**
- [ ] No FR contains implementation mechanisms (HOW) — solutions belong in Implementation Notes
- [ ] No FR prescribes UI layout or navigation patterns (WHAT IT LOOKS LIKE) — design decisions belong in Open Questions
- [ ] Each business rule is testable — a QA engineer could write a pass/fail test without asking clarifying questions

**Source Accuracy:**
- [ ] Every `(Source: SRC-N)` citation was verified against the actual source content
- [ ] No source is cited for content it does not contain
- [ ] Statements tagged `(Source: Implicit)` are genuinely logical derivations, not gap-fills that should be `[TBD]`
- [ ] No scoped statement has been over-generalized (source says "X in context A" but doc says "X everywhere")

**Cross-Section Deduplication:**
- [ ] Zero items appear in more than one home (Section 8 Known Limitations, Section 9.1 Constraints, Section 9.3 Assumptions, Section 10 OQs)
- [ ] Zero items appear in both Section 9.3 Assumptions and Section 10 Open Questions (if it needs a decision, the OQ owns it)
- [ ] All cross-references are current (OQ numbers updated after any renumbering from Step 3.5d)
- [ ] Section 5 What's Changing does not re-narrate Section 8 Known Limitations content — Section 5 states only the user-observable before/after pair; Section 8 holds the full explanation
- [ ] No FR bullet restates a Section 9.1 Constraint in user-friendly language — if they express the same rule, the FR bullet is removed (Step 3.5c)

**Table Formatting:**
- [ ] Every priority/risk/severity indicator uses plain-text labels — no emoji:
  - OQ Priority column: `Critical`, `High`, `Medium`, or `Low`
  - Risk Impact column: `Critical`, `High`, `Medium`, or `Low`
  - Do NOT use `🔴`, `🟡`, `🟠`, `🟢` emoji in any Priority or Impact column
- [ ] Tables are sorted by highest priority/risk/severity first:
  - **Section 10 Open Questions** — sorted by priority (Critical → High → Medium → Low). Resolved questions sink to the bottom.
  - **Section 9.3 Assumptions** — sorted by impact (highest first)
  - **Section 9.2 Risks** — sorted by impact (Critical first)

**Appendix B Integrity:**
- [ ] Every row passes the row inclusion test: it represents a distinct user-observable failure state that QA must test or Design must cover
- [ ] No identical rows appear in more than one capability group — check Cause + User Experience + System Behavior for duplicates; merge and update Applies To if found
- [ ] Cause column: any cell that simply rephrases the Error Type name is replaced with "—"
- [ ] System Behavior column: any cell that restates the User Experience in technical terms without adding new information is replaced with "—" or "OS-managed"
- [ ] Group order matches FR ordering principle (happy-path capabilities first)
- [ ] Every ❌ or ⚠️ Design Status row flags any unresolved OQ reference from Section 10

**Section 9.2 Risks Integrity (Stage 8 populates — verify at validation time):**
- [ ] Every Mitigation cell is additive: it contains information not already fully captured in a linked OQ or Section 9.1 Constraint
- [ ] OQ pointer cells condensed to one-liner cross-reference + at most one additive sentence
- [ ] Constraint restatement cells replaced with "→ 9.1 Constraints"
- [ ] No risk content embedded in FR business rules — FR bullets may contain only `(See Risk R-N)` cross-references
- [ ] All risks sorted by Impact descending (Critical first)

**Section 9.1 Constraints Integrity:**
- [ ] No Constraint row describes a standard professional practice (HTTPS, WCAG, OAuth lifecycle, platform-standard storage) — these are dev standards, not PM-visible constraints
- [ ] No Constraint row is entirely owned by the dev team without any PM decision or awareness needed

**Section 9.3 Assumptions Integrity:**
- [ ] No assumption appears whose RISK IF WRONG answer is "minor" or "none" — if being wrong changes no FR, OQ, or scope item, omit it

**Section 8 Known Limitations Integrity:**
- [ ] No Known Limitation describes a technical implementation detail with no user-visible effect (caching strategy, framework choice, internal state management)
- [ ] No Known Limitation is actually an unresolved decision that belongs in Section 10 Open Questions
- [ ] Every Known Limitation leads with the user-observable impact, not the technical cause

**Section 10 Open Questions Integrity:**
- [ ] No OQ is answerable from existing inputs (codebase, Stage 1 sources, prior conversations) — if the answer exists, it must be looked up and resolved before the document is printed
- [ ] No OQ is a dev team architecture decision with no product behavior consequence for the PM — those belong in Implementation Notes, not the OQ table

**Personas and User Goals:**
- [ ] Personas table uses behavioral-state naming — each persona name reflects a usage context or device state, not a job title alone
- [ ] Each persona row represents a distinct usage state that produces different product behavior (different flows, rules, or outputs)
- [ ] Each User Goal follows "As a [persona], I want [goal] so that [outcome]" — "so that" clause is present and adds beyond restating the want
- [ ] No User Goal bundles two distinct needs into one statement

**Section 5 What's Changing Language:**
- [ ] Section 5 What's Changing table uses user-observable language only in both columns — no architecture terms, SDK names, or internal system concepts (e.g., "session token", "OS-native", "codebase")
- [ ] Every Section 5 table row leads with what the user experiences, not the technical cause

**Fix any failures before presenting.** Do not present documents with known quality failures.

**FR Verbosity:**
- [ ] (P1) No intra-FR duplicate bullets: scan each FR's Business Rules list. If two bullets state the same fact in different words, merge into the more complete version. Keep the version that specifies what happens, not just that it happens.
- [ ] (P1b) No same-outcome convergence: if two bullets describe different triggers that produce the identical user experience, merge them using conditional syntax — "If [trigger A] or [trigger B], [shared outcome]." Keep triggers in separate bullets only when: (a) the user experiences them differently, or (b) QA requires distinct test cases for each trigger. Identical fallback outcomes ("the officer is offered Sign in to MyConnect") do not justify separate bullets.
- [ ] (P1c) No [TBD]-only bullets: a bullet whose entire content is "[TBD — see OQ-N]" is not a requirement — it is an open question in the wrong location. If OQ-N exists in Section 10 Open Questions, delete the [TBD] bullet entirely. The OQ is the single source of truth for that unknown behavior. A [TBD] bullet and its corresponding OQ must never coexist.
- [ ] (P1d) Bullets in the right FR: a bullet that describes what is visible or always available on a screen belongs in the FR that introduces and defines that screen — not in a subsequent interaction FR. If a bullet begins with "the screen shows", "the screen always displays", or "the option is always available on the screen" — verify it lives in the screen-definition FR. Move it if misplaced.
- [ ] (P5) No inline annotation tags in business rules: flag and remove `[Display layout, Design Decision]`, `[Design Decision]`, `[TBD - Design]` tags. The fact behind the tag is kept; the tag itself is stripped.
- [ ] (P5) No working notes masquerading as business rules: flag any bullet that reads as an unresolved observation ("In some situations X might...") rather than a stated rule. Either convert to a rule with a condition or move to Open Questions.
- [ ] (P6) Single fact per bullet: flag compound bullets containing two unrelated facts joined by a semicolon. Split into two separate bullets unless the facts are causally inseparable (cause → effect is fine to keep together).
- [ ] (P6) Rules in the right section: audit trail access control (who can view audit data) belongs in Section 9.1 Constraints or a Compliance note, not inside individual FRs. Flag and relocate.

**Phase Purity:**
- [ ] (P8) No Phase 2/3 content in Phase 1 FRs: scan every FR whose heading does NOT contain `*(Phase 2/3)*` for bullets that start with "Phase 2/3 only:" or contain a "(Phase 2/3)" qualifier. These are a quality failure — deferred behaviors belong in a Phase 2/3 FR. Move the bullet to the appropriate Phase 2/3 FR or delete it, and add the deferred behavior to the Out of Scope table.
- [ ] (P8b) No Phase 2/3 announcements outside Section 4 Scope Out of Scope: verify no other section announces a specific feature is deferred. Out of Scope is the single source of truth.
- [ ] (P8c) No full Phase 2/3 persona rows in Section 2 Personas: if a row is dedicated entirely to a Phase 2/3 feature, reduce to a one-liner note. A full persona row for a deferred persona is a quality failure.
- [ ] (P8d) No Phase 2/3 items in Section 6 User Flows table: verify the Flow Inventory table contains no rows whose Outcome names a deferred feature as the destination. If found, remove them.
- [ ] (P9) No FR body contains sub-labels: scan every FR for "Description:", "Business Rules:", "Source:", "Type:", "Phase:". Any found inside an FR body are a quality failure — remove them.
- [ ] (P10) Simple FRs (≤3 bullets, no conditionals, no external system, no failure paths) have no description sentence — heading goes directly to bullets. When counting bullets to classify: [TBD] placeholder bullets do not count toward complexity (they are not testable requirements).
- [ ] (P10b) Complex FRs have exactly one description sentence. Apply the description line test: (a) does it restate bullets 1+2 in prose? If yes, delete it. (b) does it make a claim contradicted by an unresolved Open Question? If yes, remove the premature claim or rewrite as neutral framing.
- [ ] (P11) Deferred FRs are marked `*(Phase 2/3)*` in their heading. No Phase 1 FR heading contains this marker. No FR bullet contains "Phase 2/3 only:" — deferred content belongs in a Phase 2/3 FR, not embedded in a Phase 1 FR.

**Structure (v2 compliance):**
- [ ] Document has exactly 11 main sections (Section 1–Section 11) plus Appendices A, B, D, E
- [ ] Zero Non-Functional Requirements section exists in the document
- [ ] Zero Analytics or Observability section exists in the document
- [ ] Zero Revision History or Change History section exists in the document
- [ ] Zero Business Goals section exists in the document
- [ ] Zero Stakeholders table exists in the document
- [ ] Zero Future Enhancements section exists in the document
- [ ] Zero Dependencies standalone section (dependencies route to Section 9.1 Constraints if non-negotiable, or Section 10 OQs if a decision is needed)
- [ ] Section 1 Overview is exactly 3 sentences — no technical terms, no implementation rationale
- [ ] Section 2 Personas is a table (not bullets), behavioral-state names, no OS/platform listed as a persona
- [ ] Section 3 User Goals is a standalone section with JTBD format (As a / I want / so that)
- [ ] Section 4 Scope In is a single-column capability table; Scope Out is a two-column table with a Reason column
- [ ] Section 5 What's Changing is a two-column table with user-observable language only — skip for net-new features
- [ ] Section 6 User Flows is a table (Flow | Trigger | Outcome) with happy paths only; failure paths in Appendix D
- [ ] Section 8 Known Limitations is a standalone section — not buried in Section 9
- [ ] Section 9 has exactly 3 subsections: 9.1 Constraints (table: Constraint | Imposed By) → 9.2 Risks (Stage 8 populates) → 9.3 Assumptions (table: # | Assumption | Status | Impact if Wrong)
- [ ] Section 10 Open Questions table has columns: # | Question | Blocks | Priority | Owner | Target Date
- [ ] Section 11 References has two groups: Design Assets and Source Materials
- [ ] Error Handling is in Appendix B only — not a main section
- [ ] Detailed/failure user flows are in Appendix D — not in Section 6 main table
- [ ] Document header has exactly 5 fields: Feature, Version, Date, Owner, Status — no Platform, Pipeline Stage, or Product fields
- [ ] `**Complexity: X | Size: Y**` tag is present below the header block (not inside it)

---

Quality gate complete. Proceed to Step 5: Present Document.

---

## 💬 Step 5: Present Document

Present to user:

```markdown
✅ Generated Feature Requirements:

**Feature Requirements** → [output-folder]/Generated/Internal/Feature-Requirements-[Feature].md
- [X] functional requirements
- [N] TBDs flagged
- Word count: ~[N]

---

**TBDs requiring input:**
🔴 Critical: [list with stakeholder routing]
🟡 Important: [list]

---

**Next:** Run Workflow 3 to validate completeness and readiness for story creation.
- Reply **"validate"** to continue
- Reply **"done"** to stop here
```

**STOP and WAIT for user response.**

---

## 🔄 Step 6: After User Replies

**If "validate" or "yes":**
```
Starting Workflow 3: Validation...
```
**Read and follow:** `workflows/03-validate.md`

**If "done" or any other response:**
```
✅ Requirements generation complete.

Files saved to: [output-folder]/Generated/Internal/

Next steps:
- Review document with stakeholders
- Fill in [TBD] items with relevant teams
- When requirements are finalized, generate API Contracts using `rest-api-contract-generator`
- Use these requirements to generate user stories (Story Creation workflow)
```

---

---

Workflow 2 complete. Return to `SKILL.md` workflow chain.
