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
- [figjam-diagram-generator](#figjam-diagram-generator) — Post-Pipeline

**Planning Skills (Group 3)** ⚠️ WIP
- [release-sprint-planner](#release-sprint-planner) — Standalone
- [sprint-planning-session](#sprint-planning-session) — Standalone
- [sprint-progress-tracker](#sprint-progress-tracker) — Standalone
- [sprint-review-generator](#sprint-review-generator) — Standalone
- [meeting-to-plan-integrator](#meeting-to-plan-integrator) — Standalone

**Epics & Stories Skills (Group 4)**
- [generate-epic](#generate-epic) — Standalone
- [generate-user-stories](#generate-user-stories) — Standalone
- [validate-user-stories](#validate-user-stories) — Standalone
- [generate-uat](#generate-uat) — Standalone


---

## Pipeline Skills (Group 1)

---

### requirements-pipeline

**Mode:** Pipeline Orchestrator

**Purpose:** End-to-end requirements pipeline from messy, early-stage inputs to a production-ready Feature Requirements document. Supports three modes (Express / Standard / Full), resumable runs via a state file, and inlines all sub-skill logic except two external calls. Handles inputs that are too raw or contradictory for `generate-requirements` to process directly.

**When to use:**
- Starting from rough ideas, brainstorm notes, or meeting transcripts
- Inputs are incomplete, contradictory, or need clarification
- You want a scenario matrix and multi-perspective assumption analysis before writing requirements
- The feature is complex enough to warrant stage-by-stage confirmation
- You need to resume a prior run after a session ends

**Pipeline modes:**
| Mode | Stages skipped | Use when |
|------|---------------|----------|
| Express | Stage 4 (Scenarios), Stage 6 (User Flows) | Simple feature, well-understood problem space, time-constrained |
| Standard | None | Most features — full analysis without extended exploration |
| Full | None + extended brainstorm | Complex, high-risk, or poorly-understood problem space |

Mode is determined and locked at Stage 3.5b based on complexity and size signals.

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Meeting transcripts (`.vtt`, `.md`, `.txt`, `.docx`) | Optional | Routed to `transcript-to-meeting-notes` at Stage 1a |
| Design files or Figma URLs | Optional | Read directly at Stage 1a; design-to-context logic inlined |
| PRD, feature description, or verbal idea | At least one required | Any combination works |
| Legal / policy documents | Optional | Extracted for rules and constraints |
| Swagger / OpenAPI spec | Optional | Integration points, data models, constraints. API contracts generated separately after requirements. |
| `project-context.md` (workspace root) | Optional | Pre-loads tech stack, personas, API conventions, systems, constraints, and glossary |

**Outputs (saved to `_runs/[feature-slug]-[YYYYMMDD]/stage_output/`):**
| File | Stage | Description |
|------|-------|-------------|
| `stage_output/03.5b-mode-registry.md` | Stage 3.5b | Feature decomposition, mode selection, Shared Registry |
| `stage_output/04-scenarios.md` | Stage 4 | Scenario matrix — combinations, edge cases, boundary conditions *(Standard / Full only)* |
| `stage_output/06-user-flows.md` | Stage 6 | Step-by-step user flows per actor, purity-filtered *(Standard / Full only)* |
| `stage_output/07b-feature-requirements.md` | Stage 7b | Feature Requirements document |
| `stage_output/09-validation-report.md` | Stage 9 | Combined semantic + structural validation report |
| `stage_output/09c-reconciliation.md` | Stage 9c | Post-merge reconciliation report *(multi-feature split only)* |
| `.meta/pipeline-state.json` | All | State file — tracks current task, completed stages, gate passage, run metadata |

**Mandatory gates (pipeline pauses and waits for confirmation):** Stages 2, 3.5b, 5, and 9

**External skills called:**
- Stage 1a: `transcript-to-meeting-notes` (transcript inputs only)
- Stage 9: `validate-requirements` (combined semantic + structural review)

All other sub-skill logic (`identify-assumptions`, `generate-requirements`) is inlined in stage files — no external calls.

**Resuming an interrupted run:**
Point the agent to the run folder: `_runs/[run-name]/`. The pipeline reads `current_task` from the state file and continues from the last completed task.

**Related skills:** `generate-requirements` (standalone alternative for well-defined inputs), `validate-requirements` (called at Stage 9), `transcript-to-meeting-notes` (called at Stage 1a), `design-to-context` (standalone alternative for design pre-processing), `review-findings`, `update-documents`.

---

### generate-requirements

**Mode:** Pipeline Stage / Standalone

**Purpose:** Generates a production-ready Feature Requirements document from well-defined inputs. Runs a 3-workflow sub-chain (Synthesize → Generate → Validate). Focuses exclusively on requirements; API contracts and system flows are generated separately after requirements are finalized.

**When to use:**
- Inputs are well-defined: clear PRD, confirmed Figma designs, and/or Swagger spec
- You need requirements generated quickly (Quick Mode: ~15 min)
- You're creating the final requirements document from already-analyzed inputs

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

**Workflow sub-chain:** `01-synthesize.md` → `02-generate.md` → `03-validate.md`

**Related skills:** `requirements-pipeline` (use for messy/early-stage inputs), `design-to-context`, `transcript-to-meeting-notes`, `validate-requirements`.

---

### design-to-context

**Mode:** Pipeline Stage / Standalone

**Purpose:** Converts Figma URLs or design image files into structured design context documents. Supports three output formats depending on the input and intent.

**When to use:**
- You have Figma screens or design mockups and need to document them before generating requirements
- You want to feed design context into `requirements-pipeline` or `generate-requirements`

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
- Called by `requirements-pipeline` at Stage 1a for transcript inputs (only external call for transcripts)

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
- Standalone use or as a pre-requirements step alongside `requirements-pipeline` (assumption logic is inlined in v2)

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

**Purpose:** Validates requirements documents using 15 checks across 2 dimensions: semantic accuracy (11 checks) and structural integrity (4 checks). Catches things that are factually wrong, unsourced, over-generalized, solution-prescriptive, untestable, stale, contradictory, or incomplete. Supports incremental mode for efficient re-validation after edits.

**When to use:**
- After generating requirements (as part of the pipeline at Stage 9)
- Before sharing requirements with stakeholders
- When suspecting inaccuracies or unsourced claims
- After `update-documents` propagates changes (in the verify step)
- As a periodic quality sweep

**The 15 checks:**

| # | Check | Dimension |
|---|-------|-----------|
| 1 | Source Accuracy Audit | Semantic |
| 2 | Inference Detection | Semantic |
| 3 | Requirement Purity | Semantic |
| 4 | Over-Generalization Detection | Semantic |
| 5 | Scope Boundary | Semantic |
| 6 | Testability | Semantic |
| 7 | Ambiguity Detection | Semantic |
| 8 | Assumption-Requirement Dependency | Semantic |
| 9 | Negative Path Coverage | Semantic |
| 10 | Actor Capability Check | Semantic |
| 11 | Intra-Document Consistency | Semantic |
| S1 | Staleness Detection | Structural |
| S2 | Cross-Section Contradictions | Structural |
| S3 | Cross-References | Structural |
| S4 | Completeness | Structural |

**Replaces separate `document-audit` for requirements docs.** The standalone `document-audit` skill remains available for non-requirements documents (PRDs, meeting notes, design specs).

**Modes:**
| Condition | Mode | Behavior |
|---|---|---|
| No prior report | Full | Run all 15 checks from scratch |
| Prior report provided | Incremental | Detect changes, selectively re-run, carry forward valid findings (40-60% effort reduction) |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Requirements document | Yes | The file to validate |
| Source documents folder | Yes (for Checks 1, 2, 4, 10) | Meeting summaries, design descriptions, transcripts |
| Sibling requirements docs | Optional | Needed for Check 5 (Scope Boundary) |
| Prior validation report | Optional | Enables incremental mode |

**Outputs:**
- Chat summary of critical findings
- `Validation-Report-[Feature].md` — unified report with Semantic and Structural sections, severity-grouped findings

**Related skills:** `requirements-pipeline` (calls this at Stage 9), `review-findings` (processes this skill's report), `update-documents` (calls this in verify step for requirements docs)

---

### document-audit

**Mode:** Pipeline Stage / Standalone

**Purpose:** Scans any **non-requirements** document for structural problems: stale `[TBD]`, `[PENDING]`, `[UNKNOWN]` markers that are already answered elsewhere, contradictions between sections, orphaned cross-references, and notes left over from earlier drafts.

**When to use:**
- After incorporating new information or multiple rounds of editing
- As a final quality gate before sharing any document
- After `update-documents` propagates changes (in the verify step, for non-requirements docs)

**Important:** For requirements documents (`Feature-Requirements-*`, `Client-Requirements-*`), use `validate-requirements` instead — it now includes both semantic and structural checks in a single pass. `document-audit` remains the right tool for PRDs, meeting notes, design specs, and other non-requirements documents.

**Domain-agnostic:** Works on PRDs, meeting notes, specs — any structured document except requirements docs.

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Document to audit | Yes | Any structured markdown document |

**Outputs:**
- Audit report with HIGH / MEDIUM / LOW confidence findings saved to a `reports/` folder
- HIGH-confidence fixes applied automatically
- MEDIUM-confidence findings presented for user decision
- Chat summary: file path, total count by category, top 3 findings

**Related skills:** `validate-requirements` (use for requirements docs instead), `review-findings` (processes this skill's report), `update-documents` (calls this in verify step for non-requirements docs)

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

**Purpose:** Propagates a verified change (factual correction, terminology update, scope change, new information) across multiple related documents simultaneously. Uses subagent-based execution for all document edits. Shows a change manifest for user approval before touching any file.

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
- Updated documents (edits via subagents, preserve each doc's format and tone)
- Verification: `validate-requirements` for requirements docs, `document-audit` for all others

**Run artifacts (saved to `update-workspace/`):**
- `Input-Inventory-*.md` — available/missing inputs, candidate targets
- `ChangeSet-*.md` — structured change set
- `Manifest-*.md` — full change manifest
- `RunState-*.json` — execution state for resumability

**Mandatory checkpoints:** Change set confirmation (Step 2), registry confirmation (Step 3), change manifest approval (Step 5)

**Execution model:**
- **Subagent-only edits:** All target document edits are performed by subagents, never by the main agent
- **Silent execution:** No progress narration between subagent launch and completion
- **Parallel discovery:** For 3+ documents, discovery runs via parallel read-only subagents
- **Batch execution:** Documents partitioned into dependency-ordered batches for parallel editing
- **RunState tracking:** Mandatory `T0`–`T7` todo control loop with explicit state transitions

**Related skills:** `review-findings` (produces structured decisions as input), `validate-requirements` (runs in verify step for requirements docs), `document-audit` (runs in verify step for other docs)

---

### client-ready-requirements

**Mode:** Post-Pipeline

**Purpose:** Transforms an internal feature requirements document into a structured VP/Director-ready client requirements document. Produces an 11-section output (10 sections for net-new features without a What's Changing section) with VP filter applied, deduplication across sections, and overflow content relocated to appendices.

**When to use:**
- After the internal requirements document is complete and validated
- When preparing requirements for client or senior stakeholder review
- When a focused, review-friendly version is needed that strips internal scaffolding without losing requirement fidelity

**What it produces:**
| Section | Content |
|---------|---------|
| 1. Scope | In-scope / Out-of-scope tables |
| 2. Personas | Carried from internal doc |
| 3. User Goals | Carried from internal doc |
| 4. What's Changing | Before/after comparison (existing features only) |
| 5. Flows | User flows with appendix callouts for overflow |
| 6. Functional Requirements | FR body copied verbatim, citations stripped |
| 7. Constraints & Risks | Consolidated, VP-filtered |
| 8. Open Questions | Cleaned, resolved items removed |
| 9. References | External links, sister features |
| 10–11. Appendices | Visual states, error handling tables, overflow flows |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Internal requirements document | Yes | `Feature-Requirements-[Feature].md` |

**Output:**
| File | Description |
|------|-------------|
| `Client-Requirements-[Feature].md` | Streamlined version saved in same folder as input |

**Core constraint:** FR statements are copied verbatim — no paraphrasing. Only citations and internal codes are stripped.

**Related skills:** `validate-requirements` and `document-audit` (run before this to ensure input accuracy); `update-documents` (run first to propagate any corrections); `requirements-pipeline` and `generate-requirements` (produce the input document)

---

### figjam-diagram-generator

**Mode:** Post-Pipeline

**Purpose:** Generates Mermaid.js diagrams in FigJam from requirements documents, user flows, state descriptions, or verbal input. Supports flowcharts, sequence diagrams, state diagrams, and gantt charts via the Figma MCP `generate_diagram` tool.

**When to use:**
- You want to visualize user flows, system interactions, or state machines from a requirements document
- You need a quick flowchart or sequence diagram in FigJam
- You want to turn a verbal description into a Mermaid diagram

**Supported diagram types:**
| Type | Best For |
|------|----------|
| Flowchart | User flows, decision trees, process flows |
| Sequence diagram | System-to-system interactions, API call sequences |
| State diagram | Component or feature state machines |
| Gantt chart | Timeline visualization, phased rollouts |

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Requirements doc, user flow doc, or verbal description | At least one required | Any combination works |
| FigJam file URL | Optional | If provided, uses `get_figjam` for existing context |

**Outputs:**
- Mermaid.js diagram generated in FigJam via `generate_diagram` MCP tool

**Verification:** Runs a 6-priority verification gate (accuracy, clarity, readability, completeness, conciseness, structure) before generating the diagram.

**Related skills:** `requirements-pipeline` (produces user flows and requirements that can be visualized), `generate-requirements` (produces requirements docs)

---

## Planning Skills (Group 3) ⚠️ WIP

> These skills are still being refined. Core functionality works but prompts, templates, and workflows are subject to change.

### Skill Cycle

```
One-time at release start:
  release-sprint-planner → Release-Definition.md + Release-Plan.md + Scope.md

Every sprint (repeating):
  sprint-planning-session    → Sprint-N-Planning.md
  sprint-progress-tracker    → Sprint-N-Progress.md
  sprint-review-generator    → Sprint-N-Review.md
  meeting-to-plan-integrator → updates Release-Plan.md based on feedback
```

Each skill reads the prior skill's output file — no skill depends on chat context from another skill's run.

### Output Folder Structure

All artifacts live under a single release folder in your workspace:

```
[project]/
  Product Artifacts/
    Delivery Plan/
      Releases/
        [Release-Name]/
          Release-Definition.md
          Release-Plan.md
          Scope.md
          .meta/
            constraint-registry.md
            skill-state-*.json
          Sprint-1/
            Sprint-1-Planning.md
            Sprint-1-Progress.md
            Sprint-1-Review.md
          Sprint-2/
            ...
```

### Shared Resources

The `planning/shared/` folder contains domain knowledge referenced by all 5 skills:

- **`delivery-model.md`** — Release lifecycle phases, sprint anatomy, document chain, commitment model
- **`execution-rules.md`** — Shared NON-NEGOTIABLE rules, quality criteria, self-check structure, provenance model
- **`constraint-registry-template.md`** — Template and rules for the shared constraint registry

### Build Order

If starting from scratch, skills can be used immediately in this order — each is useful on its own and the next builds on it:

1. `release-sprint-planner` — define the release first
2. `sprint-planning-session` — needed for each sprint kickoff
3. `sprint-progress-tracker` — useful from mid-sprint onward
4. `sprint-review-generator` — needed at sprint end
5. `meeting-to-plan-integrator` — needed after first sprint demo feedback

---

### release-sprint-planner

**Mode:** Standalone

**Purpose:** Defines a release — its goal, scope, timeline, team, and constraints — then produces a formal Release Definition and multi-sprint plan. Assesses context across six dimensions, collaboratively builds each section, sizes features, maps dependencies, and assigns work to sprints.

**When to use:**
- Starting a new release or major feature initiative
- You need to break a feature list into sprints with a clear goal and timeline
- You want a formal artifact the team and stakeholders can align on

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Feature list or backlog | Yes | Tickets, requirements docs, or verbal description |
| Team size and velocity | Optional | Used for sprint sizing |
| Timeline or deadline | Optional | Constrains sprint count |
| Constraints (known risks, dependencies) | Optional | |

**Outputs:**
- `Release-Definition.md` — goal, scope, team, timeline, constraints
- `Release-Plan.md` — multi-sprint breakdown with feature assignments
- `Scope.md` — in/out of scope table

**Related skills:** `sprint-planning-session` (next step after release plan), `meeting-to-plan-integrator` (updates the release plan from meeting decisions)

---

### sprint-planning-session

**Mode:** Standalone

**Purpose:** Takes a sprint's planned work (from a release plan, ticket board, or verbal list) and produces a structured Sprint Planning Session document. Groups work into logical areas, validates against the sprint goal, and defines what "done" looks like.

**When to use:**
- At the start of each sprint
- You have a ticket list and need a planning doc the team can work from

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Ticket list or release plan | Yes | Any format — normalized by the skill |
| Sprint goal | Optional | Derived if not provided |

**Outputs:**
- `Sprint-N-Planning.md` — grouped work areas, sprint goal, done criteria

**Related skills:** `release-sprint-planner` (produces the release plan used as input), `sprint-progress-tracker` (next step)

---

### sprint-progress-tracker

**Mode:** Standalone

**Purpose:** Creates a planned-vs-actual progress snapshot for mid-sprint check-ins or sprint close-out. Surfaces risks early and feeds data into sprint review.

**When to use:**
- Mid-sprint check-in
- Sprint close-out before the review

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Sprint planning doc | Yes | `Sprint-N-Planning.md` |
| Status updates | Yes | Verbal or ticket status |

**Outputs:**
- `Sprint-N-Progress.md` — planned vs actual, risks, blockers, completion percentage

**Related skills:** `sprint-planning-session` (produces input), `sprint-review-generator` (consumes output)

---

### sprint-review-generator

**Mode:** Standalone

**Purpose:** Produces a stakeholder-facing sprint review document. Answers: What did we build? Did we hit our goal? What did we learn? What's next? Serves two audiences: stakeholders (top sections) and team/PM (full detail).

**When to use:**
- After sprint close-out, before the sprint demo
- You need a shareable artifact for stakeholders

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Sprint progress doc | Yes | `Sprint-N-Progress.md` |
| Sprint planning doc | Optional | For goal comparison |

**Outputs:**
- `Sprint-N-Review.md` — what shipped, goal outcome, learnings, next steps

**Related skills:** `sprint-progress-tracker` (produces input), `meeting-to-plan-integrator` (applies decisions from the review back to the release plan)

---

### meeting-to-plan-integrator

**Mode:** Standalone

**Purpose:** Takes decisions from a meeting (sprint demo, retro, stakeholder call, team sync) and applies them to the release plan and related artifacts. The "decisions become actions" bridge.

**When to use:**
- After any meeting where decisions affect the release plan, sprint scope, or team priorities
- When feedback from a sprint review needs to cascade into the next sprint plan

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Meeting notes or summary | Yes | Any format |
| Release plan | Yes | `Release-Plan.md` |
| Related artifacts | Optional | Sprint planning docs, scope doc |

**Outputs:**
- Updated `Release-Plan.md` and related artifacts reflecting the meeting decisions

**Related skills:** `sprint-review-generator` (produces meeting input), `release-sprint-planner` (produces the release plan being updated)

---

## Epics & Stories Skills (Group 4)

---

### generate-epic

**Mode:** Standalone

**Purpose:** Creates a structured epic document from a requirements document or verbal description. Extracts business goals, success criteria, scope boundaries, and dependencies. Produces a single `Epic-[Feature].md` file ready for story decomposition.

**When to use:**
- After requirements are finalized and you're ready to move to delivery planning
- You need a single artifact that captures the business case and scope before writing stories

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Requirements document or verbal description | Yes | |
| Sprint plan or timeline | Optional | Used for milestone mapping |

**Outputs:**
- `Epic-[Feature].md` — business goal, success criteria, scope, dependencies, milestones

**Related skills:** `generate-requirements` / `requirements-pipeline` (produce the input), `generate-user-stories` (next step)

---

### generate-user-stories

**Mode:** Standalone

**Purpose:** Decomposes features into story concepts using the WAHZURT framework, then creates detailed INVEST-compliant user stories one-at-a-time with inline quality gates.

**Modes:**
| Mode | Use When |
|------|----------|
| Create (standard) | Writing stories from scratch with full INVEST validation |
| Create (quick/draft) | Fast story generation for low-stakes or exploratory work |
| Modify | Updating or improving existing stories |
| Decompose-only | Breaking down an epic into story concepts without writing full stories |

**When to use:**
- After an epic is defined and you're ready to write stories
- When you need to update or split existing stories

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Epic document or feature description | Yes | |
| Existing stories (for modify mode) | Conditional | Required for modify mode |

**Outputs:**
- Individual story files per story (format matches team convention)
- Story registry updated

**Related skills:** `generate-epic` (produces input), `validate-user-stories` (next step)

---

### validate-user-stories

**Mode:** Standalone

**Purpose:** Audits existing user stories against 12 validation categories (9 per-story + 2 cross-story + 1 practitioner readability) and fixes failures. Always builds a fresh registry from actual story files — never trusts existing registries.

**The 12 categories:**
- Per-story (9): Independent, Negotiable, Valuable, Estimable, Small, Testable, Well-formed title, Acceptance criteria present, No implementation detail in ACs
- Cross-story (2): No duplicate stories, No overlapping ACs across stories
- Readability (1): Practitioner-readable without domain expertise

**When to use:**
- After writing or importing a batch of stories
- Before sprint planning to catch quality issues early
- As a periodic story health check

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Story files (folder or list) | Yes | Any story format |

**Outputs:**
- Validation report with per-story findings
- Fixed story files for stories with resolvable failures
- Updated story registry built from actual files

**Related skills:** `generate-user-stories` (produces stories to validate), `generate-epic` (provides context for cross-story checks)

---

### generate-uat

**Mode:** Standalone

**Purpose:** Generates a client-ready UAT test plan from a release summary or ticket list. Reads GitHub issue files, extracts Acceptance Criteria, deduplicates cross-platform scenarios, and produces a requirement-pure UAT document in table format.

**When to use:**
- Before client UAT begins
- You have a set of tickets with ACs and need a structured test plan

**Inputs:**
| Input | Required | Notes |
|-------|----------|-------|
| Release summary or ticket list | Yes | GitHub issue files or manual list |
| GitHub issue folder | Optional | Local issue files extracted from GitHub |

**Outputs:**
- UAT test plan in table format — Feature, Scenario, Steps, Expected Result, Pass/Fail
- "Known Limitations" section
- "Tickets Without ACs" appendix

**Related skills:** `generate-user-stories` / `validate-user-stories` (produce the stories/ACs used as source)

