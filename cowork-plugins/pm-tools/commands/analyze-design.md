---
description: Analyze a Figma link or design screenshots and produce a structured design context document — user flows, design descriptions, or context summaries
argument-hint: "<Figma URL or attach design screenshots>"
---

# /analyze-design — Design to Context

Analyzes Figma designs or uploaded screenshots and produces a structured document capturing user flows, UI patterns, and design intent.

## Invocation

```
/analyze-design [paste Figma URL]
/analyze-design [attach design screenshots] — produce a User Flow Document
/analyze-design [Figma link] — I need a Context Summary to feed into requirements
```

## Output formats

- **User Flow Document** — step-by-step flows per actor, entry/exit points, edge cases
- **Design Description** — detailed UI description of a single screen or component
- **Context Summary** — high-level design intent summary to feed into requirements generation

## Note

Figma URL analysis requires the Figma MCP server to be connected in Cowork settings.

## Workflow

Apply the **design-to-context** skill with the Figma URL or design images as input. Specify which output format you need, or let the skill choose based on your input.
