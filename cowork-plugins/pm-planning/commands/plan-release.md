---
description: Define a release — goal, scope, team, timeline, and constraints — then produce a formal Release Definition and multi-sprint plan
argument-hint: "<release or feature name>"
---

# /plan-release — Release & Sprint Planner

Guides you through defining a release from scratch: what you're building, who's building it, when it needs to ship, and how to break the work into sprints.

## Invocation

```
/plan-release MyConnect App Shell — Q3 release
/plan-release [Feature Name]. Team: 3 devs. Deadline: end of June.
/plan-release I have a feature list and need to break it into sprints: [paste list]
```

## What to have ready

- A feature list or backlog (required)
- Team size and velocity (optional — estimated if not provided)
- Timeline or deadline (optional — derived if not provided)
- Known constraints or dependencies (optional)

## What you'll get

- `Release-Definition.md` — goal, scope, team, timeline, constraints
- `Release-Plan.md` — multi-sprint breakdown with feature assignments
- `Scope.md` — in/out of scope table

## Workflow

Apply the **release-sprint-planner** skill. The skill will assess context across six dimensions, collaboratively build each section with you, size features, map dependencies, and assign work to sprints.
