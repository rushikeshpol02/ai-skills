---
description: Audit existing user stories against 12 validation categories and fix failures — per-story, cross-story, and readability checks
argument-hint: "<path to stories folder>"
---

# /validate-stories — Validate User Stories

Audits your user stories against 12 categories: 9 per-story checks, 2 cross-story checks, and 1 readability check. Fixes failures automatically.

## Invocation

```
/validate-stories [attach stories folder or individual story files]
/validate-stories Check and fix stories in [folder path] — run all 12 categories
/validate-stories [attach story file] — just validate this one story
```

## What you'll get

- A `Validation-Report-Stories.md` with findings per story
- Fixed story files where issues were corrected
- A fresh story registry rebuilt from actual files

## Workflow

Apply the **validate-user-stories** skill with the stories folder as input. The skill always builds a fresh registry from the actual files — never trusts existing registries.
