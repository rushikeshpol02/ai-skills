---
description: Decompose an epic into INVEST-compliant user stories using the WAHZURT framework — one story at a time with inline quality gates
argument-hint: "<epic name or path to Epic doc>"
---

# /generate-stories — Generate User Stories

Decomposes a feature into story concepts, then writes detailed INVEST-compliant user stories one at a time. Each story gets an inline quality check before moving to the next.

## Invocation

```
/generate-stories [attach Epic-BiometricLogin.md]
/generate-stories Notification Centre epic — [attach or paste epic]
/generate-stories Quick/draft mode — [attach epic] — just get me rough stories fast
```

## Modes

- **Standard** — full WAHZURT decomposition with quality gates (recommended)
- **Quick/Draft** — faster, lighter stories for early estimation
- **Modify** — update a specific existing story: `/generate-stories modify [attach story file]`
- **Decompose only** — story concepts without writing full stories yet

## What you'll get

Individual story files (`Story-[N]-[Name].md`) — each INVEST-compliant with acceptance criteria, technical notes, and edge cases.

## Workflow

Apply the **generate-user-stories** skill with the epic as input.
