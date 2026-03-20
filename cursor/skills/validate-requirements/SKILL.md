---
name: validate-requirements
description: "Validates requirements documents for semantic accuracy using 10 checks across 4 dimensions: truth (source accuracy, inference detection, over-generalization, actor capability), purity (requirement vs solution vs design), actionability (testability, ambiguity), and completeness (assumption dependencies, negative paths, scope boundaries). Produces a dual output: concise chat summary + full markdown report file. Use after generating requirements, before sharing with stakeholders, when suspecting inaccuracies, or as a periodic quality sweep."
---

# Validate Requirements — Semantic Accuracy Skill

## Purpose

Catches semantic inaccuracies in requirements documents — things that are factually wrong, unsourced, over-generalized, solution-prescriptive, or untestable. Complements `document-audit` (which checks structural integrity) with semantic checks.

**Key distinction:**
- `document-audit` = **structural integrity** — stale markers, broken cross-refs, contradictions between sections, completeness gaps
- `validate-requirements` = **semantic accuracy** — is the content true, pure, actionable, and complete?

## When to Use

- After generating requirements (as part of the pipeline at Stage 9a, or standalone)
- When reviewing an existing requirements doc before sharing with stakeholders
- When the user suspects inaccuracies, over-prescription, or unsourced claims
- As a periodic quality sweep across a set of feature docs
- After `update-documents` propagates changes (in the verify step, alongside `document-audit`)

## Inputs

Gather these before starting:

1. **Requirements document** — the file to validate (REQUIRED)
2. **Source documents folder** — meeting summaries, client docs, design descriptions, transcripts (REQUIRED for Checks 1, 2, 4, 10)
3. **Sibling requirements docs** — other feature requirement docs in the same folder (OPTIONAL — needed for Check 5: Scope Boundary)

If source documents are not available, Checks 1 (Source Accuracy) and 4 (Over-Generalization) will be marked SKIPPED with a note explaining why.

---

## The 10 Checks

### Check 1: Source Accuracy Audit

**Dimension: Is it true?**

For every `(Source: SRC-N)` citation in the document:

1. Read the cited source
2. Verify the source actually contains the claimed information
3. Classify each citation:

| Verdict | Meaning |
|---|---|
| **ACCURATE** | Source directly states the claimed fact |
| **PARTIALLY ACCURATE** | Source says something related but the doc generalizes or reinterprets |
| **INACCURATE** | Source does not contain the claimed information |
| **UNVERIFIABLE** | Source is not available or cannot be checked |

For PARTIALLY ACCURATE and INACCURATE findings: show what the source actually says vs. what the doc claims.

For statements tagged `(Source: Implicit)`: flag for user validation — implicit means no source backs it. Determine if it is a valid logical derivation or a gap-fill that should be `[TBD]`.

---

### Check 2: Inference Detection

**Dimension: Is it true?**

Scan for statements that appear factual but are actually inferred:

- Statements about "current state" or "currently" — verify against a confirmed current-state source (design description, existing Figma, user confirmation)
- Pain points that assume a user experience not described in any source
- Field lists or data attributes not traceable to any source
- Behavior descriptions with no source citation (especially in user flows and business rules)
- "Confident-sounding" language: definitive statements without `[TBD]` that have no source

For each finding, classify:

| Verdict | Meaning |
|---|---|
| **CONFIRMED** | Inference is backed by a source (may just be missing the citation) |
| **PLAUSIBLE** | Inference is reasonable but not sourced — needs user confirmation |
| **FABRICATED** | No basis in any source — must be removed or tagged `[TBD]` |

---

### Check 3: Requirement Purity Classification

**Dimension: Is it a requirement?**

For each Functional Requirement and its business rules, classify:

| Classification | Definition | Action |
|---|---|---|
| **REQUIREMENT** | Describes a capability or constraint from the user's perspective. Observable, testable, solution-free. | Keep |
| **SOLUTION** | Prescribes an implementation approach (e.g., "cache locally", "use delta API", "batch hourly", "retry with exponential backoff") | Flag for reframing as the underlying need + "Implementation Note" |
| **DESIGN** | Prescribes a UI pattern, layout, or navigation structure (e.g., "organized as tabs", "show as Past/This Week/Future", "swipe left/right to navigate") | Flag for reframing as the underlying need + "Open Question / Design Decision" |

**Also check these sections** (solutions and design prescriptions often hide outside the FRs):
- Executive Summary
- UX Context
- User Flows
- Visual States
- Error Handling

---

### Check 4: Over-Generalization Detection

**Dimension: Is it true?**

For each sourced statement, check scope alignment:

- Does the source say "X in context A" but the doc says "X in all contexts"?
- Does the source describe a field for one view type but the doc applies it to all views?
- Does the source describe a rule for one actor but the doc applies it to all actors?
- Does the source describe behavior for one scenario but the doc states it as a universal rule?

**Pattern:** Find the source → check its scope → compare to the doc's scope → flag if broader.

---

### Check 5: Scope Boundary Check (Cross-Document)

**Dimension: Is it complete and safe?**

*Skip if no sibling requirements docs are available. Mark as SKIPPED.*

If sibling requirements docs exist in the same folder:

- Identify overlapping FRs — the same user experience documented in two places
- Identify contradictory rules — different thresholds, different behaviors for the same scenario
- Identify unclear boundaries — where one feature ends and another begins is ambiguous
- Flag for consolidation or cross-referencing

---

### Check 6: Testability

**Dimension: Is it actionable?**

For each FR and its business rules, check if it can be verified with a pass/fail test:

- **Vague outcomes:** "user-friendly", "fast", "intuitive", "seamless", "easy to use"
- **Missing specifics:** "within a reasonable time" (what time?), "large number of" (how many?), "appropriate error message" (what message?)
- **Undefined conditions:** "if available", "when applicable", "as needed"
- **Unmeasurable qualities:** "improved experience", "better performance", "enhanced security"

Each business rule should be specific enough that a QA engineer could write an acceptance test without asking clarifying questions.

---

### Check 7: Ambiguity Detection

**Dimension: Is it actionable?**

Scan for language that weakens requirements or defers decisions to developers:

| Pattern | Examples | Recommendation |
|---|---|---|
| **Weak modals** | "should", "may", "could", "might" | Replace with "must" or remove |
| **Vague quantifiers** | "some", "many", "few", "quickly", "periodically", "regularly" | Assign specific values or mark `[TBD]` |
| **Escape hatches** | "appropriate", "relevant", "as needed", "etc.", "and so on", "similar" | Make precise or enumerate explicitly |
| **Passive voice hiding actor** | "the data is processed", "notifications are sent" | Specify which system/actor performs the action |

Each finding gets a recommendation: make it precise, assign a specific value, or explicitly mark as `[TBD]`.

---

### Check 8: Assumption-Requirement Dependency

**Dimension: Is it complete and safe?**

For each assumption in the Assumptions table (especially unconfirmed or contradicted ones):

1. Trace which FRs depend on that assumption being true
2. Check if the FR acknowledges the dependency (e.g., "depends on H2" or "blocked by H1")
3. Flag FRs that silently depend on unconfirmed assumptions without acknowledging the risk
4. For contradicted assumptions: are the dependent FRs flagged as blocked or at-risk?

Example: If Assumption H2 (data warehouse availability) is unconfirmed, every FR that needs historical data should acknowledge the blocker.

---

### Check 9: Negative Path Coverage

**Dimension: Is it complete and safe?**

For every happy path described in user flows or FRs:

1. Check if corresponding error/edge cases are covered in Error Handling, Alternative Paths, or business rules
2. Cross-reference the Scenario Matrix (if available) against the FRs — are all scenarios covered by at least one requirement?
3. Flag gaps: "UF-1 has 3 alternative paths, but the Error Handling table only covers 2 of them"
4. Check for missing failure modes:
   - Network failure mid-action
   - Partial data / incomplete responses
   - User abandons the flow
   - Concurrent/conflicting actions
   - Timeout / service unavailability

---

### Check 10: Actor Capability Verification

**Dimension: Is it true?**

For each actor referenced in the document:

1. Verify their described capabilities match confirmed reality (from current-state sources, design descriptions, or user confirmation)
2. Flag actions assigned to actors who cannot perform them (e.g., "officer checks WFM" when officers don't have WFM access)
3. Flag assumptions about actor access, tools, or permissions that are not sourced
4. Cross-reference the actor's capabilities with what's described in the Persona section — are they consistent?

---

## Execution Workflow

### Phase 1: Setup

1. Read the requirements document
2. Identify and read all source documents (from the provided folder path)
3. Identify sibling requirements docs (if any, in the same folder)
4. Build a source index: map each SRC-N to its file and key content

### Phase 2: Run Checks

Run all 10 checks in order. For each check:
- Record each finding with: location in doc (section + line), the problematic text, the verdict, and the recommendation
- Classify severity:
  - **Critical** — factually wrong or misleading (must fix before sharing)
  - **Should Fix** — reframe, relocate, or make precise (improves quality)
  - **Verify** — needs user confirmation (may be correct, can't determine automatically)
  - **Gap** — missing coverage (negative paths, uncovered scenarios)

### Phase 3: Generate Output

Produce two outputs:

#### Output 1: Chat Summary (displayed to user)

Brief — finding counts per check, top 3-5 critical issues, overall assessment.

Format:
```
## Requirements Accuracy Review — [Feature Name]

**Document:** [filename]
**Sources checked:** [N]
**Findings:** [N] total ([N] Critical, [N] Should Fix, [N] Verify, [N] Gaps)

| Check | Findings | Status |
|-------|----------|--------|
| 1. Source Accuracy | [N] | PASS / FAIL |
| 2. Inference Detection | [N] | PASS / FAIL |
| 3. Requirement Purity | [N] | PASS / FAIL |
| 4. Over-Generalization | [N] | PASS / FAIL |
| 5. Scope Boundary | [N] | PASS / FAIL / SKIPPED |
| 6. Testability | [N] | PASS / FAIL |
| 7. Ambiguity | [N] | PASS / FAIL |
| 8. Assumption-Req Dependency | [N] | PASS / FAIL |
| 9. Negative Path Coverage | [N] | PASS / FAIL |
| 10. Actor Capability | [N] | PASS / FAIL |

### Top Issues
1. [Most critical finding — brief description]
2. [Second most critical finding]
3. [Third most critical finding]

**Full report saved to:** [filepath]

### Recommended Next Steps

1. **Review findings interactively** — use `review-findings` skill with this report to walk through each finding, collect your decisions, and produce a resolution summary.
2. **Or resolve manually** — work through findings by category:
   a. Resolve Verify items first (quick yes/no confirmations)
   b. Batch-approve Should Fix items
   c. Fill Gaps (add to doc or convert to Open Questions)
   d. Fix Critical items immediately
3. **Apply fixes** — use `update-documents` with the resolution summary to apply all approved changes in one pass.

Would you like to use `review-findings` to walk through these interactively?
```

#### Output 2: Full Report File

Save as `Validation-Report-[Feature].md` in the same directory as the requirements document.

Format:
```markdown
# Requirements Accuracy Review

**Document:** [filename]
**Validated on:** [date]
**Sources checked:** [N] source documents
**Checks run:** 10

| Check | Findings | Status |
|-------|----------|--------|
| 1. Source Accuracy | [N] | PASS / FAIL |
| 2. Inference Detection | [N] | PASS / FAIL |
| 3. Requirement Purity | [N] | PASS / FAIL |
| 4. Over-Generalization | [N] | PASS / FAIL |
| 5. Scope Boundary | [N] | PASS / FAIL / SKIPPED |
| 6. Testability | [N] | PASS / FAIL |
| 7. Ambiguity | [N] | PASS / FAIL |
| 8. Assumption-Req Dependency | [N] | PASS / FAIL |
| 9. Negative Path Coverage | [N] | PASS / FAIL |
| 10. Actor Capability | [N] | PASS / FAIL |

---

## Critical (MUST FIX — factually wrong or misleading)

| # | Location | Check | Finding | Source Says | Doc Claims | Recommendation |
|---|----------|-------|---------|-------------|------------|----------------|
| 1 | [Section, line] | [Check #] | [Description] | [What source actually says] | [What doc claims] | [Fix] |

## Should Fix (reframe, relocate, or make precise)

| # | Location | Check | Finding | Recommendation |
|---|----------|-------|---------|----------------|
| 1 | [Section, line] | [Check #] | [Description] | [Fix] |

## Verify (needs user confirmation)

| # | Location | Check | Finding | Question for User |
|---|----------|-------|---------|-------------------|
| 1 | [Section, line] | [Check #] | [Description] | [What to confirm] |

## Gaps (missing coverage)

| # | Location | Check | Finding | Suggested Addition |
|---|----------|-------|---------|-------------------|
| 1 | [Section, line] | [Check #] | [Description] | [What to add] |

## Clean (no issues found)

[List checks that passed with 0 findings and a brief note on what was verified]

---

## Recommended Next Steps

1. **Review findings interactively** — Use the `review-findings` skill with this report file to walk through each finding, collect decisions, and produce a resolution summary.
2. **Or resolve manually** — Work through findings by category: Verify items first, then Should Fix, then Gaps, then Critical.
3. **Apply fixes** — Use `update-documents` with the resolution summary (from `review-findings`) or apply changes directly.
4. **Re-run validation** — After fixes are applied, re-run `validate-requirements` to confirm findings are resolved.
```

---

## Integration with Other Skills

| Context | How it's called |
|---|---|
| **Standalone** | Run against any requirements doc + its source folder |
| **Pipeline (Stage 9a)** | Called by `generate-detailed-requirements` before `document-audit` (Stage 9b) |
| **After updates** | Can be called by `update-documents` in its Phase 3 verify step (alongside `document-audit`) |
| **Interactive resolution** | After report is generated, user invokes `review-findings` with the report file to walk through findings and collect decisions |

---

## Critical Rules

1. **Never skip a check.** If inputs are missing for a check, mark it SKIPPED with an explanation — do not silently omit it.
2. **Show evidence, not just verdicts.** For every finding, show the problematic text and (for source checks) what the source actually says.
3. **Severity matters.** Group findings by severity in the report, not by check number. A single finding may fail multiple checks — list it once under its highest severity with all applicable check numbers.
4. **Dual output + next steps are mandatory.** Always produce the chat summary, the full report file, and prioritized next steps. The chat summary is for quick triage; the report file is for persistent reference; the next steps tell the user exactly what to do next and in what order.
5. **Be conservative with PASS.** A check PASSes only if zero findings. Even one finding makes it FAIL or WARN.
6. **Don't fix — flag.** This skill identifies issues; it does not modify the requirements document. Fixes are applied separately (by the user or by the pipeline).
