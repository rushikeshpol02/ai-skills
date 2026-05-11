# PM Tools Plugin

Utility skills for PMs — transcript conversion, design analysis, and diagram generation. Works standalone or alongside the other PM plugins.

## Commands

| Command | What it does |
|---|---|
| `/transcribe-meeting` | Convert a meeting transcript into structured notes with decisions, actions, and open questions |
| `/analyze-design` | Analyze a Figma link or design screenshots and produce a User Flow Doc, Design Description, or Context Summary |
| `/generate-diagram` | Generate a Mermaid.js diagram in FigJam from requirements, user flows, or a verbal description |

## Skills included

- `transcript-to-meeting-notes` — structured meeting summaries from .vtt, .md, .txt, or .docx transcripts
- `design-to-context` — design analysis from Figma URLs or screenshots; three output formats
- `figjam-diagram-generator` — flowcharts, sequence diagrams, state diagrams, and Gantt charts via Figma MCP

## Note

`/analyze-design` and `/generate-diagram` require the **Figma MCP server** to be connected in Cowork settings for Figma URL inputs.
