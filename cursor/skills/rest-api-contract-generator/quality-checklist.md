# Quality Checklist — REST API Contract

Run every item below after drafting the contract. Fix failures before delivering.

---

## 1. Fabrication Check (Critical)

| Check | Pass condition |
|-------|---------------|
| Performance targets | All are sourced from the user or codebase, OR marked `[TBD — confirm with Engineering]`. No invented numbers (e.g., "< 2s response time"). |
| Field names | Every field name was stated by the user or found in existing designs/code/Swagger. No invented fields. |
| Field types | Every type is confirmed or marked `[TBD]`. No guessing (`string` when it could be `integer`). |
| Error codes / messages | Match codebase pattern if reviewed. No invented error code strings. |
| Default values | Sourced from codebase or user. Not assumed. |
| Status codes | Only codes with clear justification are listed. Speculative ones marked `[TBD]`. |

---

## 2. Pattern Compliance (Codebase-Sourced)

*Only applies if the user provided codebase or Swagger files in Step 2.*

| Check | Pass condition |
|-------|---------------|
| Error response shape | Contract error body matches the exact shape found in codebase (string vs object, field names, field order). |
| Pagination params | Param names, defaults, and "get all" behavior match codebase. |
| Response envelope | Wrapping (or lack of wrapping) matches codebase. |
| Field naming convention | camelCase / snake_case / PascalCase consistent with codebase. |
| Path structure | Resource nesting pattern matches codebase conventions. |
| Auth header | Matches existing auth implementation. |
| HTTP status codes | Consistent with how the existing API uses them (e.g., 422 vs 400 for validation). |

---

## 3. REST Correctness (Applied when no codebase pattern overrides)

| Check | Pass condition |
|-------|---------------|
| GET has no request body | GET endpoints use only path/query params. |
| POST returns 201 for resource creation | Unless existing codebase uses 200 for this — document the deviation. |
| PUT/PATCH distinction | PUT replaces the full resource; PATCH updates specific fields. If mixed, flag it. |
| DELETE returns 204 (no content) | Unless the codebase pattern returns 200 with a body — document the deviation. |
| Idempotency | GET, PUT, PATCH, DELETE are idempotent. POST is not. Flag any violations. |
| Path uses nouns, not verbs | `/users/{id}` not `/getUser/{id}`. Exception: action endpoints (`/report/{id}/download`). |
| Plural resource names | `/users` not `/user`. Flag exceptions. |
| Path params for resource identity | ID/slug in path, not query string. |
| Query params for filtering/sorting/pagination | Not in path or body for reads. |
| Sensitive data not in path or query | No tokens, passwords, or PII in URLs. |

---

## 4. Completeness Check

| Check | Pass condition |
|-------|---------------|
| All inputs documented | Every path param, query param, and request body field has: name, type, required/optional, description. |
| All response fields documented | Every field in the success response is defined in the Field Definitions section. |
| All error cases covered | Each stated error case has a corresponding error response entry with status code and body. |
| Pagination included if needed | If the endpoint returns a list, pagination is addressed (even if just `[TBD]`). |
| Auth requirements stated | Either documented or explicitly marked `[TBD]`. |
| All [TBD] items listed | Every `[TBD]` in the body is also listed in the Open Questions section with an owner placeholder. |

---

## 5. Clarity Check

| Check | Pass condition |
|-------|---------------|
| Consumer can implement without follow-up | A developer reading this contract should not have to ask basic questions about how to call the endpoint or what the response looks like. |
| No implementation details | No code, SQL, ORM, class names, internal method names, or database schema details. |
| No ambiguous language | No "usually", "typically", "may", "might" unless intentional and explained. |
| Consistent terminology | Same term used throughout (e.g., always "site ID" not mixing "siteId", "site_id", "Site ID"). |
| Example values are realistic | Sample request/response use realistic data, not `string`, `123`, `foo`. |

---

## Default REST Best Practices (when no codebase pattern is available)

Use these when the user has not provided a codebase for pattern extraction:

| Concern | Default |
|---------|---------|
| Error response shape | `{ "error": "Human-readable message" }` — flat, simple |
| Pagination params | `pageNumber` (int, default 1) + `pageSize` (int, default 10); omitting both returns all |
| Paginated response | `{ "data": [...], "pagination": { "pageNumber": 1, "pageSize": 10, "totalCount": 100, "totalPages": 10 } }` |
| Field naming | camelCase |
| Resource paths | Plural nouns, kebab-case for multi-word (`/shift-reports`) |
| Auth | `Authorization: Bearer {token}` header |
| Validation errors | HTTP 422 Unprocessable Entity |
| Not found | HTTP 404 Not Found |
| Unauthorized (no auth) | HTTP 401 Unauthorized |
| Forbidden (no permission) | HTTP 403 Forbidden |
| Server error | HTTP 500 Internal Server Error |
| Created | HTTP 201 Created with `Location` header |
| Updated (with body) | HTTP 200 OK |
| Deleted (no body) | HTTP 204 No Content |
