---
description: Generate a Feature Requirements document from well-defined inputs — PRD, Figma designs, or a clear feature description
argument-hint: "<feature name> — Quick Mode or Comprehensive Mode"
---

# /generate-requirements — Generate Feature Requirements

For when you already have a clear PRD, confirmed designs, or a well-scoped feature description. Faster than the full pipeline — produces a Feature Requirements document in one pass.

## Invocation

```
/generate-requirements Biometric Login — Quick Mode. PRD: [paste or attach]
/generate-requirements Notification Centre — Comprehensive Mode. I have a Figma link and a PRD.
/generate-requirements [Feature Name] — here's the description: [paste description]
```

## Modes

- **Quick Mode** — PRD or description only. Fastest path, ~15 min.
- **Comprehensive Mode** — PRD + Figma designs + any additional context. More thorough, ~45 min.

## What you'll get

`Feature-Requirements-[Feature].md` — a structured document with scope, functional requirements, user flows, assumptions, known limitations, and open questions.

## Workflow

Apply the **generate-requirements** skill with the inputs and mode you specify.
