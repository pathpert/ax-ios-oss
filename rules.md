# Rules: Codebase Modernization for Agent Experience (AX)

You are an expert AI software engineer refactoring a brownfield codebase (`ax-ios-oss` / Swift) to support Agent Experience (AX) and Agent-Native Architecture.
When transforming or extending existing code, strictly enforce the following architectural rules:

---

### Rule 1: Apply the Strangler Fig Pattern (Never Rewrite Wholesale)
- **Do not rewrite existing monolithic files in a single pass** (e.g., `KsApi/Sources/KsApi/Service.swift` or `ServiceType.swift`).
- Isolate target sub-domains into self-contained feature directories under `KsApi/Sources/KsApi/modules/{feature_name}/` (or `src/modules/{feature_name}/`).
- If existing code must still be used, wrap it behind a strictly-typed Adapter/Facade (`Legacy{Feature}ServiceAdapter`) rather than letting legacy types (`ErrorEnvelope`, `[String: Any]`, `SignalProducer`) leak across module boundaries.

---

### Rule 2: Component-Local Modularization (Dev-Primitives)
Every refactored or newly created module MUST be autonomous and colocate its artifacts:
```text
KsApi/Sources/KsApi/modules/{feature}/
├── {feature}.schema.swift     # Runtime schemas, Poka-Yoke contracts & RFC 9457 Problem Details
├── {feature}.service.swift    # Business logic, idempotency/rate-limit guards & legacy adapter calls
└── {feature}.controller.swift # Route/mutation handlers, headers & mutation hooks

KsApi/Sources/KsApiTests/modules/{feature}/
└── {feature}.spec.swift       # Carried unit tests (local to this module)
```
- Keep individual source files concise (target < 300 lines) to prevent attention decay and context window bloat.

---

### Rule 3: Poka-Yoke & Contract-First Typing
- **Eliminate loose typing:** Strictly forbid `Any`, untyped dictionaries (`[String: Any]`), stringly-typed currency/IDs, and unsafe casts (`as!`, silent `as?` fallbacks).
- **Validate at the boundary:** Validate all inputs and outputs using runtime contract schemas and Swift strongly-typed value types / enums before executing domain logic.
- **Enrich field descriptions:** Every schema property MUST include `.describe(...)` metadata specifying:
  1. The exact business meaning and expected format (e.g., UUID v4, ISO 8601, Base64 GraphID regex pattern, integer cents).
  2. Explicit **Negative Constraints** stating what NOT to pass (e.g., `"Do not pass floating-point currency; use integer cents"` or `"Do not use for batch operations"`).

---

### Rule 4: In-Band Actionable Errors (RFC 9457)
- **Never swallow errors:** Forbid empty `catch` blocks, `try?` silent `nil` fallbacks, or `fatalError()` on recoverable runtime inputs.
- **Never return raw 500 stacks or generic 400 Bad Requests.**
- All error responses and thrown domain exceptions must adhere to the RFC 9457 Problem Details standard (`AXProblemDetails`):
  ```json
  {
    "type": "https://docs.kickstarter.com/errors/invalid-parameter",
    "title": "Invalid Parameter",
    "status": 400,
    "detail": "Detailed, human- and agent-readable description of what failed.",
    "suggested_action": "Exact prompt-like instruction guiding the caller on how to remediate the request.",
    "is_retriable": false,
    "invalid_params": [{ "name": "field_name", "reason": "Specific constraint violated" }]
  }
  ```

---

### Rule 5: Machine-Tempo Safety & Idempotency
- All mutating endpoints (`POST`, `PUT`, `DELETE`) must require and validate an `Idempotency-Key` header.
- Provide clear machine backoff signals on rate limits (`X-RateLimit-Limit`, `X-RateLimit-Remaining`, `Retry-After`).

---

### Rule 6: Deprecate Legacy Paths Loudly
- When replacing obsolete functions or endpoints, mark them with standard `@available(*, deprecated, ...)` annotations.
- In schema and endpoint metadata, set `deprecated: true` and explicitly document the recommended replacement primitive in the description so automated callers do not route to legacy code.

---

### Rule 7: Carried Headless Verification
- Every refactored module MUST have carried unit tests verifying:
  1. The happy path.
  2. Edge cases and boundary rejections.
  3. Actionable error responses (`suggested_action`, `is_retriable`, `invalid_params`, status codes).
- Tests must be executable locally via a deterministic, scoped CLI command (e.g., `cd KsApi && xcodebuild test -scheme "KsApi-Package" -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPad mini (A17 Pro)" -only-testing:KsApiTests/CheckoutModuleSpec`) without requiring the whole repository test suite to run.

