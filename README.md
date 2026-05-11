# AI Agent Skills

A collection of agent skills for **Cursor** and **Claude Code** that automate product management, requirements engineering, and team workflows. Skills are markdown files that the AI agent reads at runtime to execute structured, multi-step tasks.

---

## What Are Agent Skills?

Agent skills are instruction files (`SKILL.md`) stored in a skills folder the agent scans at startup. When you invoke a skill — either explicitly by name or implicitly by describing a task — the agent reads the skill file and follows its step-by-step instructions. Skills can call other skills, save files to your workspace, ask you questions, and produce publication-ready documents.

---

## Repository Structure

```
ai-skills/
├── skills/                        19 skills — 14 production + 5 WIP across 3 category plugins + 3 standalone
│   ├── requirements/              Requirements plugin — 10 discovery and analysis skills
│   │   ├── requirements-pipeline/
│   │   │   ├── stages/            Stage instruction files (01-intake.md … 09-validation.md)
│   │   │   └── templates/
│   │   ├── generate-requirements/
│   │   │   ├── workflows/
│   │   │   └── templates/
│   │   ├── validate-requirements/
│   │   │   └── checks/            Semantic and structural check definitions
│   │   ├── client-ready-requirements/
│   │   ├── document-audit/
│   │   ├── review-findings/
│   │   ├── update-documents/
│   │   └── archive/               Archived versions (requirements-pipeline-v1, client-ready-requirements-generic)
│   ├── planning/                  Planning plugin — 5 delivery lifecycle skills  ⚠️ WIP
│   │   ├── release-sprint-planner/
│   │   ├── sprint-planning-session/
│   │   ├── sprint-progress-tracker/
│   │   ├── sprint-review-generator/
│   │   ├── meeting-to-plan-integrator/
│   │   └── shared/                Shared domain knowledge referenced by all planning skills
│   ├── epics-and-user-stories/    Epics & Stories plugin — 4 story lifecycle skills
│   │   ├── generate-epic/
│   │   ├── generate-user-stories/
│   │   ├── validate-user-stories/
│   │   └── generate-uat/
│   ├── design-to-context/         Standalone
│   ├── figjam-diagram-generator/  Standalone
│   └── transcript-to-meeting-notes/  Standalone
└── docs/
    ├── workflow-guide.md          How skills relate to each other + pipeline diagram
    ├── skill-catalog.md           Per-skill reference: inputs, outputs, mode, related skills
    └── invocation-guide.md        How to install and invoke each skill
```

Planning skills marked **⚠️ WIP** are still being refined and may change. All skills use the same `SKILL.md` format and work with both Cursor and Claude Code. The `archive/` folder holds deprecated versions and is not symlinked during install.

---

## Prerequisites

- Cursor or Claude Code installed and running
- `git` available in your terminal (`git --version` to check)
- macOS or Linux (or WSL on Windows)

---

## Installation

**Step 1 — Clone the repo**

```bash
git clone https://github.com/rushikeshpol02/ai-skills.git ~/ai-skills
```

**Step 2 — Run the install script**

```bash
bash ~/ai-skills/install.sh
```

The script will ask whether you want to install for Cursor, Claude Code, or both. It handles everything — creates the skills folders, symlinks each skill, and prints a summary of what was installed.

You can also pass a flag to skip the prompt:

```bash
bash ~/ai-skills/install.sh --cursor   # Cursor only
bash ~/ai-skills/install.sh --claude   # Claude Code only
bash ~/ai-skills/install.sh --both     # both at once
```

**Step 3 — Restart your agent**

- **Cursor**: close and reopen. Skills are loaded at startup.
- **Claude Code**: skills are discovered automatically on next invocation.

**Keeping skills up to date:**

```bash
cd ~/ai-skills && git pull
# Symlinks pick up changes automatically — no re-linking needed
```

**Verify your install:**

```bash
ls ~/.cursor/skills/    # Cursor
ls ~/.claude/skills/    # Claude Code
```

---

## Skills at a Glance

### Epics & User Stories Skills

| Skill | One-liner | Mode |
|-------|-----------|------|
| [generate-epic](skills/epics-and-user-stories/generate-epic/SKILL.md) | Create a structured epic document from requirements or a verbal description; produces Epic-[Feature].md ready for story decomposition | Standalone |
| [generate-user-stories](skills/epics-and-user-stories/generate-user-stories/SKILL.md) | Decompose features using WAHZURT framework and generate INVEST-compliant user stories one-at-a-time with quality gates; supports create, quick/draft, modify, and decompose-only modes | Standalone |
| [validate-user-stories](skills/epics-and-user-stories/validate-user-stories/SKILL.md) | Audit existing user stories against 12 validation categories (9 per-story + 2 cross-story + 1 readability) and fix failures; always builds a fresh registry from actual files | Standalone |
| [generate-uat](skills/epics-and-user-stories/generate-uat/SKILL.md) | Generate a client-ready UAT test plan from GitHub issue files or a ticket list; extracts ACs, deduplicates cross-platform scenarios, and produces a requirement-pure test document | Standalone |

### Planning Skills ⚠️ Work in Progress

> These skills are still being refined. Core functionality works but prompts, templates, and workflows are subject to change.

| Skill | One-liner | Mode |
|-------|-----------|------|
| [release-sprint-planner](skills/planning/release-sprint-planner/SKILL.md) | Define a release goal, scope, and timeline; produce a formal Release Definition and multi-sprint plan | Standalone |
| [sprint-planning-session](skills/planning/sprint-planning-session/SKILL.md) | Turn a ticket list into a structured sprint planning document with goal, grouped work, and done criteria | Standalone |
| [sprint-progress-tracker](skills/planning/sprint-progress-tracker/SKILL.md) | Generate a mid-sprint or close-out progress snapshot showing planned vs actual and surfacing risks | Standalone |
| [sprint-review-generator](skills/planning/sprint-review-generator/SKILL.md) | Produce a stakeholder-facing sprint review document covering what was built, goal outcome, and next steps | Standalone |
| [meeting-to-plan-integrator](skills/planning/meeting-to-plan-integrator/SKILL.md) | Apply decisions from a sprint demo, retro, or stakeholder call back to the release plan and artifacts | Standalone |

### Requirements Pipeline Skills

| Skill | One-liner | Mode |
|-------|-----------|------|
| [requirements-pipeline](skills/requirements/requirements-pipeline/SKILL.md) | Multi-stage discovery and analysis pipeline — Express / Standard / Full modes; resumable runs via state file; takes messy inputs to production-ready docs | Pipeline Orchestrator |
| [generate-requirements](skills/requirements/generate-requirements/SKILL.md) | Generate Feature Requirements from well-defined inputs; API contracts generated separately using `rest-api-contract-generator` | Pipeline Stage / Standalone |
| [design-to-context](skills/design-to-context/SKILL.md) | Convert Figma URLs or design images into User Flow Docs, Design Descriptions, or Context Summaries | Pipeline Stage / Standalone |
| [transcript-to-meeting-notes](skills/transcript-to-meeting-notes/SKILL.md) | Turn meeting transcripts (.vtt, .md, .docx, .txt) into structured discovery summaries | Pipeline Stage / Standalone |
| [identify-assumptions](skills/requirements/identify-assumptions/SKILL.md) | Surface and structure risky assumptions using PM / Designer / Engineer perspectives | Pipeline Stage / Standalone |
| [validate-requirements](skills/requirements/validate-requirements/SKILL.md) | Combined semantic + structural review with 15 checks; supports incremental mode for re-validation | Pipeline Stage / Standalone |
| [document-audit](skills/requirements/document-audit/SKILL.md) | Scan any non-requirements document for stale markers, contradictions, and broken cross-references | Pipeline Stage / Standalone |

### Post-Pipeline Skills

| Skill | One-liner | Mode |
|-------|-----------|------|
| [review-findings](skills/requirements/review-findings/SKILL.md) | Walk through audit or validation report findings interactively and collect decisions | Post-Pipeline |
| [update-documents](skills/requirements/update-documents/SKILL.md) | Propagate a change (fact, scope, terminology) across multiple related documents with subagent execution | Post-Pipeline |
| [client-ready-requirements](skills/requirements/client-ready-requirements/SKILL.md) | Transform an internal requirements doc into a structured client-ready format — 11-section output with VP filter, dedup, and appendix creation | Post-Pipeline |
| [figjam-diagram-generator](skills/figjam-diagram-generator/SKILL.md) | Generate Mermaid.js diagrams in FigJam from requirements, user flows, or verbal input via Figma MCP | Post-Pipeline |

> **Figma MCP required** — `design-to-context` and `figjam-diagram-generator` require the Figma MCP server to be connected. In Cursor: Settings → MCP → Add Figma. In Claude Code: configure in `~/.claude/mcp.json`. Without it, Figma URL inputs will not resolve.

---

## Documentation

- **[Workflow Guide](docs/workflow-guide.md)** — How the pipeline skills fit together, when to use the full pipeline vs a single skill, and mermaid diagrams of every relationship.
- **[Skill Catalog](docs/skill-catalog.md)** — Deep-dive reference for every skill: inputs, outputs, files produced, and related skills.
- **[Invocation Guide](docs/invocation-guide.md)** — How to trigger skills by name, by context, and how to chain the full pipeline in one conversation.

---

## Contributing

Skills are organized into category plugins:

- **`skills/epics-and-user-stories/`** — story lifecycle skills (epics, user stories, UAT)
- **`skills/planning/`** — delivery lifecycle skills (sprint planning, release planning, reviews)
- **`skills/requirements/`** — requirements and analysis skills (pipeline, validation, transformation)
- **`skills/`** (root) — standalone cross-cutting skills (`design-to-context`, `figjam-diagram-generator`, `transcript-to-meeting-notes`)

To add a new skill:
1. Place it in the appropriate category folder: `skills/<category>/<skill-name>/`
2. Add a `SKILL.md` — the agent reads this file at runtime
3. Update [docs/skill-catalog.md](docs/skill-catalog.md) with the new entry

Planning skills marked **⚠️ WIP** are still being refined. All other skills are production-ready. Work-in-progress or personal skills should live outside this repo (e.g., `~/personal-skills/wip/`) and be symlinked separately — this keeps the repo clean.
