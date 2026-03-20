# JTBD Output Template

Use this structure for the generated `JTBD-Analysis-[Name].md` file.

---

````markdown
# Jobs to Be Done Analysis: [Feature/Product Area Name]

**Date:** [YYYY-MM-DD]
**Personas:** [Persona 1 (Role)], [Persona 2 (Role)]
**Input Sources:** [List of documents/sources analyzed]
**MoSCoW Approach:** [User-assigned / Input-derived / Hybrid / Pending stakeholder input]

---

## How to Read This Document

This analysis follows the Jobs to Be Done (JTBD) framework. It describes what users are trying to accomplish in their work/life, independent of any specific product or feature.

- **Theme** — A broad area of user concern (not a product feature area)
- **Core Job** — The primary task a user is trying to accomplish in a given life/work situation
- **Job Step** — A discrete action within that task
- **Desired Outcome** — What success looks like for that action, stated as a measurable direction
- **Current Alternative** — How users get this job done today (before/without this product)
- **MoSCoW** — Priority classification: Must (MVP), Should (Phase 2), Could (Phase 3), Won't (Deferred). Assigned by stakeholders unless explicitly stated in requirements
- **Job Type** — Functional, Emotional (Personal), or Emotional (Social)

---

## JTBD Analysis

<!-- Repeat this section for each Theme. -->
<!-- Themes must be USER CONCERN AREAS, never product feature areas or system qualities. -->
<!-- If MoSCoW is assigned: order themes by priority (Must-heavy first). -->
<!-- If MoSCoW is [TBD]: order themes alphabetically. -->
<!-- Non-functional concerns (cross-device, error handling, performance) are NOT themes. -->

### Theme: [Theme Name — user concern area]

<!-- Current Alternative applies at the Core Job level — what do users do today to get this job done? -->
**Current Alternative:** [How users accomplish this today without the product, OR "Unknown — needs stakeholder input"]

| MoSCoW | Core Job | Job Step | Desired Outcome | Job Type |
|--------|----------|----------|-----------------|----------|
| _[TBD]_ | When [life/work situation], [persona] wants to [job] | [Verb phrase — step 1] | [Direction] the [metric] of [object] | Functional |
| _[TBD]_ | | [Step 2] | [Direction] the [metric] of [object] | Emotional (Personal) |
| _[TBD]_ | | [Step 3] | [Direction] the [metric] of [object] | Emotional (Social) |
| _[TBD]_ | When [different life/work situation], [persona] wants to [different job] | [Step 1] | [Direction] the [metric] of [object] | Functional |
| _[TBD]_ | | [Step 2] | [Direction] the [metric] of [object] | Functional |

<!-- Replace _[TBD]_ with Must/Should/Could/Won't once stakeholder assigns priority. -->
<!-- Leave Core Job cell blank when multiple steps belong to the same parent job. -->
<!-- Within a Core Job, order steps by natural execution sequence (define → conclude). -->
<!-- LITMUS TEST: Every Core Job must pass "Delete the Product" and "Life Context" tests. -->
<!-- EMOTIONAL DEPTH: Emotional (Personal) must NOT be a "confidence echo" of functional outcomes. -->
<!-- SOCIAL JOBS: If domain involves accountability/compliance/oversight, Emotional (Social) jobs are MANDATORY. -->

### Theme: [Next Theme Name — user concern area]

**Current Alternative:** [How users accomplish this today]

| MoSCoW | Core Job | Job Step | Desired Outcome | Job Type |
|--------|----------|----------|-----------------|----------|
| ... | ... | ... | ... | ... |

---

<!-- ONLY include Phase Summary if MoSCoW has been assigned. Omit this section if all values are [TBD]. -->

## Phase Summary

| Phase | MoSCoW | Themes | Unique Core Jobs | Job Steps | Description |
|-------|--------|--------|-----------------|-----------|-------------|
| **MVP** | Must | [N] | [N] | [N] | [1-line: what the MVP enables users to do] |
| **Phase 2** | Should | [N] | [N] | [N] | [1-line: what Phase 2 adds to the experience] |
| **Phase 3** | Could | [N] | [N] | [N] | [1-line: what Phase 3 enhances] |
| **Deferred** | Won't | [N] | [N] | [N] | [1-line: what's excluded and why] |

<!-- Unique Core Jobs: count distinct jobs, not persona variants. -->
<!-- If the same job applies to multiple personas with different access scope, count as 1. -->

**Total:** [N] Themes, [N] Unique Core Jobs, [N] Job Steps across all phases.

---

## Non-Functional Constraints

<!-- Capture cross-cutting constraints that apply across all jobs but are NOT standalone themes. -->

| Constraint | Applies to | Notes |
|------------|-----------|-------|
| [e.g., Cross-device access] | All jobs | [e.g., Users need to perform jobs from mobile, tablet, and desktop] |
| [e.g., Error resilience] | All jobs | [e.g., Users must not lose progress when system errors occur] |

---

## Assumptions & Open Questions

<!-- List any assumptions made during analysis and questions that need stakeholder input -->

| # | Type | Description | Impact |
|---|------|-------------|--------|
| 1 | Assumption | [What was assumed] | [What changes if assumption is wrong] |
| 2 | Open Question | [What needs clarification] | [Which jobs/priorities are affected] |
| 3 | Open Question — Current Alternatives | [Jobs where current workaround is unknown] | [Affects prioritization of those jobs] |

````
