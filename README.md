# AI Agent Skills

A collection of agent skills for **Cursor** and **Claude Code** that automate product management, requirements engineering, and team workflows. Skills are markdown files that the AI agent reads at runtime to execute structured, multi-step tasks.

---

## What Are Agent Skills?

Agent skills are instruction files (`SKILL.md`) stored in a skills folder the agent scans at startup. When you invoke a skill — either explicitly by name or implicitly by describing a task — the agent reads the skill file and follows its step-by-step instructions. Skills can call other skills, save files to your workspace, ask you questions, and produce publication-ready documents.

---

## Repository Structure

```
ai-skills/
├── cursor/
│   └── skills/              12 production skills (Cursor + Claude Code compatible)
│       ├── requirements-pipeline/
│       │   └── stages/      Stage instruction files (e.g., 01-intake.md)
│       ├── generate-requirements/
│       │   ├── workflows/   Workflow instruction files
│       │   └── archive/     Archived templates (moved to dedicated skills)
│       ├── validate-requirements/
│       │   └── checks/      Semantic and structural check definitions
│       └── ...
├── skill-eval/              Skill evaluation utilities
└── docs/
    ├── workflow-guide.md    How skills relate to each other + pipeline diagram
    ├── skill-catalog.md     Per-skill reference: inputs, outputs, mode, related skills
    └── invocation-guide.md  How to install and invoke each skill
```

All 12 skills in `cursor/skills/` work with both Cursor and Claude Code — they share the same `SKILL.md` format.

---

## Installation

### Cursor

Skills live in `~/.cursor/skills/`. The recommended approach is to symlink each skill so that a `git pull` automatically picks up changes without re-linking.

```bash
# Clone the repo (if you haven't already)
git clone https://github.com/rushikeshpol02/ai-skills.git ~/ai-skills

# Create the skills folder if it doesn't exist
mkdir -p ~/.cursor/skills

# Symlink each skill
for skill in ~/ai-skills/cursor/skills/*/; do
  ln -s "$skill" ~/.cursor/skills/$(basename "$skill")
done
```

Restart Cursor. Skills are loaded at agent startup — no other configuration required.

**Keeping skills up to date:**

```bash
cd ~/ai-skills && git pull
# Symlinks pick up changes automatically — no re-linking needed
```

---

### Claude Code

Skills live in `~/.claude/skills/`. Same symlink approach:

```bash
# Create the skills folder if it doesn't exist
mkdir -p ~/.claude/skills

# Symlink each skill
for skill in ~/ai-skills/cursor/skills/*/; do
  ln -s "$skill" ~/.claude/skills/$(basename "$skill")
done
```

Skills are discovered automatically by Claude Code at startup.

---

### Install for Both at Once

```bash
git clone https://github.com/rushikeshpol02/ai-skills.git ~/ai-skills
mkdir -p ~/.cursor/skills ~/.claude/skills

for skill in ~/ai-skills/cursor/skills/*/; do
  name=$(basename "$skill")
  ln -s "$skill" ~/.cursor/skills/"$name"
  ln -s "$skill" ~/.claude/skills/"$name"
done
```

---

## Skills at a Glance

### Pipeline Skills

| Skill | One-liner | Mode |
|-------|-----------|------|
| [requirements-pipeline](cursor/skills/requirements-pipeline/SKILL.md) | 9-stage discovery and analysis pipeline from messy inputs to production-ready docs; supports multi-feature decomposition | Pipeline Orchestrator |
| [generate-requirements](cursor/skills/generate-requirements/SKILL.md) | Generate Feature Requirements from well-defined inputs; API contracts generated separately using `rest-api-contract-generator` | Pipeline Stage / Standalone |
| [design-to-context](cursor/skills/design-to-context/SKILL.md) | Convert Figma URLs or design images into User Flow Docs, Design Descriptions, or Context Summaries | Pipeline Stage / Standalone |
| [transcript-to-meeting-notes](cursor/skills/transcript-to-meeting-notes/SKILL.md) | Turn meeting transcripts (.vtt, .md, .docx, .txt) into structured discovery summaries | Pipeline Stage / Standalone |
| [identify-assumptions](cursor/skills/identify-assumptions/SKILL.md) | Surface and structure risky assumptions using PM / Designer / Engineer perspectives | Pipeline Stage / Standalone |
| [validate-requirements](cursor/skills/validate-requirements/SKILL.md) | Combined semantic + structural review with 15 checks; supports incremental mode for re-validation | Pipeline Stage / Standalone |
| [document-audit](cursor/skills/document-audit/SKILL.md) | Scan any non-requirements document for stale markers, contradictions, and broken cross-references | Pipeline Stage / Standalone |

### Post-Pipeline Skills

| Skill | One-liner | Mode |
|-------|-----------|------|
| [review-findings](cursor/skills/review-findings/SKILL.md) | Walk through audit or validation report findings interactively and collect decisions | Post-Pipeline |
| [update-documents](cursor/skills/update-documents/SKILL.md) | Propagate a change (fact, scope, terminology) across multiple related documents with subagent execution | Post-Pipeline |
| [client-ready-requirements](cursor/skills/client-ready-requirements/SKILL.md) | Transform an internal requirements doc into a client-safe version for all stakeholder types | Post-Pipeline |
| [figjam-diagram-generator](cursor/skills/figjam-diagram-generator/SKILL.md) | Generate Mermaid.js diagrams in FigJam from requirements, user flows, or verbal input via Figma MCP | Post-Pipeline |
| [securitas-client-ready-requirements](cursor/skills/securitas-client-ready-requirements/SKILL.md) | Transform internal requirements into streamlined Securitas client-ready format | Post-Pipeline / Client-Specific |

---

## Documentation

- **[Workflow Guide](docs/workflow-guide.md)** — How the pipeline skills fit together, when to use the full pipeline vs a single skill, and mermaid diagrams of every relationship.
- **[Skill Catalog](docs/skill-catalog.md)** — Deep-dive reference for every skill: inputs, outputs, files produced, and related skills.
- **[Invocation Guide](docs/invocation-guide.md)** — How to trigger skills by name, by context, and how to chain the full pipeline in one conversation.

---

## Contributing

To add a new skill:
1. Create a folder under `cursor/skills/<skill-name>/`
2. Add a `SKILL.md` — the agent reads this file at runtime
3. Update [docs/skill-catalog.md](docs/skill-catalog.md) with the new entry

Skills in this repo are production-ready. Work-in-progress or personal skills should live outside this repo (e.g., `~/personal-skills/wip/`) and be symlinked separately — this keeps the repo clean and ensures only stable skills are published.
