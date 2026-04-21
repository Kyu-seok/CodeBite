---
name: test-case-generator
description: Generate comprehensive test cases for a CodeBite problem, validate them by running reference solutions through Judge0, and output a Flyway SQL migration.
---

# Test Case Generator Agent

You generate comprehensive test cases for existing CodeBite problems and validate them by running reference solutions against Judge0.

## Prerequisites

- `JUDGE0_URL` environment variable must be set (e.g., `http://localhost:2358`)
- The target problem must already exist (SQL migration, driver code, starter code)

## Before You Start

**Read these files first:**

1. `docs/DRIVER_CODE.md` — understand driver code architecture
2. Find the problem's existing test cases by searching migration files:
   ```bash
   grep -r '{slug}' common/src/main/resources/db/migration/ --include='*.sql'
   ```
3. Read the problem's driver code for all 4 languages:
   - `common/src/main/resources/drivers/{slug}/java.java`
   - `common/src/main/resources/drivers/{slug}/python.py`
   - `common/src/main/resources/drivers/{slug}/cpp.cpp`
   - `common/src/main/resources/drivers/{slug}/javascript.js`
4. Read the problem's description from its migration file to understand input/output format

## Input

A problem slug (e.g., `pair-sum`) or a list of slugs.

## Step 1: Analyze the Problem

From the migration file, extract:
- Problem description and constraints
- Existing test cases (input format, output format)
- Input parsing pattern from driver code

## Step 2: Generate Reference Solutions

Write a correct, efficient solution in all 4 languages. These are internal validation tools — they will NOT be stored in the app.

The solution code must match what the starter code expects (same class name `Solution`, same method signature).

## Step 3: Generate Test Cases

Generate additional test cases targeting 10-15 total (including existing ones). Cover:

1. **Minimum input** — smallest valid input per constraints (e.g., single element array, empty string)
2. **Maximum input edge** — large inputs near constraint limits (but keep reasonable for Judge0 — avoid timeout-inducing sizes)
3. **Boundary values** — 0, -1, INT_MAX, empty arrays, single character strings
4. **Duplicate values** — all same elements, many duplicates
5. **Already sorted / reverse sorted** — if order matters
6. **Single element** — arrays of length 1
7. **Negative numbers** — if the problem allows them
8. **Algorithm-specific edge cases** — varies by problem type

Each test case needs:
- `input`: line-separated stdin matching the driver's parsing format
- `expected_output`: exactly what the driver prints for this input

## Step 4: Validate via Judge0

For each test case, validate against the reference solution in at least 2 languages (Python is fastest, Java for type safety).

### Validation Process

First, check Judge0 is reachable:
```bash
curl -s "$JUDGE0_URL/about" | head -5
```

For each (language, test_case) pair:

1. **Assemble source code:** Read the driver template file and replace `{USER_CODE}` with the reference solution.

   If the driver has `// {{LIB:ClassName}}` markers, you need to inline the library. Read the library file from `common/src/main/resources/drivers/lib/{language}/{ClassName}.{ext}` and replace the marker line with its contents.

2. **Submit to Judge0:**
```bash
curl -s -X POST "$JUDGE0_URL/submissions?base64_encoded=false&wait=true" \
  -H "Content-Type: application/json" \
  -d '{
    "source_code": "<assembled source>",
    "language_id": <id>,
    "stdin": "<test input>"
  }'
```

Language IDs: Java=62, Python=71, JavaScript=63, C++=54

3. **Check result:**
   - Status ID 3 = executed successfully
   - Compare `stdout` (trimmed) against `expected_output` (trimmed)
   - If status != 3 or output doesn't match, the test case FAILS

4. **Handle failures:**
   - If a test case fails, check if the expected output is wrong (fix it) or the reference solution has a bug (fix the solution)
   - If it fails in one language but passes in others, the driver or solution for that language has a bug
   - Do NOT include test cases that fail validation

### Dealing with large source code in curl

For source code too large for command-line arguments, write it to a temp file and use:
```bash
# Write source to temp file
cat > /tmp/judge0_source.json << 'ENDJSON'
{
  "source_code": "...",
  "language_id": 71,
  "stdin": "..."
}
ENDJSON

curl -s -X POST "$JUDGE0_URL/submissions?base64_encoded=false&wait=true" \
  -H "Content-Type: application/json" \
  -d @/tmp/judge0_source.json
```

## Step 5: Write SQL Migration

Determine the next Flyway version:
```bash
ls common/src/main/resources/db/migration/ | sort -V | tail -1
```

Create the migration at `common/src/main/resources/db/migration/V{N}__add_{slug}_test_cases.sql`:

```sql
-- Additional test cases for {Problem Name}
-- Validated against reference solutions in all 4 languages via Judge0

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = '{slug}'), '{input}', '{output}', FALSE, {next_order_index}),
    ...;
```

**Rules:**
- New test cases are always `is_sample = FALSE` (hidden)
- `order_index` continues from the last existing test case's index
- Escape single quotes as `''`
- For multi-line inputs, use PostgreSQL `E'line1\nline2'` syntax

## Output Summary

Report:
1. SQL migration file path
2. Number of new test cases added
3. Validation results: how many test cases passed in each language
4. Any test cases that were generated but excluded (and why)
