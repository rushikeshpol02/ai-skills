---
name: jtbd-generator
description: "Generates a Jobs to Be Done (JTBD) analysis from requirements documents, PRDs, meeting notes, issue trackers, or verbal descriptions. Produces a hierarchical JTBD table (Theme → Core Job → Job Step → Desired Outcome) with MoSCoW prioritization and phase summary. Based on Anthony Ulwick's Outcome-Driven Innovation framework. Use when asked to: generate JTBD, create jobs to be done, identify user jobs, map customer needs, define MVP scope from jobs, or produce an ODI analysis."
---

# JTBD Generator — Outcome-Driven Innovation Analysis

## Purpose

Generates a structured Jobs to Be Done analysis from product inputs, following Anthony Ulwick's ODI framework. Output is designed for stakeholder approval, design vision sharing, and MVP/phase scoping.

**Works on any project** — no project-specific configuration required. The skill adapts to whatever domain, personas, and inputs are provided.

**What you'll produce:**
- `JTBD-Analysis-[Name].md` — hierarchical JTBD table with phase summary

**Core principle: Jobs are solution-agnostic.** Describe what the user is trying to accomplish, never how the product solves it. Mark unknowns as [TBD].

---

## Workflow

```
SKILL.md (Intake + Generation)
  Step 0 → Prerequisites check (GATE — must pass before proceeding)
  Step 1 → Scan workspace for inputs
  Step 2 → Gather context and confirm persona(s)
  Step 3 → Extract and structure JTBDs
  Step 4 → Assign MoSCoW priority
  Step 5 → Generate output document
  Step 6 → Quality check
```

---

## Step 0: Prerequisites Check (MANDATORY GATE)

**Do NOT proceed to generation until all prerequisites pass.** This gate ensures the inputs are sufficient to produce valuable JTBDs.

### Minimum Viable Input

At least ONE of the following must be available:

| Input type | What it provides | Minimum quality bar |
|------------|-----------------|---------------------|
| Requirements doc / PRD | User goals, constraints, scope | Must describe what users need to do (not just system specs) |
| Meeting notes / transcript | Stakeholder intent, priorities, decisions | Must contain discussion of user problems or workflows |
| GitHub issues / backlog | Specific pain points, user requests | At least 5 related issues to identify patterns |
| Design files / mockups | Implied workflows and user tasks | Must show user-facing flows (not just component specs) |
| User's verbal description | Domain context, user goals | Must describe at least one user and what they're trying to accomplish |

**If the only input is a technical spec with no user context** (e.g., database schema, API spec with no consumer description, infrastructure doc), STOP and tell the user:

```
The inputs I have are technical specifications without user context.
JTBD analysis requires understanding of who the users are and what they're
trying to accomplish. Can you provide any of the following?

- Who are the end users? (role, context)
- What problems are they facing today?
- What tasks do they need to accomplish?
- Any requirements doc, PRD, or meeting notes that describe user needs?
```

### Persona Readiness

At least ONE persona must be identifiable — either:
- Explicitly stated in inputs ("the officer," "the admin," "the customer")
- Inferable from role/actor references in the documents
- Provided by the user when asked

**If no persona can be identified**, STOP and ask:
```
I can't identify who the users are from the provided inputs.
JTBD analysis is centered on a specific user's perspective.

Who is the primary user? Please describe:
- Their role
- The context they operate in
- What they're broadly trying to achieve
```

### Domain Clarity

The analysis must have enough context to distinguish meaningful jobs from generic ones.

**Check:** Can you answer these three questions from the inputs?
1. **Who** is the user? (persona)
2. **What domain** do they operate in? (industry, product area, context)
3. **What are they trying to do** at a high level? (at least one goal or problem)

If any of the three is unanswerable, ask the user for that specific missing piece.

### Prerequisites Report

After checking, report the result:

```
✅ Prerequisites Check:
- Input sufficiency: ✅ [N source(s)] with user context
- Persona readiness: ✅ [N persona(s)] identified — [list names/roles]
- Domain clarity: ✅ [domain/product area]

Ready to proceed.
```

OR

```
⚠️ Prerequisites Check:
- Input sufficiency: ✅ / ❌ [reason]
- Persona readiness: ✅ / ❌ [reason]
- Domain clarity: ✅ / ❌ [reason]

I need the following before I can generate a quality JTBD analysis:
[specific asks]
```

**Do NOT proceed past this step until all three checks pass.**

---

## Step 1: Scan for Available Inputs

Scan the workspace for relevant files. Be project-agnostic — look for common patterns:

- `*.md`, `*.pdf`, `*.docx` — PRDs, specs, meeting notes, requirements
- `issues/`, `tickets/`, `backlog/` — issue tracker exports
- `*.yaml`, `*.json`, `*.yml` — potential API specs (note: only useful if they describe user-facing behavior)
- Design files or Figma URLs referenced in chat
- Any file the user points to or has open

Report what you found:
```
📂 Found in workspace:
- [list relevant files discovered, grouped by type]
```

If the user provided inputs via chat context, acknowledge those:
```
📝 Also received in chat:
- [description of what was provided]
```

---

## Step 2: Gather Context

### 2a: Confirm Persona(s)

If personas were identified in Step 0, confirm with the user:
```
I identified these personas from the inputs:
- [Persona 1]: [brief description — role, context]
- [Persona 2]: [brief description — role, context]

Are these correct? Any to add or remove?
```

### 2b: Confirm Scope

Ask only what you don't already have:

```
To generate the JTBD analysis, I need:

1. **Scope** — What feature or product area should this analysis cover?
   (e.g., "Shift Management," "Officer Mobile App," "entire product")

2. **Input sources** — Confirm which of these I should analyze:
   [list files found + chat context]

3. **MoSCoW priority** — How should priority be assigned?
   A) I'll present unprioritized JTBDs and you assign MoSCoW (recommended)
   B) Assign priority where the inputs explicitly state it; leave the rest for me to assign
   C) Other approach — describe
```

---

## Step 3: Extract and Structure JTBDs

Read all provided inputs. For each input source, extract:

1. **What is the user trying to accomplish?** → Core Functional Job
2. **What steps do they take?** → Job Steps (use the universal job map as a lens)
3. **What does success look like at each step?** → Desired Outcomes
4. **What emotional needs exist?** → Emotional jobs (personal AND social)
5. **What do they do today without this product?** → Current Alternatives

### JTBD Hierarchy Rules

Follow this strict hierarchy — see [jtbd-framework.md](jtbd-framework.md) for detailed rules and examples:

```
Theme (broad user concern area — NOT a product module or feature area)
  └── Core Functional Job (what the user is hiring a product to do — framed from their LIFE context, not the product)
       └── Job Step (a phase within executing the core job)
            └── Desired Outcome (measurable success criteria for the step)
```

**Formatting rules for each level:**

| Level | Format | Example |
|-------|--------|---------|
| Theme | Noun phrase — a **user concern area** | Workforce Accountability |
| Core Job | "When [life situation/trigger], [persona] wants to [job]" | When a client asks about a past incident, the admin wants to reconstruct what happened at that site |
| Job Step | Verb phrase, action within the job | Determine which officers were on duty during the incident window |
| Desired Outcome | "Minimize/Increase the [metric] of [object]" | Minimize the time to identify the responsible officer |

### Solution-Agnostic Litmus Test (MANDATORY)

Apply this test to **every Core Job and Job Step** before including it in the output. If it fails, rewrite.

**The "Delete the Product" test:** If the product didn't exist, would this job still need to get done? If yes, the job is correctly framed. If the job only makes sense in the context of the product, it's a feature requirement disguised as a job.

**The "Life Context" test:** Does the Core Job's situation (`When [...]`) describe a moment in the user's *work/life*, or a moment in the *product*? It must be the former.

| Fails litmus test (solution-aware) | Passes litmus test (solution-agnostic) |
|-------------------------------------|----------------------------------------|
| "wants to find and retrieve a past report" | "wants to reconstruct past events at a site without re-gathering data from scratch" |
| "wants to ensure the request parameters are valid" | "wants to avoid wasting time on a request that won't produce useful results" |
| "wants to generate or access reports from any device" | (not a job — this is a consumption constraint; remove as a job, note as a non-functional attribute) |
| "wants to recover and try again after a system error" | (not a standalone job — this is an outcome under whatever job the user was performing; fold it in) |

### Theme Naming Rules

Themes must represent **user concern areas**, never product feature areas or system qualities. If a theme name could be a section header in your product backlog, it's wrong.

| Bad theme name (solution/feature domain) | Good theme name (user concern area) |
|------------------------------------------|-------------------------------------|
| Report History & Retrieval | Auditability & Evidence Reconstruction |
| Error Recovery & Resilience | (not a theme — non-functional constraint across all jobs) |
| Cross-Device Accessibility | (not a theme — consumption constraint across all jobs) |
| Data Scope & Accuracy | Trust in Operational Data |
| Site Tags Management | Organizational Context & Categorization |

**Rule:** If a theme describes a system quality (resilience, accessibility, performance) or a product feature (report history, search, export), it is NOT a valid theme. Either rename it to the user concern it serves, or dissolve its jobs into the themes where they naturally belong.

### Non-Functional Constraints Are Not Themes

Some requirements describe **how** the product delivers value, not **what job** the user is doing. These are constraints that apply across all jobs, not standalone themes.

Common non-functional areas that should NOT be themes:
- Cross-device / responsive access → Note as a consumption constraint in assumptions
- Error handling / resilience → Fold "retry" and "don't lose my work" outcomes into the job that was interrupted
- Performance / speed → Fold into relevant job outcomes ("Minimize the time to...")
- Accessibility → Note as a non-functional requirement

When you encounter these in the inputs, capture the *outcomes* they serve (e.g., "Minimize the effort to resubmit after a failure") as outcomes under the actual job the user was doing, not as a separate theme.

### Persona Commitment Rule

**Every identified persona must appear throughout the analysis or be consolidated.**

If two personas share the same jobs with different scope/access levels:
- **Consolidate** into one persona and note the access-level difference as a constraint in Assumptions
- Do NOT write one persona into a single theme and then abandon them

If two personas have genuinely different jobs:
- **Both must appear** in every theme where their jobs exist
- A persona appearing in only 1 of 8 themes is a red flag — either they have more jobs you haven't captured, or they should be consolidated with another persona

After drafting the full JTBD table, do a **persona coverage check**: for each persona, count how many themes they appear in. If a persona appears in fewer than half the themes, either add their missing jobs or consolidate them.

**Job Types to capture:**

| Type | Description |
|------|-------------|
| Functional | The practical task being accomplished |
| Emotional (Personal) | How the user wants to feel |
| Emotional (Social) | How the user wants to be perceived by others |

### Emotional Job Depth Rules

Emotional jobs are where JTBD analysis provides the most differentiated insight. Do not treat them as an afterthought.

**Emotional (Personal) anti-pattern — "Confidence echo":**
Do NOT mechanically add "Increase confidence that [functional outcome]" as the Personal emotional variant of every functional outcome. That's not insight, it's repetition. Real personal emotional jobs describe *specific anxieties, frustrations, or feelings of capability* that exist independently of the functional step.

| Formulaic / low-value | Genuine / high-value |
|-----------------------|---------------------|
| "Increase confidence that the data is complete" | "Reduce the dread of discovering a coverage gap after making a client commitment" |
| "Reduce the anxiety that work was lost" | "Minimize the frustration of repeating tedious selections after an unexpected failure" |

**Emotional (Social) is MANDATORY for accountability/compliance/oversight domains:**
Products where users report to others, defend decisions, or demonstrate diligence to stakeholders ALWAYS have Social emotional jobs. If the domain involves any of these patterns, you MUST capture Social jobs:

- Reporting to management or clients
- Compliance, auditing, or regulatory oversight
- Performance evaluation or accountability
- Incident investigation or post-mortems

Example Social emotional jobs:
- "Increase the perception of diligence when a client VP asks about a vacant post"
- "Minimize the likelihood of appearing uninformed during a quarterly compliance review"
- "Increase the credibility of evidence presented to resolve a client dispute"

**If the output has zero Emotional (Social) jobs in an accountability/compliance domain, the analysis is incomplete. Go back and add them.**

### Current Alternatives

For each Core Job, briefly identify what users do *today* to get the job done (before or without the product). This reveals:
- **Overserved jobs** — current workaround is adequate; low priority to digitize
- **Underserved jobs** — current workaround is painful; high value to improve

Capture this in the output as an optional "Current Alternative" column in the JTBD table. If the inputs don't describe current workflows, note it as an open question in Assumptions and ask the user.

### Universal Job Map (lens for completeness)

Use these 8 steps to check you haven't missed jobs. Not every job will have all 8:

1. **Define** — What needs to be done?
2. **Locate** — Find inputs needed
3. **Prepare** — Set up for execution
4. **Confirm** — Verify readiness
5. **Execute** — Do the core task
6. **Monitor** — Track progress
7. **Modify** — Adjust if needed
8. **Conclude** — Finish and hand off

---

## Step 4: Assign MoSCoW Priority

**Default behavior: MoSCoW is assigned by the user/stakeholder, not inferred by the AI.**

### Option A — User assigns priority (default)

Present the JTBD table WITHOUT MoSCoW values. Use a placeholder:

```markdown
| MoSCoW | Core Job | Job Step | Desired Outcome | Job Type |
|--------|----------|----------|-----------------|----------|
| _[TBD]_ | When [situation]... | [Step] | [Outcome] | Functional |
```

Then ask:
```
Here are the JTBDs I've identified. Please assign MoSCoW priority to each
Job Step (Must / Should / Could / Won't).

You can:
- Assign per Job Step (most precise)
- Assign per Core Job (all steps inherit)
- Assign per Theme (all jobs and steps inherit)
```

After the user provides priorities, fill in the MoSCoW column and generate the phase summary.

### Option B — Priority from explicit input signals

Only assign MoSCoW where the inputs **explicitly state priority**. Leave the rest as [TBD] for the user.

Explicit signals (assign only when language is unambiguous):

| Signal in inputs | MoSCoW |
|-----------------|--------|
| "required," "mandatory," "must have," "compliance," "blocker" | Must |
| "important," "expected," "should have," "needed for launch" | Should |
| "nice to have," "could have," "if time permits," "enhancement" | Could |
| "out of scope," "not now," "future," "phase 2+," "deferred" | Won't |

For any job step without an explicit signal: mark as `_[TBD — needs stakeholder input]_`.

### MoSCoW Reference

| MoSCoW | Meaning | Phase mapping |
|--------|---------|---------------|
| **Must** | Non-negotiable for MVP | MVP |
| **Should** | Important, expected in v1 | Phase 2 |
| **Could** | Desirable, can wait | Phase 3 |
| **Won't** | Out of scope for now | Deferred |

Priority lives at the **Job Step level**. A Core Job's effective priority is its highest-priority step.

---

## Step 5: Generate Output

Save the output to the workspace. Use a sensible path:
- If a `requirements/` folder exists: `requirements/[Name]/JTBD-Analysis-[Name].md`
- Otherwise: `JTBD-Analysis-[Name].md` in the workspace root or a location the user specifies

Use the template structure from [templates/jtbd-output.md](templates/jtbd-output.md).

The output has five sections:

### Section 1: Header
- Feature/product area name
- Date generated
- Personas covered
- Input sources used
- MoSCoW approach used (user-assigned / input-derived / hybrid)

### Section 2: JTBD Table (grouped by Theme)

For each Theme, produce a grouped table with a Current Alternative note:

```markdown
### Theme: [Theme Name — user concern area]

**Current Alternative:** [How users accomplish this today without the product]

| MoSCoW | Core Job | Job Step | Desired Outcome | Job Type |
|--------|----------|----------|-----------------|----------|
| Must | When [life situation], [persona] wants to [job] | [Step 1] | [Outcome 1] | Functional |
| Must | | [Step 2] | [Outcome 2] | Emotional (Personal) |
| Must | | [Step 3] | [Outcome 3] | Emotional (Social) |
| Must | When [life situation], [persona] wants to [different job] | [Step 1] | [Outcome 1] | Functional |
```

**Table rules:**
- Core Job cell merges (leave blank) when multiple steps share the same parent job
- Steps within a Core Job are ordered by the universal job map sequence (define → conclude)
- MoSCoW is assigned per Job Step row
- Related Core Jobs within a Theme are placed adjacent to each other
- Themes are ordered by their highest-priority Core Job (Must-heavy themes first)
- If MoSCoW is [TBD], sort themes alphabetically and steps by job map sequence
- Current Alternative is noted once per theme (above the table), not per row

### Section 3: Phase Summary

Only generate this section if MoSCoW has been assigned (not if all values are [TBD]).

```markdown
## Phase Summary

| Phase | MoSCoW | Themes | Unique Core Jobs | Job Steps | Description |
|-------|--------|--------|-----------------|-----------|-------------|
| MVP | Must | N | N | N | [1-line summary of what MVP enables] |
| Phase 2 | Should | N | N | N | [1-line summary of what Phase 2 adds] |
| Phase 3 | Could | N | N | N | [1-line summary of what Phase 3 adds] |
| Deferred | Won't | N | N | N | [1-line summary of what's excluded and why] |
```

**Counting rules for Phase Summary:**
- **Unique Core Jobs**: Count distinct jobs, not persona variants. If "Client Admin wants to reconstruct past events" and "Site Manager wants to reconstruct past events" are the same job with different access scope, count as 1 unique job with a note about persona variants. This prevents inflating perceived scope.
- **Themes**: Count themes that contain at least one job step at this priority level.
- **Job Steps**: Count all job step rows at this priority level (including persona variants if they exist as separate rows).

### Section 4: Non-Functional Constraints

Capture cross-cutting constraints that apply across all jobs but are NOT standalone themes (cross-device access, error resilience, performance requirements). This is where requirements that were excluded from themes go.

### Section 5: Assumptions & Open Questions

Always include this section. List assumptions made, questions needing stakeholder input, and any Core Jobs where the current alternative is unknown.

---

## Step 6: Quality Check

Before delivering, verify against this checklist. **If any check fails, fix it before presenting to the user.**

### JTBD Quality — Solution Agnosticism
- [ ] **"Delete the Product" test**: Every Core Job still makes sense if the product didn't exist
- [ ] **"Life Context" test**: Every Core Job situation describes a moment in the user's work/life, not a product interaction
- [ ] No product features, screens, buttons, APIs, or report names appear in Core Jobs, Job Steps, or Outcomes
- [ ] Every Core Job follows format: "When [life situation], [persona] wants to [job]"
- [ ] Every Desired Outcome is measurable: "Minimize/Increase the [metric] of [object]"
- [ ] Job Steps use verb phrases (user actions, not system actions)

### Theme Quality
- [ ] Every theme is named as a **user concern area**, not a feature area or system quality
- [ ] No theme name could double as a product backlog section header
- [ ] Non-functional concerns (cross-device, error handling, performance) are NOT standalone themes — their outcomes are folded into the jobs they serve
- [ ] Themes group related Core Jobs logically
- [ ] No duplicate jobs across themes

### Persona Quality
- [ ] **Persona coverage check**: Each persona appears in at least half the themes, OR is explicitly consolidated with another persona
- [ ] No persona appears in only one theme and then vanishes
- [ ] If two personas share the same job with different access scope, they are consolidated (not duplicated as separate rows)

### Emotional Job Quality
- [ ] Emotional (Personal) jobs are NOT mechanical "confidence echoes" of functional outcomes
- [ ] If the domain involves accountability, compliance, oversight, or reporting to others: Emotional (Social) jobs are present
- [ ] Emotional jobs describe specific feelings, anxieties, or perceptions — not generic confidence restatements

### Current Alternatives
- [ ] Current alternatives are captured for Core Jobs (or noted as an open question if inputs don't describe them)

### MoSCoW Quality
- [ ] MoSCoW assigned by user/stakeholder OR explicitly derived from input language
- [ ] No AI-inferred priority presented as definitive
- [ ] [TBD] used where priority is unknown
- [ ] Phase summary only present if MoSCoW is assigned
- [ ] Phase summary counts distinguish unique Core Jobs from persona variants

### Readability
- [ ] A stakeholder with no JTBD training can understand the table
- [ ] Phase summary (if present) is actionable for scope decisions
- [ ] No framework jargon left unexplained
- [ ] The "How to Read This Document" section is included

---

## Critical Rules

1. **Jobs are solution-agnostic** — Apply the "Delete the Product" and "Life Context" tests to every Core Job. Never reference features, screens, buttons, or APIs in Core Jobs, Job Steps, or Desired Outcomes
2. **Themes are user concerns, not feature areas** — If a theme name could be a backlog section header, rename it. Non-functional qualities (resilience, accessibility, performance) are never themes
3. **Commit to personas or consolidate** — Every persona must appear throughout the analysis. A persona that shows up in one theme and vanishes is a red flag. Consolidate personas that share jobs but differ only in access scope
4. **Emotional jobs require depth** — Never mechanically echo functional outcomes as "confidence" variants. For accountability/compliance domains, Emotional (Social) jobs are mandatory, not optional
5. **Capture current alternatives** — Identify what users do today without the product. This is what makes JTBD useful for prioritization. If unknown, flag it as an open question
6. **Truth over completeness** — Mark unknowns as [TBD]. Never invent jobs not supported by inputs
7. **Prerequisites are mandatory** — Never skip Step 0. Garbage in → garbage out
8. **MoSCoW is a stakeholder decision** — Do not infer priority unless inputs explicitly state it. Default to [TBD] and ask the user
9. **Confirm personas** — Always validate inferred personas before generating
10. **One output file** — Save the complete analysis as a single markdown file
11. **Stakeholder-ready language** — Avoid framework jargon in the output; keep the table self-explanatory
12. **Project-agnostic** — Do not assume any specific folder structure, tool, or project convention. Adapt to what exists

---

## Framework Reference

For detailed JTBD hierarchy rules, outcome formatting standards, and worked examples, see [jtbd-framework.md](jtbd-framework.md).
