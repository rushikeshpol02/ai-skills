---
description: Generate a mid-sprint or close-out progress snapshot — planned vs actual, risks, blockers, and completion percentage
argument-hint: "<sprint number> — mid-sprint or close-out"
---

# /sprint-progress — Sprint Progress Tracker

Creates a structured progress snapshot for a mid-sprint check-in or sprint close-out. Surfaces risks early and feeds directly into the sprint review.

## Invocation

```
/sprint-progress Sprint 2 mid-sprint — [attach Sprint-2-Planning.md] — here's what's done: [paste update]
/sprint-progress Sprint 1 close-out. Planning doc: [attach]. Status: [paste or describe]
/sprint-progress [attach planning doc] — everything is on track except [describe blocker]
```

## What to have ready

- Sprint planning doc (required — `Sprint-N-Planning.md`)
- Status update — which tickets are done, in progress, or blocked (required)

## What you'll get

`Sprint-N-Progress.md` — planned vs actual, completion percentage, risks, blockers, and recommendations for the remainder of the sprint.

## Workflow

Apply the **sprint-progress-tracker** skill with the planning doc and status update as input.
