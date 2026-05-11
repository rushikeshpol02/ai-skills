---
description: Turn a ticket list into a structured Sprint Planning document — goal, grouped work areas, and done criteria
argument-hint: "<sprint number or name>"
---

# /plan-sprint — Sprint Planning Session

Takes your sprint's tickets and produces a structured Sprint Planning document the team can work from.

## Invocation

```
/plan-sprint Sprint 3 — tickets: [paste list or attach release plan]
/plan-sprint Sprint 1. Goal: Ship login flow. Here are the tickets: [paste]
/plan-sprint [attach Release-Plan.md] — plan Sprint 2
```

## What to have ready

- Ticket list or release plan (required)
- Sprint goal (optional — derived if not provided)

## What you'll get

`Sprint-N-Planning.md` — grouped work areas, sprint goal, capacity notes, and done criteria.

## Workflow

Apply the **sprint-planning-session** skill with the ticket list or release plan as input.
