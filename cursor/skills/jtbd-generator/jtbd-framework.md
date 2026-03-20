# JTBD Framework Reference — Ulwick's ODI

Reference material for the JTBD Generator skill. Read this when you need detailed rules or examples for structuring jobs.

---

## Hierarchy Definition

```
Theme
  └── Core Functional Job
       └── Job Step
            └── Desired Outcome
```

### Theme

A broad domain area that groups multiple related Core Jobs. Themes describe what the **user** cares about, never what the **product** contains.

**Rules:**
- Noun phrase (not a sentence)
- Represents a user concern area, not a product module or feature area
- 3–8 themes per analysis is typical
- A theme with only one Core Job is acceptable but worth questioning — it may belong elsewhere
- System qualities (resilience, accessibility, performance) are NEVER themes — see "Non-Functional Constraints" below

**The backlog test:** If the theme name could be a section header in a product backlog or feature list, it's wrong. Rename it to the user concern it serves.

**Good:** Workforce Accountability, Incident Reconstruction, Trust in Operational Data, Organizational Context
**Bad:** GPS Module, Dashboard Features, Push Notification System, Report History & Retrieval, Error Recovery, Cross-Device Accessibility

**Theme naming transformations:**

| Feature-area name (wrong) | User-concern name (right) |
|---------------------------|--------------------------|
| Report History & Retrieval | Auditability & Evidence Reconstruction |
| Data Scope & Accuracy | Trust in Operational Data |
| Site Tags Management | Organizational Context & Categorization |
| Error Recovery & Resilience | (not a theme — fold outcomes into the interrupted job) |
| Cross-Device Accessibility | (not a theme — note as consumption constraint) |
| Performance & Scalability | (not a theme — fold "minimize wait time" into relevant job outcomes) |

### Non-Functional Constraints Are Not Themes

Some requirements describe **how** the product delivers value across all jobs, not a distinct **job** the user does. These are non-functional constraints, not themes.

**Do not create themes for:**
- Error handling / resilience → Fold "don't lose my work" and "let me retry" outcomes into the job that was interrupted
- Cross-device / responsive → Note as a consumption constraint in Assumptions
- Performance / speed → Fold "minimize wait time" into relevant job step outcomes
- Accessibility → Note as a non-functional requirement

When inputs describe these areas, capture the *outcomes they serve* under the actual job the user was performing.

### Core Functional Job

The primary task the user is trying to accomplish. This is the "job" they "hire" a product to do.

**Rules:**
- Format: "When [situation/trigger], [persona] wants to [job verb phrase]"
- Must be solution-agnostic — no UI elements, features, or product names
- The `[situation/trigger]` must describe a moment in the user's **work/life**, not a moment in the **product**
- Stable over time — the job exists regardless of what product is used
- One persona per job statement (if two personas have the same job, write it twice — but see Persona Commitment below)
- 2–6 Core Jobs per Theme is typical

**Solution-Agnostic Litmus Tests:**

1. **"Delete the Product" test:** If the product didn't exist, would this job still need to get done? If yes, the job is correctly framed. If the job only makes sense in the context of the product (e.g., "retrieve a past report"), it's a feature disguised as a job.

2. **"Life Context" test:** Does the situation describe the user's work/life trigger ("a client VP calls asking about a vacant post") or a product trigger ("opening the report history screen")? It must be the former.

3. **"10-Year" test:** Would this job statement still be valid in 10 years, even if the technology changes completely? If the job is tied to current product concepts (reports, downloads, dashboards), it won't survive.

**Good examples:**
- "When a client asks about a past incident, the admin wants to reconstruct what happened at that site"
- "When starting a shift, the security officer wants to confirm their post assignment"
- "When an incident occurs on site, the officer wants to report it accurately and quickly"
- "When reviewing team performance, the supervisor wants to verify attendance compliance"

**Bad examples (with rewrites):**

| Solution-aware (fails litmus tests) | Solution-agnostic (passes) | Why it fails |
|--------------------------------------|---------------------------|--------------|
| "wants to find and retrieve a past report" | "wants to reconstruct past events at a site without re-gathering data from scratch" | The "report" is the product's solution, not the user's job |
| "wants to ensure the request parameters are valid" | "wants to avoid wasting time on a request that won't produce useful results" | Nobody wakes up wanting to "validate parameters" — they want to avoid wasted effort |
| "wants to generate or access reports from any device" | Remove — this is a consumption constraint, not a job | Cross-device access describes *how* a job is done, not *what* job is done |
| "wants to recover and try again after a system error" | Fold into the original job: add outcome "Minimize the effort to resume after an interruption" | Error recovery isn't a standalone job; it's a failure mode of the real job |
| "The officer wants to use the check-in button" | "The officer wants to confirm they've arrived at their assigned post" | Button is a solution; arrival confirmation is the job |
| "Handle post assignments" | "When starting a shift, the officer wants to confirm their post assignment" | Missing situation, persona, and framed as system action |

### Persona Commitment Rule

**Every identified persona must appear throughout the analysis or be consolidated.**

- If two personas share the same jobs but differ only in access scope (e.g., admin sees all sites, manager sees one site), **consolidate** them into one persona and note the access-level difference in Assumptions
- If two personas have genuinely distinct jobs, **both must appear** across multiple themes — not just one

After drafting the full JTBD table, do a **persona coverage check**: count how many themes each persona appears in. A persona that appears in fewer than half the themes is either missing jobs or should be consolidated.

### Job Step

A discrete phase within executing the Core Job. Maps to the universal job map (define → conclude) but not every step applies to every job.

**Rules:**
- Verb phrase (action-oriented)
- Represents a step the user takes, not a system action
- Ordered by natural execution sequence
- 2–8 steps per Core Job is typical
- Each step gets its own MoSCoW rating

**Good examples:**
- Verify current location matches assigned post
- Review post-specific safety instructions
- Acknowledge receipt of assignment details
- Record arrival time at post

**Bad examples:**
- GPS verification (noun, not a verb phrase)
- The system validates the location (system action, not user step)
- Click the confirm button (solution-specific)

### Desired Outcome

A measurable statement of what success looks like when executing a Job Step.

**Rules:**
- Format: "[Direction] the [metric] of [object]"
- Direction is one of: Minimize, Increase, Reduce, Maximize
- Must be measurable (even if the metric is qualitative like "confidence" or "likelihood")
- One outcome per row (a step can have multiple outcomes across rows)
- Outcomes should not reference solutions

**Direction guide:**

| Direction | Use when |
|-----------|----------|
| Minimize | Time, effort, errors, likelihood of failure, steps required |
| Increase | Confidence, accuracy, visibility, completeness, likelihood of success |
| Reduce | Risk, confusion, dependency on others, manual intervention |
| Maximize | Coverage, clarity, autonomy, awareness |

**Good examples:**
- Minimize the time to confirm location match
- Increase the likelihood of noticing critical post instructions
- Reduce the risk of missing a shift start time
- Minimize the number of steps to report an incident

**Bad examples:**
- Make it faster (not measurable, no object)
- Show a green checkmark (solution-specific)
- The officer feels good (not structured, not measurable)

---

## Job Types

| Type | What it captures | When to use | Outcome format |
|------|-----------------|-------------|----------------|
| **Functional** | The practical task | Always — every core job has functional aspects | Standard: Minimize/Increase the [metric] of [object] |
| **Emotional (Personal)** | How the user wants to feel | When inputs reveal anxiety, confidence, frustration, or pride | "Increase the feeling of [emotion] when [context]" or "Minimize the anxiety of [context]" |
| **Emotional (Social)** | How the user wants to be perceived by others | When users report to others, defend decisions, or demonstrate diligence | "Increase the perception of [quality] by [audience]" or "Minimize the likelihood of appearing [negative quality] to [audience]" |

**Guidelines:**
- Every Core Job should have at least one Functional job step
- Emotional jobs are captured only when the inputs support them — never fabricate
- Emotional outcomes are placed as separate rows under the relevant Job Step
- A single Job Step can have both a Functional and an Emotional outcome

### Emotional (Personal) — Depth Over Formulas

**Anti-pattern: "Confidence echo"**

The most common mistake is mechanically adding "Increase confidence that [functional outcome]" as the Personal emotional job for every functional outcome. This adds zero insight — it's the functional outcome restated with the word "confidence" prepended.

| Formulaic (low value) | Genuine (high value) |
|-----------------------|---------------------|
| "Increase confidence that the data is complete" | "Reduce the dread of discovering a coverage gap after making a client commitment" |
| "Increase confidence that the data covers only their site" | "Minimize the worry that they'll be held accountable for another site's problems" |
| "Reduce the anxiety that work was lost due to the error" | "Minimize the frustration of repeating tedious selections after an unexpected failure" |
| "Increase confidence that re-obtained data matches original" | "Reduce the fear that presenting changed numbers will undermine their credibility" |

**Rule:** If the Emotional (Personal) outcome is just "Increase confidence that [functional outcome]" — rewrite it. Ask: what *specific* feeling does the user have? Dread, frustration, relief, pride, fear of blame? Name it.

### Emotional (Social) — Mandatory for Accountability Domains

Products where users **report to others, defend decisions, or demonstrate diligence** always carry Social emotional jobs. These are often the most powerful unmet needs in compliance, oversight, and security products — and they're the most commonly omitted from JTBD analyses.

**If the domain involves ANY of these patterns, Emotional (Social) jobs are MANDATORY:**
- Reporting upward (to management, clients, regulators)
- Compliance and auditing
- Performance oversight or accountability
- Incident investigation or post-mortems
- Defending recommendations or decisions

**Emotional (Social) outcome format:**
- "Increase the perception of [positive quality] by [audience]"
- "Minimize the likelihood of appearing [negative quality] to [audience]"

**Examples for a security/compliance domain:**

| Core Job context | Emotional (Social) Outcome |
|-----------------|---------------------------|
| Reconstructing past events for a client inquiry | "Minimize the likelihood of appearing uninformed when a client VP asks about a vacant post" |
| Reviewing compliance data before a quarterly meeting | "Increase the perception of diligence during a compliance review" |
| Investigating an officer's location violations | "Increase the credibility of evidence presented to resolve a staffing dispute" |
| Identifying unattended posts across sites | "Minimize the risk of being the last person to know about a coverage failure" |

**An analysis of an accountability/compliance product with zero Emotional (Social) jobs is incomplete.**

**Example with all three types:**

| MoSCoW | Core Job | Job Step | Desired Outcome | Job Type |
|--------|----------|----------|-----------------|----------|
| Must | When a client asks about a past incident, the admin wants to reconstruct what happened at that site | Determine which officers were on duty during the incident window | Minimize the time to identify the responsible officers | Functional |
| Must | | | Reduce the fear of presenting incomplete information to the client | Emotional (Personal) |
| Must | | | Minimize the likelihood of appearing uninformed when the client asks follow-up questions | Emotional (Social) |
| Should | | Assess the severity and duration of the incident | Minimize the effort to quantify the impact | Functional |

---

## MoSCoW at Job Step Level

Priority lives on the Job Step row. A Core Job's effective priority is its highest-priority step.

**Example:**
- Core Job: "When starting a shift, the officer wants to confirm their post assignment"
  - Job Step: "Verify location" → Must
  - Job Step: "Review instructions" → Should
  - Job Step: "Log arrival for supervisor" → Could
  - **Core Job effective priority: Must** (inherited from its Must step)

This means the Core Job appears in the MVP (because it has Must steps) but not all of its steps are in the MVP.

**Phase mapping:**

| MoSCoW | Phase | Implication |
|--------|-------|-------------|
| Must | MVP | Ship without this and the product fails its core purpose |
| Should | Phase 2 | Users expect this; absence is noticeable but not blocking |
| Could | Phase 3 | Enhances experience; absence doesn't cause complaints |
| Won't | Deferred | Consciously excluded; document the reason |

---

## Completeness Check: Universal Job Map

Use these 8 steps as a lens, not a template. Check each against the Core Job and ask "does the user need to do this?"

| # | Step | Question to ask |
|---|------|----------------|
| 1 | Define | Does the user need to determine what needs to be done? |
| 2 | Locate | Does the user need to find information or resources? |
| 3 | Prepare | Does the user need to set up before executing? |
| 4 | Confirm | Does the user need to verify readiness? |
| 5 | Execute | What is the core action? |
| 6 | Monitor | Does the user need to track progress or status? |
| 7 | Modify | Might the user need to make adjustments? |
| 8 | Conclude | How does the user finish and hand off? |

Not every job has all 8. A simple job might only have Confirm + Execute. A complex job might have all 8.

---

## Current Alternatives

For each Core Job, identify what users do *today* to get the job done — before or without the product. This is what makes JTBD useful for prioritization beyond what a requirements doc provides.

**Why it matters:**
- **Overserved jobs** — Current workaround is adequate → low priority to digitize
- **Underserved jobs** — Current workaround is painful, manual, or impossible → high value to improve
- **Non-consumption** — Users don't attempt the job at all today → indicates a latent need or low importance

**How to capture:**
- Add an optional "Current Alternative" column to the JTBD output table
- If inputs describe current workflows, note them per Core Job
- If inputs don't describe current state, add an open question: "What do users currently do to [job]?"

**Examples:**

| Core Job | Current Alternative |
|----------|-------------------|
| Reconstruct what happened at a site during a past incident | Manually compile data from multiple systems; call operations managers for verbal reports |
| Identify posts left unattended across multiple sites | Review individual site logs; rely on site managers to self-report gaps |
| Verify officer location compliance | No systematic method — discovered reactively when clients complain |

---

## Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Writing features as jobs ("find and retrieve a past report") | Apply the "Delete the Product" test; rewrite from the user's life context ("reconstruct what happened at a site") |
| Outcomes without metrics | Add a measurable dimension: time, likelihood, count, effort |
| Mixing personas in one job | Split into separate Core Job statements, one per persona — or consolidate if they share the same job with different access |
| All jobs at same priority | Re-examine inputs; if truly equal, ask the user for differentiation |
| Themes that mirror product architecture ("Report History") | Rename to user concern areas ("Auditability & Evidence Reconstruction") |
| Non-functional constraints as themes ("Error Recovery", "Cross-Device") | Fold their outcomes into the actual jobs they serve; note constraints in Assumptions |
| Forcing all 8 job map steps | Only include steps supported by the inputs; mark gaps as [TBD] if suspected |
| Emotional jobs on every step as "confidence echoes" | Only where inputs provide evidence of specific emotional needs; never mechanically echo functional outcomes |
| Zero Emotional (Social) jobs in accountability domains | If users report to others or defend decisions, Social jobs exist — find them |
| Tokenized personas (appear once, vanish) | Every persona must appear throughout OR be consolidated; do a persona coverage check |
| Inflated Phase Summary counts | Distinguish unique jobs from persona variants when counting |
| No current alternatives captured | Identify what users do today; if unknown, flag as an open question |
