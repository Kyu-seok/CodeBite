# Submission Flow & Code Templates

## Overview

When a user submits code on CodeBite, the request flows through a Kafka-based pipeline:

```
Frontend → Backend API → Kafka → Worker → Judge0 → DB → Frontend (polling)
```

The system uses two types of code templates — **starters** and **drivers** — to bridge between the user's solution code and Judge0's stdin/stdout execution model.

---

## Starters vs Drivers

### Starter Code

Starter code is the boilerplate shown to the user when they open a problem. It defines the function signature they need to implement.

**Example** (`starters/two-sum/java.java`):
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        // write your solution here
    }
}
```

- **Location**: `backend/src/main/resources/starters/{slug}/{language}.{ext}`
- **Loaded by**: `StarterCodeLoader` (`backend/.../problem/service/StarterCodeLoader.java`)
- **When**: Cached on startup via `@PostConstruct`. Served as part of the problem detail response (`GET /api/problems/{slug}`)
- **Used by**: Frontend only (populates the Monaco editor)

### Driver Code

Driver code is a hidden wrapper template that turns the user's solution into a complete program Judge0 can execute. It handles input parsing (stdin), calling the user's function, and printing the output (stdout).

**Example** (`drivers/two-sum/java.java`):
```java
// {{LIB:JsonOutput}}
import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // parse stdin into function arguments...
        Solution sol = new Solution();
        int[] result = sol.twoSum(nums, target);
        System.out.println(JsonOutput.toJson(result));
    }
}
```

- **Location**: `common/src/main/resources/drivers/{slug}/{language}.{ext}`
- **Libraries**: `common/src/main/resources/drivers/lib/{language}/*.{ext}` — reusable code (e.g., `JsonOutput`, `TreeNode`, `ListNode`) referenced via `// {{LIB:ClassName}}` markers in templates
- **Loaded by**: `DriverCodeLoader` (`common/.../judge/service/DriverCodeLoader.java`)
- **When**: Cached on startup. Library markers are resolved at load time (replaced with actual library code).
- **Used by**: Backend (to build final source code before publishing to Kafka). The user never sees driver code.

### Why They're Separate

| Aspect | Starters | Drivers |
|--------|----------|---------|
| **Purpose** | User-facing boilerplate | Hidden execution wrapper |
| **Contains** | Function signature only | Input parsing + output formatting + `{USER_CODE}` placeholder |
| **Module** | `backend/` (only API serves them) | `common/` (shared — backend builds source with them) |
| **Visible to user** | Yes (shown in editor) | No (internal only) |

---

## Submission Flow — Step by Step

### 1. Frontend: User Submits Code

The user writes code in the Monaco editor and clicks **Submit**.

`ProblemDetailPage.tsx` calls `POST /api/problems/{slug}/submit` with:
```json
{ "language": "java", "sourceCode": "class Solution { ... }" }
```

### 2. Backend: Validate & Publish to Kafka

`SubmissionService.submit()` processes the request synchronously:

1. **Validate** — Problem exists, language is supported
2. **Load driver template** — `driverCodeLoader.getDriverCode(slug, language)` returns the cached template with library markers already resolved
3. **Save to DB** — Create `Submission` entity with status `PENDING`, store the user's raw source code
4. **Build final source** — `judgeService.buildSourceCode(driverTemplate, userCode)` replaces the `{USER_CODE}` placeholder in the driver template with the user's code
5. **Map language** — Convert language string to Judge0 ID (java→62, python→71, javascript→63, cpp→54)
6. **Publish to Kafka** — `SubmissionEventProducer.send()` publishes a `SubmissionEvent` to the `submission-events` topic:
   ```
   SubmissionEvent {
       submissionId: 42,
       sourceCode: "// full driver + user code merged",
       languageId: 62,
       problemId: 1
   }
   ```
7. **Return immediately** — Respond with `201 Created` and the submission in `PENDING` status (empty results)

### 3. Kafka: Message Queue

The `submission-events` topic (3 partitions) decouples the API from processing. The submission ID is used as the message key, ensuring ordering per submission.

### 4. Worker: Consume & Execute Against Judge0

`SubmissionConsumer.consume()` picks up the event:

1. **Idempotency check** — Fetch the submission from DB. Skip if it's missing or no longer `PENDING` (protects against duplicate delivery).
2. **Load test cases** — Fetch all test cases for the problem, ordered by `orderIndex`
3. **For each test case**, call `JudgeService.execute()`:

   **a. Submit to Judge0:**
   ```
   POST {judge0-url}/submissions?base64_encoded=false
   Body: { source_code, language_id, stdin }
   Response: { token: "abc-123" }
   ```

   **b. Poll for result** (every 500ms, up to 30s timeout):
   ```
   GET {judge0-url}/submissions/abc-123?base64_encoded=false
   Response: { status: { id, description }, stdout, stderr, time, memory }
   ```
   - Status 1 (In Queue) or 2 (Processing) → keep polling
   - Any other status → done

   **c. Map Judge0 status** to `SubmissionStatus`:
   | Judge0 Status | Mapped Status |
   |---------------|---------------|
   | 3 (Accepted) + output matches expected | `ACCEPTED` |
   | 3 (Accepted) + output mismatch | `WRONG_ANSWER` |
   | 5 | `TIME_LIMIT_EXCEEDED` |
   | 6 | `COMPILATION_ERROR` |
   | 7–12 | `RUNTIME_ERROR` |
   | Other | `INTERNAL_ERROR` |

   **d. Create `SubmissionResult`** entity with: status, actual output, stderr, runtime (ms), memory (KB)

   **e. Early exit** — If any test case is not `ACCEPTED`, stop immediately (don't run remaining cases)

4. **Save results** — Bulk insert all `SubmissionResult` rows
5. **Update submission** — Set final `status`, `runtimeMs` (max across cases), `memoryKb` (max across cases)

If any exception occurs, the submission is marked `INTERNAL_ERROR`.

### 5. Frontend: Poll for Result

After receiving the initial `PENDING` response, the frontend polls every **2 seconds**:

```
GET /api/submissions/{id}
```

- If `status === "PENDING"` → keep polling
- If `status !== "PENDING"` → stop polling, display results:
  - Overall status badge (ACCEPTED, WRONG_ANSWER, etc.)
  - Runtime and memory usage
  - Per-test-case results (input/expected/actual output shown **only for sample test cases** — hidden test cases are private)
  - Refresh submission history list

---

## Sequence Diagram

```
User          Frontend         Backend API        Kafka         Worker          Judge0         DB
  |               |                |                |              |               |             |
  |--write code-->|                |                |              |               |             |
  |--click submit>|                |                |              |               |             |
  |               |--POST /submit->|                |              |               |             |
  |               |                |--save PENDING--+------------------------------------>|     |
  |               |                |--build source  |              |               |             |
  |               |                |--publish------>|              |               |             |
  |               |<--201 PENDING--|                |              |               |             |
  |               |                |                |--consume---->|               |             |
  |               |--GET /sub/{id}>|                |              |               |             |
  |               |<--PENDING------|                |              |               |             |
  |               |                |                |              |--POST /sub--->|             |
  |               |                |                |              |<--token-------|             |
  |               |                |                |              |--GET /sub---->|             |
  |               |                |                |              |<--result------|             |
  |               |                |                |              |--save results----------->|  |
  |               |                |                |              |--update status---------->|  |
  |               |--GET /sub/{id}>|                |              |               |             |
  |               |<--ACCEPTED-----|<-------------------------------------------------read--|   |
  |<--show result-|                |                |              |               |             |
```

---

## Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Kafka send fails after DB commit | Submission stuck as `PENDING` (consider adding a stale-submission cleanup job) |
| Worker crashes mid-processing | Kafka redelivers the message; idempotency check skips if already processed |
| Judge0 times out (>30s) | `JudgeExecutionException` thrown → submission marked `INTERNAL_ERROR` |
| Judge0 unreachable | HTTP error → `JudgeExecutionException` → `INTERNAL_ERROR` |
| Duplicate Kafka delivery | Consumer checks `status == PENDING` before processing; skips otherwise |
