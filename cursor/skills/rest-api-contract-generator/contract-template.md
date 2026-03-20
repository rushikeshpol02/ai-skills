# API Contract Template

Use this structure for every generated contract. Remove sections that are explicitly not applicable and state why (e.g., "Pagination: N/A — single resource endpoint").

---

```markdown
# [Feature Name] — API Contract

**Version:** 1.0
**Status:** Draft
**Date:** [YYYY-MM-DD]
**Consumer:** [Frontend / Mobile / Service-to-Service]
**Author:** [TBD]

---

## Endpoint Overview

| Field | Value |
|-------|-------|
| **Method** | `[GET / POST / PUT / PATCH / DELETE]` |
| **Path** | `/[resource-path]` |
| **Purpose** | [1–2 sentence plain-English description of what this endpoint does] |
| **Authentication** | [Required — Bearer token / API key / None] `[TBD if unknown]` |
| **Authorization** | [Permission required, e.g., "Manage Tags" role] `[TBD if unknown]` |

---

## Request

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `[param]` | `[type]` | Yes | [description] |

*None — if no path parameters.*

### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `[param]` | `[type]` | No | `[default]` | [description] |

*None — if no query parameters.*

### Request Body

*Applies to: POST, PUT, PATCH.*
*Omit this section for GET and DELETE.*

**Content-Type:** `application/json`

```json
{
  "[field]": "[value — use realistic example data]"
}
```

#### Request Body Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `[field]` | `[type]` | Yes / No | [description] |

---

## Response

### Success Response

**Status:** `[200 OK / 201 Created / 204 No Content]`

```json
{
  "[field]": "[realistic example value]"
}
```

#### Field Definitions

| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| `[field]` | `[type]` | Yes / No | [description] |

### Paginated Response *(include only if applicable)*

```json
{
  "data": [...],
  "pagination": {
    "pageNumber": 1,
    "pageSize": 10,
    "totalCount": 47,
    "totalPages": 5
  }
}
```

*Replace with codebase pagination shape if one was extracted in Step 2.*

---

## Error Responses

*Use the codebase error shape if one was extracted in Step 2. Otherwise, use the default flat shape.*

| Status | When | Response Body |
|--------|------|---------------|
| `400 Bad Request` | [when this occurs] | `{ "error": "[message]" }` |
| `401 Unauthorized` | No valid auth token | `{ "error": "Unauthorized" }` |
| `403 Forbidden` | Valid token, insufficient permission | `{ "error": "Forbidden" }` |
| `404 Not Found` | [resource] not found | `{ "error": "[message]" }` |
| `422 Unprocessable Entity` | Validation failure | `{ "error": "[message]" }` |
| `500 Internal Server Error` | Unexpected server failure | `{ "error": "[message]" }` |

*Remove rows that don't apply. Add rows for any domain-specific errors.*

---

## Pagination *(include only if applicable)*

| Behaviour | Detail |
|-----------|--------|
| **Default page size** | `[value]` `[TBD if unknown]` |
| **Max page size** | `[value]` `[TBD if unknown]` |
| **Get all records** | [Omit params / pass `pageSize=0` / not supported] |
| **Params** | `pageNumber` (int), `pageSize` (int) |

---

## Performance Targets *(include only if confirmed)*

| Metric | Target | Source |
|--------|--------|--------|
| Response time (p95) | `[TBD — confirm with Engineering]` | — |
| Max payload size | `[TBD]` | — |

*Do not populate this section unless targets were explicitly provided by the user or found in the codebase. Mark all as [TBD] if unknown.*

---

## Security

| Concern | Handling |
|---------|---------|
| Authentication | [Token type and header] |
| Authorization | [Permission check description] |
| Sensitive data in URL | [Yes / No — note any PII exposure risk] |
| Input validation | [Where validation occurs — API gateway, controller, service layer] `[TBD if unknown]` |

---

## Open Questions

*All [TBD] items from this contract must appear here.*

| # | Question | Owner | Due |
|---|----------|-------|-----|
| 1 | [Question derived from a [TBD] item above] | [TBD] | [TBD] |

---

## QA Summary

*(Filled in by the skill after running quality-checklist.md)*

- ✅ / ❌ Pattern compliance: [matched codebase patterns / applied REST defaults — list which]
- ✅ / ❌ No fabricated values
- ✅ / ❌ All [TBD] items listed in Open Questions
- ✅ / ❌ HTTP methods and status codes validated
- ⚠️ Issues found and resolved: [list any, or "None"]
```
