# Reference Tables

> MANDATORY READ for `07a-synthesize.md` and `07b-generate.md`. Apply every rule in this file before generating any section of the output document.

---

## Writing Rules

### No Em Dashes
Never use — (em dash) anywhere in the document. Rewrite as two sentences or use a colon.

### No Semicolons
Never use ; to chain clauses. One idea per sentence.

### One Idea Per Sentence or Bullet

**Level 1 — Document-wide:**
Every sentence and every bullet in the document states one idea. If a sentence or bullet contains more than one outcome, behavior, or system state that a tester would verify separately — split it.

**Period-replacement test:** If you can replace "and" (or "while", "as", "so that") with a period and both halves stand as valid standalone statements, they must be split.

**What does NOT need splitting:**
- Temporal trigger + one outcome: "After selecting No, a comment field appears." — the trigger is not a separate outcome.
- Compound noun list: "The notification includes name, date, and comment." — one outcome, enumerated content.
- Conditional + one outcome: "If the comment field is empty, submission is blocked." — the condition is not a separate outcome.

**Level 2 — FR bullets (instance of Level 1):**
Each FR bullet states one observable outcome. Split compound statements into separate bullets.

❌ "The user taps the sign-in button, the device runs the biometric check, and the home screen appears on success."
✅ "The user taps the sign-in button to start the biometric check."
✅ "The home screen appears after a successful biometric check."

**Open Questions cell rule:**
7a extracts Open Questions raw from Stage 5. 7b has full authority to rewrite compound OQs — 7a's role is completeness, 7b's role is clarity.

Each Open Questions row states one primary question. If a follow-on question is related or conditional on the primary answer, write it as a sub-bullet under the primary — not as a new row and not as a second sentence in the same cell. Create a new row only when the follow-on topic is genuinely distinct or complex enough to stand on its own.

❌ "Is submission atomic or split across two calls? If split, what is the behavior when one call succeeds and one fails?"
✅ Question cell: "Is submission atomic or split across two calls?"
✅ Sub-bullet: "If split: what is the behavior when one call succeeds and one fails?"

### FR Bullets — User Flow Order
Bullets within each FR must follow the sequence a user experiences them — entry trigger first, outcome last. Mirror the flow from Stage 6.

### Overview Sentence Constraints
- 3–4 sentences only. Each sentence passes the period-replacement test — if "and" can be replaced with a period, split the sentence.
- Structure: problem → what the feature does → what changes → one key constraint (if relevant).
- Max 3 ideas per sentence.
- Write as a continuous paragraph. No blank lines between sentences. The four sentences read as connected prose, not a stanza or bullet list.

---

## Format Rules

### Tables vs. Bullets
Use a table when 3 or more columns each carry distinct, non-redundant information. Use bullets when content is a list of single items, one-per-line facts, or entries with fewer than 3 meaningful columns. Never use a table just because the content has two columns — a two-column table is usually a labeled list in disguise.

### Word Count Ceilings
Measure words in Sections 1–9 only. Exclude Section 10, Section 11, and all Appendix content.

| | Small (≤3 flows) | Medium (4–7 flows) | Large (8+ flows) |
|---|---|---|---|
| **Simple** | 300–600 | 600–1,000 | 1,000–1,500 |
| **Medium** | 700–1,200 | 1,500–2,500 | 2,500–3,500 |
| **Complex** | 1,200–2,000 | 2,500–4,000 | 4,000–6,000 |

If the document is over the ceiling, apply reductions in this order:
1. Remove duplicate rules that appear in multiple FRs — state the rule once in the first relevant FR only.
2. Move field-level specs and conditional branching to Appendix E. Add a callout line in the parent FR body.
3. Shorten Overview and Known Limitations to minimum sentences.

---

## FR Purity Rules

### WHAT vs. HOW
FR bullets describe what the user observes or what the system produces — not how the system achieves it. Any bullet that names an API call, database operation, internal state variable, OS callback, or evaluation algorithm is a HOW violation.

**Test:** Ask "Can a PM verify this in a demo without reading the code?" If no — it is a HOW.

❌ HOW: "The Login screen evaluates the user's stored sign-in preference against the device's current biometric enrollment state before rendering the sign-in button."
✅ WHAT: "The Login screen shows only the sign-in option that matches the user's configured preference and current device capabilities."

❌ HOW: "Tapping the button initiates the device's biometric authentication callback."
✅ WHAT: "The user signs in with a single tap when a biometric is enrolled on the device."

### Common HOW Patterns to Reject
- "The app calls / sends / queries / fetches / stores / reads..." → describe the result the user sees
- "The system sets [flag] to [value]..." → describe the behavior change the user observes
- "The OS returns a [callback / result]..." → describe what happens on screen next
- "On a [event name] event..." → describe the trigger as user action, not system event name

---

## FR Bullet Hierarchy Rule

Use one level of sub-bullets when a bullet describes a property, content, or constraint OF the outcome immediately above it — and only applies in that specific context.

**Parent-child test:** If the parent bullet were removed, would this bullet still stand as a meaningful standalone requirement? If no — sub-bullet. If yes — peer bullet.

The test applies to consecutive bullets only. A sub-bullet must be directly linked to the property, state, or content of the bullet immediately above it — not merely topically related to the same FR. If bullet N+1 is about the same topic as bullet N but would make sense under a different parent, it is a peer bullet.

**Use a sub-bullet for:**
- A property, content, or constraint that describes what the parent outcome IS, CONTAINS, or RESTRICTS — and has no meaningful standalone existence outside that parent. The sub-bullet is about the parent outcome itself, not what happens next.
- A constraint that clarifies one specific parent constraint and has no meaning without it.
- An exception that qualifies one specific parent bullet (not the whole FR).

**Stay top-level for:**
- Independent flow steps with their own trigger condition.
- Constraints that apply to the whole FR, not one parent bullet.
- Bullets related by sequence but not by parent-child dependency.

**NEVER use a sub-bullet for:**
- Sequential events — even when causally connected. "After A, B happens" describes two independently verifiable outcomes. Both stay flat regardless of causal connection.
- The next observable event after a trigger. Temporal adjacency is not parent-child dependency.

**Max depth:** One level only. If a sub-sub-bullet seems necessary, split the FR instead.

❌ Sequential nesting (wrong — both bullets are independent outcomes in sequence):
"After the user taps Submit, a confirmation message appears."
  - The list view updates to reflect the new entry.

✅ Sequential flat (correct — keep sequential outcomes as peer bullets):
"After the user taps Submit, a confirmation message appears."
"The list view updates to reflect the new entry after submission completes."

✅ Property nesting (correct — sub-bullets describe what the notification contains):
"The user receives a notification when their request is declined."
  - The notification includes the reviewer's reason for declining.
  - The notification includes instructions for resubmission.

❌ Flat (hides property hierarchy): "The submit button is not available while a session is active." / "The user must close the active session before the exit flow is accessible."
✅ Nested (shows property hierarchy): "The submit button is not available while a session is active." / "  - The user must close the active session before the exit flow is accessible."

---

## Appendix Routing Rules

| Route to Appendix | When |
|---|---|
| **A — Visual States** | A section of a FR has 3 or more named screen states with distinct user-visible differences |
| **B — Error Handling** | 3 or more distinct error conditions with different recovery paths for a single flow |
| **C — Audit Trail** | The feature creates, modifies, or reads an audit record at any point |
| **D — Detailed User Flows** | A flow has more than 4 decision branches or sub-paths that would make Section 6 unreadable |
| **E — Field-Level Specs** | A FR has conditional logic or validation rules that require 4 or more bullets to specify |
| **F — Full Risk Register** | §9.2 has more than 4 risks after sorting by Impact |
| **G — Open Questions** | Any open question with Medium or Low priority |

**Callout rule:** Every FR that routes content to Appendix E must include this line in its body:
`> See Appendix E: [rule name]`
No callout = no routing. Keep the content inline until a callout exists.

Same rule applies to Appendix F: if the §9.2 routing rule fires and Appendix F is created, §9.2 must contain `> See Appendix F: Full Risk Register` as its last line — or revert all overflow risks to §9.2.

---

## Platform Purity Rule

If a FR contains platform-labeled sections (`**[Platform]:**`), each section must use only terminology native to that platform. Do not reference a trademark, system API name, or UI pattern from one platform inside another platform's labeled section.

**Test:** Read each labeled section in isolation. Does every term in it naturally belong to that platform? If a term requires qualification ("... which is the X equivalent of..."), it is in the wrong section.

---

## Section Boundary Rules

These rules prevent HC/DEP/OQ contamination in Section 9.

| Content type | Correct location |
|---|---|
| Delivery dependency (another team, service, or artifact must be ready first) | Section 9.1 Constraints — as a bullet: "[Dependency name] must be ready before [milestone]. ([Imposing party])" |
| Assumption that could change feature behavior if wrong | Section 9.3 Assumptions — one row per assumption |
| Hard constraint imposed by an external party | Section 9.1 Constraints — with imposing party in parentheses |
| Risk that could derail delivery or harm users | Section 9.2 Risks — one row; "What goes wrong → user impact" in the Risk cell |
| Unresolved decision blocking design or dev | Section 10 Open Questions — Critical/High only; Medium/Low → Appendix G |

**Section 9 contamination check:** Before saving, confirm that no row in Section 9.1, 9.2, or 9.3 is actually an open question in disguise. The test: does the item describe something unknown that requires a decision? If yes — it is an open question, not a constraint, risk, or assumption.