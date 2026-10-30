---
name: restate-problem
description: Restate a CodeBite problem, rewording its Slug, title, description, constraints (English and Korean) or the method and parameter names in its Starter Code while its Test Cases stay the same. Use when a problem's statement doesn't make sense, reads badly, or its slug/title or starter names should change.
---

# Restate a problem

A **Restatement** (GLOSSARY.md) rewords a problem without changing what is asked. Its Test Cases are the invariant: every input and expected output, and so the algorithm that solves the problem, stays byte for byte the same. When the change you want needs a different test case, it is a new problem, and this skill is the wrong tool.

What may change, and where each piece lives:

| Piece | Lives in |
|---|---|
| Slug, title, description, constraints (en) | `problems` row, changed by a new Flyway migration |
| Title, description, constraints (ko) | `problem_translations` row (`locale = 'ko'`), same migration |
| Former Slug | `problem_former_slugs` row, same migration, only when the Slug changes |
| Driver | `common/src/main/resources/drivers/<slug>/<language>.<ext>`, 4 Languages |
| Starter Code | `common/src/main/resources/starters/<slug>/<language>.<ext>`, 4 Languages |

Everything else (Test Cases, submissions, Reviews, Streaks, roadmap, stats, translations) keys on `problem_id` and follows the problem untouched.

Work in your own worktree, per CLAUDE.md. One Restatement is one commit.

## 1. Read the problem as it stands

1. Find the newest text for every piece. With the local database migrated (`docker compose -f infra/docker-compose.yml up -d`, then one `bootRun`), read it directly:
   ```bash
   docker exec codebite-postgres psql -U codebite -d codebite -c "
     SELECT p.id, p.slug, p.title, p.description, p.constraints, t.title, t.description, t.constraints
     FROM problems p LEFT JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'
     WHERE p.slug = '<slug>'"
   ```
   Without it, the newest migration that sets each column wins: `grep -ln '<slug>' common/src/main/resources/db/migration/` and read from the highest version down. The problem may appear under a Former Slug in older migrations (`SELECT slug FROM problem_former_slugs WHERE problem_id = …`).
2. Read the sample Test Cases (`is_sample = true`, by `order_index`) the same way: `SELECT order_index, input, expected_output FROM test_cases WHERE problem_id = … AND is_sample ORDER BY order_index`.
3. Read all 4 Drivers and all 4 Starter Code files.

Done when you can state, from the Test Cases alone, what the problem computes, and every example in the current description matches a sample case.

## 2. Write the new statement

1. Draft the English title, description and constraints, then the Korean ones, following the house style of recent Restatements (`V192__rename_product_of_all_other_elements.sql` is the model: a direct statement, **Example N:** blocks, constraints as a bullet list).
2. Pick the Slug: kebab-case of the new title. It must be neither a current Slug nor a Former Slug (`ProblemRepository.isSlugTaken`; check both tables, or `ls common/src/main/resources/drivers/` plus `problem_former_slugs`).
3. Pick the method and parameter names, if they change. Every name in the description's examples must match a name in the Starter Code.

Done when each example's Input and Output are exactly a sample case's input and expected output (order_index 1 and 2), restated in the new names, and the constraints describe the inputs the Test Cases actually contain.

## 3. Write the migration

Create `common/src/main/resources/db/migration/V<next>__restate_<new_slug_with_underscores>.sql`, where `<next>` is one above the highest version on `origin/master` (another branch may have taken the next number: re-check before merging). Use `$$…$$` quoting so backticks and apostrophes need no escaping. In this order:

```sql
-- V<next>: <old-slug> -> <new-slug>, retitled "<New Title>". <one line on why>.
-- <method/parameter renames, if any>. Drivers and Starter Code directories are
-- renamed in the same commit. Examples match the sample test cases, which are
-- unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$<old-slug>$$, id FROM problems WHERE slug = $$<old-slug>$$;

UPDATE problems SET
    slug = $$<new-slug>$$,
    title = $$<New Title>$$,
    description = $$…$$,
    constraints = $$…$$
WHERE slug = $$<old-slug>$$;

UPDATE problem_translations SET
    title = $$…$$,
    description = $$…$$,
    constraints = $$…$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$<new-slug>$$);
```

Leave out the `problem_former_slugs` insert and the `slug =` line when the Slug stays. Leave out any column that stays.

## 4. Move and rename the assets

1. When the Slug changes: `git mv` both `drivers/<old-slug>` and `starters/<old-slug>` to `<new-slug>`.
2. When the method or parameter names change: edit all 4 Starter Code files and all 4 Drivers together. The Driver's call (`new Solution().<method>(…)`, `Solution().<method>(…)`) must name the Starter Code's method. Rename the Driver's local variables to match too, so the files read alike. Touch nothing in a Driver beyond names: its parsing and printing are what make the Test Cases pass.
3. `git grep -n '<old-slug>\|<oldMethod>'` outside `db/migration/` and update every hit: tests, frontend, docs. Older migrations stay as they are: Flyway runs them before yours, under the old names.

Done when that grep finds nothing outside the migrations.

## 5. Verify

1. `./gradlew :common:test --tests '*DriverStarterMethodTest' --tests '*ProblemAssetsTest'` and `./gradlew :backend:test --tests '*ProblemSlugsTest' --tests '*MigrationSlugReferencesTest'`. ProblemSlugsTest runs every migration and goes red when a Slug and its asset directories disagree, or a Former Slug clashes with a Slug. MigrationSlugReferencesTest goes red when a `WHERE slug = …` names a slug no problem has when the migration runs (an UPDATE that silently matches nothing), e.g. one another branch Restated first: rebase, and point the migration at the current Slug.
2. Apply the migration to the local database (restart `bootRun`) and read the result back:
   ```bash
   docker exec codebite-postgres psql -U codebite -d codebite -c "
     SELECT p.slug, p.title, t.title, f.slug AS former
     FROM problems p JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'
     LEFT JOIN problem_former_slugs f ON f.problem_id = p.id
     WHERE p.slug = '<new-slug>'"
   ```
3. Run a reference solution written against the new Starter Code through the Run endpoint, so Java and C++ compile against the renamed Drivers and every sample passes:
   `curl -s -X POST localhost:8080/api/problems/<new-slug>/run -H 'Content-Type: application/json' -d '{"language":"<language>","sourceCode":"…"}'` for each of the 4 Languages.
4. Open `http://localhost:5173/problems/<old-slug>`: the page lands on `/problems/<new-slug>`.

Done when all four are green for all 4 Languages.

## 6. Commit and PR

Commit `refactor(problem): restate <old-slug> as <new-slug>` (or `restate <slug>` when it stays) with the migration, the moved assets and the grep fixes together. In the PR body, state what users will notice:

- When the method or parameter names changed: earlier code calling the old names no longer compiles, if resubmitted or loaded from a past submission. Stored Verdicts are untouched.
- When the Slug changed: editor drafts saved in the browser under the old Slug are left behind; Solution Repositories keep the old folder, and new Solution Commits go to `<new-slug>/`; old links and READMEs still reach the problem through the Former Slug.
