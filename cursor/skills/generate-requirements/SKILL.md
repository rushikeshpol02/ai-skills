---
name: generate-requirements
description: "Generates complete Agile requirements documentation from any combination of inputs — PRDs, design files/Figma URLs, Swagger/OpenAPI specs, meeting transcripts, or verbal descriptions. Produces Feature Requirements, API Contract (if APIs involved), and System Flow (if integrations involved). Runs in Quick mode for MVPs/small features (1 doc, ~20 min) or Comprehensive mode for production/API work (2-3 docs, ~45 min). Use when asked to: generate requirements, write a feature spec, create a PRD, document a feature, analyze designs for requirements, or produce an API contract from a PRD."
---

# Generate Requirements — Entry Orchestrator

## 🎯 Purpose

This skill generates production-ready Agile requirements documentation from messy inputs.
It orchestrates three sequential workflows, each saved as a file, so context survives across long sessions.

**What you'll get:**
- `Context-Summary-[Feature].md` — internal analysis artifact (saved to workspace)
- `Feature-Requirements-[Feature].md` — always generated
- `API-Contract-[Feature].md` — if APIs are in scope (Comprehensive mode)
- `System-Flow-[Feature].md` — if integrations are in scope (Comprehensive mode)
- `Validation-Report-[Feature].md` — quality gate report

**Core principle: Truth over completeness.** Mark unknowns as [TBD]. Never fabricate data.

---

## 🔄 Workflow Chain

This skill chains three workflows in sequence:

```
[You are here]
SKILL.md (Intake)
     ↓ reads
workflows/01-synthesize.md     → saves Context-Summary-[Feature].md
     ↓ reads
workflows/02-generate.md       → saves requirement doc(s)
     ↓ reads
workflows/03-validate.md       → saves Validation-Report-[Feature].md
```

Each workflow file is read in turn. Do NOT skip ahead.

---

## 📥 Step 1: Scan Workspace for Available Inputs

Before asking the user anything, scan the workspace folder for relevant files:

```bash
ls [workspace]
ls [workspace]/requirements/   # check for existing project context and prior sessions
```

Look for:
- `project-context.md` — **project-level context file** (pre-populates most questions if present)
- `requirements/*/Context-Summary-*.md` — prior session summaries (useful for resume)
- `*.md`, `*.pdf`, `*.docx` — likely PRDs or specs
- `*.yaml`, `*.json`, `*.yml` — likely Swagger/OpenAPI specs
- `*.png`, `*.jpg`, `*.figma` — likely design files
- `*transcript*`, `*notes*`, `*meeting*` — likely transcripts

Report what you found:
```
📂 Found in workspace:
- project-context.md: ✅ Found — project memory loaded / ❌ Not found
- [other files found]
```

---

## 🗂️ Step 1.5: Load Project Context (IF project-context.md exists)

**IF `project-context.md` is found in the workspace root:**

1. Read the file completely
2. Extract and cache internally:
   - Tech stack (frontend, backend, DB)
   - API conventions (auth, naming, error shape, pagination)
   - Defined personas (names, roles, pain points)
   - System components and integrations
   - Compliance baseline
   - Browser/device support
   - Project-wide out-of-scope items
   - Glossary

3. Announce what was loaded:
```
✅ Project context loaded from project-context.md
   I already know:
   - Stack: [Frontend] + [Backend] + [DB]
   - Auth: [method]
   - Personas: [Persona 1 name], [Persona 2 name]
   - Integrations: [count] pre-defined

   I only need feature-specific information.
```

**This context is automatically applied to Workflow 1 (Synthesis) and pre-populates:**
- Technical Context (stack, conventions, integrations)
- Persona Context (uses existing personas; new ones flagged for update)
- Compliance Context (uses baseline; overrides noted per feature)

**IF `project-context.md` is NOT found:**

Proceed to Step 2 as normal. After the session completes, offer:
```
💡 This is the first time I've run on this project. Want me to create a
   project-context.md file from what I learned? This will save time on
   future features.
```

---

## 📋 Step 2: Gather Required Context

**IF project-context.md was loaded**, ask only what's missing:

```
I have your project context. For this feature, I need:

1. **Feature name** — What is this feature called?

2. **Feature-specific inputs** — Do you have any of these for this feature?
   - [ ] PRD or feature description
   - [ ] Design files (Figma URL or images)
   - [ ] Swagger changes / new endpoints
   - [ ] Meeting transcript or notes
   - [ ] Just your description in this chat

3. **New or existing feature?**
   - A) New feature (greenfield)
   - B) Modifying an existing feature

4. **Scope?**
   - A) Quick Mode — MVP/small change (1 doc)
   - B) Comprehensive Mode — production/API changes (2-3 docs)
   - C) Suggest based on inputs
```

**IF project-context.md was NOT loaded**, ask the full set:

```
To generate requirements, I need a few details:

1. **Feature name** — What is this feature called?

2. **Inputs available** — Which of these do you have?
   - [ ] PRD or feature description document
   - [ ] Design files (Figma URL or images)
   - [ ] Swagger/OpenAPI specification
   - [ ] Meeting transcript or notes
   - [ ] Just your description in this chat

3. **New or existing feature?**
   - A) New feature (greenfield)
   - B) Modifying an existing feature

4. **Scope?**
   - A) Quick Mode — MVP/prototype/internal tool (1 doc, ~20 min)
   - B) Comprehensive Mode — production/API changes/integrations (2-3 docs, ~45 min)
   - C) Not sure — I'll suggest based on your inputs
```

**Mode inference (if user selects C):**
- Swagger provided + "modify/enhance/update" → Comprehensive
- API endpoints mentioned → Comprehensive
- Simple UI-only feature, no APIs → Quick
- Production deadline / external integration → Comprehensive
- State recommendation: "Based on your inputs, I recommend [Mode] because [reason]. Confirm?"

---

## ⚡ Step 3: Pre-Flight Checks

Before starting synthesis, confirm:

| Check | Source | Action if missing |
|-------|--------|-------------------|
| Feature name captured | User input | Required — ask |
| At least 1 input source | User input or workspace scan | Required — verbal description qualifies |
| Mode determined | Inferred or confirmed | Required — infer or ask |
| Project context loaded? | project-context.md | If found: pre-populated. If not: proceed without it |
| Design files provided? | Workspace or user | Note: "I'll analyze designs in Workflow 1" |
| Transcript provided? | Workspace or user | Note: "I'll extract decisions from transcript in Workflow 1" |
| Swagger + "modify" keywords? | User input | Note: "Step 0.5 (verify existing) will run in Workflow 1" |

**Output folder:**
```
requirements/[Feature-Name]/
```
All generated files go here. The project-context.md stays in the workspace root (not inside the feature folder).

---

## 🚀 Step 4: Start Synthesis Workflow

Once intake is complete, confirm what you have and what's pre-loaded:

```
✅ Ready to start.

Feature: [name]
Mode: [Quick / Comprehensive]
Inputs: [list]
Project context: ✅ Loaded ([N] contexts pre-populated) / ❌ Not found (starting fresh)
Output folder: requirements/[feature-name]/

Starting Workflow 1: Context Synthesis...
```

Pass the following to Workflow 1:
- Feature name
- Mode (Quick / Comprehensive)
- Input sources list
- Project context (if loaded) — mark which contexts are pre-populated vs need feature-specific input
- Whether "verify existing" (Step 0.5) should run

Then **read the file:**
```
workflows/01-synthesize.md
```

Follow that file's instructions completely from start to finish.

---

## 🚨 Critical Rules for This Skill

1. **Never skip steps** — The three workflows must run in order
2. **Always save files** — Every output is saved to the workspace, not just shown in chat
3. **Mark TBDs honestly** — Never invent business rules, performance targets, or field names
4. **Wait at checkpoints** — After each workflow, STOP and wait for user approval before continuing
5. **One skill at a time** — Complete each workflow file fully before reading the next
6. **Respect existing patterns** — If Swagger is provided, follow its naming and error conventions

---

## 📎 Related Skills (Complementary)

These existing skills can assist with specific inputs before running this workflow:

| Situation | Skill to suggest |
|-----------|-----------------|
| User has a meeting recording or .vtt transcript | `transcript-to-meeting-notes` — process first, use output as PRD input |
| User has Figma URL or design screenshots | Design analysis is built into this skill's Workflow 1 |
| User only needs a standalone API contract | `rest-api-contract-generator` — use directly instead of this skill |

---

---

## 🔄 After All Workflows Complete: Update Project Context

When Workflow 3 (Validation) finishes, check if `project-context.md` needs updating:

**IF project-context.md existed and new information was discovered:**
```
💡 I learned some new things during this session that aren't in your project-context.md:
- [New integration found: System X]
- [New persona identified: Role Y]
- [Existing API convention clarified: error shape updated]

Want me to update project-context.md with these? (yes / no / review first)
```

**IF project-context.md did NOT exist:**
```
💡 Want me to create a project-context.md from what I learned in this session?
   It will save time on future features by pre-loading your stack, personas,
   API conventions, and integrations automatically.

   I'll create it from: tech stack, API conventions, personas, system components,
   compliance baseline, and browser/device support found during synthesis.

   (yes / no)
```

If user says yes: generate `project-context.md` in the workspace root using `templates/project-context.md` as structure, populated with everything learned this session.

---

**INTAKE COMPLETE → Read `workflows/01-synthesize.md` to begin**
