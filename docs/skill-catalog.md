# Skill Catalog

Deep-dive reference for every skill. Each entry covers: purpose, inputs, outputs, mode, and related skills.

---

## Table of Contents

**Pipeline Skills (Group 1)**
- [requirements-pipeline](#requirements-pipeline) — Pipeline Orchestrator
- [generate-requirements](#generate-requirements) — Pipeline Stage / Standalone
- [design-to-context](#design-to-context) — Pipeline Stage / Standalone
- [transcript-to-meeting-notes](#transcript-to-meeting-notes) — Pipeline Stage / Standalone
- [identify-assumptions](#identify-assumptions) — Pipeline Stage / Standalone
- [validate-requirements](#validate-requirements) — Pipeline Stage / Standalone
- [document-audit](#document-audit) — Pipeline Stage / Standalone

**Post-Pipeline Skills (Group 2)**
- [review-findings](#review-findings) — Post-Pipeline
- [update-documents](#update-documents) — Post-Pipeline
- [client-ready-requirements](#client-ready-requirements) — Post-Pipeline


---

## Pipeline Skills (Group 1)

---

### requirements-pipeline

**Mode:** Pipeline Orchestrator

**Purpose:** End-to-end requirements pipeline from messy, early-stage inputs to a production-ready Feature Requirements document. Orchestrates 9 stages, calling other skills at each quality gate. Handles inputs that are too raw or contradictory for `generate-requirements` to process directly.

**When to use:**
- Starting from rough ideas, brainstorm notes, or meeting transcripts
- Inputs are incomplete, contradictory, or need clarification
- You want a scenario matrix and multi-perspective assumption analysis before writing requirements
- The feature is complex enough to warrant stage-by-stage confirmation

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Meeting transcripts (`.vtt`, `.md`, `.txt`, `.docx`) | Optional | Automatically routed to `transcript-to-meeting-notes` |
| Design files or Figma URLs | Optional | Automatically routed to `design-to-context` |
| PRD, feature description, or verbal idea | At least one required | Any combination works |
| Legal / policy documents | Optional | Extracted for rules and constraints |
| Existing requirements doc (for iterative update) | Optional | Used as baseline for delta updates |
| Swagger / OpenAPI spec | Optional | Read and extract integration points, data models, constraints. API contracts are generated separately after requirements are finalized using `rest-api-contract-generator`. |
| `project-context.md` (workspace root) | Optional | Pre-loads tech stack, personas, API conventions, systems, constraints, and glossary if present |

**Outputs (saved to workspace):**
| File | Stage | Description |
|------|-------|-------------|
| `[Feature]-Scenarios-Matrix.md` | Stage 4 | All scenario combinations, edge cases, boundary conditions (with priority column) |
| `[Feature]-User-Flows.md` | Stage 6 | Step-by-step user flows per actor (with purity filter applied) |
| `Feature-Requirements-[Feature].md` | Stage 7 | Feature Requirements document (saved to user-provided output folder) |
| `Validation-Report-[Feature].md` | Stage 9a | Semantic accuracy review findings |
| Audit report | Stage 9b | Structural integrity findings |

**Mandatory checkpoints (STOP and wait for user):** Stages 2, 5, and 9

**Key pipeline enhancements (vs standalone `generate-requirements`):**
- **Stage 1.1:** Loads `project-context.md` if present — pre-populates personas, systems, constraints, and terminology across all stages
- **Stage 1.4.1:** Mandatory processing verification gate — ensures every input routed to a skill has a saved output file before proceeding (prevents unverifiable source citations)
- **Stage 7:** Skips `generate-requirements` intake (Steps 1-3) and passes all pipeline context directly to Workflow 1
- **After Stage 9b:** Offers to create or update `project-context.md` to capture project-level knowledge for future sessions

**Skills called:**
- Stage 1: `transcript-to-meeting-notes`, `design-to-context`
- Stage 5: `identify-assumptions`
- Stage 7: `generate-requirements` (skips intake, enters at Workflow 1)
- Stage 9a: `validate-requirements`
- Stage 9b: `document-audit`

**Related skills:** All pipeline skills — `generate-requirements`, `design-to-context`, `transcript-to-meeting-notes`, `identify-assumptions`, `validate-requirements`, `document-audit`.

---

### generate-requirements

**Mode:** Pipeline Stage / Standalone

**Purpose:** Generates a production-ready Feature Requirements document from well-defined inputs. Runs a 3-workflow sub-chain (Synthesize → Generate → Validate). Focuses exclusively on requirements; API contracts and system flows are generated separately after requirements are finalized.

**When to use:**
- Inputs are well-defined: clear PRD, confirmed Figma designs, and/or Swagger spec
- You need requirements generated quickly (Quick Mode: ~15 min)
- You're creating the final requirements document from already-analyzed inputs
- Called by `requirements-pipeline` at Stage 7 (skips intake, enters at Workflow 1)

**Modes:**
| Mode | Analysis Depth | Use When | Timing |
|------|---------------|----------|--------|
| Quick | 3 contexts (Business, Product, UX) | MVP, small feature, internal tool, single actor, low risk | ~15 min |
| Comprehensive | 6 contexts (+ Persona, Technical, Compliance) | Production feature, complex interactions, compliance-sensitive, external integrations | ~30 min |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Feature name | Yes | |
| PRD or feature description | At least one required | |
| Design files or Figma URLs | Optional | Analyzed in Workflow 1 |
| Swagger / OpenAPI spec | Optional | Read for integration points and data models |
| Meeting transcript or notes | Optional | Decisions extracted in Workflow 1 |
| `project-context.md` (workspace root) | Optional | Pre-populates tech stack, personas, API conventions if present |

**Outputs (saved to user-provided `[output-folder]`):**
| File | Path | Description |
|------|------|-------------|
| `Context-Summary-[Feature].md` | `[output-folder]/` | Internal analysis artifact |
| `Feature-Requirements-[Feature].md` | `[output-folder]/Generated/Internal/` | Always generated |
| `Validation-Report-[Feature].md` | `[output-folder]/Generated/Report/` | Quality gate report |

**Pipeline-aware entry point:** When called from `requirements-pipeline` (Stage 7), Steps 1-3 (workspace scan, project context loading, intake) are skipped entirely. The pipeline passes all context directly, and the skill enters at Workflow 1 (`01-synthesize.md`).

**Workflow sub-chain:** `01-synthesize.md` → `02-generate.md` → `03-validate.md`

**Related skills:** `requirements-pipeline` (calls this), `design-to-context`, `transcript-to-meeting-notes`, `validate-requirements`.

---

### design-to-context

**Mode:** Pipeline Stage / Standalone

**Purpose:** Converts Figma URLs or design image files into structured design context documents. Supports three output formats depending on the input and intent.

**When to use:**
- You have Figma screens or design mockups and need to document them
- You want to feed design context into a requirements pipeline
- Called by `requirements-pipeline` at Stage 1 for design inputs

**Output formats:**
| Format | Use When | File Produced |
|--------|----------|---------------|
| User Flow Document | Multiple sequential screens showing a journey | `[FlowName]_User_Flow_Document.md` |
| Design Description | Single screen, component set, or state variants | `[FeatureName]_Design_Description.md` |
| Context Summary | Design will feed into requirements generation | `Context-Summary-[FeatureName].md` |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Design images (`.png`, `.jpg`, `.webp`) | One of these required | Attached or in workspace |
| Figma URL (`figma.com/design/...`) | One of these required | Requires Figma MCP to be enabled |

**Outputs:** One of the three format files above, saved to workspace

**Figma MCP — subagent delegation:** If a Figma URL is provided and the Figma MCP is available, the skill **always delegates Figma calls to a `generalPurpose` subagent**. Figma responses are unpredictable in size (thousands of lines of metadata + screenshots); making these calls in the main conversation burns irreplaceable context. The subagent fetches screenshots, extracts metadata, and returns a distilled summary. Direct Figma MCP calls in the main conversation are explicitly prohibited.

**Related skills:** `requirements-pipeline` (calls this), `generate-requirements`

---

### transcript-to-meeting-notes

**Mode:** Pipeline Stage / Standalone

**Purpose:** Converts meeting transcripts into structured discovery summaries. Adapts the internal topic structure based on meeting type (discovery/requirements vs engineering/technical) while using the same output template for both.

**When to use:**
- You have a meeting transcript and need a structured summary
- You want to extract decisions, assumptions, and open questions from a call
- Called by `requirements-pipeline` at Stage 1 for transcript inputs

**Meeting types:**
| Type | Indicators | Topic Internal Structure |
|------|-----------|--------------------------|
| Discovery / Requirements | Stakeholder session, requirements gathering, discovery call | Fact-gathering bullets with traceability |
| Engineering / Technical | Engineering sync, architecture discussion, vendor call | Context, Requirements, Final Decision, Alternatives Considered, Key Technical Insights |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Transcript file (`.vtt`, `.md`, `.txt`, `.docx`) | Yes | |

**Outputs:**
- Meeting summary saved to workspace (named based on meeting date/title)
- Sections: Decisions table, topic-by-topic findings, know/don't-know analysis, assumptions, open questions, next steps

**Related skills:** `requirements-pipeline` (calls this), `generate-requirements`, `identify-assumptions`

---

### identify-assumptions

**Mode:** Pipeline Stage / Standalone

**Purpose:** Surfaces and structures risky assumptions using multi-perspective analysis (PM, Designer, Engineer) across four risk areas (Value, Usability, Viability, Feasibility). Outputs structured assumptions with status, validation method, deadline, and risk if wrong.

**When to use:**
- Stress-testing a feature idea before writing requirements
- Preparing for stakeholder review
- Called by `requirements-pipeline` at Stage 5

**Risk areas:**
| Area | What It Covers |
|------|---------------|
| Value | Will users find this valuable? Does it solve the right problem? |
| Usability | Can users understand and use it without friction? |
| Viability | Is it commercially sustainable? Does it fit the business model? |
| Feasibility | Can it be built with current team / tech / timeline? |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Feature description, PRD, or requirements document | Yes | |
| Scenario matrix | Optional | From Stage 4 of the pipeline |
| Meeting notes / transcripts | Optional | Assumptions from meetings are enriched, not duplicated |

**Outputs:**
- Assumptions register grouped by priority (HIGH / MEDIUM / LOW), then by risk area
- Each assumption includes: RISK AREA, STATUS, EVIDENCE, VALIDATE WITH, BY WHEN, RISK IF WRONG, SUGGESTED TEST

**Related skills:** `requirements-pipeline` (calls this), `transcript-to-meeting-notes` (produces simpler assumption format that this skill enriches)

---

### validate-requirements

**Mode:** Pipeline Stage / Standalone

**Purpose:** Validates requirements documents for semantic accuracy using 10 checks across 4 dimensions. Catches things that are factually wrong, unsourced, over-generalized, solution-prescriptive, or untestable.

**When to use:**
- After generating requirements (as part of the pipeline at Stage 9a)
- Before sharing requirements with stakeholders
- When suspecting inaccuracies or unsourced claims
- As a periodic quality sweep

**The 10 checks:**
| # | Check | Dimension |
|---|-------|-----------|
| 1 | Source Accuracy Audit | Is it true? |
| 2 | Inference Detection | Is it true? |
| 3 | Actor Capability Check | Is it true? |
| 4 | Over-Generalization Detection | Is it true? |
| 5 | Requirement Purity | Is it a requirement? |
| 6 | Testability | Is it actionable? |
| 7 | Ambiguity Detection | Is it actionable? |
| 8 | Assumption-Requirement Dependency | Is it complete? |
| 9 | Negative Path Coverage | Is it complete? |
| 10 | Scope Boundary | Is it complete? |

**Distinct from `document-audit`:** This skill checks semantic accuracy (is the content true and correct?). `document-audit` checks structural integrity (are there stale markers, contradictions, broken cross-refs?).

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Requirements document | Yes | The file to validate |
| Source documents folder | Yes (for Checks 1, 2, 4, 10) | Meeting summaries, design descriptions, transcripts |
| Sibling requirements docs | Optional | Needed for Check 5 (Scope Boundary) |

**Outputs:**
- Chat summary of critical findings
- `Validation-Report-[Feature].md` — full report with Critical / Should Fix / Verify / Gaps findings

**Related skills:** `requirements-pipeline` (calls this), `review-findings` (processes this skill's report), `document-audit` (structural counterpart)

---

### document-audit

**Mode:** Pipeline Stage / Standalone

**Purpose:** Scans any document for structural problems: stale `[TBD]`, `[PENDING]`, `[UNKNOWN]` markers that are already answered elsewhere, contradictions between sections, orphaned cross-references, and notes left over from earlier drafts.

**When to use:**
- After incorporating new information or multiple rounds of editing
- As a final quality gate before sharing any document
- Called by `requirements-pipeline` at Stage 9b (after `validate-requirements`)
- After `update-documents` propagates changes (in the verify step)

**Domain-agnostic:** Works on requirements docs, PRDs, meeting notes, specs — any structured document.

**Distinct from `validate-requirements`:** This skill checks structural integrity. `validate-requirements` checks semantic accuracy.

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Document to audit | Yes | Any structured markdown document |

**Outputs:**
- Audit report with HIGH / MEDIUM / LOW confidence findings
- HIGH-confidence fixes applied automatically
- MEDIUM-confidence findings presented for user decision

**Related skills:** `requirements-pipeline` (calls this), `validate-requirements` (semantic counterpart), `review-findings` (processes this skill's report), `update-documents`

---

## Post-Pipeline Skills (Group 2)

---

### review-findings

**Mode:** Post-Pipeline

**Purpose:** Interactively walks users through findings from any audit or validation report. Reads the report file, presents each finding via structured AskQuestion dialogs, collects user decisions (fix / defer / dismiss), and produces a resolution summary.

**When to use:**
- After `validate-requirements` produces a `Validation-Report-*.md`
- After `document-audit` produces an audit report
- When you want to systematically work through findings rather than handle them ad-hoc
- When collecting decisions for later batch application via `update-documents`

**Key principle:** This skill does not re-run checks. It reads the report and presents findings — the heavy analysis was already done by the producing skill.

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Report file path | Yes | Output from `validate-requirements` or `document-audit` |

**Outputs:**
- Resolution summary with decision per finding (fix / defer / dismiss)
- Structured output ready to hand off to `update-documents`

**Related skills:** `validate-requirements` (produces input), `document-audit` (produces input), `update-documents` (consumes output)

---

### update-documents

**Mode:** Post-Pipeline

**Purpose:** Propagates a verified change (factual correction, terminology update, scope change, new information) across multiple related documents simultaneously. Shows a change manifest for user approval before touching any file.

**When to use:**
- A fact or assumption was wrong and multiple documents reference it
- Stakeholder feedback or a design review requires cascading updates
- Terminology is changing across a document set
- A feature or scope item is being added, deferred, or removed

**Change types:**
| Type | Propagation Pattern |
|------|---------------------|
| Factual correction | Any section that assumed the wrong fact |
| Terminology change | All occurrences of old term (context-aware, handles plural/possessive) |
| Scope change | Scope sections, feature lists, assumptions, success metrics |
| New information | Additive — new content in contextually correct sections |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Change description | Yes | Can be informal — the skill structures it |
| Documents to update | Yes | List of file paths |

**Outputs:**
- Change manifest (presented for user approval before any edits)
- Updated documents (edits preserve each doc's format and tone)
- `document-audit` run as a final consistency check

**Mandatory checkpoints:** Change verification (Step 2) and change manifest approval (Phase 2)

**Additional behaviors:**
- **Client-ready doc detection:** Automatically scans for a corresponding `Client-Requirements-*.md` alongside any `Feature-Requirements-*.md` in scope and adds it as the last downstream document in the change chain.
- **Intra-document consistency sweep:** When any Functional Requirement is added, modified, or removed, runs a mandatory sweep across all derived sections in the same document (User Flows, Visual States, Error Handling, Executive Summary, Assumptions, Open Questions, Dependencies, Risk Analysis) and checks Stage 4/6 artifacts if in scope.

**Related skills:** `review-findings` (produces structured decisions as input), `document-audit` (runs as final step)

---

### client-ready-requirements

**Mode:** Post-Pipeline

**Purpose:** Transforms an internal feature requirements document (produced by the requirements pipeline) into a client-safe version for all stakeholder types — business, product, UX, technology, and executive — in a single shared document. Strips internal scaffolding without changing any functional requirement content.

**When to use:**
- After the internal requirements document is complete and validated (`validate-requirements` + `document-audit` have been run)
- Before sharing a requirements document with a client or external stakeholder
- When preparing for a stakeholder review across mixed audiences (business, product, UX, technology, executive)

**What it removes or transforms:**

| Internal Content | Transformation |
|-----------------|----------------|
| `(Source: SRC-N)` citations | Removed |
| `(Source: Implicit)` markers | Removed; uncertain statements converted to [TBD] |
| Internal assumption/constraint codes (H1, D14, C9, etc.) | Removed from body text |
| Pipeline process metadata in header | Removed; Audience field updated |
| Stage artifact references in body | Removed |
| Figma node IDs | Replaced with "current app design" |
| Struck-through resolved OQ rows | Removed |
| "Contradicted" / "BLOCKER" language | Reframed as plain risk language |
| Implementation notes inside requirements | Wrapped in `> Engineering Note:` callout |
| Change history — internal validation details | Stripped to clean version table |
| Related Documents — internal stage files | Removed; external links and sister features kept |

**What it adds:**

A **Sources & Reference Materials** section at the end, listing all input documents used. Format per entry: `Display Name (Type, Day Month Year)` e.g. `(Meeting Record, January 7, 2026)` — falling back to name + type (no date) or name + date (no type) when full info is unavailable. Figma design links are placed in Related Documents, not Sources. Grouped by: Meeting Records → Discovery Sessions → Client Documents → Related Feature Documents.

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Internal requirements document | Yes | `Feature-Requirements-[Feature].md` |
| Stage 1 intake file | Yes | Maps SRC codes to readable document names and dates |

**Output:**
| File | Description |
|------|-------------|
| `Client-Requirements-[Feature].md` | Saved in same folder as input; identical structure, internal metadata removed |

**Core constraint:** Requirement statements are never changed — only citations and codes are stripped. `[TBD]` items are always preserved.

**Related skills:** `validate-requirements` and `document-audit` (run before this skill to ensure the input is accurate); `update-documents` (run first to propagate any corrections); `generate-requirements` and `requirements-pipeline` (produce the input document)


