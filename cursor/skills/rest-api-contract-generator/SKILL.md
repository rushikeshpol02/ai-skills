---
name: rest-api-contract-generator
description: Generates a complete REST API contract document for a feature or endpoint. Enforces information gathering before generating, optionally reviews existing codebase and Swagger files to extract API patterns, applies those patterns over generic best practices, and runs a mandatory quality check before delivering results. Use when asked to create an API contract, API spec, API design, endpoint specification, or REST API documentation.
---

# REST API Contract Generator

## Overview

This skill produces a complete, implementation-ready API contract. It follows a strict 4-step workflow. **Do not skip or reorder steps.**

---

## Step 1: Gather Required Context

**Before generating anything**, confirm you have all required information. If any item is missing or ambiguous, ask the user. Do not infer, assume, or fabricate.

### Required (block generation if any are missing)

| # | Information | How to prompt if missing |
|---|-------------|--------------------------|
| 1 | **Feature purpose** — what this endpoint does in plain English (1–2 sentences) | "What does this endpoint do? Describe the business purpose." |
| 2 | **HTTP method** — GET / POST / PUT / PATCH / DELETE | "What HTTP method should this use?" |
| 3 | **Endpoint path** — or ask to propose one based on existing conventions | "What is the endpoint path? Or should I propose one?" |
| 4 | **Consumer** — who calls this (frontend, mobile app, another service) | "Who is the consumer of this endpoint?" |
| 5 | **Inputs** — path params, query params, and/or request body fields | "What inputs does the consumer send? Describe each field." |
| 6 | **Success response** — what data must come back on a successful call | "What data should the response include on success?" |
| 7 | **Known error cases** — specific failure scenarios to handle | "What are the known error cases?" |

### Optional (mark as [TBD] if not provided — do NOT invent)

- Authentication / permission requirements
- Performance expectations (response time, throughput)
- Caching / rate limiting requirements
- Versioning requirements
- Pagination requirements

---

## Step 2: Review Existing Patterns (Ask the User)

Ask the user **exactly once**:

> "Do you want me to review your existing codebase or Swagger/OpenAPI files before generating the contract? This helps me match your team's existing API patterns for error responses, pagination, naming conventions, and response structure.
>
> If yes — share the file paths or @mention the files you'd like me to review."

**If the user says yes**, read the provided files and extract the following. Document what you find — these patterns will override generic REST best practices:

| Pattern | What to look for |
|---------|-----------------|
| **Error response shape** | What does an error response body look like? Is `error` a string or object? Are there additional fields (`exception`, `code`, `details`, `traceId`)? |
| **Pagination** | How are page params sent (query params vs body)? What are the defaults? How is "get all" handled (nullable params, special value, omit params entirely)? What does the paginated response envelope look like? |
| **Response envelope** | Are responses wrapped (`{ data: {...}, meta: {...} }`) or bare? |
| **Naming convention** | camelCase, snake_case, or PascalCase for field names? |
| **Path conventions** | Plural nouns? Nested resource patterns (`/client/{id}/sites`)? |
| **HTTP status codes** | Which codes does the existing API use and for what? Are 422 or 400 used for validation errors? |
| **Auth pattern** | Bearer token, API key, cookie? What header? |

Summarize what you found before proceeding. State explicitly: *"I found the following patterns. These will be applied to the contract."*

**If the user says no**, apply standard REST best practices (see [quality-checklist.md](quality-checklist.md) for the defaults used).

---

## Step 3: Generate the Contract

Use [contract-template.md](contract-template.md) as the output structure.

### Non-negotiable rules during generation

1. **Existing patterns override generic best practices.** If the codebase uses a flat error shape, use it — even if nested is "better practice."
2. **Never fabricate values.** If a value was not stated by the user and not found in the codebase:
   - Performance targets → mark as `[TBD — confirm with Engineering]`
   - Field names/types not confirmed → mark as `[TBD]`
   - Unknown status codes → mark as `[TBD]`
3. **No implementation details.** No code, SQL, ORM queries, class names, or internal logic in the contract.
4. **All [TBD] items must be listed** in the Open Questions section at the bottom.
5. **Verify HTTP method + path follow REST conventions** unless overridden by existing patterns:
   - GET = read, idempotent, no request body
   - POST = create or trigger action, non-idempotent
   - PUT = full replace, idempotent
   - PATCH = partial update, idempotent
   - DELETE = remove, idempotent
6. **Status codes must be appropriate.** Flag any mismatch (e.g., returning 200 for a resource creation that should be 201).
7. **If pagination is required**, apply the codebase pattern exactly. If no codebase was reviewed, use the nullable pattern as default (omitting params returns all; providing both returns paged results).

---

## Step 4: Quality Check (Mandatory — Run Before Delivering)

After drafting, run every item in [quality-checklist.md](quality-checklist.md) before presenting results to the user.

**If any check fails**: fix the issue in the contract, then continue. Do not present a contract with known quality failures.

After the check, append a brief **QA Summary** at the bottom of the contract:

```
## QA Summary
- ✅ Pattern compliance: [matched codebase / applied REST defaults]
- ✅ No fabricated values
- ✅ All [TBD] items listed in Open Questions
- ✅ HTTP methods and status codes validated
- ⚠️ [Any issues found and how they were resolved]
```

---

## Additional Resources

- Output structure: [contract-template.md](contract-template.md)
- Quality gate details: [quality-checklist.md](quality-checklist.md)
