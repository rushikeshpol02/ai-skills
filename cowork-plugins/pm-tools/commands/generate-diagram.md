---
description: Generate a Mermaid.js diagram in FigJam from requirements, user flows, or a verbal description — flowcharts, sequence diagrams, state diagrams
argument-hint: "<requirements doc, user flow, or describe what to diagram>"
---

# /generate-diagram — FigJam Diagram Generator

Creates diagrams in FigJam from requirements documents, user flows, or a verbal description. Supports flowcharts, sequence diagrams, state diagrams, and Gantt charts.

## Invocation

```
/generate-diagram [attach Feature-Requirements.md] — create a flowchart of the user flows
/generate-diagram Login flow — user taps biometric → system validates → home screen or error
/generate-diagram [attach user flow doc] — sequence diagram showing system interactions
```

## Diagram types

- **Flowchart** — user flows, decision trees, process maps (with standard 5-color palette)
- **Sequence diagram** — system interactions, API flows, multi-actor sequences
- **State diagram** — feature states and transitions
- **Gantt** — timeline and sprint schedule

## Note

Requires the Figma MCP server to be connected in Cowork settings to generate directly in FigJam.

## Workflow

Apply the **figjam-diagram-generator** skill with your input. Specify the diagram type if you have a preference; otherwise the skill will choose based on the content.
