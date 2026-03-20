# Workflow 2: Generate Requirements Documents

**Called from:** `workflows/01-synthesize.md` after user approves Context Summary
**Next step:** `workflows/03-validate.md` after documents are generated
**Reads:** `requirements/[feature-name]/Context-Summary-[Feature-Name].md`
**Outputs:**
- `requirements/[feature-name]/Feature-Requirements-[Feature-Name].md` (always)
- `requirements/[feature-name]/API-Contract-[Feature-Name].md` (if APIs in scope, Comprehensive)
- `requirements/[feature-name]/System-Flow-[Feature-Name].md` (if integrations in scope, Comprehensive)

---

## 🎯 Purpose

Convert the validated Context Summary into 1–3 polished requirement documents.
All documents are saved as files. Mode and scope were determined in SKILL.md.

---

## 🔧 Execution Mode Rules

| Mode | Documents | Word limits | Attribution |
|------|-----------|-------------|-------------|
| **Quick** | Feature Requirements only | 1,500–2,000 words | Tier 1 only |
| **Comprehensive** | Requirements + API Contract (if APIs) + System Flow (if integrations) | Requirements: 2,500–3,000 / API: 1,000–1,500 / Flow: 800–1,200 | Tier 1 + Tier 2 (60%+) |

---

## 📖 Step 1: Read Context Summary

Read the saved Context Summary file:
```
requirements/[feature-name]/Context-Summary-[Feature-Name].md
```

Validate before proceeding:
- [ ] All required contexts are present (3 for Quick, 6 for Comprehensive)
- [ ] Mode is clearly stated
- [ ] Source coverage meets threshold (Tier 1 minimum)
- [ ] EXISTING vs NEW classification present (if applicable)

If the file is missing or incomplete, ask the user to re-run Workflow 1 or provide missing context.

---

## 📊 Step 2: Determine Required Documents

**Quick Mode:** Always generate Feature Requirements only. Skip steps 4 and 5.

**Comprehensive Mode — use this decision matrix:**

| Technical Context includes… | Generate |
|------------------------------|---------|
| No APIs, no integrations (UI only) | Feature Requirements only |
| APIs (new or modified) | Feature Requirements + API Contract |
| Integrations (external systems) | Feature Requirements + System Flow |
| APIs + Integrations | Feature Requirements + API Contract + System Flow |

State upfront which documents you'll generate:
```
📄 Documents to generate:
1. Feature Requirements ✅ (always)
2. API Contract ✅ / ❌ — [reason]
3. System Flow ✅ / ❌ — [reason]
```

---

## 📝 Step 3: Generate Feature Requirements (ALWAYS)

**Template:** `templates/feature-requirements.md`

**Language rules (enforce strictly):**
- ✅ "System must generate the report within 60 seconds" — factual requirement
- ❌ "System should consider performance optimization" — opinion
- ✅ Plain English only
- ❌ No code snippets, SQL, class names, or implementation details
- ✅ "As a [persona], I need [capability] so that [outcome]" for user-facing requirements
- ❌ No vague words: "should", "probably", "might", "could"

**Requirement purity rules (enforce strictly):**
- ✅ Requirements describe WHAT (capability or constraint), never HOW (implementation) or WHAT IT LOOKS LIKE (UI pattern)
- ❌ "Cache schedule data locally for offline access" — this is a SOLUTION. Reframe: "Schedule must remain viewable when offline"
- ❌ "Organize schedule as Past | This Week | Future tabs" — this is a DESIGN DECISION. Reframe: "Officer can navigate across past, current, and future weeks"
- ✅ If a statement prescribes an implementation approach, reframe it as the underlying need and add an **Implementation Note** callout
- ✅ If a statement prescribes a UI pattern or layout, move it to **Open Questions / Design Decisions** unless the user explicitly confirmed the design
- ✅ When citing `(Source: SRC-N)`, the source must actually contain the claimed information — do not attribute content to a source that does not say it

**Sections to include (adapt; skip if not applicable):**

### 1. Executive Summary (3–4 sentences)
- What the feature does
- Why it exists (business value)
- Who uses it
- Priority / timeline (if known)

### 2. Business Context
- Business goals (with sources)
- Success metrics (measurable KPIs)
- Constraints (budget, timeline, regulatory)

**Tier 1 attribution required: 100%**

### 3. User Context
- Primary personas (specific roles, not "user")
- User needs and pain points
- High-level user journey

**Tier 1 attribution required for persona info**

### 4. UX Context *(Frontend/Mobile only — skip for Backend)*
- Design asset references (Figma links with `/m=dev`)
- User flows (numbered steps)
- Visual states: empty, loading, success, error, no-data
- Key interactions (trigger → action → feedback)
- Responsive behavior (desktop / tablet / mobile)

### 5. Technical Context
- System architecture (high-level)
- Technology stack (relevant)
- APIs / Endpoints summary (detailed specs in API Contract)
- Data model (key entities)
- Integration points (external systems)
- Performance requirements (timeouts, concurrency limits)

**Tier 1 attribution required for performance and constraints**

### 6. Compliance & Constraints *(Comprehensive only)*
- Regulatory requirements or N/A
- Security requirements (auth, data protection)
- Accessibility (WCAG level or N/A)
- Browser/device support
- Backward compatibility statement

**Tier 1 attribution required for regulatory and security**

### 7. Functional Requirements (Detailed)

For each requirement use this structure:

```
#### FR-[N]: [Requirement Name]

**Description:** [What this requirement enables — user value]

**Inputs:** [What goes in]

**Outputs:** [What comes out]

**Business Rules:**
- [Rule 1] (Source: [reference])
- [Rule 2] (Source: [reference])

**Validation:**
- Frontend: [What frontend validates]
- Backend: [What backend validates]

**Source:** [Document/person, date]
```

### 8. Error Handling

```
| Error Type | Cause | User Experience | System Behavior |
|------------|-------|-----------------|-----------------|
| [Type] | [Cause] | [What user sees] | [What system does] |
```

### 9. Backward Compatibility *(include ONLY if EXISTING features modified)*

```
**Changes Overview:** [What's being modified]

**Breaking Changes:** [List any]
- Impact: [Who is affected]

**Non-Breaking Changes:** [List]

**Migration Strategy:** [If breaking changes exist]

**Recommendation:** [Minimum-impact approach]
```

### 10. Known Limitations
- [Limitation — reason]

### 11. Assumptions & Dependencies

```
| Dependency | Owner | Status | Risk |
|------------|-------|--------|------|
| [Item] | [Team] | [Status] | HIGH/MED/LOW |
```

### 12. Related Documents
- API Contract: [path if exists]
- System Flow: [path if exists]
- Design files: [links]

---

**Save file:** `requirements/[feature-name]/Feature-Requirements-[Feature-Name].md`

---

## 🔌 Step 4: Generate API Contract *(Comprehensive mode, APIs in scope only)*

**Choose approach based on complexity:**

- **Simple API (1–3 endpoints, well-understood):** Generate inline using `templates/api-contract.md`
- **Complex API (4+ endpoints, or existing patterns need matching):** Consider using the `rest-api-contract-generator` skill for deeper pattern analysis. Say: "For detailed API contract generation that matches your existing codebase patterns, you can also run the `rest-api-contract-generator` skill separately."

**Generate using `templates/api-contract.md` as structure reference.**

**Sections:**

### API Overview
- Summary (2–3 sentences)
- Endpoints table: `| Endpoint | Method | Purpose | Auth Required |`

### Authentication & Authorization
- Auth type (Bearer/JWT/API Key)
- Authorization rules (role/permission matrix)
- Cross-context visibility rules (who can access what)

### Endpoint Details (one section per endpoint)
For each endpoint:
```
**Endpoint:** `[METHOD] /api/[path]`
**Purpose:** [business purpose]

Request:
- Headers
- Query Parameters: | Parameter | Type | Required | Description | Validation |
- Request Body: | Field | Type | Required | Description | Validation |

Responses:
- 200 OK: [structure]
- 422 Validation Error: [error shape]
- 401 / 403 / 500 / 503 / 504: [standard errors]

Validation errors table:
| Error Message | Field | Condition |

Performance:
- Timeout: [X] min
- Rate limiting: [X] req/min
- Expected response: [small/medium/large dataset times]

cURL example
```

### Error Handling
- Standard error response structure (match existing patterns from Step 0.5 if available)
- HTTP status codes table
- Retry strategy: retryable (503, 504) vs non-retryable (400, 401, 403, 422, 500)

### Security
- Input validation rules
- Data protection (HTTPS, token encryption)
- Rate limiting details

### Performance Benchmarks
```
| Scenario | Expected Time | Max Acceptable Time |
```

**Naming rule:** Follow existing Swagger conventions extracted in Step 0.5. If no existing patterns, use camelCase for fields and kebab-case for paths.

**TBD rule:** Mark unknown values as `[TBD — confirm with [Engineer / Architect]]`

**Save file:** `requirements/[feature-name]/API-Contract-[Feature-Name].md`

---

## 🔄 Step 5: Generate System Flow *(Comprehensive mode, integrations in scope only)*

**Generate using `templates/system-flow.md` as structure reference.**

**Sections:**

### Overview
- Summary (2–3 sentences of end-to-end flow)
- Systems involved table: `| System | Role | Owner | Technology |`

### High-Level Flow Diagram (ASCII)
```
[User] → [System A] → [System B] → [Output]
```

### Step-by-Step Flow
For each step:
```
**Step N: [Action Name]**
Actor/System: [who does this]
Actions:
- [Action 1]
- [Action 2]
Output: [what happens next]
```

### Alternative Flows
- Alt Flow 1: No data scenario
- Alt Flow 2: Timeout scenario
- Alt Flow 3: Service unavailable

### Error Handling
```
| Error | Cause | Response | Recovery |
```

### Integration Points (one per external system)
```
**[System Name]**
- Interface: [API / SDK / DB]
- Auth: [method]
- Data: [what data flows]
- SLA: [uptime %]
- Owner: [team/contact]
```

### Data Transformations
```
| Source Field | Destination Field | Transformation |
```

### Performance Benchmarks
```
| Scenario | Expected Time | Bottleneck | Mitigation |
```

**Save file:** `requirements/[feature-name]/System-Flow-[Feature-Name].md`

---

## ✅ Step 6: Inline Quality Check

Before presenting documents to user, run these checks on EACH generated document:

**Completeness:**
- [ ] All required sections present
- [ ] No [TBD] without explanation and stakeholder routing
- [ ] Source attribution meets threshold (Tier 1 = 100%, Tier 2 = 60%+ target)

**Clarity:**
- [ ] Plain English throughout (no code, no jargon without explanation)
- [ ] All requirements are specific and testable ("System must X within Y seconds")
- [ ] No vague language ("should consider", "might", "probably")

**Alignment (if multiple docs):**
- [ ] All APIs mentioned in Feature Requirements also appear in API Contract
- [ ] All integrations in Feature Requirements also appear in System Flow
- [ ] No contradictions between documents

**Requirement Purity:**
- [ ] No FR contains implementation mechanisms (HOW) — solutions belong in Implementation Notes
- [ ] No FR prescribes UI layout or navigation patterns (WHAT IT LOOKS LIKE) — design decisions belong in Open Questions
- [ ] Each business rule is testable — a QA engineer could write a pass/fail test without asking clarifying questions

**Source Accuracy:**
- [ ] Every `(Source: SRC-N)` citation was verified against the actual source content
- [ ] No source is cited for content it does not contain
- [ ] Statements tagged `(Source: Implicit)` are genuinely logical derivations, not gap-fills that should be `[TBD]`
- [ ] No scoped statement has been over-generalized (source says "X in context A" but doc says "X everywhere")

**Fix any failures before presenting.** Do not present documents with known quality failures.

---

## 💬 Step 7: Present Documents

Present to user:

```markdown
✅ Generated [N] document(s):

1. **Feature Requirements** → requirements/[feature]/Feature-Requirements-[Feature].md
   - [X] functional requirements
   - [N] TBDs flagged
   - Word count: ~[N]

2. **API Contract** → requirements/[feature]/API-Contract-[Feature].md (if applicable)
   - [N] endpoints documented

3. **System Flow** → requirements/[feature]/System-Flow-[Feature].md (if applicable)
   - [N] integration points

---

**TBDs requiring input:**
🔴 Critical: [list with stakeholder routing]
🟡 Important: [list]

---

**Next:** Run Workflow 3 to validate completeness and readiness for story creation.
- Reply **"validate"** to continue
- Reply **"done"** to stop here
```

**STOP and WAIT for user response.**

---

## 🔄 After User Replies

**If "validate" or "yes":**
```
Starting Workflow 3: Validation...
```
Then **read the file:**
```
workflows/03-validate.md
```

**If "done" or any other response:**
```
✅ Requirements generation complete.

Files saved to: requirements/[feature-name]/

Next steps:
- Review documents with stakeholders
- Fill in [TBD] items with relevant teams
- Use these requirements to generate user stories (Story Creation workflow)
```

---

## 🚨 Critical Rules

| ✅ Do | ❌ Don't |
|-------|---------|
| Save each file before presenting | Display only in chat |
| Match existing Swagger patterns for API naming | Use generic REST naming if Swagger exists |
| Run inline quality check before presenting | Present documents with known failures |
| Flag all TBDs with stakeholder routing | Leave TBDs without context |
| Keep within word limits | Write exhaustive documents beyond limits |
| Wait for user feedback at the end | Auto-proceed to validation |
