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

Driver templates live as standalone source files on the classpath under `src/main/resources/drivers/`. Each file uses native file extensions (`.java`, `.py`, `.cpp`, `.js`) so editors provide syntax highlighting, linting, and formatting out of the box.

### Why files instead of database rows?

- **Readable:** Multi-line source code instead of escaped JSON strings in SQL
- **Editable:** Standard IDE support with syntax highlighting
- **Diffable:** Changes show up clearly in git history
- **Reviewable:** PRs can show exactly what changed in a driver template

### File layout

```
src/main/resources/drivers/
├── lib/                        ← shared utilities (data structures, parsers)
│   ├── java/
│   │   ├── ListNode.java
│   │   ├── TreeNode.java
│   │   └── GraphNode.java
│   ├── python/
│   │   ├── list_node.py
│   │   ├── tree_node.py
│   │   └── graph_node.py
│   ├── cpp/
│   │   └── ...
│   └── javascript/
│       └── ...
├── two-sum/
│   ├── java.java
│   ├── python.py
│   ├── cpp.cpp
│   └── javascript.js
├── fizzbuzz/
│   ├── java.java
│   └── ...
└── reverse-linked-list/
    ├── java.java               ← includes // {{LIB:ListNode}}
    └── python.py
```

**Lookup convention:** `drivers/{problem-slug}/{language}.{ext}`

Language-to-extension mapping:

| Language     | Extension | Judge0 ID |
|-------------|-----------|-----------|
| `java`       | `.java`   | 62        |
| `python`     | `.py`     | 71        |
| `cpp`        | `.cpp`    | 54        |
| `javascript` | `.js`     | 63        |

## The `{USER_CODE}` Placeholder

Every driver template contains exactly one `{USER_CODE}` placeholder. At submission time, this literal string is replaced with the user's source code via `String.replace()`.

### Example: Two Sum (Java)

**Driver template** (`drivers/two-sum/java.java`):
```java
import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = numsLine.substring(1, numsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] nums = new int[parts.length];
        for (int i = 0; i < parts.length; i++)
            nums[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().twoSum(nums, target);
        System.out.println(Arrays.toString(result).replace(" ", ""));
    }
}
```

**User's code** (what they write in the editor):
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement))
                return new int[]{map.get(complement), i};
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}
```

**Final source code** sent to Judge0: the driver template with `{USER_CODE}` replaced by the user's code — a complete, compilable program.

### Example: Two Sum (Python)

**Driver template** (`drivers/two-sum/python.py`):
```python
{USER_CODE}

import sys
nums = eval(input())
target = int(input())
result = Solution().twoSum(nums, target)
print(result)
```

Python drivers tend to be shorter since `eval(input())` handles most parsing.

## Shared Utility Libraries (`// {{LIB:ClassName}}`)

Problems involving linked lists, trees, or graphs need shared data structure definitions. Rather than duplicating `ListNode` in every driver file, shared utilities live under `drivers/lib/{language}/` and are inlined via markers.

### How it works

1. A driver file includes a marker comment:
   ```java
   // {{LIB:ListNode}}

   {USER_CODE}

   public class Main { ... }
   ```

2. `DriverCodeLoader` scans the template for `// {{LIB:ClassName}}` patterns.

3. It reads the corresponding utility file from `drivers/lib/{language}/{ClassName}.java` (or the language-appropriate equivalent).

4. The marker line is replaced with the full utility source code.

5. The result (with utilities inlined + user code inserted) is sent to Judge0 as a single source file.

### Example: Reverse Linked List (Java)

**Shared utility** (`drivers/lib/java/ListNode.java`):
```java
class ListNode {
    int val;
    ListNode next;
    ListNode(int val) { this.val = val; this.next = null; }

    static ListNode fromArray(int[] arr) {
        ListNode dummy = new ListNode(0);
        ListNode curr = dummy;
        for (int v : arr) { curr.next = new ListNode(v); curr = curr.next; }
        return dummy.next;
    }

    static String toArrayString(ListNode head) {
        StringBuilder sb = new StringBuilder("[");
        while (head != null) {
            sb.append(head.val);
            if (head.next != null) sb.append(",");
            head = head.next;
        }
        return sb.append("]").toString();
    }
}
```

**Driver template** (`drivers/reverse-linked-list/java.java`):
```java
import java.util.*;

// {{LIB:ListNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // parse [1,2,3,4,5] into int array, then build linked list
        String inner = line.substring(1, line.length() - 1);
        int[] arr = Arrays.stream(inner.split(","))
            .mapToInt(s -> Integer.parseInt(s.trim())).toArray();
        ListNode head = ListNode.fromArray(arr);
        ListNode result = new Solution().reverseList(head);
        System.out.println(ListNode.toArrayString(result));
    }
}
```

Multiple markers can appear in a single file (e.g., `// {{LIB:ListNode}}` and `// {{LIB:TreeNode}}`).

## `DriverCodeLoader` Service

`DriverCodeLoader` is a Spring `@Service` in `com.codebite.judge.service` responsible for loading and caching driver templates.

### Behavior

- **Startup:** Scans `classpath:drivers/` and loads all templates into an in-memory `Map<String, String>` keyed by `{slug}:{language}` (e.g., `two-sum:java`)
- **`getDriverCode(slug, language)`:** Returns the cached template string. Throws if no template exists for the given slug+language combination.
- **Library resolution:** Before caching, processes `// {{LIB:ClassName}}` markers by reading the corresponding file from `drivers/lib/{language}/` and inlining its contents.

### Integration point

`SubmissionService.submit()` calls `driverCodeLoader.getDriverCode(problem.getSlug(), language)` to get the template, then passes it to `judgeService.buildSourceCode(template, userCode)` for `{USER_CODE}` replacement.

## Submission Flow

```
User writes code in Monaco Editor
    │
    ▼
POST /api/problems/{slug}/submit  { sourceCode, language }
    │
    ▼
SubmissionService.submit()
    ├── Fetch Problem by slug
    ├── Validate language is supported
    ├── Load driver template: driverCodeLoader.getDriverCode(slug, language)
    ├── Save Submission (status=PENDING, stores raw user code)
    ├── Build full source: driverTemplate.replace("{USER_CODE}", userCode)
    ├── Get Judge0 language ID
    └── Trigger async processing → return immediately with PENDING
            │
            ▼
      SubmissionJudgeProcessor.processAsync()  [background thread]
            │
            ├── For each TestCase (ordered by orderIndex):
            │     ├── POST to Judge0: { source_code, language_id, stdin: testCase.input }
            │     ├── Poll GET /submissions/{token} until complete
            │     ├── Compare stdout.trim() to expectedOutput.trim()
            │     └── Save SubmissionResult (status, actualOutput, runtime, memory)
            │
            └── Update Submission with overall status, max runtime, max memory
```

## Writing a New Driver Template

When adding a new problem, create one driver file per supported language:

1. **Create the file** at `src/main/resources/drivers/{slug}/{language}.{ext}`

2. **Include `{USER_CODE}`** exactly once — this is where the user's solution class gets inserted

3. **Read input from stdin:** Each test case provides input as stdin. Parse it line by line.
   - Convention: each logical input is on its own line
   - Arrays use JSON-style format: `[1,2,3]`
   - Strings are bare (no quotes in stdin)

4. **Call the user's solution:** Instantiate `Solution` and call the expected method

5. **Print the result to stdout:** Must match the `expected_output` in the test case exactly (after trimming)

6. **Add `// {{LIB:ClassName}}`** if the problem uses shared data structures

### Checklist

- [ ] `{USER_CODE}` placeholder present
- [ ] Reads all inputs from stdin in the correct order
- [ ] Output format matches expected output in test cases
- [ ] No extra whitespace or newlines in output (use `trim()` on expected output comparison)
- [ ] If using shared utilities, `// {{LIB:ClassName}}` marker is present
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
