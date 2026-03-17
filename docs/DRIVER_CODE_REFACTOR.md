# Driver Code Refactor Plan

## Problem

Driver code templates are stored in the `problems` PostgreSQL table as a JSON `Map<String, String>` (language key → escaped code string), added in migration V5. These are hard to read, edit, and maintain as escaped single-line strings in SQL.

## Goals

1. Move driver code into separate files on the classpath for readability and maintainability
2. Support complex problem types (linked lists, trees, graphs) via shared utility libraries
3. Prepare for C++ and JavaScript language support

## Approach: Per-Problem Driver Files + Shared Language Utilities

**Templating:** Plain `String.replace()` with `{USER_CODE}` placeholder. One placeholder doesn't justify a template engine dependency, and native file extensions preserve syntax highlighting.

**Shared utilities:** Reusable data structure definitions + parse/serialize helpers per language (ListNode, TreeNode, GraphNode). Prepended to driver code via a `// {{LIB:ClassName}}` marker before sending to Judge0.

**Driver files:** One file per problem per language. Short because they delegate to shared utilities. For complex problems (clone graph, etc.), custom verification logic lives in the driver.

## File Organization

```
src/main/resources/drivers/
├── lib/                              ← shared per-language utilities
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
└── reverse-linked-list/              ← uses shared ListNode utility
    ├── java.java                     ← contains // {{LIB:ListNode}}
    └── ...
```

Lookup: `drivers/{slug}/{language}.{ext}` via a static map (`java`→`.java`, `python`→`.py`, `cpp`→`.cpp`, `javascript`→`.js`).

## Implementation Steps

### Step 1: Create driver template files

- Extract 5 existing problems × 2 languages from V5 migration into 10 files under `src/main/resources/drivers/{slug}/`
- Each file is readable, multi-line source code with `{USER_CODE}` placeholder

### Step 2: Create `DriverCodeLoader` service

- New class in `com.codebite.judge.service`
- Reads templates from classpath at startup, caches in `Map<String, String>` keyed by `{slug}:{language}`
- Exposes `getDriverCode(String slug, String language)` → returns template string
- Handles `// {{LIB:ClassName}}` markers: resolves and inlines shared utility code

### Step 3: Update `SubmissionService.submit()`

- Inject `DriverCodeLoader` instead of reading `problem.getDriverCode()`
- Change line 62-64 from:
  ```java
  Map<String, String> driverCode = problem.getDriverCode();
  if (driverCode == null || !driverCode.containsKey(language)) { ... }
  ```
  to:
  ```java
  String driverTemplate = driverCodeLoader.getDriverCode(problem.getSlug(), language);
  ```

### Step 4: Remove `driverCode` from Problem entity and DTOs

- `Problem.java` — remove field, getter, setter (lines 38-40, 91-97)
- `CreateProblemRequest.java` — remove `driverCode` field
- `UpdateProblemRequest.java` — remove `driverCode` field
- `ProblemService.java` — remove `setDriverCode()` calls in create/update methods

### Step 5: Flyway migration

- New migration `V7__drop_driver_code_column.sql`:
  ```sql
  ALTER TABLE problems DROP COLUMN driver_code;
  ```

### Step 6: Update tests

- Update any tests that reference `problem.getDriverCode()` or set driver code on Problem entities
- Add tests for `DriverCodeLoader` (template loading, lib resolution, missing template error)

### Step 7: Add C++ and JavaScript support

- Add language ID mappings in `JudgeService.LANGUAGE_IDS`: `"cpp" → 54`, `"javascript" → 63`
- Create starter code for all 5 problems in C++ and JavaScript
- Create driver template files for all 5 problems in C++ and JavaScript
- Update frontend language selector (if applicable)

### Future: Shared utility libraries

- When linked list / tree / graph problems are added, create shared utility files under `drivers/lib/{language}/`
- Driver files for those problems include `// {{LIB:ListNode}}` markers
- `DriverCodeLoader` resolves markers by inlining the utility code

## Key Files to Modify

- `backend/src/main/java/com/codebite/submission/service/SubmissionService.java` (lines 62-71)
- `backend/src/main/java/com/codebite/problem/entity/Problem.java` (lines 38-40, 91-97)
- `backend/src/main/java/com/codebite/problem/dto/CreateProblemRequest.java`
- `backend/src/main/java/com/codebite/problem/dto/UpdateProblemRequest.java`
- `backend/src/main/java/com/codebite/problem/service/ProblemService.java`
- `backend/src/main/java/com/codebite/judge/service/JudgeService.java` (LANGUAGE_IDS map)
- New: `backend/src/main/java/com/codebite/judge/service/DriverCodeLoader.java`
- New: `backend/src/main/resources/drivers/**`
- New: `backend/src/main/resources/db/migration/V7__drop_driver_code_column.sql`

## Verification

```bash
cd backend && ./gradlew test
# Verify DriverCodeLoader loads all templates correctly
# Submit from frontend → status should still update to ACCEPTED
# Test all 5 problems in all supported languages
```
