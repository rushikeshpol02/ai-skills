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
         Reads stage artifacts 2-6 only (not original sources)
     ↓
Stage 8: Risk Analysis
     ↓
Stage 9a: Requirements Accuracy Review (calls validate-requirements skill)
     ↓
Stage 9b: Document Audit (calls document-audit skill)
```

**Stages 2, 5, and 9 are mandatory checkpoints.** Do not skip them.

---

## Output Folder & Artifact Registry

### Output folder (ask in Stage 1)

At the start of Stage 1, before processing any inputs, ask the user:

> "Where should I save the pipeline output? Please provide a folder path (e.g., `/path/to/project/output`). I'll create subfolders for stage artifacts and final deliverables."

**If the user provides a path:** Use it as `[output]` for the rest of the pipeline.
**If the user says "here" or points to the workspace root:** Use the workspace root as `[output]`.
**If called from another skill that already set an output path:** Use that path without re-asking.

### Folder structure

```
[output]/
├── stage_output/                          ← Pipeline working artifacts
│   ├── Stage1-Intake.md
│   ├── Stage2-Interpretation.md
│   ├── Stage3-Variables-Actors.md
│   ├── Stage4-Scenarios-Matrix.md
│   ├── Stage5-Assumptions.md
│   ├── Stage6-User-Flows.md
│   ├── Stage8-Risk-Analysis.md
│   ├── Stage9a-Accuracy-Review.md
│   └── Stage9b-Document-Audit.md
├── source_summaries/                      ← Processed inputs from Stage 1
│   ├── [Meeting]_Summary_[date].md
│   ├── Context-Summary-[Design].md
│   └── ...
├── [Feature]-Requirements.md              ← Final requirements (internal)
└── [Feature]-Requirements-Client.md       ← Client-ready version (if requested)
```

Create the `stage_output/` and `source_summaries/` subfolders at the start of Stage 1 (use `mkdir -p`).

### Stage Artifact Registry

Every stage MUST save its output to a markdown file before proceeding to the next stage. This is not optional. **Never present stage output only in chat.** Chat output is ephemeral and lost when context fills up; files persist across the entire pipeline.

| Stage | Save To | What It Contains |
|---|---|---|
| 1 | `[output]/stage_output/Stage1-Intake.md` | Source registry, input classification, processing verification, current state summary |
| 2 | `[output]/stage_output/Stage2-Interpretation.md` | STATED facts, INFERRED items, actors, constraints, decisions, open items |
| 3 | `[output]/stage_output/Stage3-Variables-Actors.md` | Variables table, constraints table, actor interaction map |
| 4 | `[output]/stage_output/Stage4-Scenarios-Matrix.md` | Full scenario matrix with edge cases and boundary conditions |
| 5 | `[output]/stage_output/Stage5-Assumptions.md` | All assumptions grouped by priority and risk area |
| 6 | `[output]/stage_output/Stage6-User-Flows.md` | User flows with purity filter classification |
| 7 | `[output]/[Feature]-Requirements.md` | Feature requirements document *(produced by `generate-requirements` skill)* |
| 8 | `[output]/stage_output/Stage8-Risk-Analysis.md` | Tigers / Paper Tigers / Elephants analysis |
| 9a | `[output]/stage_output/Stage9a-Accuracy-Review.md` | Accuracy review report *(produced by `validate-requirements` skill)* |
| 9b | `[output]/stage_output/Stage9b-Document-Audit.md` | Document audit report *(produced by `document-audit` skill)* |

**Processed inputs** from Stage 1 (meeting summaries, design context docs) save to `[output]/source_summaries/`.

**Rules:**
- Save the file FIRST, then present a brief summary in chat (max 10-15 lines) with the file path.
- At checkpoint stages (2, 5, 9), tell the user to review the file and confirm. Do NOT dump the full content into chat.
- If a stage needs user confirmation, the file is the artifact they review — not a chat message.
- Each file should end with a `## Next Stage` pointer (e.g., "→ Stage 3: Brainstorm").

---

## Stage 1: Intake & Classification

Read the file:

    stages/01-intake.md

Follow that file's instructions completely from start to finish.
When Stage 1 is complete, return here and proceed to Stage 2.

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

### Save Stage 2 artifact

**Save to:** `[output]/stage_output/Stage2-Interpretation.md`

Include: all sections above (Problem/Feature, Current State, STATED facts, INFERRED items, Actors, Constraints, Open items, Decisions). End with an `## ACTION REQUIRED` section listing what the user needs to confirm/reject.

**In chat, present only:** A brief summary (file path, count of STATED facts, count of INFERRED items needing review, count of open items) and ask the user to review the file.

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

### Save Stage 3 artifact

**Save to:** `[output]/stage_output/Stage3-Variables-Actors.md`

Include: variables table, constraints table, actor interaction map. End with `## Next Stage → Stage 4: Scenario Matrix`.

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

**Save to:** `[output]/stage_output/Stage4-Scenarios-Matrix.md`

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

### Save Stage 5 artifact

**Save to:** `[output]/stage_output/Stage5-Assumptions.md`

Include: all assumptions grouped by priority (HIGH/MEDIUM/LOW) then by risk area, with STATUS, VALIDATE WITH, BY WHEN, RISK IF WRONG, and any enrichment from the `identify-assumptions` skill. End with `## ACTION REQUIRED` section.

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

**Save to:** `[output]/stage_output/Stage6-User-Flows.md`

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
- **Inputs (stage artifacts only, read in order):**
  - Stage 2: Interpretation Checkpoint (confirmed facts, rejected inferences, decisions, actors, constraints, open items)
  - Stage 3: Variables, Constraints, Actors (variables table, constraints table, actor interaction map)
  - Stage 4: Scenario Matrix (all scenarios with edge cases and boundary conditions)
  - Stage 5: Assumptions (validated assumptions with risk areas)
  - Stage 6: User Flows (flows after purity filter)
- **Output folder:** use `[output]` path established in Stage 1. Do NOT re-ask.
- **Project context:** loaded from Stage 1.1 (if `project-context.md` existed)
- **Current state:** from Stage 1.5 (if available)
- **New or existing:** determined in Stage 1.5

The skill then runs its 3-workflow pipeline (synthesize → generate → validate) with all context pre-loaded.

**Why stage artifacts only (not original source documents):** Stage artifacts are curated, user-confirmed, and corrected versions of the raw inputs. They contain rejected inferences (guardrails against re-introducing errors), confirmed decisions, and structured analysis that the originals lack. Re-reading original sources at this stage risks picking up information that was already discussed and rejected during Stages 2-6. Source-level verification against originals is handled separately by Stage 9a (validate-requirements, Checks 1, 2, and 4).

**Source traceability:** Instruct the skill to carry forward the source IDs from stage artifacts (e.g., `(Source: SRC-1, Decision 3)`). These IDs were assigned in Stage 1 and flow through all stage artifacts. Requirements that synthesize multiple stage inputs should list all sources.

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

### Save Stage 8 artifact

**Save to:** `[output]/stage_output/Stage8-Risk-Analysis.md`

Include: Tigers / Paper Tigers / Elephants analysis, and a summary of which risks were merged back into the requirements document.

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
3. **Save artifacts at every stage — see Stage Artifact Registry.** Long sessions lose context. Files persist. Never present stage output only in chat. Save the file first, then summarize briefly in chat with the file path.
4. **Mark unknowns honestly.** `[TBD]` is always better than invented data.
5. **Domain-agnostic.** Never assume a specific tech stack, industry, or platform unless the user's inputs specify one.
6. **One stage at a time.** Complete each stage fully before starting the next. Wait for user confirmation at checkpoints.
7. **Consolidate inputs upfront.** Process all user-confirmed inputs (from the three-tier scoping gate) in Stage 1 before doing any analysis. Do not process inputs one at a time across multiple rounds.
8. **Source traceability everywhere.** Every requirement, assumption, decision, and constraint in the final document must carry a source tag (`Source: SRC-N, section/decision` or `Source: Implicit`). If you can't trace a statement to an input, tag it as Implicit — this flags it for extra validation.
9. **Never invent the current state.** If existing product capabilities are unknown, tag them as `[CURRENT STATE UNKNOWN]` — do not fabricate a plausible "before" scenario. Always ask about existing product in Step 1.5.
10. **Requirements describe WHAT, never HOW or WHAT IT LOOKS LIKE.** If you catch yourself writing an implementation mechanism (solution) or a UI layout/navigation pattern (design decision), reframe it as the underlying need or flag it as a design decision / open question.
11. **Inferred content must be flagged.** `[INFERRED]` is better than confident-sounding fabrication. When filling a gap, tag it explicitly so the user can verify or reject it. Never present an inference as a stated fact.
12. **Source citations must be accurate.** When citing `(Source: SRC-N)`, carry forward the source ID from stage artifacts faithfully. Source-level verification against original documents is performed in Stage 9a (validate-requirements, Checks 1, 2, and 4).
13. **Scoped statements stay scoped.** If a source says "X in context A", do not generalize to "X everywhere" without additional sourcing or explicit `[INFERRED — generalized from SRC-N context A]` tagging.
14. **Table indicators must be labeled and sorted.** Never use a bare dot (`🔴`) without a label (`🔴 Critical`). All tables with priority, risk, or severity columns must be sorted highest first. Resolved items sink to the bottom.
15. **Scope inputs to user-provided context.** Never scan the full workspace by default. Use the three-tier scoping gate in Stage 1.1: (1) user-provided files are always included, (2) same-folder discovery with user selection, (3) workspace-wide keyword search only on explicit request. Files not selected by the user are never read.
