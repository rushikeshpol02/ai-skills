---
name: design-to-context
description: "Analyzes design image files or Figma links (when Figma MCP is available) and generates a structured design context document. Handles three output formats: (1) User Flow Document — sequential multi-screen journeys with screen-by-screen breakdowns, state transitions, and error handling; (2) Design Description — screen/component documentation covering visual design, layout, and interaction behavior; (3) Context Summary — structured six-context analysis (Business/Product/UX) used as input for requirements generation. Use when given design images, Figma URLs, or asked to document a screen, flow, or feature from mockups."
---

# design-to-context

## Step 0: Resolve the input source

Before anything else, determine where the design content is coming from.

### Case A — Image files attached or in workspace
The user has uploaded screenshots, mockups, or exported design images. Proceed directly to Step 1.

### Case B — Figma URL provided
The user has shared a `figma.com` link (e.g., `https://www.figma.com/design/...?node-id=...`).

1. **Check if Figma MCP is available** — look for tools like `get_design_context` or `get_screenshot` in the available MCP tools.

2. **If Figma MCP is available:**
   - Extract `fileKey` and `nodeId` from the URL.
     - `fileKey` is the segment after `/design/` (e.g., `vvDPZ5v3PppO3ekMXiq2Xv`)
     - `nodeId` is the value of `node-id` query param, with `-` replaced by `:` (e.g., `2173-19802` → `2173:19802`)
   - Call `get_design_context` (preferred — returns screenshot + metadata) or fall back to `get_screenshot`.
   - If the user provides multiple node URLs, fetch each one and treat them as separate screens, labelled by their node name or URL order.
   - Treat the fetched screenshot(s) and any returned metadata as the design input for Steps 1–5.

3. **If Figma MCP is NOT available:**
   - Inform the user: *"I don't have access to Figma tools in this session. Please export the screen(s) as images and share them here, or enable the Figma connector."*
   - Stop and wait — do not proceed until images are provided.

### Case C — Neither images nor a Figma URL
Ask the user: *"Could you share the design? You can attach image files (screenshots, exports) or paste a Figma link if you have the Figma connector enabled."*

---

## Step 1: Determine output format

Read the images and the user's intent, then follow this decision tree:

1. Did the user explicitly name a format? → Use it.
2. Do the images show a clear start-to-end journey with 2+ sequential, distinct steps? → **User Flow Document**
3. Do the images show a single screen, a set of components, or multiple states of the same screen (not a journey)? → **Design Description**
4. Did the user say this will feed into requirements, a spec, or further generation? → **Context Summary**
5. Still unclear? → Ask: *"Are these images showing a user journey (flow), a specific screen/component, or are you building requirements from them?"*

**When to use two formats:** If images show a multi-screen flow AND the user needs requirements output, produce both a User Flow Document and a Context Summary. State this upfront so the user can confirm before proceeding.

| Format | Signals in images | Signals in user intent |
|--------|-------------------|------------------------|
| **User Flow Document** | Multiple sequential screens; back arrows; step/progress indicators; modal overlays | "document this flow", "map the journey", "show screen transitions" |
| **Design Description** | One screen with sections; component variants; side-by-side states of same UI | "describe this screen", "document these components", "what's on this page" |
| **Context Summary** | Any design images | "generate requirements", "feed into a spec", "I need a context doc" |

---

## Edge cases — handle before drafting

Address these before running Step 3:

| Situation | How to handle |
|-----------|---------------|
| **Single image** | Default to Design Description unless the user says otherwise. Note in the doc that only one screen was provided. |
| **Wireframes / low-fidelity** | Describe structure and intent, not visual style. Mark color/typography observations as `[TBD — wireframe only]`. |
| **High-fidelity vs. wireframe mix** | Document each image at the fidelity level it shows. Flag the inconsistency in a Design Notes bullet. |
| **Multiple states of same screen** | Treat each state (empty, filled, error, loading) as a named variant within one Design Description section, not as separate screens. |
| **Dark mode / light mode variants** | Document one as primary, the other as a "Theme Variant" subsection. Note differences only — don't re-document identical elements. |
| **Annotated design (callouts, redlines)** | Treat annotations as additional context. Include them under a `Design Annotations` subsection at the end of the relevant screen section. |
| **Images with no clear order** | State the assumed order at the top of the document and ask the user to confirm if sequence matters. |
| **Figma node with no visible content** | If `get_design_context` or `get_screenshot` returns an empty or error response, tell the user: *"I couldn't retrieve that node. Please check the link or try a different node."* |

---

## Step 2: Core rules (apply to all formats)

- **Images only.** Every observation must be visible in a provided image. NEVER infer, assume, or add outside knowledge.
- **Mark unknowns.** Use `[TBD]` for anything not visible. Never invent values.
- **Attribution.** Note which image each observation comes from (e.g., `(Image 1)`, `(Screen 3 image)`). For Figma inputs, reference by node name or URL if multiple nodes were fetched.
- **Visual specifics matter.** Capture icon descriptions, color states (active/inactive/error), label text, placeholder text, and badge/indicator states.
- **Interactions over aesthetics.** Prioritize what happens when elements are tapped/toggled over visual decoration.
- **Scope clearly.** Note what the document covers and what it does NOT cover. Reference related flows/docs by name if known.
- **State ≠ behavior.** Separate what is displayed (state) from what happens when the user acts (behavior).

---

## Step 3: Analyze the images

Before drafting, work through the images systematically:

1. **Inventory** — Count images. Label each (e.g., Screen 1, Screen 2). Identify what each shows.
2. **Sequence** — For flows: determine the order. Look for back arrows, progression indicators, modal overlays.
3. **Per screen/component, extract:**
   - Screen purpose (one sentence)
   - All visible UI sections and their elements (labels, icons, placeholders, states)
   - Primary action (the main tap target)
   - Secondary actions (back, edit, links, toggles)
   - Visible conditional logic (e.g., "first-time only", "if geo required")
   - State displayed (e.g., "clocked in", "location verified", "empty state")
4. **Cross-screen patterns** — Note shared elements: nav bar, header format, color scheme, button style.
5. **Gaps** — List anything that seems like it should be documented but isn't visible in the images.

---

## Step 4: Draft using the correct template

See [templates.md](templates.md) for all three templates.

### User Flow Document guidance
- **Flow diagram first** — ASCII/text diagram showing screen → screen transitions. Include conditional branches.
- **Screen-by-Screen** — One `###` section per screen. Include: Purpose, Key Elements, Primary Action, Secondary Actions, State, Display Logic (if conditional).
- **State Transitions** — Group by state type (e.g., location monitoring, shift status, banner visibility).
- **Error Handling** — Group errors by category (Network, Location, Auth, etc.). For each: When, System Response, User Actions, Recovery Path.
- **Design Notes** — Color scheme, typography, icon patterns, spacing. One bullet per observation.
- **Out-of-scope note** — Always include what other flows/docs handle the scenarios NOT covered here.

### Design Description guidance
- **Overview first** — One short paragraph: what this screen/feature is, who uses it, when.
- **Component hierarchy** — Top-level sections → subsections → elements. Never skip levels.
- **Per component:** Visual Design (position, icon, color), Purpose, Navigation/Behavior.
- **Destination screens** — If buttons navigate to sub-screens, document those as full sub-sections.
- **Navigation context management** — If back button behavior has logic (e.g., "returns to origin screen"), document it explicitly.
- **UX Considerations** — End with Consistency, Accessibility, Efficiency notes.

### Producing two formats in one pass

If you determined in Step 1 that both a User Flow Document and a Context Summary are needed, produce the User Flow Document first (it's more detailed), then derive the Context Summary from it. The UX Context section of the Context Summary should reference the Flow Document by name rather than re-documenting every screen.

### Context Summary guidance
- **Six contexts:** Business, Product, Persona, UX, Technical, Compliance. Mark `**N/A** — [reason]` if not applicable (e.g., "Quick Mode (skipped)").
- **UX Context is the most detailed** — List every screen, its name, key elements, and user actions.
- **Source Attribution** — Tier 1 (critical business rules), Tier 2 (functional requirements), Tier 3 (UI details). Note source for each item.
- **EXISTING vs NEW** — Classify each part of the feature.
- **Unresolved Gaps** — RED (blocks generation) / YELLOW (reduces quality) / GREEN (optional). Each gap needs: what's unknown + who can answer.
- **Ready for Next Step** — State whether the document is ready for requirements generation and what the recommended output type is.

---

## Step 5: Quality gate before saving

Run through every item. Do not skip.

**Accuracy**
- [ ] Every non-obvious observation cites an image (e.g., `(Image 2)`).
- [ ] No invented values — anything not visible is marked `[TBD]`.
- [ ] All `[TBD]` items are also listed in the gaps/unresolved section.

**Completeness**
- [ ] In-scope and out-of-scope boundaries are explicitly stated.
- [ ] All visible states are documented (empty, filled, error, loading) — not just the "happy path."
- [ ] For flows: every conditional branch appears in both the flow diagram and Screen-by-Screen sections.

**Clarity**
- [ ] Elements shared across screens are described once and referenced thereafter (not re-described verbatim).
- [ ] State and behavior are kept separate — what is shown vs. what happens when the user acts.
- [ ] No section is so long it buries key information — split or summarize if needed.

**Output**
- [ ] Filename follows the format:
  - Flow doc: `[FlowName]_User_Flow_Document.md`
  - Design description: `[FeatureName]_Design_Description.md`
  - Context summary: `Context-Summary-[FeatureName].md`
- [ ] File saved to the correct output location.
- [ ] Share the file link with the user and confirm any open `[TBD]` items they should follow up on.

---

## Additional resources

- For document templates, see [templates.md](templates.md)
