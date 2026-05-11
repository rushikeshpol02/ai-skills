---
description: Run the full requirements discovery pipeline — from rough inputs (transcripts, Figma, rough ideas) to a production-ready Feature Requirements document
argument-hint: "<feature name or description>"
---

# /requirements-pipeline — Requirements Discovery Pipeline

Takes messy, early-stage inputs and guides you through a structured multi-stage pipeline to produce a complete Feature Requirements document. Supports three modes: Express (fast), Standard, and Full.

## Invocation

```
/requirements-pipeline Login with Biometrics
/requirements-pipeline I have a transcript and some rough ideas for a notification feature
/requirements-pipeline [paste or describe the feature you need requirements for]
```

## What to have ready

- A feature name or description (required)
- Any combination of: meeting transcripts, Figma links, PRDs, rough notes, legal docs (all optional)

## What you'll get

A production-ready `Feature-Requirements-[Feature].md` document covering user flows, functional requirements, assumptions, risk analysis, and validation findings — with mandatory checkpoints at key stages so you stay in control.

## Workflow

Apply the **requirements-pipeline** skill. The pipeline will:

1. Lock the input set and assign source IDs
2. Present its interpretation for your confirmation — **pause for approval**
3. Brainstorm constraints, actors, and rules
4. Lock the pipeline mode (Express / Standard / Full) — **pause for approval**
5. Surface risky assumptions by priority — **pause for approval**
6. Draft user flows per actor
7. Generate the Feature Requirements document
8. Run a pre-mortem risk analysis
9. Validate the document — **pause for approval**

If you have a transcript, say so upfront and the pipeline will summarize it before analysis begins.
