# AI Agent Skills

A collection of agent skills for Cursor (and future Claude) that automate product management, requirements engineering, and team workflows. Skills are markdown files that the AI agent reads at runtime to execute structured, multi-step tasks.

---

## What Are Agent Skills?

Agent skills are instruction files (`SKILL.md`) stored in `~/.cursor/skills/`. When you invoke a skill — either explicitly by name or implicitly by describing a task — Cursor reads the skill file and follows its step-by-step instructions. Skills can call other skills, save files to your workspace, ask you questions, and produce publication-ready documents.

---

## Repository Structure

```
ai-skills/
├── cursor/
│   └── skills/              Product & requirements skills (13 skills)
├── claude/                  Placeholder for future Claude skills
└── docs/
    ├── workflow-guide.md    How skills relate to each other + pipeline diagram
    ├── skill-catalog.md     Per-skill reference: inputs, outputs, mode, related skills
    └── invocation-guide.md  How to install and invoke each skill
```

---

## Installation

### Option A — Copy (recommended for most users)

```bash
# Clone this repo
git clone https://github.com/<your-username>/ai-skills.git

# Copy skills into Cursor's skills folder
cp -r ai-skills/cursor/skills/* ~/.cursor/skills/
```

### Option B — Symlink (keeps skills in sync with repo automatically)

```bash
git clone https://github.com/<your-username>/ai-skills.git ~/ai-skills

# Back up existing skills folder if needed
mv ~/.cursor/skills ~/.cursor/skills.bak

# Symlink
ln -s ~/ai-skills/cursor/skills ~/.cursor/skills
```

After installation, restart Cursor. Skills are available immediately in any Cursor project.

---

## Skills at a Glance

### Product & Requirements Skills (`cursor/skills/`)

| Skill | One-liner | Mode |
|-------|-----------|------|
| [requirements-pipeline](cursor/skills/requirements-pipeline/SKILL.md) | 9-stage discovery and analysis pipeline from messy inputs to production-ready docs | Pipeline Orchestrator |
| [generate-requirements](cursor/skills/generate-requirements/SKILL.md) | Generate Feature Requirements, API Contract, and System Flow from well-defined inputs | Pipeline Stage / Standalone |
| [design-to-context](cursor/skills/design-to-context/SKILL.md) | Convert Figma URLs or design images into User Flow Docs, Design Descriptions, or Context Summaries | Pipeline Stage / Standalone |
| [transcript-to-meeting-notes](cursor/skills/transcript-to-meeting-notes/SKILL.md) | Turn meeting transcripts (.vtt, .md, .docx, .txt) into structured discovery summaries | Pipeline Stage / Standalone |
| [identify-assumptions](cursor/skills/identify-assumptions/SKILL.md) | Surface and structure risky assumptions using PM / Designer / Engineer perspectives | Pipeline Stage / Standalone |
| [validate-requirements](cursor/skills/validate-requirements/SKILL.md) | Check requirements for semantic accuracy across 10 checks in 4 dimensions | Pipeline Stage / Standalone |
| [document-audit](cursor/skills/document-audit/SKILL.md) | Scan any document for stale markers, contradictions, and broken cross-references | Pipeline Stage / Standalone |
| [review-findings](cursor/skills/review-findings/SKILL.md) | Walk through audit or validation report findings interactively and collect decisions | Post-Pipeline |
| [update-documents](cursor/skills/update-documents/SKILL.md) | Propagate a change (fact, scope, terminology) across multiple related documents | Post-Pipeline |
| [rest-api-contract-generator](cursor/skills/rest-api-contract-generator/SKILL.md) | Generate a complete REST API contract from a feature spec or Swagger file | Standalone |
| [jtbd-generator](cursor/skills/jtbd-generator/SKILL.md) | Produce a Jobs to Be Done analysis with MoSCoW prioritization (Ulwick's ODI framework) | Standalone |
| [github-issue-classifier](cursor/skills/github-issue-classifier/SKILL.md) | Classify GitHub issues into epics/stories/tasks/defects and build a milestone hierarchy | Standalone |
| [generate-pm-jd](cursor/skills/generate-pm-jd/SKILL.md) | Generate standardized Product Manager job descriptions (L3/L4 × Traditional / AI Builder) | Standalone |


---

## Documentation

- **[Workflow Guide](docs/workflow-guide.md)** — How the pipeline skills fit together, when to use the full pipeline vs a single skill, and mermaid diagrams of every relationship.
- **[Skill Catalog](docs/skill-catalog.md)** — Deep-dive reference for every skill: inputs, outputs, files produced, and related skills.
- **[Invocation Guide](docs/invocation-guide.md)** — How to trigger skills by name, by context, and how to chain the full pipeline in one conversation.

---

## Future Skills

The `claude/` directory is reserved for Claude agent skills (`.claude/commands/` or CLAUDE.md-based skills). Structure to be added when Claude skills are authored.

---

## Contributing

To add a new skill:
1. Create a folder under `cursor/skills/<skill-name>/`
2. Add a `SKILL.md` with a valid YAML frontmatter block (`name`, `description`)
3. Update [docs/skill-catalog.md](docs/skill-catalog.md) with the new entry
