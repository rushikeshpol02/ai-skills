# PM Epics & Stories Plugin

Story lifecycle skills for PMs — from epic creation through user story generation, validation, and UAT planning.

## Commands

| Command | What it does |
|---|---|
| `/generate-epic` | Create a structured epic from a requirements doc or feature description |
| `/generate-stories` | Decompose an epic into INVEST-compliant user stories using WAHZURT framework |
| `/validate-stories` | Audit and fix user stories across 12 validation categories |
| `/generate-uat` | Generate a client-ready UAT test plan from tickets or GitHub issues |

## Skills included

- `generate-epic` — structured epic creation with goals, scope, and dependencies
- `generate-user-stories` — WAHZURT-based story decomposition with inline quality gates; supports create, quick/draft, modify, and decompose-only modes
- `validate-user-stories` — 12-category validation (9 per-story + 2 cross-story + 1 readability) with auto-fix
- `generate-uat` — UAT test plan generation from tickets with AC extraction and deduplication

## Story lifecycle

```
generate-epic       →  Epic-[Feature].md
generate-stories    →  Story-N-[Name].md (one per story)
validate-stories    →  fixed stories + Validation-Report.md
generate-uat        →  UAT-TestPlan-[Feature].md
```
