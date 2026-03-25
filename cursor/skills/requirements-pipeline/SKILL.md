---
name: requirements-pipeline
description: "A 9-stage discovery and analysis pipeline that takes messy, early-stage inputs — rough ideas, transcripts, designs, legal docs, hypotheses — and produces a production-ready requirements document. Handles brainstorming, scenario mapping, assumption analysis, user flows, and risk analysis with mandatory human checkpoints. Calls complementary skills at each stage. Use when asked to: run the requirements pipeline, build requirements from scratch, start from rough ideas or a transcript, or work through a feature from discovery to requirements."
---

# Generate Detailed Requirements — Pipeline Orchestrator

## Purpose

Orchestrates a full requirements pipeline from messy, diverse inputs to a production-ready requirements document. It coordinates multiple skills and enforces quality gates between stages.

**What makes this different from `generate-requirements`:**
- `generate-requirements` takes well-defined inputs (PRDs, designs, transcripts) and generates a structured Feature Requirements document.
- This skill handles the **earlier, messier phase** — rough ideas, brainstorming, scenario mapping, stakeholder feedback loops — and builds up to the point where `generate-requirements` can take over for the final doc.

**Core principles:**
- **Interpret before editing.** Always summarize understanding and wait for confirmation before producing artifacts.
- **Facts only.** Mark unknowns as `[TBD]`. Never fabricate rules, thresholds, or business logic.
- **Domain-agnostic.** This pipeline works for any feature, any industry, any platform.

---

## Pipeline Overview

```
Stage 1: Intake & Classification + Current State Discovery
     ↓
Stage 2: Interpretation Checkpoint (STOP — wait for user confirmation)
         Includes Inference Register — STATED vs INFERRED separation
     ↓
Stage 3: Brainstorm — Variables, Constraints, Actors
     ↓
Stage 4: Scenario Matrix — Combinations, Edge Cases, Boundary Conditions
     ↓
Stage 5: Assumptions Identification (calls identify-assumptions skill)
     ↓
Stage 6: User Flows — Step-by-step for each actor
         Includes Requirement Purity Filter (Step 6.5)
     ↓
Stage 7: Requirements Document (calls generate-requirements skill)
         Includes Source Verification Pass
     ↓
Stage 8: Risk Analysis
     ↓
Stage 9a: Requirements Accuracy Review (calls validate-requirements skill)
     ↓
Stage 9b: Document Audit (calls document-audit skill)
```

**Stages 2, 5, and 9 are mandatory checkpoints.** Do not skip them.

---

## Stage 1: Intake & Classification

### 1.1 Scan for inputs and load project context

Before asking the user anything, scan the workspace for available files using Glob and Read tools.

**Check for `project-context.md` in the workspace root.**

**IF found:** Read it completely and extract:
- Tech stack (frontend, backend, DB, mobile)
- API conventions (auth, naming, error shape)
- Defined personas (names, roles, pain points)
- System components and integrations
- Known limitations and constraints
- Compliance baseline
- Glossary / terminology

Announce what was loaded:
```
Project context loaded from project-context.md:
- Stack: [stack summary]
- Personas: [list]
- Systems: [list]
- Constraints: [count] known

This context will be applied throughout all pipeline stages.
```

This pre-loaded context informs:
- Stage 2 (Interpretation) -- known actors and systems don't need re-discovery
- Stage 3 (Variables/Constraints) -- pre-populated with known constraints
- Stage 4 (Scenarios) -- system-level edge cases already known
- Stage 6 (User Flows) -- personas and system interactions pre-loaded
- Stage 7 (Requirements) -- passed directly to `generate-requirements`

**IF not found:** Proceed without it. The pipeline will discover context from inputs. At the end of the pipeline (after Stage 9b), offer to create `project-context.md` from everything learned during this session.

### 1.2 Classify each input

| Input Type | How to Identify | Route To |
|---|---|---|
| Meeting transcript (.vtt, .md, .txt, .docx) | Filename contains "transcript", "meeting", "notes"; content has speaker names + timestamps | `transcript-to-meeting-notes` skill |
| Design file / Figma / FigJam URL | Image files, `figma.com` URLs | `design-to-context` skill |
| High-level requirements, ideas, hypotheses | User describes in chat or provides rough notes; no formal structure | Capture directly — processed in Stage 3 |
| Legal docs, policy docs, reference material | Formal language, regulatory content, compliance references | Read and extract key rules, constraints, thresholds |
| Existing requirements doc (for iterative update) | Structured doc with sections like Scope, Assumptions, Dependencies | Read as baseline — delta updates only |
| Swagger / OpenAPI spec | `.yaml`, `.json` with endpoint definitions | Read and extract integration points, data models, constraints. API contracts are generated separately after requirements are finalized using `rest-api-contract-generator`. |

### 1.3 Assign source IDs and report

Every input gets a short **source ID** used throughout the pipeline for traceability.

```
Inputs identified:
- [SRC-1] [filename] → [classification] → [will be processed by: skill name or "directly"]
- [SRC-2] [filename] → [classification] → [will be processed by: ...]
- [SRC-3] User-provided context → [rough ideas / hypotheses / requirements]

Processing order: [list in priority order]
```

**Source ID format:** `SRC-N` for files and user input. Within processed outputs, use finer-grained tags: `SRC-1, Decision 3` or `SRC-2, Screen 4`. For facts surfaced during analysis (not in any input), use `Implicit`.

### 1.4 Process routed inputs

Run complementary skills on their respective inputs:
- Transcripts → `transcript-to-meeting-notes` → produces structured meeting summary
- Designs (Figma URLs, FigJam URLs, screenshots, images) → `design-to-context` → produces a Context Summary, Design Description, or User Flow Document
- All other inputs → read and extract key information directly

**Save all processed outputs to workspace before proceeding.**

### 1.4.1 Processing Verification Gate (MANDATORY)

Before moving to Step 1.5, verify that every input classified for skill processing in Step 1.2 has a corresponding saved output file. Present a checklist:

```
Processing verification:
- [SRC-1] transcript.vtt → ✅ Produced: Meeting-Summary-[name].md
- [SRC-2] figma.com/board/... → ✅ Produced: Context-Summary-[name].md
- [SRC-3] screenshot.png → ❌ NOT PROCESSED — design-to-context was not run
```

**Rules:**
- Every input routed to a skill MUST have a saved output file. A URL or filename alone is not a processed output.
- If any input shows ❌, run the skill on it immediately before proceeding. Do NOT treat unprocessed inputs as valid sources -- a URL without a processed output means the content was never actually read or analyzed.
- If a skill cannot process an input (e.g., Figma MCP is unavailable, image is unreadable), flag it explicitly: `[SRC-N] ⚠️ COULD NOT PROCESS — [reason]. Content is unavailable for analysis. Any citations to SRC-N will be unverifiable.` Present this to the user and ask how to proceed (provide alternative input, skip, or proceed with gap).
- Do NOT proceed to Step 1.5 until all routed inputs are either ✅ processed or ⚠️ explicitly flagged with user acknowledgment.

**Why this matters:** Without this gate, URLs and filenames get assigned source IDs and cited throughout the pipeline as if their content was analyzed, when in reality the content was never fetched or read. This leads to unverifiable citations, fabricated interpretations of what the source "says," and findings like "SRC-N is unverifiable" surfacing much later in validation (Stage 9a) -- wasting significant rework effort.

### 1.5 Current State Discovery (MANDATORY)

Before proceeding to Stage 2, determine whether this feature is new or enhances something that already exists.

**Ask the user:**
- "Is this a new feature (greenfield) or an enhancement to something that already exists?"
- If enhancement: "What exists today? Describe or provide: existing screens, current capabilities, known limitations. Figma links, screenshots, or verbal description all work."

**If the user provides current-state inputs:**
- Process Figma links or screenshots through `design-to-context` to produce a current-state design description
- Assign a source ID (e.g., `SRC-CS-1`) and save the output
- This becomes the baseline for identifying what is EXISTING vs NEW in the requirements

**If no current-state information is available:**
- Flag it explicitly: `[CURRENT STATE UNKNOWN — do not assume what exists today]`
- Carry this flag into Stage 2 so the interpretation checkpoint surfaces it
- Do NOT invent or assume current capabilities, pain points about current tools, or "before" scenarios

**Why this matters:** Without confirmed current state, the pipeline will fabricate a plausible "before" scenario (e.g., assuming users have no existing tool when they do). This leads to incorrect pain points, wrong framing (new feature vs. enhancement), and requirements that ignore existing capabilities.

---

## Stage 2: Interpretation Checkpoint (MANDATORY STOP)

**Before doing any analysis or editing, summarize what you understood from ALL inputs.**

Present to the user, separating STATED facts from INFERRED conclusions:

```
Here's what I extracted from all inputs:

**Problem / Feature:**
[1-2 sentence summary of what this feature is about]

**Current State:**
[What exists today — from Step 1.5. If unknown, state: "CURRENT STATE UNKNOWN — not yet provided"]

**STATED facts (directly from sources):**
- [Fact 1] (Source: SRC-N, section/decision)
- [Fact 2] (Source: SRC-N, section/decision)

**INFERRED conclusions (derived or gap-filled — need your confirmation):**
- [Inference 1] — reasoning: [why this was inferred] (Based on: SRC-N)
- [Inference 2] — reasoning: [why this was inferred] (Based on: SRC-N)

**Actors identified:**
- [Actor 1: role and relevance] (Source: SRC-N)
- [Actor 2: role and relevance] (Source: SRC-N)

**Constraints / rules identified:**
- [Constraint 1] (Source: SRC-N, section/decision)
- [Constraint 2] (Source: SRC-N, section/decision)

**Open / unclear items:**
- [Item 1 — what's unclear and why it matters]

**Decisions already made (from transcripts/meetings):**
- [Decision 1] (Source: SRC-N, Decision N)

Does this match your understanding? Anything missing or incorrect?
Please review the INFERRED items — confirm, correct, or reject each one.
```

Every fact, constraint, and decision must carry its source ID.

**Inference Register rules:**
- Any item not directly quoted or clearly present in a source is INFERRED and must be listed in the INFERRED section, not the STATED section.
- The user must confirm, correct, or reject each INFERRED item before proceeding.
- Confirmed inferences become STATED facts (with `Source: User-confirmed`).
- Rejected inferences are removed.
- Unresolved inferences become `[TBD]` — they must NOT be written as confident fact in later stages.

**STOP and WAIT for user confirmation.** Do not proceed to Stage 3 until the user confirms or corrects.

---

## Stage 3: Brainstorm — Variables, Constraints, Actors

### 3.1 Identify variables

Work with the user to define the variables that determine system behavior:

| Variable | Values / Range | Source (SRC-N) | Determines |
|---|---|---|---|
| [Variable 1] | [Possible values] | [SRC-N, section/decision] | [What system behavior it affects] |

### 3.2 Identify constraints

Constraints are non-negotiable rules that limit how the system can behave:

| Constraint | Rule | Source (SRC-N) | Impact |
|---|---|---|---|
| [Constraint 1] | [Exact rule] | [SRC-N, section/decision] | [What it prevents or requires] |

### 3.3 Map actors and their interactions

| Actor | Actions | Receives | Depends On |
|---|---|---|---|
| [Actor 1] | [What they do] | [What they see/get] | [What must happen first] |

### 3.4 Present variables list for confirmation

Show the complete variables list and ask:
- Are any variables missing?
- Are the values/ranges correct?
- Are there any constraints I haven't captured?

**Wait for user confirmation before proceeding.**

---

## Stage 4: Scenario Matrix — Combinations, Edge Cases, Boundary Conditions

### 4.1 Build scenario matrix

Cross-reference variables to identify all meaningful combinations:

| Scenario ID | [Variable 1] | [Variable 2] | [Variable N] | Expected Behavior | Priority | Notes |
|---|---|---|---|---|---|---|
| S1 | [value] | [value] | [value] | [What happens] | 🔴 Critical | |

**Rules:**
- Include happy path scenarios first
- Include boundary conditions (minimum, maximum, just-above, just-below thresholds)
- Include error scenarios (invalid inputs, timeouts, missing data)
- Include edge cases (concurrent actions, interrupted flows, partial data)
- Sort scenarios: happy paths first, then by priority (🔴 Critical → 🟡 Important → 🟢 Edge case)

### 4.2 Identify edge cases

For each variable, ask:
- What happens at the boundary? (e.g., exactly at a threshold)
- What if this value is missing or null?
- What if two actors do conflicting things simultaneously?
- What if the process is interrupted midway?

### 4.3 Present matrix for review

Show the full scenario matrix and edge case list. Ask:
- Any scenarios missing?
- Any edge cases you've seen in practice?
- Which scenarios are highest priority?

**Save the scenario matrix as a workspace file:** `[Feature]-Scenarios-Matrix.md`

---

## Stage 5: Assumptions Identification (MANDATORY CHECKPOINT)

**Read and follow the `identify-assumptions` skill** with the following context:
- The variables and constraints from Stage 3
- The scenario matrix from Stage 4
- All processed inputs from Stage 1
- Any assumptions already surfaced by `transcript-to-meeting-notes` (if transcripts were processed in Stage 1). Note: meeting notes produce a simpler 3-field assumption format (STATUS, VALIDATE WITH / BY WHEN, RISK IF WRONG). The `identify-assumptions` skill will enrich these with RISK AREA, EVIDENCE, and SUGGESTED TEST fields, and may identify additional assumptions not discussed in the meeting.

**Present all assumptions to the user.** Group by priority (HIGH / MEDIUM / LOW), then by risk area (Value, Usability, Viability, Feasibility) within each group. Highest risk first.

**Table formatting rule (applies to all tables in all pipeline artifacts):**
- Every priority/risk/severity indicator must include a label, never a bare dot: `🔴 Critical` not `🔴`, `🟡 Important` not `🟡`, `🟢 Low` not `🟢`
- Tables must be sorted by highest priority/risk/severity first. Resolved items sink to the bottom.

**Wait for user to confirm, correct, or add assumptions before proceeding.**

---

## Stage 6: User Flows

### 6.1 Identify flows needed

Based on actors from Stage 3 and scenarios from Stage 4:

| Flow | Actor | Trigger | Happy Path Steps | Alternative Paths |
|---|---|---|---|---|
| [Flow 1] | [Actor] | [What starts it] | [Count] | [Count] |

### 6.2 Draft each flow

For each flow, produce:
1. **Step-by-step happy path** — numbered steps with actor, action, system response
2. **Decision points** — where the flow branches, with conditions for each branch
3. **Alternative paths** — what happens on each non-happy-path branch
4. **Background processing** — what the system does behind the scenes (data storage, notifications, triggers)
5. **Error handling** — what happens when things go wrong

### 6.3 Flow ordering rationale

If multiple flows exist, explain why they are ordered this way. Consider:
- Which flow is legally or business-critical?
- What happens if the process is interrupted — which data should already be captured?

### 6.4 Present flows for review

Show each flow and ask for feedback before proceeding to full requirements generation.

**Save user flows as a workspace file:** `[Feature]-User-Flows.md`

### 6.5 Requirement Purity Filter

After drafting user flows but before finalizing them, run a classification pass on every element in the flows. For each step, business rule, data field, and behavior description, classify it as:

| Classification | Definition | Action |
|---|---|---|
| **REQUIREMENT** | What the system must enable — observable, testable, solution-free | Keep in the flow and pass to Stage 7 |
| **SOLUTION** | How the system achieves it — implementation mechanism (e.g., "cache locally", "use delta API", "retry with exponential backoff") | Move to an "Implementation Notes" callout. Reframe the underlying need as a requirement. |
| **DESIGN** | What it looks like — UI layout, navigation pattern, visual structure (e.g., "organized as tabs", "swipe left/right") | Move to "Design Decisions [TBD]" or "Open Questions". Reframe the underlying need as a requirement. |
| **DATA** | What information is needed — field lists, data scope | Keep, but verify the source. Flag any data fields not traceable to a source as `[INFERRED — verify]`. |

**Present the classification to the user at the Stage 6 review checkpoint.** This catches solutions and design prescriptions before they enter the requirements document.

**Why this matters:** User flows naturally produce implementation and design details because they describe concrete interactions. Without this filter, those details propagate into Stage 7 as if they were requirements — making the final doc prescribe solutions and designs instead of capabilities.

---

## Stage 7: Requirements Document Generation

**Call the `generate-requirements` skill, skipping its intake step (SKILL.md Steps 1-3).** The pipeline has already gathered all required context. Go directly to Workflow 1 (`workflows/01-synthesize.md`).

**Pipeline provides these values (do not re-ask the user):**
- **Feature name:** determined in Stage 1
- **Mode:** always **Comprehensive** (6 contexts) -- the pipeline is the thorough path
- **Inputs:** all processed inputs from Stage 1, scenario matrix from Stage 4, assumptions from Stage 5, user flows from Stage 6 (after purity filter)
- **Output folder:** ask the user for the output folder path at this point, if not already provided. This is the only question asked at Stage 7.
- **Project context:** loaded from Stage 1.1 (if `project-context.md` existed)
- **Current state:** from Stage 1.5 (if available)
- **New or existing:** determined in Stage 1.5

The skill then runs its 3-workflow pipeline (synthesize → generate → validate) with all context pre-loaded.

**Important:** Pass the scenario matrix and assumptions as explicit inputs -- they contain information that may not be in the original source documents.

**Source traceability:** Instruct the skill to tag every requirement, decision, assumption, and key fact in the output document with its source. Use the source IDs assigned in Stage 1 (e.g., `(Source: SRC-1, Decision 3)`). Requirements that synthesize multiple inputs should list all sources.

**Source verification pass (MANDATORY after generation):** After the requirements document is generated, perform a source verification pass:
- For each `(Source: SRC-N)` citation, go back to the actual source and verify it contains the claimed information.
- Check for **over-generalization** — if a source says "X in context A", the requirement must not say "X in all contexts" without additional sourcing.
- Check for **misattribution** — if a source is cited but does not actually contain the claimed fact, flag it as `[SOURCE UNVERIFIED — SRC-N does not contain this claim]`.
- Any requirement tagged `(Source: Implicit)` should be reviewed: is it truly a logical derivation, or is it a gap-fill that should be `[TBD]`?

**Requirement purity enforcement:** Instruct the skill to apply these language rules:
- Requirements describe WHAT (capability), never HOW (implementation) or WHAT IT LOOKS LIKE (UI pattern).
- If a statement prescribes an implementation approach, reframe it as the underlying need and add an "Implementation Note" callout.
- If a statement prescribes a UI pattern, move it to Open Questions / Design Decisions unless the user explicitly confirmed the design in a prior stage.

---

## Stage 8: Risk Analysis

Perform a pre-mortem analysis with:
- The requirements document from Stage 7
- The assumptions from Stage 5 (especially unconfirmed ones)
- The scenario matrix from Stage 4 (especially edge cases)

Produce a Tigers / Paper Tigers / Elephants analysis:
- **Tigers** — Real, high-impact risks that need mitigation plans
- **Paper Tigers** — Risks that seem scary but are manageable
- **Elephants** — Obvious problems everyone sees but no one has addressed

**Merge relevant risks back into the requirements document's Risks section.**

---

## Stage 9a: Requirements Accuracy Review (MANDATORY)

**Read and follow the `validate-requirements` skill** on the requirements document from Stage 7.

This skill performs 10 semantic accuracy checks across 4 dimensions:
- **Is it true?** — Source accuracy, inference detection, over-generalization, actor capability
- **Is it a requirement?** — Requirement purity (not a solution or design decision)
- **Is it actionable?** — Testability, ambiguity detection
- **Is it complete and safe?** — Assumption-requirement dependency, negative path coverage, scope boundary

**Inputs to provide:**
- The requirements document from Stage 7
- The source documents folder (meeting summaries, client docs, design descriptions from Stage 1)
- Sibling requirements docs (if multiple feature docs were generated)

**Fix all Critical findings immediately.** Present Should Fix and Verify findings to the user for decision before proceeding to Stage 9b.

---

## Stage 9b: Document Audit (MANDATORY FINAL STEP)

**Read and follow the `document-audit` skill** on the requirements document (after Stage 9a fixes are applied).

This skill checks structural integrity:
- Scans for `[PENDING]`, `[TBD]`, `[UNKNOWN]` markers that are already answered elsewhere in the doc
- Finds contradictions between sections
- Finds stale notes from earlier drafts
- Checks cross-references between sections
- Verifies assumptions table matches assumption references in the body

**Apply all HIGH-confidence fixes. Present the audit report and a summary of what was cleaned up.**

**STOP and WAIT for user to review the audit findings.** Do not mark the document as final until the user confirms all MEDIUM-confidence findings are resolved.

---

## After Stage 9b: Update or Create Project Context

After the pipeline completes, offer to create or update the project context:

```
This pipeline run discovered new project-level context (personas, systems,
constraints, terminology). To capture it for future sessions, run
/project-context to create or update your project-context.md.

This is optional but recommended -- it saves significant re-discovery time.
```

The `/project-context` skill handles both first-time creation and incremental updates with source confirmation and conflict detection. Do NOT attempt to create or update `project-context.md` inline -- always redirect to the skill.

---

## Critical Rules

1. **Never skip the interpretation checkpoint (Stage 2).** Misunderstanding inputs wastes more time than confirming understanding.
2. **Never skip the quality gates (Stage 9a + 9b).** Stage 9a catches semantic inaccuracies; Stage 9b catches structural issues. Both are required.
3. **Save artifacts at every stage.** Long sessions lose context. Files persist.
4. **Mark unknowns honestly.** `[TBD]` is always better than invented data.
5. **Domain-agnostic.** Never assume a specific tech stack, industry, or platform unless the user's inputs specify one.
6. **One stage at a time.** Complete each stage fully before starting the next. Wait for user confirmation at checkpoints.
7. **Consolidate inputs upfront.** Process all available inputs in Stage 1 before doing any analysis. Do not process inputs one at a time across multiple rounds.
8. **Source traceability everywhere.** Every requirement, assumption, decision, and constraint in the final document must carry a source tag (`Source: SRC-N, section/decision` or `Source: Implicit`). If you can't trace a statement to an input, tag it as Implicit — this flags it for extra validation.
9. **Never invent the current state.** If existing product capabilities are unknown, tag them as `[CURRENT STATE UNKNOWN]` — do not fabricate a plausible "before" scenario. Always ask about existing product in Step 1.5.
10. **Requirements describe WHAT, never HOW or WHAT IT LOOKS LIKE.** If you catch yourself writing an implementation mechanism (solution) or a UI layout/navigation pattern (design decision), reframe it as the underlying need or flag it as a design decision / open question.
11. **Inferred content must be flagged.** `[INFERRED]` is better than confident-sounding fabrication. When filling a gap, tag it explicitly so the user can verify or reject it. Never present an inference as a stated fact.
12. **Source citations must be accurate.** When citing `(Source: SRC-N)`, verify the source actually contains the claimed information. Do not cite a source for content it does not contain. Run the source verification pass in Stage 7.
13. **Scoped statements stay scoped.** If a source says "X in context A", do not generalize to "X everywhere" without additional sourcing or explicit `[INFERRED — generalized from SRC-N context A]` tagging.
14. **Table indicators must be labeled and sorted.** Never use a bare dot (`🔴`) without a label (`🔴 Critical`). All tables with priority, risk, or severity columns must be sorted highest first. Resolved items sink to the bottom.
