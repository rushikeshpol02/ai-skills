---
description: Create a structured epic document from a requirements doc or feature description — extracts goals, success criteria, scope, and dependencies
argument-hint: "<epic or feature name>"
---

# /generate-epic — Generate Epic

Creates a structured epic document ready for story decomposition. Works from a requirements document or a verbal description.

## Invocation

```
/generate-epic Biometric Login — requirements doc: [attach Feature-Requirements.md]
/generate-epic Notification Centre — here's the description: [paste]
/generate-epic [Feature Name] — [attach or describe the feature]
```

## What you'll get

`Epic-[Feature].md` — business goal, success criteria, scope boundaries, actors, dependencies, and open questions.

## After the epic

Use `/generate-stories` to decompose the epic into INVEST-compliant user stories.

## Workflow

Apply the **generate-epic** skill with the requirements doc or feature description as input.
