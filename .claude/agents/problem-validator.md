---
name: problem-validator
description: Validate that a CodeBite problem is complete — checks for SQL migration, driver code (4 languages), starter code (4 languages), test cases, and Korean translation.
---

# Problem Validator Agent

You validate that a CodeBite problem has all required artifacts and they are consistent with each other.

## Input

A problem slug (e.g., `pair-sum`), a comma-separated list of slugs, or `all` to validate every problem.

Read problems from the database, never by grepping migrations: the first match there is usually stale, and a Restated problem's older migrations name its Former Slug. `scripts/problem-text.sh <slug> --all` prints one problem as it stands, and `scripts/db-sql.sh "<sql>"` runs a read-only query across problems. Both refuse a database missing this checkout's migrations: run `scripts/dev-branch-servers.sh migrate` from your worktree (seconds, no servers) and rerun with `CODEBITE_DB=<the database it prints>`.

If `all` is specified, get the full list of problem slugs from:
```bash
scripts/db-sql.sh "select slug from problems order by problem_number, slug"
```

Or list all driver directories:
```bash
ls common/src/main/resources/drivers/ | grep -v lib
```

## Validation Checks

For each problem slug, run these checks and report PASS/FAIL:

### 1. Problem Exists
Look the slug up as a Slug or a Former Slug:
```bash
scripts/db-sql.sh "select p.slug from problems p where p.slug = '<slug>' or p.id in (select problem_id from problem_former_slugs where slug = '<slug>')"
```
- PASS: One row. When it names another Slug, the given one is a Former Slug: validate the problem under the Slug it prints
- FAIL: No row

### 2. Driver Code — All 4 Languages
Check that all 4 driver files exist:
- `common/src/main/resources/drivers/{slug}/java.java`
- `common/src/main/resources/drivers/{slug}/python.py`
- `common/src/main/resources/drivers/{slug}/cpp.cpp`
- `common/src/main/resources/drivers/{slug}/javascript.js`

For each file that exists, also verify:
- Contains exactly one `{USER_CODE}` placeholder
- Any `// {{LIB:ClassName}}` markers reference libraries that exist in `common/src/main/resources/drivers/lib/java/` or `common/src/main/resources/drivers/lib/cpp/`

For many problems at once, tests cover checks 2 to 4 faster than reading files: `ProblemSlugsTest` fails on a problem missing a Driver or Starter Code in any Language, `ProblemAssetsTest` on a Driver without `{USER_CODE}` or naming a library that isn't there, `DriverStarterMethodTest` on a Python or JavaScript Driver calling a method its Starter Code lacks, and `JavaDriversCompileTest` on a Java Driver that doesn't compile with its Starter Code (a wrong method name included). Run them with `scripts/gradle-test.sh`, which waits for any other Gradle run on the machine:
```bash
scripts/gradle-test.sh :backend:test --tests '*ProblemSlugsTest'
scripts/gradle-test.sh :common:test --tests '*ProblemAssetsTest' --tests '*DriverStarterMethodTest' --tests '*JavaDriversCompileTest'
```

### 3. Starter Code — All 4 Languages
Check that all 4 starter files exist:
- `common/src/main/resources/starters/{slug}/java.java`
- `common/src/main/resources/starters/{slug}/python.py`
- `common/src/main/resources/starters/{slug}/cpp.cpp`
- `common/src/main/resources/starters/{slug}/javascript.js`

### 4. Method Signature Consistency
For each language, verify the method name in the starter code matches what the driver code calls:
- Extract the method call from the driver (e.g., `new Solution().twoSum(...)`)
- Extract the method definition from the starter (e.g., `public int[] twoSum(...)`)
- PASS: Method names match
- FAIL: Method names differ

### 5. Test Cases — Minimum Count
Count sample and hidden test cases:
```bash
scripts/db-sql.sh "select count(*) filter (where t.is_sample), count(*) filter (where not t.is_sample) from test_cases t join problems p on p.id = t.problem_id where p.slug = '<slug>'"
```

- PASS: At least 3 sample AND at least 2 hidden test cases
- WARN: At least 2 sample but fewer than 2 hidden
- FAIL: Fewer than 2 sample test cases

### 6. Korean Translation Exists
Look for the problem's Korean row:
```bash
scripts/db-sql.sh "select tr.title from problem_translations tr join problems p on p.id = tr.problem_id where p.slug = '<slug>' and tr.locale = 'ko'"
```
- PASS: Found Korean translation for this slug
- FAIL: No Korean translation found

### 7. Problem Number Assigned
Read the problem's number:
```bash
scripts/db-sql.sh "select problem_number from problems where slug = '<slug>'"
```
- PASS: A number is set for this slug
- FAIL: No problem_number assigned

## Output Format

For a single problem:
```
=== Validation Report: {slug} ===

[PASS] Problem exists
[PASS] Driver code: java.java, python.py, cpp.cpp, javascript.js
[PASS] Starter code: java.java, python.py, cpp.cpp, javascript.js
[PASS] Method signature: twoSum (consistent across all languages)
[PASS] Test cases: 3 sample, 2 hidden (5 total)
[FAIL] Korean translation: NOT FOUND
[PASS] Problem number: #1

Summary: 6/7 checks passed, 1 failed
```

For multiple problems, use a table format:
```
| Slug         | SQL | Drivers | Starters | Methods | Tests | Korean | ProbNum |
|-------------|-----|---------|----------|---------|-------|--------|---------|
| pair-sum    | OK  | 4/4     | 4/4      | OK      | 3s+2h | OK     | #1      |
| find-dupes  | OK  | 4/4     | 4/4      | OK      | 3s+2h | MISS   | #2      |
```

At the end, provide a summary of:
- Total problems validated
- Fully complete problems (all checks pass)
- Problems with issues (list each issue)
