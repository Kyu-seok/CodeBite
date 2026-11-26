# Submission Flow, Starter Code & Drivers

## Overview

When a user submits code on CodeBite, the request flows through a Kafka-based pipeline:

```
Frontend → Backend API → Kafka → Worker → Judge0 → DB → Kafka → Backend → Frontend (SSE, polling as fallback)
```

The system uses two kinds of per-problem source — **starters** and **drivers** — to bridge between the user's solution code and Judge0's stdin/stdout execution model.

---

## Starters vs Drivers

### Starter Code

Starter code is the boilerplate shown to the user when they open a problem. It defines the function signature they need to implement.

**Example** (`starters/snack-drawer-pair/java.java`):
```java
class Solution {
    public int[] findPairIndices(int[] snacks, int target) {
        // Write your solution here
    }
}
```

- **Location**: `common/src/main/resources/starters/{slug}/{language}.{ext}`
- **Loaded by**: `ProblemAssets` (`common/.../judge/program/ProblemAssets.java`)
- **When**: Cached on startup. Served as part of the problem detail response (`GET /api/problems/{slug}`)
- **Used by**: Frontend only (populates the Monaco editor)

### Driver Code

A Driver is the hidden per-problem source that turns the user's solution into a complete program Judge0 can execute. It handles input parsing (stdin), calling the user's function, and printing the output (stdout).

**Example** (`drivers/snack-drawer-pair/java.java`, shortened):
```java
import java.util.*;

{USER_CODE}

// {{LIB:JsonOutput}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // parse stdin into nums and target...
        int[] result = new Solution().findPairIndices(nums, target);
        System.out.println(JsonOutput.intArray(result));
    }
}
```

- **Location**: `common/src/main/resources/drivers/{slug}/{language}.{ext}`
- **Libraries**: `common/src/main/resources/drivers/lib/{language}/*.{ext}`, Java and C++ only — reusable code (`JsonOutput`, `ListNode`, `Node`, `TreeNode`) referenced via `// {{LIB:ClassName}}` markers in Drivers
- **Loaded by**: `ProblemAssets` (`common/.../judge/program/ProblemAssets.java`), which `assemble`s a `Program` from a Driver and the user's code
- **When**: Cached on startup. Library markers are resolved at load time (replaced with actual library code), and a Driver without `{USER_CODE}` fails startup.
- **Used by**: Backend (to build final source code before publishing to Kafka). The user never sees driver code.

### Why They're Separate

| Aspect | Starters | Drivers |
|--------|----------|---------|
| **Purpose** | User-facing boilerplate | Hidden Driver that runs the user's code |
| **Contains** | Function signature only | Input parsing + output formatting + `{USER_CODE}` placeholder |
| **Module** | `common/` (only the API serves them; one `ProblemAssets` reads both) | `common/` (shared — backend builds source with them) |
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

1. **Validate** — The problem exists under the Slug or a Former Slug, and `Language.ofRequest` knows the language (400 otherwise)
2. **Assemble the Program** — `problemAssets.assemble(slug, language, userCode)` puts the user's code at the `{USER_CODE}` placeholder of the cached Driver (library markers already resolved) and picks the Judge0 id from `Language` (java→62, python→100, javascript→63, cpp→54); a problem with no Driver for the language fails here, before anything is saved
3. **Save to DB** — Create `Submission` entity with status `PENDING`, store the user's raw source code
4. **Publish to Kafka** — `SubmissionEventProducer.send(program.toEvent(submission))` publishes a `SubmissionEvent`, without waiting for the broker, to the `submission-events` topic (an admin's to `submission-events-admin`):
   ```
   SubmissionEvent {
       submissionId: 42,
       sourceCode: "// full driver + user code merged",
       languageId: 62,
       problemId: 1,
       adminSubmission: false,
       language: "java"
   }
   ```
5. **Return immediately** — Respond with `201 Created` and the submission in `PENDING` status (empty results)

### 3. Kafka: Message Queue

The `submission-events` topic (3 partitions; `submission-events-admin` has 1) decouples the API from processing. The submission ID is used as the message key, ensuring ordering per submission.

### 4. Worker: Consume & Execute Against Judge0

`SubmissionConsumer.consume()` (group `codebite-worker`; `consumeAdmin()`, group `codebite-worker-admin`, for the admin topic) picks up the event, in one transaction:

1. **Idempotency check** — Fetch the submission from DB. Skip if it's missing or no longer `PENDING` (protects against duplicate delivery).
2. **Load test cases** — Fetch all test cases for the problem, ordered by `orderIndex`
3. **Grade every case in one Judge0 batch** — `Program.fromEvent(event)` rebuilds the Program, and `Grader.grade` hands every case to `JudgeService.executeBatch()`:

   **a. Submit the batch to Judge0**, one submission per test case:
   ```
   POST {judge0-url}/submissions/batch?base64_encoded=true
   Body: { submissions: [{ source_code, language_id, stdin }, ...] }
   Response: [{ token }, ...]
   ```

   **b. Poll the batch** (every 150 ms, `app.judge0.poll-interval-ms`, up to 30 s, `app.judge0.poll-timeout-ms`):
   ```
   GET {judge0-url}/submissions/batch?tokens=abc-123,def-456&base64_encoded=true
   Response: { submissions: [{ status: { id, description }, stdout, stderr, compile_output, time, memory }, ...] }
   ```
   - Any submission at status 1 (In Queue) or 2 (Processing) → keep polling
   - Every one at another status → done

   **c. Map each Judge0 status** to `SubmissionStatus` (`CaseVerdict.of`, comparing trimmed stdout with the trimmed expected output):
   | Judge0 Status | Mapped Status |
   |---------------|---------------|
   | 3 (Accepted) + output matches expected | `ACCEPTED` |
   | 3 (Accepted) + output mismatch | `WRONG_ANSWER` |
   | 5 | `TIME_LIMIT_EXCEEDED` |
   | 6 | `COMPILATION_ERROR` |
   | 7–12 | `RUNTIME_ERROR` |
   | Other | `INTERNAL_ERROR` |

   **d. Every case runs.** The overall status is the status of the first case, in order, that is not `ACCEPTED`, or `ACCEPTED` when there is none (docs/adr/0005).

4. **Save results** — `Submission.grade(verdict, testCases)` adds one `SubmissionResult` per case (status, actual output, stderr, runtime in ms, memory in KB), saved by cascade
5. **Update submission** — Set final `status`, `runtimeMs` (max across cases), `memoryKb` (max across cases)
6. **Announce** — After the commit, `SubmissionResultProducer` publishes the result to the `submission-results` topic, where the backend's `SubmissionResultListener` pushes it to the user's open result stream

An exception (Judge0 unreachable or timed out included) rolls the transaction back and leaves the submission `PENDING`; the worker retries three times, one second apart, and then `SubmissionFailureRecoverer` marks it `INTERNAL_ERROR`.

### 5. Frontend: Wait for the Verdict

After receiving the initial `PENDING` response, `ProblemDetailPage.tsx` watches the submission through `useSubmissionWatch`, which runs `frontend/src/judge/watchSubmission.ts`:

1. **Stream first** — `POST /api/submissions/{id}/stream-token` returns a short-lived token, and an `EventSource` opens `GET /api/submissions/{id}/stream`. When the stream announces the verdict, the page fetches `GET /api/submissions/{id}`.
2. **Then polling** — When the stream can't be opened (no Redis: the token request answers 404), closes for good, stays silent for 90 s, or announces a result the fetch still reports as `PENDING`, the watch polls `GET /api/submissions/{id}` every 500 ms for up to 60 s.

Once the status is no longer `PENDING`, the page shows:
  - Overall status badge (ACCEPTED, WRONG_ANSWER, etc.)
  - Runtime and memory usage
  - Per-test-case results. A sample case carries its input and expected output; a hidden case carries neither, except the Failing Case: the first case that is not `ACCEPTED` (none after a compile error or an error on our side), whose input, expected output and actual output come in `failingCase` even when it is hidden (docs/adr/0006). Turning off "Show failing case" in the editor settings hides it on the page only.
  - Refresh submission history list

---

## Sequence Diagram

```
User        Frontend          Backend API        Kafka           Worker          Judge0       DB
  |             |                  |                |               |               |           |
  |--submit---->|                  |                |               |               |           |
  |             |--POST /submit--->|                |               |               |           |
  |             |                  |--assemble Program              |               |           |
  |             |                  |--save PENDING------------------------------------------------>|
  |             |                  |--publish------>|               |               |           |
  |             |<--201 PENDING----|                |               |               |           |
  |             |--POST stream-token, open stream-->|               |               |           |
  |             |                  |                |--consume----->|               |           |
  |             |                  |                |               |--POST batch-->|           |
  |             |                  |                |               |<--tokens------|           |
  |             |                  |                |               |--GET batch--->| (polls)   |
  |             |                  |                |               |<--results-----|           |
  |             |                  |                |               |--save results, status---->|
  |             |                  |                |<--result------|               |           |
  |             |                  |<--result-------|               |               |           |
  |             |<--SSE "result"---|                |               |               |           |
  |             |--GET /sub/{id}-->|                |               |               |           |
  |             |<--ACCEPTED-------|<--read--------------------------------------------------------|
  |<--result----|                  |                |               |               |           |
```

---

## Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Kafka send fails after DB commit | The row stays `PENDING` and `codebite.submissions.publish.failures` counts it; `StuckSubmissionRedriver`, every 60 s, re-publishes a submission `PENDING` for over 2 minutes, and abandons one `PENDING` for over 30 minutes to `INTERNAL_ERROR` |
| Worker crashes mid-processing | The transaction rolls back and Kafka redelivers the message; idempotency check skips if already processed |
| Judge0 times out (>30s) | `JudgeExecutionException` → rollback, three retries one second apart → `INTERNAL_ERROR` (`SubmissionFailureRecoverer`) |
| Judge0 unreachable | HTTP error → `JudgeExecutionException` → the same retries → `INTERNAL_ERROR` |
| Duplicate Kafka delivery | Consumer checks `status == PENDING` before processing; skips otherwise |
