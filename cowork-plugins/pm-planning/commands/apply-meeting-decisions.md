---
description: Apply decisions from a sprint demo, retro, or stakeholder call back to the release plan and related artifacts
argument-hint: "<meeting type — e.g. sprint demo, retro, stakeholder call>"
---

# /apply-meeting-decisions — Meeting to Plan Integrator

Takes decisions from any meeting and propagates them into the release plan and related sprint artifacts. The "decisions become actions" bridge.

## Invocation

```
/apply-meeting-decisions Sprint 2 demo — decisions: [paste or attach meeting notes]
/apply-meeting-decisions Retro decisions: [paste]. Release plan: [attach Release-Plan.md]
/apply-meeting-decisions Stakeholder call — they want to cut [feature] from scope. Update the plan.
```

## What to have ready

- Meeting notes or a summary of decisions (required)
- Release plan (required — `Release-Plan.md`)
- Related sprint artifacts (optional — planning docs, scope doc)

## What you'll get

Updated `Release-Plan.md` and related artifacts with decisions applied, a change summary showing what was updated and why.

## Workflow

Apply the **meeting-to-plan-integrator** skill with the meeting notes and release plan as input.
