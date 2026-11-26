# Driver Code Architecture

This document explains how CodeBite manages driver code — the wrapper code that turns a user's solution into a runnable program that reads test inputs, calls the user's function, and prints output for automated judging.

## Overview

Each problem needs driver code per supported language. The driver code:

1. Reads test case input from **stdin** (one test case per Judge0 execution)
2. Parses the input into the correct data types
3. Calls the user's solution class/method
4. Formats and prints the result to **stdout**
5. The judge compares stdout against the expected output

The user never sees driver code — they only write the solution class shown in the starter code.

## Approach: Per-Problem Driver Files + Shared Language Utilities

Driver templates live as standalone source files on the classpath under `common/src/main/resources/drivers/`. Each file uses native file extensions (`.java`, `.py`, `.cpp`, `.js`) so editors provide syntax highlighting, linting, and formatting out of the box.

### Why files instead of database rows?

- **Readable:** Multi-line source code instead of escaped JSON strings in SQL
- **Editable:** Standard IDE support with syntax highlighting
- **Diffable:** Changes show up clearly in git history
- **Reviewable:** PRs can show exactly what changed in a driver template

### File layout

```
common/src/main/resources/drivers/
├── lib/                        ← shared Libraries, Java and C++ only
│   ├── java/
│   │   ├── JsonOutput.java
│   │   ├── ListNode.java
│   │   ├── Node.java
│   │   └── TreeNode.java
│   └── cpp/
│       ├── JsonOutput.cpp
│       ├── ListNode.cpp
│       ├── Node.cpp
│       └── TreeNode.cpp
├── snack-drawer-pair/
│   ├── java.java               ← includes // {{LIB:JsonOutput}}
│   ├── python.py
│   ├── cpp.cpp
│   └── javascript.js
└── reverse-linked-list/
    ├── java.java               ← includes // {{LIB:ListNode}}
    ├── python.py
    ├── cpp.cpp
    └── javascript.js
```

**Lookup convention:** `drivers/{problem-slug}/{language}.{ext}`

Language-to-extension mapping:

| Language     | Extension | Judge0 ID |
|-------------|-----------|-----------|
| `java`       | `.java`   | 62        |
| `python`     | `.py`     | 100 (Python 3.12, from CodeBite's own Judge0 image: docs/adr/0004) |
| `cpp`        | `.cpp`    | 54        |
| `javascript` | `.js`     | 63        |

`Language` (`common/src/main/java/com/codebite/judge/Language.java`) is the one place these live.

## The `{USER_CODE}` Placeholder

Every driver template contains exactly one `{USER_CODE}` placeholder. At submission time, this literal string is replaced with the user's source code via `String.replace()`.

### Example: Snack Drawer Pair (Java)

**Driver template** (`drivers/snack-drawer-pair/java.java`):
```java
import java.util.*;

{USER_CODE}

// {{LIB:JsonOutput}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = numsLine.substring(1, numsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] nums = new int[parts.length];
        for (int i = 0; i < parts.length; i++) nums[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().findPairIndices(nums, target);
        if (result != null && result.length == 2 && result[0] > result[1]) {
            int tmp = result[0]; result[0] = result[1]; result[1] = tmp;
        }
        System.out.println(JsonOutput.intArray(result));
    }
}
```

**User's code** (what they write in the editor):
```java
class Solution {
    public int[] findPairIndices(int[] snacks, int target) {
        Map<Integer, Integer> seen = new HashMap<>();
        for (int i = 0; i < snacks.length; i++) {
            Integer j = seen.get(target - snacks[i]);
            if (j != null) return new int[]{j, i};
            seen.put(snacks[i], i);
        }
        return new int[]{};
    }
}
```

**Final source code** sent to Judge0: the driver template with `{USER_CODE}` replaced by the user's code — a complete, compilable program.

### Example: Snack Drawer Pair (Python)

**Driver template** (`drivers/snack-drawer-pair/python.py`):
```python
{USER_CODE}

import json
nums = eval(input())
target = int(input())
result = Solution().findPairIndices(nums, target)
if result is not None and len(result) == 2 and result[0] > result[1]:
    result = [result[1], result[0]]
print(json.dumps(result, separators=(',', ':')))
```

Python drivers tend to be shorter since `eval(input())` handles most parsing.

## Shared Utility Libraries (`// {{LIB:ClassName}}`)

Problems involving linked lists or trees need shared data structure definitions, and Java and C++ need help printing compact JSON. Rather than duplicating `ListNode` or `JsonOutput` in every driver file, shared utilities live under `drivers/lib/java/` and `drivers/lib/cpp/` and are inlined via markers. Python and JavaScript have no Libraries: a node class comes from the Starter Code, which the user's code keeps, and the Driver formats its own output.

### How it works

1. A driver file includes a marker comment:
   ```java
   import java.util.*;

   {USER_CODE}

   // {{LIB:ListNode}}

   public class Main { ... }
   ```
   In a Java Driver nothing but the Driver's own `import` lines comes before `{USER_CODE}`; markers and helper classes go below it, because Java allows no `import` after a class and the user's code may open with one (`JavaDriversCompileTest` fails on a Driver that breaks this). A Java Library has no imports of its own: one it needs goes with the Driver's imports at the top. C++ keeps its markers above `{USER_CODE}`, where an `#include` after a class is legal.

2. `ProblemAssets` scans the template for `// {{LIB:ClassName}}` patterns.

3. It reads the corresponding utility file from `drivers/lib/{language}/{ClassName}.java` (or the language-appropriate equivalent).

4. The marker line is replaced with the full utility source code.

5. The result (with utilities inlined + user code inserted) is sent to Judge0 as a single source file.

### Example: Reverse Linked List (Java)

**Shared utility** (`drivers/lib/java/ListNode.java`, shortened):
```java
class ListNode {
    int val;
    ListNode next;
    ListNode() {}
    ListNode(int val) { this.val = val; }
    ListNode(int val, ListNode next) { this.val = val; this.next = next; }

    static ListNode fromArray(String input) { ... }     // "[1,2,3]" to a list, "[]" to null

    static String toJsonArray(ListNode head) { ... }    // a list to "[1,2,3]", null to "[]"
}
```

**Driver template** (`drivers/reverse-linked-list/java.java`):
```java
import java.util.*;

{USER_CODE}

// {{LIB:ListNode}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        ListNode head = ListNode.fromArray(line);
        head = new Solution().reverseList(head);
        System.out.println(ListNode.toJsonArray(head));
    }
}
```

Multiple markers can appear in a single file (e.g., `// {{LIB:ListNode}}` and `// {{LIB:TreeNode}}`).

## `ProblemAssets` Service

`ProblemAssets` is a Spring `@Service` in `com.codebite.judge.program` that loads and caches every Driver and Starter Code (`starters/{slug}/{language}.{ext}`).

### Behavior

- **Startup:** Scans `classpath:drivers/` and `classpath:starters/` once, per `Language`.
- **Library resolution:** Before caching, processes `// {{LIB:ClassName}}` markers by reading the corresponding file from `drivers/lib/{language}/` and inlining its contents. A missing library, or a Driver without `{USER_CODE}`, fails startup.
- **`assemble(slug, language, userCode)`:** Returns a `Program`: the Driver with the user's code at `{USER_CODE}`, its Judge0 id, and `diagnostics(compileOutput, stderr)` that maps Judge0's errors back onto the user's lines. Throws `NoDriverException` (answered 400) if the problem has no Driver for that language.

### Integration point

`RunService.run()` and `SubmissionService.submit()` call `problemAssets.assemble(problem.getSlug(), language, userCode)`; Submit publishes `program.toEvent(submission)` to the worker.

## Submission Flow

```
User writes code in Monaco Editor
    │
    ▼
POST /api/problems/{slug}/submit  { sourceCode, language }
    │
    ▼
SubmissionService.submit()                       [backend]
    ├── Find the Problem by Slug or Former Slug
    ├── Language.ofRequest(language)             (400 for a language CodeBite doesn't accept)
    ├── problemAssets.assemble(slug, language, sourceCode)  → Program
    │                                            (400 when the problem has no Driver for it)
    ├── Save Submission (status=PENDING, stores raw user code)
    └── Publish program.toEvent(submission) to Kafka `submission-events`
        (`submission-events-admin` for an admin) → return 201 with PENDING
            │
            ▼
      SubmissionConsumer                         [worker]
            ├── Program.fromEvent(event)         (the event carries the assembled source and Judge0 id)
            ├── grader.grade(program, every TestCase by orderIndex)
            │     one Judge0 batch, one submission per case; compares stdout.trim() to expectedOutput.trim()
            ├── Save one SubmissionResult per case and the overall status
            └── Publish the result to `submission-results`, which the backend announces over SSE
```

Run (`RunService.run()`) takes the same `assemble` step, then grades synchronously and stores nothing: the samples with `grader.gradeUntilFailure`, stopping at the first that fails, and, once they all pass, the request's custom cases with `grader.grade`.

## Writing a New Driver Template

When adding a new problem, create one driver file per supported language:

1. **Create the file** at `common/src/main/resources/drivers/{slug}/{language}.{ext}`

2. **Include `{USER_CODE}`** exactly once — this is where the user's solution class gets inserted

3. **Read input from stdin:** Each test case provides input as stdin. Parse it line by line.
   - Convention: each logical input is on its own line
   - Arrays use JSON-style format: `[1,2,3]`
   - Strings are bare (no quotes in stdin)

4. **Call the user's solution:** Instantiate `Solution` and call the expected method

5. **Print the result to stdout:** Must match the `expected_output` in the test case exactly (after trimming)

6. **Add `// {{LIB:ClassName}}`** if the problem uses shared data structures: below `{USER_CODE}` in Java, above it in C++

### Checklist

- [ ] `{USER_CODE}` placeholder present
- [ ] Reads all inputs from stdin in the correct order
- [ ] Output format matches expected output in test cases
- [ ] No extra whitespace or newlines in output (use `trim()` on expected output comparison)
- [ ] If using shared utilities, `// {{LIB:ClassName}}` marker is present (Java: below `{USER_CODE}`, with only imports above it)
- [ ] Starter code shows the class/method signature the driver expects

## Test Case Input/Output Format

Test case inputs are stored as plain text (one value per line) and passed as stdin to Judge0. The driver parses these.

| Data Type | Input Format | Example |
|-----------|-------------|---------|
| Integer | Plain number | `42` |
| String | Bare text | `hello world` |
| Int array | JSON array | `[1,2,3,4]` |
| String array | JSON array | `["foo","bar"]` |
| 2D array | JSON nested array | `[[1,2],[3,4]]` |
| Boolean | `true` / `false` | `true` |
| Linked list | JSON int array | `[1,2,3,4,5]` (driver converts to ListNode) |
| Tree | Level-order with nulls | `[3,9,20,null,null,15,7]` |

Expected output follows the same conventions. The judge compares `stdout.trim()` against `expectedOutput.trim()`.
