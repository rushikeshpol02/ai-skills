---
description: Transform an internal Feature Requirements document into a VP/Director-ready client deliverable — 11-section format with VP filter, deduplication, and appendices
argument-hint: "<path to internal Feature Requirements doc>"
---

# /client-ready-requirements — Create Client-Ready Requirements

Takes your internal Feature Requirements document and produces a clean, structured client deliverable. Applies a VP filter, removes internal notes, deduplicates content, and formats for a Director or VP audience.

## Invocation

```
/client-ready-requirements [attach or paste your Feature-Requirements doc]
/client-ready-requirements [feature name] — requirements doc: [attach]
```

## What you'll get

A `Client-Requirements-[Feature].md` — an 11-section document structured for stakeholder review, with overflow content moved to appendices and FR statements copied verbatim (no paraphrasing).

## When to use

After your internal requirements are validated and you need to share them with a client or senior stakeholder. Run `/validate-requirements` first if you haven't already.

## Workflow

Apply the **client-ready-requirements** skill with the internal requirements document as input.
