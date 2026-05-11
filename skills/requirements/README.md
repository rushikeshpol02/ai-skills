# Requirements Plugin — Discovery, Analysis & Quality Suite

A collection of 9 interconnected skills covering the full requirements lifecycle: from raw inputs through structured requirements, validation, client-ready transformation, and multi-document change management.

---

## Skills

| Skill | Purpose | Tier |
|-------|---------|------|
| **requirements-pipeline** | 9-stage discovery and analysis pipeline — takes rough ideas, transcripts, and designs through to production-ready requirements | Orchestrator |
| **generate-requirements** | Generates Feature Requirements from any combination of inputs (PRDs, designs, transcripts, verbal descriptions) | Core |
| **validate-requirements** | Validates requirements documents for semantic accuracy across 11 checks in 4 dimensions (truth, purity, actionability, completeness) | Core |
| **identify-assumptions** | Identifies and structures risky assumptions using multi-perspective analysis (PM, Designer, Engineer) | Core |
| **client-ready-requirements** | Transforms internal requirements into a structured VP/Director-ready client document — 11-section output, VP filter, dedup, appendices | Transform |
| **review-findings** | Interactively walks users through findings from any audit or validation report | Support |
| **document-audit** | Scans documents for stale content, contradictions, unresolved markers, and broken cross-references | Support |
| **update-documents** | Propagates corrections, new information, and scope changes across multiple related documents | Support |

---

## Skill Relationships

```
                        ┌─────────────────────┐
                        │ requirements-pipeline│  (9-stage orchestrator)
                        │  Calls at stages:    │
                        │  S7: generate-req    │
                        │  S5: identify-assumps│
                        │  S9: validate-req    │
                        └──────────┬───────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              v                    v                     v
   ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
   │generate-          │ │identify-         │ │validate-         │
   │requirements       │ │assumptions       │ │requirements      │
   │                   │ │                  │ │  (11 checks)     │
   └────────┬──────────┘ └──────────────────┘ └────────┬─────────┘
            │                                          │
            v                                          v
   ┌──────────────────┐                     ┌──────────────────┐
   │client-ready-     │                     │review-findings   │
   │requirements      │                     │  (interactive    │
   │  (generic)       │                     │   walkthrough)   │
   ├──────────────────┤                     └────────┬─────────┘
   │securitas-client- │                              │
   │ready-requirements│                              v
   │  (Securitas)     │                     ┌──────────────────┐
   └──────────────────┘                     │update-documents  │
                                            │  (multi-doc      │
                                            │   propagation)   │
                                            └────────┬─────────┘
                                                     │
                                                     v
                                            ┌──────────────────┐
                                            │document-audit    │
                                            │  (consistency    │
                                            │   check)         │
                                            └──────────────────┘
```

**External inputs used by these skills** (not part of this plugin):
- `design-to-context` — design analysis fed into requirements-pipeline and generate-requirements
- `transcript-to-meeting-notes` — meeting transcript processing fed into requirements-pipeline
- `project-context` — project-level knowledge loaded by multiple skills

---

## Install

Symlink each skill folder into `~/.claude/skills/` for Claude CLI discovery:

```bash
# For Claude Code
find ~/ai-skills/skills/requirements -mindepth 1 -maxdepth 1 -type d | while read skill; do
  ln -s "$skill" ~/.claude/skills/$(basename "$skill")
done

# For Cursor
find ~/ai-skills/skills/requirements -mindepth 1 -maxdepth 1 -type d | while read skill; do
  ln -s "$skill" ~/.cursor/skills/$(basename "$skill")
done
```

See the [root README](../../README.md) for full install instructions covering all skills at once.

---

## Typical Workflows

**Full discovery-to-requirements:**
`requirements-pipeline` (orchestrates generate-requirements, identify-assumptions, validate-requirements)

**Quick requirements generation:**
`generate-requirements` (standalone, Quick or Comprehensive mode)

**Post-generation quality:**
`validate-requirements` → `review-findings` → `update-documents` → `document-audit`

**Client delivery:**
`client-ready-requirements`
