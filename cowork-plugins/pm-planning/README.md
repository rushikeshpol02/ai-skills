# PM Planning Plugin

Delivery planning skills for PMs — from release definition through sprint execution, review, and iteration.

## Commands

| Command | What it does |
|---|---|
| `/plan-release` | Define a release and produce a formal Release Definition + multi-sprint plan |
| `/plan-sprint` | Turn a ticket list into a structured Sprint Planning document |
| `/sprint-progress` | Generate a mid-sprint or close-out progress snapshot |
| `/sprint-review` | Produce a stakeholder-facing sprint review document |
| `/apply-meeting-decisions` | Apply sprint demo or retro decisions back to the release plan |

## Skills included

- `release-sprint-planner` — release definition and multi-sprint planning
- `sprint-planning-session` — sprint planning document generation
- `sprint-progress-tracker` — planned vs actual progress snapshots
- `sprint-review-generator` — stakeholder-facing sprint review documents
- `meeting-to-plan-integrator` — applies meeting decisions to release artifacts
- `shared/` — delivery model, execution rules, and constraint registry shared across all planning skills

## Skill cycle

```
release-sprint-planner  →  Release-Definition.md + Release-Plan.md
sprint-planning-session →  Sprint-N-Planning.md
sprint-progress-tracker →  Sprint-N-Progress.md
sprint-review-generator →  Sprint-N-Review.md
meeting-to-plan-integrator → updates Release-Plan.md
```
