---
name: generate-pm-jd
description: Generate standardized Product Manager job descriptions for Robots & Pencils. Supports 4 variants (L3/L4 × Traditional PM / AI Builder PM). Walks the user through role context, renders an interactive skill checklist, and generates a complete JD in markdown. Use when someone wants to create a PM job description, write a JD for a product manager role, generate a PO/PM posting, build a job spec for a product owner, or customize a PM role description for a client engagement. Trigger on phrases like "create a PM JD", "write a job description for a product manager", "I need a JD for an L3", "generate a job posting for AI PM", "help me write a PM role description", or any mention of creating/writing job descriptions for product manager or product owner roles at R&P.
---

# Generate PM Job Description

You are helping a hiring manager at Robots & Pencils create a standardized Product Manager job description. R&P is a digital agency — PMs work on client engagements, not internal products.

## How This Skill Works

There are three phases:
1. **Gather context** — ask background questions to understand the role
2. **Render checklist** — show an interactive skill selector with smart defaults
3. **Generate JD** — produce the final job description from the user's selections

## Phase 1: Gather Context

Ask the user the following. Use the AskQuestion tool for structured choices and conversational follow-up for open-ended items.

**Structured questions (use AskQuestion):**

1. **Level**: L3 (Senior PM) or L4 (Principal PM)?
2. **Variant**: Traditional PM (AI-Leveraged) or AI Builder PM?

**Open-ended questions (ask conversationally, one at a time):**

3. **Client / project context**: What's the client, product, or problem space? (e.g., "Fleet logistics platform for a trucking company" or "AI-powered document processing for a law firm")
4. **Location & remote policy**: Where is this role based? Remote, hybrid, on-site?
5. **Industry / domain**: What industry does the client operate in? (e.g., logistics, healthcare, fintech, education)
6. **Key technologies**: Any specific tech stack or platforms? (e.g., AWS, React Native, LangChain)
7. **Anything special about this role?**: Any unique requirements, team structure notes, or context the JD should reflect?

Once you have answers to all questions, confirm back to the user:
- Level: L3 or L4
- Variant: Traditional or AI Builder
- Client/project summary (1 line)
- Location
- Industry
- Key technologies

Then proceed to Phase 2.

## Phase 2: Render the Skill Checklist

Generate an interactive HTML page that shows the skill inventory as an interactive checklist. The page must be built using the data and logic described below.

### Which inventory to show

- **L3**: Show Section C skills (C1–C9 for Traditional, C1–C7 + C8 + C9 for AI Builder)
- **L4**: Show Section D skills (D1–D9 for Traditional, D1–D7 + D8 + D9 for AI Builder)

For **Traditional PM**: Show categories C1–C7 (or D1–D7) plus C8/D8 (Leverage AI). Do NOT show C9/D9 (AI Builder).
For **AI Builder PM**: Show all categories including both C8/D8 (Leverage AI) AND C9/D9 (AI Builder).

### Skill data

Read the skill inventories from the references directory to get the complete skill lists:
- `references/l3-skills-inventory.md` — L3 skills (Section C)
- `references/l4-skills-inventory.md` — L4 skills (Section D)

Extract skill number, skill name (short — just the title before the em dash), and category for each skill.

### Badge logic (Must / Should / Could / n/a) — PER SKILL, not per category

**IMPORTANT: Badges are assigned per individual skill, not per category.** Within any category, different skills will have different badges depending on the engagement context. Use the user's answers from Phase 1 (client context, tech stack, industry, special requirements) to make per-skill judgments.

**Must** — The candidate needs this skill. Without it, project success is at risk — budget, scope, timeline, or client trust.
- Skills directly tied to the core problem being solved
- Skills the user explicitly called out in their context (e.g., if they mentioned union stakeholders, then stakeholder management with skeptical audiences is Must)
- Skills that are foundational to any PM role (e.g., backlog ownership, client relationship building)

**Should** — The candidate benefits from this skill. It accelerates their effectiveness and contributes to project success. They can build it quickly on the engagement, but starting with it is a clear advantage.
- Skills that support the engagement but aren't the core differentiator
- Skills where baseline competence is expected but mastery isn't required for this engagement

**Could** — Nice to have. The candidate can succeed on the project with or without this skill — no material impact either way.
- Skills that would be a bonus but aren't required for success on this engagement

**n/a** (not relevant — no badge):
- Skills that don't apply to this engagement at all. Examples:
  - "AI vendor and model selection" when the tech stack is already decided
  - "Conduct user research" when this is a defined-scope build, not a discovery engagement
  - "AI tool evaluation and selection" when the tools are already chosen
  - "AI prototypes as a persuasion tool" when the decision to build is already made
  - Internal R&P skills that don't belong in a client-facing JD (e.g., "Contribute to company knowledge sharing")
- These appear greyed out (not strikethrough) with an "n/a" label so the user can still override if needed

**Applying judgment per skill — examples:**

Within C3 (Execution & Delivery) for a phased-release project:
- "Coordinate phased rollouts and release management" → **Must** (phased approach is explicit)
- "Drive agile ceremonies" → **Should** (expected but not the differentiator)

Within C9 (AI Builder) when vendor is already chosen:
- "AI observability and monitoring" → **Must** (if observability tooling is in the stack)
- "AI vendor and model selection" → **n/a** (vendor already decided)

Within C7 (Competencies) for a project with skeptical stakeholders:
- "Communication — clear, structured communicator across audiences" → **Must**
- "Strategic thinking — connects problems to scalable solutions" → **Should**

### Badge logic for C10/C11 (Domain & Platform Awareness / Client Industry Expertise)

These sections are populated from the user's Phase 1 answers. Since the user explicitly provided this context as requirements for the role, **do NOT default these to Could**.

**C10 — Reframe from PM perspective:** Technology skills should be framed as PM-level awareness, not deep technical expertise. The PM needs to understand the tech enough to make informed product tradeoffs — they don't need to be an expert.

Examples of PM-framed tech skills:
- "Working understanding of AWS serverless services (Lambda, DynamoDB) to inform product tradeoffs" — not "AWS Lambda expertise"
- "Familiarity with voice AI and telephony systems to define requirements and acceptance criteria" — not "Amazon Connect expert"
- "Awareness of SAP integration patterns to coordinate data requirements with the client" — not "SAP developer"

Exception: If the user explicitly says they need someone who is an expert with a technology (e.g., "must be a Salesforce expert", "needs deep Shopify experience"), then frame it as expertise.

Assign Must/Should based on how central the technology is to the product:
- Technology that IS the product (e.g., voice AI for a voice AI callout system) → **Must**
- Supporting infrastructure the PM should understand → **Should**

**C11 — Assign based on user's stated context:** If the user mentioned specific industry concerns (e.g., "union stakeholders who may be skeptical", "compliance-oriented mindset"), these are **Must** or **Should**, not Could. The user told you this matters.

### Auto-check logic

Based on badge assignment:
- **Must** skills: checked by default
- **Should** skills: unchecked by default (user decides which to include)
- **Could** skills: unchecked by default
- **n/a** skills: unchecked by default

### Interactive checklist requirements

The HTML page should:
1. Group skills by category with the category brief as a subtitle
2. Each skill has a checkbox, the skill name, and a **per-skill** badge (Must/Should/Could/n/a)
3. Badge colors (pastel, non-distracting): **Must = pastel green**, **Should = pastel blue**, **Could = pastel yellow**, **n/a = light gray**
4. n/a skills appear greyed out (no strikethrough) with an "n/a" label — still checkable if the user wants to override
5. User can check/uncheck any skill
6. A "Copy Selection" button at the bottom generates a clean text block and copies to clipboard
7. Show a count of selected skills out of **relevant** skills (excluding n/a from the denominator), e.g., "34 of 52 relevant skills selected"
8. Use Tailwind CSS (via CDN)
9. Include a header showing: Level, Variant, Client context (from Phase 1)
10. Category headers show mini badge counts (e.g., "3M 2S 1C") so the user can see the mix at a glance without expanding
11. Each category has All/None quick-select buttons (All skips n/a skills)
12. "Select All" within a category should NOT check n/a skills

### Copy output format

When the user clicks "Copy Selection", generate this format:

```
PM JD Skill Selection
Level: [L3/L4]
Variant: [Traditional/AI Builder]
Client: [client context]
Location: [location]
Industry: [industry]
Technologies: [tech stack]

Selected Skills:
---
[Category Name]
- [Skill #] [Skill name]
- [Skill #] [Skill name]

[Category Name]
- [Skill #] [Skill name]
...
```

After rendering the checklist, tell the user: "Review the checklist, adjust any selections, then click 'Copy Selection' and paste the result back here. I'll generate the JD from your selections."

## Phase 3: Generate the JD

When the user pastes their skill selection back, generate a complete JD in markdown.

### Template selection

Read the appropriate template from references:
- Traditional PM: `references/pm-jd-template-traditional.md`
- AI Builder PM: `references/pm-jd-template-ai-builder.md`

### Generation rules

1. **Follow the template structure exactly** - same sections, same order, with the addition of a "Project Context" section (see rule 13)
2. **Fill in metadata** from Phase 1 context (title, location, domain, etc.)
3. **Write the "About the Role"** section focused on the role itself - what kind of PM this is, how they'll work, what success looks like. Do NOT put project details here (those go in Project Context).
4. **Map selected skills into responsibilities** - start from the template's responsibility sections (4a-4f), but split or add sections when the engagement demands it. For example, if the engagement has significant compliance/security concerns, break that into its own section rather than burying it under another heading. Similarly, "Technical Collaboration" and "Team Collaboration" can be separate if the role requires distinct guidance for each. Section names can be adjusted to fit the engagement (e.g., "AI Prototyping & Building" instead of "Hands-On AI Prototyping & Building"). Write responsibilities as action-oriented bullets, not as raw skill names.
5. **Use L3 or L4 language** - if L4, include the L4-specific bullets from the template. If L3, use only L3 bullets.
6. **Required Skills as a bullet list, not a table.** Use a clean scannable bullet list (one bullet per requirement) instead of a table. Tables are harder to scan on job boards and mobile. Include agile delivery practices and technical fluency as explicit bullets - HR benchmarking showed these are expected baseline items candidates look for.
7. **Populate Domain & Platform Awareness** from the user's technology context - framed from PM perspective (see C10 badge logic above). Use "may leverage" hedging language (e.g., "Systems delivered in this environment may leverage technologies such as:") to signal these are engagement-specific, not hard requirements.
8. **Populate Competencies as a two-column table** (Competency | What it looks like) from the selected C7/D7 skills. Each row should have a short competency name and a 1-2 sentence description grounded in the engagement context - not generic definitions. Weave relevant soft skills into the descriptions (see rule 21).
9. **Omit "Why This Role Matters" and "Impact & Scope"** - the About the Role and Project Context sections already cover this. Do not add redundant motivational or scope sections.
10. **Omit unselected skills** - if a skill wasn't selected, it should not appear in the JD
11. **Do NOT include skill numbers** in the final JD - these are internal references only
12. **NEVER name the client in the JD** - this is an agency role and client names are confidential. Use "the client", "a major [industry] company", or similar generic references. The JD may be shared publicly (job boards, LinkedIn), so no identifying client details should appear anywhere in the output.
13. **R&P PMs are consultants, not product owners.** The client's product team owns the product and its direction. R&P PMs guide, advise, and help the client succeed - they don't "own" the product. Use consulting language throughout:
    - **Good**: "Partner with the client to shape product vision", "Guide product strategy", "Work with the client to define roadmap", "Help clients articulate outcomes", "Advise on prioritization decisions"
    - **Bad**: "Define product vision" (implies ownership), "Own product strategy" (client owns), "Set the roadmap" (client approves), "Decide priorities" (consultant advises, client decides)
    - Similarly, Delivery Managers/Leads own project delivery (timelines, resourcing, risk), not the PM. Reference partnering with both the client's product team and the Delivery Manager where relevant.
14. **Add a "Project Context" section** immediately after "About the Role". Section order is: Metadata → About the Role → Project Context → Key Responsibilities → ... This section describes the engagement the PM may support, framed with soft language like "One of the key initiatives this role may support involves..." - keeping it non-committal since agency PMs can move between engagements. Put all project/product details here (what is being built, for whom, the problem space, tech approach). Keep "About the Role" focused on the role itself (how the PM will work, what success looks like, team structure).
15. **Avoid repeating the same point in multiple sections.** If union dynamics are mentioned in Stakeholder Management, don't also mention them in About the Role. Each section should add new information, not echo previous sections.
16. **Responsibility bullets should use PM language, not engineering language.** PMs "define" governance requirements, they don't "implement" them. PMs "drive" the product lifecycle, they don't "own delivery."
17. **Agency/consulting experience placement depends on engagement context.** If the engagement has complex client dynamics, multi-stakeholder environments, or requires operating without direct authority, agency/consulting experience should be in Required Skills. If the engagement is more straightforward, it can be in Preferred Qualifications. Use judgment based on the client context provided in Phase 1.
18. **Use "Partner" language for collaborative work.** Wherever the PM collaborates with others who own or co-own the work, use "Partner with [role]" language:
    - "Partner with engineering" when engineering implements systems, builds infrastructure, or owns technical decisions
    - "Partner with the Delivery Manager" when coordinating rollouts, managing scope/timeline expectations, or having difficult conversations (DM owns P&L and delivery)
    - "Partner with UX/UI" when testing prototypes or validating interaction patterns
    - "Partner with the client" when shaping vision, defining roadmap, or making strategic decisions
19. **Order bullets by lifecycle, not importance.** Within each responsibility section, order bullets to follow the natural workflow:
    - Product Strategy: Vision → Outcomes → Prioritization/Scoping → Requirements → Execution planning
    - Discovery: Research → Criteria → Experiment → Validate → Synthesize
    - Hands-On AI Building: POC → Eval → UX → Production path → Operations → Security → Governance → Metrics
    - Delivery: Metrics → Backlog → Lifecycle → Demos → Rollouts → Handoff
    - Stakeholder Management: Build trust → Serve as advisor → Manage expectations → Facilitate decisions → Push back → Educate → Grow account
20. **Always include "Consultative Mindset" in Competencies.** This is a key differentiator for consulting PMs - the ability to think beyond immediate deliverables, see around corners for the client, and surface risks and opportunities proactively. This was a gap identified in review.
19. **Keep the JD scannable.** Target ~90-100 lines. Consolidate bullets that cover related ground (e.g., AI observability + cost optimization = one "production AI operations" bullet). A Senior PM scanning this should not see repetition.
20. **Competencies format: Use "How You Work" with simple bullet list.** Replace the two-column table (Competency | What it looks like) with a simple bullet list under the heading "How You Work". Write behaviors (what you do) not traits (who you are). Each bullet should be 8-15 words, action-oriented, and scannable. Target 8-10 bullets. Example: "Question assumptions and see around corners to surface risks before they become problems" not "Strategic thinker who questions assumptions..."
21. **Include a "Why Join R&P?" closing section.** A brief 2-3 sentence section at the end that speaks to R&P's culture and what makes the role compelling. Keep it grounded and specific - avoid generic boilerplate. Focus on the intersection of client impact, modern tech, and collaborative team culture.
22. **Soft skills belong in "How You Work", not a separate section.** Weave key soft skills into the behavior descriptions rather than creating a standalone "Soft Skills" section. This avoids redundancy while ensuring they're visible.
22. **Preferred Qualifications capture engagement-specific nice-to-haves.** This section holds qualifications that are valuable for the current engagement but not required for the role. Typically: software engineering/coding background, agency or consulting experience (if not required), specific platform experience (e.g., Amazon Connect, Twilio), industry background (e.g., utilities, union workforce), and supporting tech familiarity (e.g., AWS serverless, SAP). Keep it to 4-6 bullets. If something is truly required, it belongs in Required Skills, not here.
23. **Job title should reflect the PM's role at R&P, not the current engagement.** Use generic titles like "Senior Product Manager, AI" or "Principal Product Manager, AI" - not engagement-specific titles like "Senior Product Manager, Conversational AI" or "Senior Product Manager, Fleet Logistics." The PM may rotate to a different engagement once this one concludes. Engagement-specific context belongs in the Project Context section, not the title.
24. **Use hyphens (-) not em dashes (—).** Write naturally - humans don't commonly use em dashes. Use regular hyphens for all punctuation throughout the JD.
25. **AI Builder PM coding requirements:** For AI Builder PMs, emphasize "prototyping with AI tools" rather than traditional coding. The intent is for them to leverage AI coding tools (Cursor, Claude, Copilot) to generate prototypes, not code from scratch in Python/JS/TS. Frame Required Skills as: "Strong technical fluency and comfort with code - can read and understand code, evaluate technical architectures, and determine product tradeoffs based on technical constraints." Coding background (Python, JS, TS) is beneficial (list in Preferred Qualifications), but strong understanding and familiarity with code is sufficient. AI Builder PMs should "prototype with AI tools to prove value and de-risk product decisions" - they're not traditional software engineers.
26. **Distinguish PM from AI Engineer roles.** For AI Builder PMs, clarify that they prototype to validate hypotheses and align stakeholders, not to build production infrastructure. Add clarifying language to "About the Role": "You'll leverage AI coding tools to rapidly build prototypes that align stakeholders and accelerate learning, not to build production infrastructure." In responsibilities, emphasize "using AI coding tools to validate product hypotheses" and "partner with engineering to scale" - this signals the PM builds to prove, engineers build to ship.
27. **Experience requirements for L4.** For L4 roles, require "8+ years of product management experience with demonstrated strategic thinking and hands-on execution; must have delivered AI products from prototype through production at scale." Do NOT require software engineering background. Do NOT require agency/consulting experience (can be preferred). DO require "Experience working with senior stakeholders including Directors, VPs, and C-level executives." This opens the candidate pool to strong PMs from product companies who've built AI systems but haven't done consulting.

### Consolidation principles (apply during generation)

When mapping skills to JD sections, apply these principles to keep the JD scannable:

**Principle 1: Load-Bearing Test** - If removing a bullet wouldn't change the candidate's understanding of success, consolidate or cut it.

**Principle 2: One Job Per Bullet** - Each bullet should have a single clear job. Consolidate bullets that touch the same outcome area (e.g., AI observability + cost monitoring + failure detection = one "production AI operations" bullet).

**Principle 3: Avoid Repetition Across Sections** - If a skill appears in Responsibilities AND Required Skills, pick one place. Don't say the same thing twice.

**Principle 4: Cognitive Load Management** - Keep responsibility sections to 5-8 bullets each. 10+ bullets in a section is unreadable. Split large sections (e.g., "Hands-On AI Building" + "Delivery & Execution" instead of one 20-bullet mega-section).

**Principle 5: Specificity Over Comprehensiveness** - Favor engagement-specific bullets over generic PM work. "Prove value in 4-week cycles; test assumptions Week 1 not Week 3" beats "Prioritize based on business value."

**Principle 6: Production-Readiness for AI Builder** - For AI Builder roles, consolidate prototyping skills into one bullet, then emphasize production depth (observability, security, governance, cost optimization, scaling).

**Examples of good consolidation:**
- "Build prototypes" + "Define path to production" → "Build functional AI prototypes to validate product hypotheses; define the path from POC through pilot to production-ready system and partner with engineering to scale"
- "Observability" + "Monitoring" + "Costs" + "Failure modes" → "Implement production AI operations - observability, monitoring (prompts, latency, token usage, costs), failure detection, and model drift management"
- "Security" + "Privacy" + "Governance" → "Define AI security and governance frameworks - data retention policies, regulatory compliance, access controls, and prompt injection prevention"
- "Backlog" + "Scope" + "Dependencies" + "Documentation" → "Manage the product backlog, scope, dependencies, risks, and blockers; produce high-quality documentation (PRDs, product briefs, decision logs) that sets the standard for the engagement"

**Target lengths:**
- Responsibility sections: 5-8 bullets each
- Required Skills: 9-12 bullets max
- How You Work: 8-10 bullets max
- Total JD: ~90-100 lines (excluding Why Join R&P)

### Bullet-level decision principles

Apply these tests to every bullet when generating or reviewing JD sections:

**1. The 5-Second Scan Test:** Can someone understand the main point in 5 seconds? If not, simplify or split.

**2. The "So What?" Test:** If removed, would the candidate misunderstand something critical? If no, remove it.

**3. The Repetition Smell Test:** Am I saying the same thing in different words? If yes, consolidate.

**4. The Junior PM Test:** Would a junior PM think "that's obvious"? If yes, remove or make it engagement-specific.

**5. The Laundry List Smell Test:** Am I listing 5+ examples to prove domain knowledge? If yes, consolidate to the outcome instead.

**6. The Semicolon Smell Test:** Is this semicolon joining related ideas, or cramming two jobs into one bullet? If two jobs, split them.

**7. The Engagement-Specific Test:** Does this tell me something unique about THIS engagement, or could it appear in any PM JD? Favor specific over generic.

**8. The "Who Does This?" Test:** Who actually performs this work - PM, engineering, design, DM, or client? Use "Partner with [role]" when collaboration is needed.

**9. The Cognitive Chunking Test:** Can I hold this section in working memory (5-8 bullets), or do I lose track? If 10+ bullets, split the section.

**10. The Action Verb Test:** Does this bullet describe an action (what you do), or a trait (who you are)? For "How You Work", always use actions.

**11. The Mobile Preview Test:** On a phone screen, will this bullet wrap into 4+ lines? If yes (20+ words), simplify.

**12. The Lifecycle Flow Test:** Do bullets in this section tell a coherent story in sequence? If they jump around, reorder by workflow.

### Priority hierarchy for conflict resolution

When bullet-level principles conflict, apply this hierarchy (highest priority first):

**Tier 1: Accuracy & Role Clarity** (Always wins)
- Correct ownership/partnership language (Rule 13, 18)
- PM vs. Engineer distinction (Rule 26)
- "Who Does This?" Test

**Tier 2: Candidate Understanding** (Second priority)
- "So What?" Test - critical for understanding success
- Engagement-Specific Test - helps candidates self-select
- Lifecycle Flow Test - sequence aids comprehension

**Tier 3: Scannability** (Third priority)
- 5-Second Scan Test
- Cognitive Chunking Test (5-8 bullets per section)
- Repetition Smell Test

**Tier 4: Polish & Professionalism** (Fourth priority)
- Mobile Preview Test (<20 words)
- Action Verb Test (behaviors not traits)
- Semicolon Smell Test (one job per bullet)
- Laundry List Smell Test

**Tier 5: Junior PM Test** (Tiebreaker only)
- Use to remove obvious + generic content
- Never remove engagement-specific context just because it seems obvious

**Decision tree for conflicts:**
1. Does it misrepresent the role (ownership, collaboration)? → Fix it (Tier 1)
2. Does removing it affect candidate understanding of success? → Keep it (Tier 2)
3. Does it make the JD harder to scan (too long, repetitive, 10+ bullets)? → Simplify (Tier 3)
4. Is it unprofessional or mobile-unfriendly? → Polish it (Tier 4)
5. Is it obvious to a junior PM AND not engagement-specific? → Consider removing (Tier 5)

**When to apply this hierarchy:**
- During initial generation when mapping skills to bullets
- When reviewing sections with 10+ bullets (need to consolidate)
- When a bullet feels too long but contains critical information (split vs. simplify)
- When deciding whether to use "Partner with" or solo verb
- When choosing between detailed examples and outcome statements

**Golden rule:** Accurate and understandable beats scannable and polished. But scannable and polished beats verbose and complete.

### Output

Save the generated JD as a markdown file in the user's workspace folder. Name it descriptively: `[client]-[level]-[variant]-jd.md` (e.g., `acme-l3-traditional-jd.md`).

Share the file path with the user and offer to make adjustments.

## Reference Files

All reference files are in the `references/` directory relative to this skill:

- `references/l3-skills-inventory.md` — Complete L3 skill inventory with categories C1–C11
- `references/l4-skills-inventory.md` — Complete L4 skill inventory with categories D1–D11
- `references/pm-jd-template-traditional.md` — JD template for Traditional PM variant
- `references/pm-jd-template-ai-builder.md` — JD template for AI Builder PM variant

Read the appropriate inventory and template files when needed — don't try to hold all of them in memory at once.
