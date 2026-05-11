---
description: Generate a client-ready UAT test plan from GitHub issue files or a ticket list — extracts acceptance criteria, deduplicates scenarios, and produces a structured test document
argument-hint: "<feature name or path to ticket files>"
---

# /generate-uat — Generate UAT Test Plan

Produces a client-ready UAT test plan from your tickets or GitHub issues. Extracts acceptance criteria, deduplicates cross-platform scenarios (iOS/Android), and flags tickets with missing ACs.

## Invocation

```
/generate-uat Biometric Login release — tickets: [attach folder or paste list]
/generate-uat [Feature Name] — here are the GitHub issues: [attach files]
/generate-uat [paste ticket list with acceptance criteria]
```

## What to have ready

- GitHub issue files or a ticket list with acceptance criteria (required)
- Feature or release name (required)

## What you'll get

`UAT-TestPlan-[Feature].md` — structured test scenarios grouped by feature area, a "Known Limitations" section, and a "Tickets Without ACs" appendix.

## Workflow

Apply the **generate-uat** skill with the ticket files or list as input.
