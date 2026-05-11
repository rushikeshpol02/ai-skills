---
description: Produce a stakeholder-facing sprint review document — what was built, goal outcome, learnings, and next steps
argument-hint: "<sprint number>"
---

# /sprint-review — Sprint Review Generator

Produces a clean sprint review document for the sprint demo. Stakeholder-facing at the top, full team detail below.

## Invocation

```
/sprint-review Sprint 2 — [attach Sprint-2-Progress.md]
/sprint-review Sprint 1. Progress doc: [attach]. Additional notes: [paste]
/sprint-review [attach progress doc] — we also shipped [describe anything not in the doc]
```

## What to have ready

- Sprint progress doc (required — `Sprint-N-Progress.md`)
- Sprint planning doc (optional — used for goal comparison)

## What you'll get

`Sprint-N-Review.md` — what shipped, whether the sprint goal was met, learnings, and next steps. Written for two audiences: stakeholders (top sections) and team/PM (full detail).

## After the review

Use `/apply-meeting-decisions` after the sprint demo to apply stakeholder feedback back to the release plan.

## Workflow

Apply the **sprint-review-generator** skill with the progress doc as input.
