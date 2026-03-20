# Skill Catalog

Deep-dive reference for every skill. Each entry covers: purpose, inputs, outputs, mode, and related skills.

---

## Table of Contents

**Pipeline Skills (Group 1)**
- [generate-detailed-requirements](#generate-detailed-requirements) — Pipeline Orchestrator
- [generate-requirements](#generate-requirements) — Pipeline Stage / Standalone
- [design-to-context](#design-to-context) — Pipeline Stage / Standalone
- [transcript-to-meeting-notes](#transcript-to-meeting-notes) — Pipeline Stage / Standalone
- [identify-assumptions](#identify-assumptions) — Pipeline Stage / Standalone
- [validate-requirements](#validate-requirements) — Pipeline Stage / Standalone
- [document-audit](#document-audit) — Pipeline Stage / Standalone

**Post-Pipeline Skills (Group 2)**
- [review-findings](#review-findings) — Post-Pipeline
- [update-documents](#update-documents) — Post-Pipeline

**Standalone Skills (Group 3)**
- [rest-api-contract-generator](#rest-api-contract-generator) — Standalone
- [jtbd-generator](#jtbd-generator) — Standalone
- [github-issue-classifier](#github-issue-classifier) — Standalone
- [generate-pm-jd](#generate-pm-jd) — Standalone

---

## Pipeline Skills (Group 1)

---

### generate-detailed-requirements

**Mode:** Pipeline Orchestrator

**Purpose:** End-to-end requirements pipeline from messy, early-stage inputs to production-ready requirements documents. Orchestrates 9 stages, calling other skills at each quality gate. Handles inputs that are too raw or contradictory for `generate-requirements` to process directly.

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
| Swagger / OpenAPI spec | Optional | Passed through to `generate-requirements` in Stage 7 |

**Outputs (saved to workspace):**
| File | Stage | Description |
|------|-------|-------------|
| `[Feature]-Scenarios-Matrix.md` | Stage 4 | All scenario combinations, edge cases, boundary conditions |
| `[Feature]-User-Flows.md` | Stage 6 | Step-by-step user flows per actor |
| `Feature-Requirements-[Feature].md` | Stage 7 | Core requirements document |
| `API-Contract-[Feature].md` | Stage 7 | Only if APIs are in scope (Comprehensive mode) |
| `System-Flow-[Feature].md` | Stage 7 | Only if integrations are in scope (Comprehensive mode) |
| `Validation-Report-[Feature].md` | Stage 9a | Semantic accuracy review findings |
| Audit report | Stage 9b | Structural integrity findings |

**Mandatory checkpoints (STOP and wait for user):** Stages 2, 5, and 9

**Skills called:**
- Stage 1: `transcript-to-meeting-notes`, `design-to-context`
- Stage 5: `identify-assumptions`
- Stage 7: `generate-requirements`
- Stage 9a: `validate-requirements`
- Stage 9b: `document-audit`

**Related skills:** All pipeline skills

---

### generate-requirements

**Mode:** Pipeline Stage / Standalone

**Purpose:** Generates production-ready Agile requirements documentation from well-defined inputs. Runs a 3-workflow sub-chain (Synthesize → Generate → Validate) and produces Feature Requirements, optionally an API Contract and System Flow.

**When to use:**
- Inputs are well-defined: clear PRD, confirmed Figma designs, and/or Swagger spec
- You need requirements generated quickly (Quick Mode: ~20 min)
- You're creating the final requirements document from already-analyzed inputs
- Called by `generate-detailed-requirements` at Stage 7

**Modes:**
| Mode | Use When | Outputs |
|------|----------|---------|
| Quick | MVP, small feature, UI-only change | Feature Requirements only (~20 min) |
| Comprehensive | Production feature with APIs or integrations | Feature Requirements + API Contract + System Flow (~45 min) |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Feature name | Yes | |
| PRD or feature description | At least one required | |
| Design files or Figma URLs | Optional | Analyzed in Workflow 1 |
| Swagger / OpenAPI spec | Optional | Triggers Comprehensive mode |
| Meeting transcript or notes | Optional | Decisions extracted in Workflow 1 |
| `project-context.md` (workspace root) | Optional | Pre-populates tech stack, personas, API conventions if present |

**Outputs (saved to `requirements/[Feature-Name]/`):**
| File | Description |
|------|-------------|
| `Context-Summary-[Feature].md` | Internal analysis artifact |
| `Feature-Requirements-[Feature].md` | Always generated |
| `API-Contract-[Feature].md` | Comprehensive mode only |
| `System-Flow-[Feature].md` | Comprehensive mode only |
| `Validation-Report-[Feature].md` | Quality gate report |

**Workflow sub-chain:** `01-synthesize.md` → `02-generate.md` → `03-validate.md`

**Related skills:** `generate-detailed-requirements` (calls this), `design-to-context`, `transcript-to-meeting-notes`, `validate-requirements`

---

### design-to-context

**Mode:** Pipeline Stage / Standalone

**Purpose:** Converts Figma URLs or design image files into structured design context documents. Supports three output formats depending on the input and intent.

**When to use:**
- You have Figma screens or design mockups and need to document them
- You want to feed design context into a requirements pipeline
- Called by `generate-detailed-requirements` at Stage 1 for design inputs

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

**Figma MCP:** If a Figma URL is provided and the Figma MCP is available, the skill calls `get_design_context` to retrieve screenshots and metadata automatically.

**Related skills:** `generate-detailed-requirements` (calls this), `generate-requirements`

---

### transcript-to-meeting-notes

**Mode:** Pipeline Stage / Standalone

**Purpose:** Converts meeting transcripts into structured discovery summaries. Adapts the internal topic structure based on meeting type (discovery/requirements vs engineering/technical) while using the same output template for both.

**When to use:**
- You have a meeting transcript and need a structured summary
- You want to extract decisions, assumptions, and open questions from a call
- Called by `generate-detailed-requirements` at Stage 1 for transcript inputs

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

**Related skills:** `generate-detailed-requirements` (calls this), `generate-requirements`, `identify-assumptions`

---

### identify-assumptions

**Mode:** Pipeline Stage / Standalone

**Purpose:** Surfaces and structures risky assumptions using multi-perspective analysis (PM, Designer, Engineer) across four risk areas (Value, Usability, Viability, Feasibility). Outputs structured assumptions with status, validation method, deadline, and risk if wrong.

**When to use:**
- Stress-testing a feature idea before writing requirements
- Preparing for stakeholder review
- Called by `generate-detailed-requirements` at Stage 5

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

**Related skills:** `generate-detailed-requirements` (calls this), `transcript-to-meeting-notes` (produces simpler assumption format that this skill enriches)

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

**Related skills:** `generate-detailed-requirements` (calls this), `review-findings` (processes this skill's report), `document-audit` (structural counterpart)

---

### document-audit

**Mode:** Pipeline Stage / Standalone

**Purpose:** Scans any document for structural problems: stale `[TBD]`, `[PENDING]`, `[UNKNOWN]` markers that are already answered elsewhere, contradictions between sections, orphaned cross-references, and notes left over from earlier drafts.

**When to use:**
- After incorporating new information or multiple rounds of editing
- As a final quality gate before sharing any document
- Called by `generate-detailed-requirements` at Stage 9b (after `validate-requirements`)
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

**Related skills:** `generate-detailed-requirements` (calls this), `validate-requirements` (semantic counterpart), `review-findings` (processes this skill's report), `update-documents`

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

**Related skills:** `review-findings` (produces structured decisions as input), `document-audit` (runs as final step)

---

## Standalone Skills (Group 3)

---

### rest-api-contract-generator

**Mode:** Standalone

**Purpose:** Generates a complete, implementation-ready REST API contract document. Optionally reviews existing codebase or Swagger files to extract your team's API patterns before generating, ensuring the contract matches your conventions.

**When to use:**
- You need a standalone API contract for a new or modified endpoint
- You want a contract that matches your existing Swagger conventions and error shapes
- You need a quick API spec without running a full requirements pipeline

**4-step workflow:**
1. Gather required context (method, path, consumer, inputs, success response, error cases)
2. Optionally review existing codebase/Swagger for team patterns
3. Generate contract applying found patterns over generic best practices
4. Mandatory quality check before delivering

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Feature purpose (plain English) | Yes | |
| HTTP method | Yes | GET / POST / PUT / PATCH / DELETE |
| Endpoint path | Yes | Or asks to propose one |
| Consumer | Yes | Frontend, mobile, another service |
| Request inputs (path params, query params, body fields) | Yes | |
| Success response definition | Yes | |
| Known error cases | Yes | |
| Existing Swagger / codebase files | Optional | Used to match team patterns |

**Outputs:**
- `API-Contract-[Feature].md` — complete contract with endpoint definition, request/response schemas, error responses, and notes

**Related skills:** `generate-requirements` (also produces API contracts in Comprehensive mode)

---

### jtbd-generator

**Mode:** Standalone

**Purpose:** Generates a structured Jobs to Be Done (JTBD) analysis following Anthony Ulwick's Outcome-Driven Innovation framework. Produces a hierarchical table (Theme → Core Job → Job Step → Desired Outcome) with MoSCoW prioritization, designed for stakeholder alignment and MVP scoping.

**When to use:**
- Defining MVP scope through user jobs (not features)
- Preparing for stakeholder review or design vision alignment
- Understanding what users are trying to accomplish before prescribing solutions
- Scoping phases of a product

**Core principle:** Jobs are solution-agnostic — describe what the user is trying to accomplish, never how the product solves it.

**Prerequisite gate:** At least one input with user context is required. Technical specs alone (database schema, infrastructure docs) do not qualify.

**Inputs:**
| Input | Minimum Quality Bar |
|-------|---------------------|
| Requirements doc / PRD | Must describe what users need to do |
| Meeting notes / transcript | Must contain discussion of user problems or workflows |
| GitHub issues / backlog | At least 5 related issues to identify patterns |
| Design files | Must show user-facing flows |
| Verbal description | Must describe at least one user and what they're trying to accomplish |

**Outputs:**
- `JTBD-Analysis-[Name].md` — hierarchical JTBD table with MoSCoW prioritization and phase summary

**Related skills:** `generate-requirements` (JTBD output can serve as input), `identify-assumptions`

---

### github-issue-classifier

**Mode:** Standalone

**Purpose:** Classifies GitHub issues (stored as local markdown files from the Github-Issue-Extractor tool) into epics, user stories, tasks, and defects. Produces two reports: a flat classification and a full milestone hierarchy.

**When to use:**
- Analyzing and categorizing a GitHub repository's issue backlog
- Building a hierarchy view for sprint planning or roadmap discussions
- Identifying which issues are epics vs stories vs tasks

**Modes:**
| Mode | Output |
|------|--------|
| Mode A — Classify All | Flat list of every non-DONE issue by type (Epic / User Story / Task / Defect) with status |
| Mode B — Hierarchy View | Full repo organized as Milestone → Epic → Story/Task → Defect |

**Prerequisite:** Issues must be extracted first using the Github-Issue-Extractor tool, which produces markdown files in `Github-Issue-Extractor/issues/<owner>-<repo>/`.

**Inputs:**
| Input | Required |
|-------|----------|
| Issue markdown files from Github-Issue-Extractor | Yes |
| Python venv (PyYAML) activated | Yes |

**Outputs:**
- `issues/<owner>-<repo>/reports/classification-YYYY-MM-DD.md` (Mode A)
- `issues/<owner>-<repo>/reports/hierarchy-YYYY-MM-DD.md` (Mode B)
- Optional: `release-candidates-*.md` for release-scoped reports

**Related skills:** None — fully standalone

---

### generate-pm-jd

**Mode:** Standalone

**Purpose:** Generates standardized Product Manager job descriptions for Robots & Pencils (R&P) client engagements. Supports four variants across two seniority levels and two PM types.

**When to use:**
- Writing a job description for a Product Manager or Product Owner role at R&P
- Customizing a PM JD for a specific client engagement

**Four variants:**
| | Traditional PM | AI Builder PM |
|--|---------------|---------------|
| **L3** | L3 Traditional PM JD | L3 AI Builder PM JD |
| **L4** | L4 Traditional PM JD | L4 AI Builder PM JD |

**Three-phase workflow:**
1. Gather context (role level, PM type, client context, engagement details)
2. Render interactive skill checklist (presented via AskQuestion)
3. Generate complete JD in markdown from selections

**Inputs:**
| Input | Required |
|-------|----------|
| Seniority level (L3 or L4) | Yes |
| PM type (Traditional or AI Builder) | Yes |
| Client / engagement context | Optional (customizes the JD) |

**Outputs:**
- Complete PM job description in markdown

**Related skills:** None — fully standalone

