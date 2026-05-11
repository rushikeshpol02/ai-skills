# Invocation Guide

How to install skills, how Cursor discovers them, and how to trigger each skill — explicitly by name, implicitly by context, and chained across a full pipeline.

---

## Installation

Skills in this repo work with both **Cursor** and **Claude Code**. The recommended approach is to symlink each skill folder so that `git pull` picks up updates automatically — no re-copying needed.

### Step 1: Clone the repo

```bash
git clone https://github.com/rushikeshpol02/ai-skills.git ~/ai-skills
```

### Step 2: Symlink skills into the agent's skills folder

**Cursor** — skills are discovered from `~/.cursor/skills/`:

```bash
mkdir -p ~/.cursor/skills
find ~/ai-skills/skills -mindepth 2 -maxdepth 3 -name "SKILL.md" | while read f; do
  skill=$(dirname "$f")
  ln -s "$skill" ~/.cursor/skills/$(basename "$skill")
done
```

**Claude Code** — skills are discovered from `~/.claude/skills/`:

```bash
mkdir -p ~/.claude/skills
find ~/ai-skills/skills -mindepth 2 -maxdepth 3 -name "SKILL.md" | while read f; do
  skill=$(dirname "$f")
  ln -s "$skill" ~/.claude/skills/$(basename "$skill")
done
```

**Both at once:**

```bash
mkdir -p ~/.cursor/skills ~/.claude/skills
find ~/ai-skills/skills -mindepth 2 -maxdepth 3 -name "SKILL.md" | while read f; do
  skill=$(dirname "$f")
  name=$(basename "$skill")
  ln -s "$skill" ~/.cursor/skills/"$name"
  ln -s "$skill" ~/.claude/skills/"$name"
done
```

### Step 3: Restart the agent

- **Cursor**: close and reopen. Skills load at agent startup.
- **Claude Code**: skills are discovered automatically on next invocation.

### Keeping skills up to date

```bash
cd ~/ai-skills && git pull
# Symlinks pick up changes automatically — no re-linking needed
```

---

## How Cursor Discovers Skills

Cursor's agent scans `~/.cursor/skills/` for `SKILL.md` files at startup. Each skill file has a YAML frontmatter block:

```yaml
---
name: generate-requirements
description: "Generates Feature Requirements documentation from any combination of
  inputs -- PRDs, design files/Figma URLs, meeting transcripts, or verbal descriptions.
  Focuses exclusively on requirements; API contracts and system flows are generated
  separately after requirements are finalized..."
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
| "I have rough ideas and a transcript, help me build requirements from scratch" | `requirements-pipeline` |
| "Summarize this meeting transcript" | `transcript-to-meeting-notes` |
| "Analyze this Figma link and document the flow" | `design-to-context` |
| "What are the risky assumptions for this feature?" | `identify-assumptions` |
| "Check this requirements doc for accuracy" | `validate-requirements` |
| "Audit this document for stale markers and contradictions" | `document-audit` |
| "Walk me through the findings in this validation report" | `review-findings` |
| "A decision changed — update all the docs" | `update-documents` |
| "Prepare this requirements doc for the client" | `client-ready-requirements` |
| "Create a diagram of this user flow in FigJam" | `figjam-diagram-generator` |
| "Plan this release and break it into sprints" | `release-sprint-planner` |
| "Create a sprint planning doc for this sprint" | `sprint-planning-session` |
| "What's the sprint status / how are we tracking?" | `sprint-progress-tracker` |
| "Prepare the sprint review doc" | `sprint-review-generator` |
| "Apply the decisions from today's meeting to the release plan" | `meeting-to-plan-integrator` |
| "Write an epic for this feature" | `generate-epic` |
| "Create user stories for this epic" | `generate-user-stories` |
| "Validate / fix these user stories" | `validate-user-stories` |
| "Create a UAT test plan from these tickets" | `generate-uat` |

---

## Per-Skill Trigger Prompts

### requirements-pipeline

Best for messy, early-stage inputs:

```
I want to build requirements for [Feature Name].
I have [a transcript / rough ideas / a Figma link / a legal doc / some meeting notes].
Use requirements-pipeline to walk me through the full pipeline.
```

```
Run requirements-pipeline. I'll describe the feature now: [description]
```

### generate-requirements

Best for well-defined inputs. Produces Feature Requirements only — API contracts are generated separately after requirements are finalized using `rest-api-contract-generator`:

```
Generate requirements for [Feature Name].
Quick Mode — inputs: [PRD at path] + [Figma link]
Save output to: [output folder path]
```

```
Generate requirements in Comprehensive Mode.
I have: PRD at [path], designs at [path].
Output folder: [path]
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

### client-ready-requirements

```
Use client-ready-requirements on [path to Feature-Requirements-*.md].
```

```
Prepare [requirements file path] for client review.
```

```
Create a client-ready version of [requirements file path] for stakeholder review.
```

### figjam-diagram-generator

```
Create a FigJam diagram from the user flows in [file path].
```

```
Generate a flowchart in FigJam from the requirements at [file path].
```

```
Build a sequence diagram in FigJam for [describe the interaction].
```

### release-sprint-planner

```
Plan this release. Feature list: [paste or point to file]
Team: [size / velocity]. Deadline: [date].
```

```
Define the release for [Feature Name]. I'll walk you through it.
```

```
Break this feature list into sprints: [paste list]
Timeline: [N] sprints of [N] weeks.
```

### sprint-planning-session

```
Create a sprint planning doc for Sprint [N].
Tickets: [paste list or point to release plan]
```

```
Sprint planning for Sprint [N]. Goal: [paste goal].
Here are the tickets: [list]
```

### sprint-progress-tracker

```
Sprint progress check for Sprint [N].
Planning doc: [file path]
Status: [paste verbal update or ticket statuses]
```

```
Close out Sprint [N]. Planning doc: [path]. Here's what's done: [summary]
```

### sprint-review-generator

```
Create the sprint review doc for Sprint [N].
Progress doc: [file path]
```

```
Prepare the sprint demo doc for Sprint [N]: [progress doc path]
```

### meeting-to-plan-integrator

```
Apply today's meeting decisions to the release plan.
Meeting notes: [file path or paste summary]
Release plan: [file path]
```

```
We just finished the Sprint [N] retro. Here are the decisions: [paste]
Update the release plan at [file path].
```

### generate-epic

```
Write an epic for [Feature Name].
Requirements doc: [file path]
```

```
Create an epic from this description: [paste feature description]
```

### generate-user-stories

```
Generate user stories for [Epic Name].
Epic: [file path]
```

```
Decompose [Epic Name] into story concepts first, then write full stories.
Epic: [file path]
```

```
Modify this story: [file path]
Change: [describe what needs to change]
```

### validate-user-stories

```
Validate the user stories in [folder path].
```

```
Check and fix the stories in [folder path] — run all 12 validation categories.
```

### generate-uat

```
Generate a UAT test plan from these tickets: [folder path or list]
```

```
Create a UAT plan for the [Feature Name] release.
Tickets are in: [folder path]
```

---

## Pipeline Chaining — Running the Full Pipeline in One Conversation

### Option A: Start from scratch with requirements-pipeline

This runs a multi-stage pipeline in one session. Expect mandatory checkpoints at Stages 2, 3.5b, 5, and 9 where the agent pauses for your confirmation.

```
I want to build requirements for [Feature Name] from scratch.
Here's what I have:
- Transcript: [file path]
- Design: [Figma URL or image]
- Description: [paste notes or rough ideas]

Run requirements-pipeline.
```

The agent will:
1. Lock the input set with a three-tier scoping gate, assign SRC-IDs (Stage 1a)
2. Route transcripts to `transcript-to-meeting-notes`, rate input quality (Stage 1b)
3. Present STATED vs INFERRED interpretation for confirmation — **STOP** (Stage 2)
4. Brainstorm constraints, actors, rules (Stage 3)
5. Determine if the feature needs to be split across multiple runs; lock pipeline mode (Express / Standard / Full) — **STOP** (Stage 3.5b)
6. Build scenario matrix — combinations, edge cases, boundary conditions (Stage 4 — Standard/Full only)
7. Surface risky assumptions by priority — **STOP** (Stage 5)
8. Draft user flows per actor with purity filter (Stage 6 — Standard/Full only)
9. Synthesize all stage artifacts, then generate Feature Requirements document (Stages 7a + 7b)
10. Run pre-mortem risk analysis (Stage 8)
11. Call `validate-requirements` for combined semantic + structural review — **STOP** (Stage 9)
12. Post-merge reconciliation if multi-feature split (Stage 9c)

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

Step 7 — Produce client-ready version:
"Run client-ready-requirements on [requirements file path]."
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
