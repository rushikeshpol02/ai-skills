---
description: Validate a Feature Requirements document for accuracy, completeness, and structural integrity — 15 checks across semantic and structural dimensions
argument-hint: "<path to requirements doc>"
---

# /validate-requirements — Validate Requirements Document

Runs 15 checks against your requirements document to catch inaccuracies, gaps, and structural issues before sharing with stakeholders or engineering.

## Invocation

```
/validate-requirements [attach or paste your Feature Requirements doc]
/validate-requirements [doc path] against source docs in [folder path]
/validate-requirements Run incremental validation — prior report: [attach report]
```

## What you'll get

A `Validation-Report-[Feature].md` with findings ranked by severity (Critical / Major / Minor), each pointing to a specific section and explaining why it's an issue.

## After validation

Use `/review-findings` to walk through the report interactively and decide what to fix.

## Workflow

Apply the **validate-requirements** skill. If you have source documents (PRD, transcripts, Figma notes), provide them so the skill can check the requirements against them. If you have a prior validation report, mention it to run in incremental mode.
