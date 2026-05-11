# Feature Requirements: [Feature Name]

| Field | Value |
|---|---|
| **Feature** | [Feature Name] |
| **Version** | 1.0 |
| **Date** | [YYYY-MM-DD] |
| **Owner** | [Product Manager] |
| **Status** | Draft — Pending Review |

**Complexity: [Simple | Medium | Complex] | Size: [Small | Medium | Large]**

---

## 1. Overview

[Sentence 1: the user problem this feature solves — user perspective only, no technical context.] [Sentence 2: what the feature enables for the user — 2–3 user-facing capabilities.] [Sentence 3: operational impact on day one — include only if a large-scale user action is required at launch; omit if none.]

---

## 2. Personas

| Persona | Description | Primary Need |
|---|---|---|
| **[Behavioral-state name — reflects what the user has configured or is doing, not their job title]** | [Device or configuration context that explains why their experience differs. Does not restate the persona name.] | [What the user needs to achieve, from their own perspective. Not a system action.] |

---

## 3. User Goals

- As a [persona], I want [goal] so that [outcome].
- As a [persona], I want [goal] so that [outcome].

---

## 4. Scope

### In Scope

| Capability |
|---|
| [User-facing capability the feature includes — noun form, plain language, no sub-functions or UI elements] |

### Out of Scope

| Capability | Reason |
|---|---|
| [Excluded capability a VP would reasonably assume is in scope] | [Owner or plain reason — one short phrase] |

---

## 5. What's Changing

| Current State | What's New |
|---|---|
| [What the user experiences today — user-observable language only, no architecture or SDK names] | [What the user will experience after the update — user-observable language only] |

---

## 6. User Flows

| Flow | Trigger | Outcome |
|---|---|---|
| [Flow name — accurate after launch, no transient context like "new app" or "post-migration"] | [User's situation when the flow begins — a user action, not a system event] | [What the user sees at the end] |

*Failure paths — see Appendix D.*

---

## 7. Functional Requirements

### FR-1: [Requirement Name]

[One sentence stating what the user can do. Capability level only. Does not preview bullet content.]

- [Rule 1 — use must for mandatory behavior, may only for explicitly optional behavior] (Source: SRC-N)
- [Rule 2] (Source: SRC-N)
- [Rule 3 — conditional: on [condition], [user-observable outcome]] (Source: SRC-N)

---

### FR-2: [Requirement Name]

- [Rule 1] (Source: SRC-N)
- [Rule 2] (Source: SRC-N)

---

## 8. Known Limitations

> **[User-observable limitation — plain English header.]** [Why it exists — one sentence.] [Recommended action or communication before launch.]

---

## 9. Constraints, Risks & Assumptions

### 9.1 Constraints

| Constraint | Imposed By |
|---|---|
| [Non-negotiable rule — state what the team cannot do or what boundary applies, not the technical reason] | [Regulatory body, legal requirement, platform policy, or timeline] |

### 9.2 Risks

*Populated by Stage 8 — Risk Analysis. Leave empty at generation time.*

| Risk | Probability | Impact | Owner | Mitigation |
|---|---|---|---|---|

### 9.3 Assumptions

| # | Assumption | Status | Impact if Wrong |
|---|---|---|---|
| A-1 | [What the team believes to be true — plain English; technical detail in parentheses after if needed] | Not confirmed | [What changes if this assumption is wrong — FR, scope, or timeline impact in one sentence] |

---

## 10. Open Questions

| # | Question | Blocks | Priority | Owner | Target Date |
|---|---|---|---|---|---|
| OQ-1 | [Plain question directed at the listed owner — answerable without a glossary] | [FR-N or —] | Critical | [Who must decide] | TBD — owner to confirm |

---

## 11. References

### Design Assets

- [Display Name](https://figma.com/...) — design file

### Source Materials

- [filename.md] — [doc type]

---

## Appendix A — Visual States

| State | Description | Design Status |
|---|---|---|
| [State name — user-observable state, not internal system state] | [What the user sees in this state] | ✅ Confirmed / ⚠️ Behavior confirmed; design TBD / ❌ Not designed |

---

## Appendix B — Error Handling

| Error Type | Cause | User Experience | System Behavior | Design Status | Applies To |
|---|---|---|---|---|---|
| [Error type] | [Cause — or — if rephrasing the error type adds nothing] | [What the user sees, reads, or can do — in the user's words] | [What the system does that the user cannot observe — or — if it restates User Experience] | ✅ Confirmed | [FR-N] |

---

## Appendix D — Detailed User Flows

| Flow | Trigger | Steps | Outcome |
|---|---|---|---|
| [Flow name] | [User action that starts the flow] | [Step-by-step narrative] | [Where the user ends up] |

---

## Appendix E — Field-Level Specs

*Include validation rules, character limits, exact UI labels, picker behavior, and other Low decision-impact detail that does not belong in FR bodies. Populate from source material if available. If no Low decision-impact detail exists, omit this appendix.*
