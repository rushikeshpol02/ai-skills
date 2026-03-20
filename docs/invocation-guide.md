# Invocation Guide

How to install skills, how Cursor discovers them, and how to trigger each skill — explicitly by name, implicitly by context, and chained across a full pipeline.

---

## Installation

### Step 1: Clone the repo

```bash
git clone https://github.com/<your-username>/ai-skills.git ~/ai-skills
```

### Step 2: Copy skills into Cursor's skills folder

```bash
# Product & requirements skills
cp -r ~/ai-skills/cursor/skills/* ~/.cursor/skills/

# Cursor meta-skills
cp -r ~/ai-skills/cursor/skills-cursor/* ~/.cursor/skills-cursor/
```

> If `~/.cursor/skills/` does not exist yet, create it first: `mkdir -p ~/.cursor/skills`

### Step 3: Restart Cursor

Close and reopen Cursor. Skills are loaded at agent startup — no other configuration is required.

### Keeping skills up to date

```bash
cd ~/ai-skills
git pull

# Re-copy updated skills
cp -r cursor/skills/* ~/.cursor/skills/
cp -r cursor/skills-cursor/* ~/.cursor/skills-cursor/
```

---

## How Cursor Discovers Skills

Cursor's agent scans `~/.cursor/skills/` for `SKILL.md` files at startup. Each skill file has a YAML frontmatter block:

```yaml
---
name: generate-requirements
description: "Generates complete Agile requirements documentation from any combination
  of inputs — PRDs, design files/Figma URLs, Swagger/OpenAPI specs, meeting transcripts,
  or verbal descriptions..."
---
```

The `description` field is the primary signal Cursor uses for **implicit auto-detection**. When your message resembles the description, Cursor reads the matching `SKILL.md` and follows its instructions.

You can also **explicitly invoke any skill by name** — which always works regardless of context.

---

## Explicit Invocation (by Name)

The most reliable way to invoke a skill. Mention the skill name and describe what you want:

```
Use the generate-requirements skill to build requirements from [this PRD / this Figma link / ...]
```

```
Run the transcript-to-meeting-notes skill on this file: [path]
```

```
Use identify-assumptions on the feature described in [file]
```

```
Run validate-requirements on [file path]
```

The agent will read the corresponding `SKILL.md` and follow its step-by-step instructions.

---

## Implicit Invocation (by Context)

Cursor auto-detects skills from the content of your message. You do not need to name the skill explicitly — just describe what you want naturally:

| What you say | Skill triggered |
|-------------|----------------|
| "Generate requirements for this feature" | `generate-requirements` |
| "I have rough ideas and a transcript, help me build requirements from scratch" | `generate-detailed-requirements` |
| "Summarize this meeting transcript" | `transcript-to-meeting-notes` |
| "Analyze this Figma link and document the flow" | `design-to-context` |
| "What are the risky assumptions for this feature?" | `identify-assumptions` |
| "Check this requirements doc for accuracy" | `validate-requirements` |
| "Audit this document for stale markers and contradictions" | `document-audit` |
| "Walk me through the findings in this validation report" | `review-findings` |
| "A decision changed — update all the docs" | `update-documents` |
| "Generate an API contract for this endpoint" | `rest-api-contract-generator` |
| "Create a Jobs to Be Done analysis" | `jtbd-generator` |
| "Classify these GitHub issues into epics and stories" | `github-issue-classifier` |
| "Write a PM job description for an L3" | `generate-pm-jd` |
| "Help me create a new skill" | `create-skill` |

---

## Per-Skill Trigger Prompts

### generate-detailed-requirements

Best for messy, early-stage inputs:

```
I want to build requirements for [Feature Name].
I have [a transcript / rough ideas / a Figma link / a legal doc / some meeting notes].
Use generate-detailed-requirements to walk me through the full pipeline.
```

```
Run generate-detailed-requirements. I'll describe the feature now: [description]
```

### generate-requirements

Best for well-defined inputs:

```
Generate requirements for [Feature Name].
Quick Mode — inputs: [PRD at path] + [Figma link]
```

```
Generate requirements in Comprehensive Mode.
I have: PRD at [path], Swagger at [path], designs at [path].
```

```
Create a Feature Requirements doc for [Feature Name].
Here's the description: [paste description]
```

### design-to-context

```
Analyze this Figma link and produce a User Flow Document: [URL]
```

```
Document this screen from the attached image. Output format: Design Description.
```

```
I have 5 design screenshots. Produce a Context Summary to feed into requirements generation.
[attach images]
```

### transcript-to-meeting-notes

```
Summarize this meeting transcript: [file path]
```

```
Convert this transcript to meeting notes: [file path or paste content]
```

```
Process this engineering sync transcript and extract decisions and open questions.
[file path]
```

### identify-assumptions

```
What are the risky assumptions for [Feature Name]?
Context: [paste feature description or point to a file]
```

```
Run identify-assumptions on [requirements file path].
```

```
Stress-test this feature from a PM, designer, and engineer perspective.
[paste feature description]
```

### validate-requirements

```
Validate [file path] against these source documents: [folder path]
```

```
Run validate-requirements on [requirements file path].
Source documents are in [folder path].
```

```
Check this requirements doc for accuracy issues before I share it with stakeholders.
[file path]
```

### document-audit

```
Audit [file path] for stale markers and contradictions.
```

```
Run a document audit on [file path].
```

```
Final quality check before I share this doc — run document-audit on [file path].
```

### review-findings

```
Walk me through the findings in [Validation-Report-*.md path].
```

```
Review the audit findings at [file path] and help me decide what to fix.
```

```
Run review-findings on [report file path].
```

### update-documents

```
A decision changed: [describe the change].
These docs reference it: [list file paths].
Update them all.
```

```
The term "[old term]" is now called "[new term]" everywhere.
Update all documents in [folder path].
```

```
New information from the design review: [describe what changed].
Propagate it across: [list docs].
```

### rest-api-contract-generator

```
Generate an API contract for a [GET/POST/PUT/DELETE] endpoint that [does X].
Consumer: [frontend / mobile / service].
```

```
Create an API contract for [endpoint path].
Here are the inputs and expected response: [describe].
I want you to review our existing Swagger first: [file path]
```

### jtbd-generator

```
Generate a Jobs to Be Done analysis for [Feature/Product Name].
Context: [point to PRD / meeting notes / describe the feature]
```

```
Create a JTBD with MoSCoW prioritization for [Feature Name].
Inputs: [file paths or description]
```

### github-issue-classifier

```
Classify all issues in Github-Issue-Extractor/issues/[owner]-[repo]/.
Use Mode A (flat classification).
```

```
Build a hierarchy view for Github-Issue-Extractor/issues/[owner]-[repo]/.
Mode B — organize by milestone → epic → story/task.
```

### generate-pm-jd

```
Write a PM job description for an L3 Traditional PM for a [client type] engagement.
```

```
Create a PM JD for an L4 AI Builder PM.
```

```
Generate a PM job posting. I'll answer your questions.
```

---

## Pipeline Chaining — Running the Full Pipeline in One Conversation

### Option A: Start from scratch with generate-detailed-requirements

This runs all 9 stages in one session. Expect multiple checkpoints where the agent will pause and ask for your input.

```
I want to build requirements for [Feature Name] from scratch.
Here's what I have:
- Transcript: [file path]
- Design: [Figma URL or image]
- Description: [paste notes or rough ideas]

Run generate-detailed-requirements.
```

The agent will:
1. Pre-process the transcript and design (Stages 1)
2. Present its understanding for your confirmation (Stage 2 — STOP)
3. Map variables, constraints, actors (Stage 3)
4. Build a scenario matrix (Stage 4)
5. Run assumption analysis and present for confirmation (Stage 5 — STOP)
6. Draft user flows with purity filter (Stage 6)
7. Generate requirements documents (Stage 7)
8. Run risk analysis (Stage 8)
9. Validate and audit the output (Stages 9a + 9b — STOP)

### Option B: Pre-process inputs first, then generate

If you want more control, pre-process inputs separately before generating requirements:

```
Step 1 — Summarize the transcript:
"Summarize this transcript: [file path]"

Step 2 — Document the designs:
"Analyze this Figma link and produce a Context Summary: [URL]"

Step 3 — Generate requirements from the outputs:
"Generate requirements for [Feature Name] in Comprehensive Mode.
Inputs: [transcript summary path] + [Context Summary path]"

Step 4 — Validate:
"Validate [requirements file path] against [sources folder path]"

Step 5 — Review findings:
"Walk me through the validation report: [report path]"

Step 6 — Apply fixes:
"Update the requirements doc at [path] based on these decisions: [summary of decisions]"
```

### Option C: Quick turnaround (well-defined inputs)

```
Generate requirements for [Feature Name]. Quick Mode.
PRD: [paste or point to file]
Designs: [Figma URL]
```

Then after generation:

```
Validate the generated requirements: [file path]
Source docs folder: [folder path]
```

---

## Tips

**Save artifacts at every stage.** Skills save files to your workspace automatically. If a session gets long, you can resume by pointing to the saved files rather than starting over.

**Point to files rather than pasting content.** Skills use `Read` and `Glob` to scan files directly. Saying "use the file at [path]" is more reliable than pasting large blocks of content.

**Use `project-context.md` to avoid repeating yourself.** If you run `generate-requirements` on a project repeatedly, keep a `project-context.md` in the workspace root. The skill pre-loads your tech stack, personas, and API conventions automatically.

**Checkpoints are mandatory — don't skip them.** The pipeline has mandatory STOP points where the agent waits for your confirmation before proceeding. These catch misunderstandings early and save significant rework.

**`[TBD]` is intentional.** Skills never fabricate business rules, thresholds, or field names. When something is unknown, it is marked `[TBD]` so you can fill it in — this is by design.
