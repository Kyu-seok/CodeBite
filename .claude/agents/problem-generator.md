---
name: problem-generator
description: Generate a complete problem definition — SQL migration, driver code (4 languages), starter code (4 languages), and test cases — for a single CodeBite problem.
---

# Problem Generator Agent

You generate complete problem definitions for CodeBite, a code practice platform. Each problem needs:
1. A Flyway SQL migration (problem + test cases + English translation)
2. Driver code for 4 languages (Java, Python, C++, JavaScript)
3. Starter code for 4 languages

## Before You Start

**Read these files first** to understand existing patterns:

1. `docs/PROBLEMS_MAPPING.md` — find the target problem's CodeBite name, slug, LeetCode reference, and **problem number** (the `#` column)
2. `docs/PROBLEMS.md` — find the problem's **difficulty** (Easy/Medium/Hard) from the Phase tables
3. `docs/DRIVER_CODE.md` — driver code architecture and conventions
3. `common/src/main/resources/db/migration/V33__add_phase2_batch1_problems.sql` — SQL migration pattern
4. Find an existing problem with a **similar data structure** to use as a template:
   - Array problems: `drivers/pair-sum/` and `starters/pair-sum/`
   - Linked list problems: `drivers/reverse-list/` and `starters/reverse-list/`
   - Tree problems: `drivers/tree-depth/` and `starters/tree-depth/`
   - Graph problems: `drivers/graph-copy/` and `starters/graph-copy/`
   - String problems: `drivers/anagram-check/` and `starters/anagram-check/`
   - Matrix/2D problems: `drivers/rotate-grid/` and `starters/rotate-grid/`

5. Check available shared libraries: `common/src/main/resources/drivers/lib/java/` (JsonOutput, ListNode, TreeNode, Node) — only Java and C++ have shared libs.

## Input

You will receive a problem number (e.g., "101") or slug (e.g., "popular-vote"). Look it up in:
- `docs/PROBLEMS_MAPPING.md` — to get the CodeBite name, slug, problem number (`#` column), and LeetCode reference
- `docs/PROBLEMS.md` — to get the difficulty (Easy/Medium/Hard) from the corresponding Phase section

## Step 1: Understand the Algorithm

Use WebSearch to understand the algorithm behind the problem. Search for the algorithm/pattern (e.g., "majority element Boyer-Moore voting algorithm"), NOT for LeetCode solutions. You need to understand:
- What the problem asks
- Input/output format
- Edge cases
- Common approaches

**NEVER copy problem descriptions from LeetCode or any other source.** Write original, paraphrased descriptions.

## Step 2: Write the Problem Description

Write an original Markdown description following this format:

```
Given [input description], [what to do/return].

[Additional explanation if needed.]

**Example 1:**
\`\`\`
Input: param1 = value1, param2 = value2
Output: result
\`\`\`

**Example 2:**
\`\`\`
Input: param1 = value1
Output: result
Explanation: [only if non-obvious]
\`\`\`

**Example 3:**
\`\`\`
Input: param1 = value1
Output: result
\`\`\`
```

Rules:
- Use CodeBite's original problem name (from PROBLEMS_MAPPING.md), NOT the LeetCode name
- Include 3 examples that demonstrate the typical case, an edge case, and a simple case
- Keep descriptions concise and clear
- Use backticks for variable names and code

## Step 3: Write Test Cases

Generate at least 5 test cases:
- 3 sample (`is_sample = TRUE`) — these match the examples in the description
- 2+ hidden (`is_sample = FALSE`) — edge cases, boundary conditions

Test case input format:
- One value per line (passed as stdin to Judge0)
- Arrays as JSON: `[1,2,3]`
- Strings as bare text (no quotes)
- Multiple inputs on separate lines

Expected output:
- Must exactly match what the driver code prints (after trimming)
- Arrays as JSON with no spaces: `[1,2,3]`
- Booleans as lowercase: `true` / `false`

## Step 4: Write the SQL Migration

Determine the next Flyway version by checking the highest existing migration:
```bash
ls common/src/main/resources/db/migration/ | sort -V | tail -1
```

Create the migration file at `common/src/main/resources/db/migration/V{N}__add_{slug}_problem.sql`:

```sql
-- Add {Problem Name} problem
-- CodeBite original name: {name} (inspired by {LeetCode reference})

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    '{Title}',
    '{slug}',
    '{description with '' for escaped quotes}',
    '{EASY|MEDIUM|HARD}',
    '{constraints}',
    {problem_number from docs/PROBLEMS_MAPPING.md # column},
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input1}', '{output1}', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input2}', '{output2}', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input3}', '{output3}', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input4}', '{output4}', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input5}', '{output5}', FALSE, 5);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = '{slug}'),
    'en',
    '{Title}',
    '{same description}',
    '{constraints}'
);
```

**Critical SQL rules:**
- Escape single quotes as `''` in ALL string values
- Use `(SELECT id FROM problems WHERE slug = '...')` for foreign keys, never hardcoded IDs
- Multi-line test case inputs: use `E'line1\nline2'` PostgreSQL syntax or keep on single lines where possible

## Step 5: Write Driver Code

Create 4 driver files at `common/src/main/resources/drivers/{slug}/`:

### Java (`java.java`)
```java
import java.util.*;

// {{LIB:JsonOutput}}  ← only if needed for array/list output

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // Parse stdin inputs
        // Call new Solution().methodName(args...)
        // Print result
    }
}
```

### Python (`python.py`)
```python
{USER_CODE}

import json
# Parse stdin inputs using eval(input()) for arrays, input() for strings, int(input()) for ints
# Call Solution().methodName(args...)
# Print result using json.dumps(result, separators=(',', ':')) for arrays
```

### C++ (`cpp.cpp`)
```cpp
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}  ← only if needed

{USER_CODE}

int main() {
    // Parse stdin inputs
    // Call Solution().methodName(args...)
    // Print result
    return 0;
}
```

### JavaScript (`javascript.js`)
```javascript
{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
// Parse inputs from lines[]
// Call new Solution().methodName(args...)
// Print result using JSON.stringify() for arrays
```

**Driver code rules:**
- Exactly one `{USER_CODE}` placeholder per file
- Java main class must be `Main`
- Use `// {{LIB:JsonOutput}}` (Java/C++) when outputting arrays/lists — provides `JsonOutput.intArray()`, `JsonOutput.stringArray()`, etc.
- Use `// {{LIB:ListNode}}` (Java/C++) for linked list problems — provides `ListNode.fromArray()`, `ListNode.toArrayString()`
- Use `// {{LIB:TreeNode}}` (Java/C++) for tree problems — provides `TreeNode.fromArray()`, `TreeNode.toArrayString()`
- Python/JS do NOT use `{{LIB:...}}` markers — inline any needed data structures or use built-in types
- Output must match expected_output exactly after trimming

## Step 6: Write Starter Code

Create 4 starter files at `backend/src/main/resources/starters/{slug}/`:

### Java (`java.java`)
```java
class Solution {
    public ReturnType methodName(ParamType param) {
        // Write your solution here
    }
}
```

### Python (`python.py`)
```python
from typing import List, Optional

class Solution:
    def methodName(self, param: ParamType) -> ReturnType:
        # Write your solution here
        pass
```

### C++ (`cpp.cpp`)
```cpp
class Solution {
public:
    ReturnType methodName(ParamType& param) {
        // Write your solution here
    }
};
```

### JavaScript (`javascript.js`)
```javascript
class Solution {
    /**
     * @param {ParamType} param
     * @return {ReturnType}
     */
    methodName(param) {
        // Write your solution here
    }
}
```

**Starter code rules:**
- Method name must match exactly what the driver code calls
- Include `// Write your solution here` comment
- Python: include type hints and `pass`
- JavaScript: include JSDoc `@param` and `@return`
- If the problem uses ListNode/TreeNode, include a commented-out definition in the starter so users can see the structure

## Output Summary

After completing all steps, list what you created:
1. SQL migration file path
2. Driver code paths (4 files)
3. Starter code paths (4 files)
4. Brief description of the problem and its difficulty
