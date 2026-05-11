# Reference Tables — generate-requirements

Referenced by `SKILL.md` and workflow files for conditional conventions and lookup rules. Load these tables when the relevant input type is present.

---

## Conventions by Input Type

Apply these conventions when the specified input is provided. These supplement the core quality rules but do not override NON-NEGOTIABLE constraints.

| Input provided | Convention to apply |
|---|---|
| Swagger / OpenAPI spec | Follow the spec's naming conventions, error shapes, and response formats throughout all generated content. Do not invent endpoint names or error codes that contradict the spec. |
| Figma / design files | Derive UX context (flows, visual states) from the design. Do not specify UI layout or component placement in the FR itself. |
| Meeting transcript | Treat decisions and confirmations in the transcript as Tier 1 sources. Unconfirmed statements are Tier 2. |
