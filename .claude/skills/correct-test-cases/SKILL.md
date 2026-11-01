---
name: correct-test-cases
description: Correct a CodeBite problem's Test Cases where a case breaks what the statement promises (two right answers where it says exactly one, an input outside the constraints) or expects a wrong output. Use for a Problem Report of a wrong test case, a correct answer judged Wrong Answer, or a bad case found while working on a problem.
---

# Correct a problem's Test Cases

A **Test Case Correction** (GLOSSARY.md) makes a problem's Test Cases agree with its statement. The statement is the truth: when it is the statement that promises the wrong thing, stop and use `.claude/skills/restate-problem/SKILL.md` instead. Cases are edited in place and past Verdicts stand (docs/adr/0010).

The proof is a **Guarantee**: a `ProblemGuarantee` in `backend/src/test/java/com/codebite/problem/guarantee/`, written from the statement alone, which `ProblemGuaranteesTest` runs over every case. It must go **red** on the wrong case before you change anything, and green after. A reference solution is no proof: two pointers print one of two right answers and pass the case that has both.

Input is a Problem Report (`gh issue view <n>`: the problem, the case's position, the user's output) or a bare slug. Work in your own worktree, per CLAUDE.md. One problem's correction is one commit.

## 1. Read the problem and its cases

1. `scripts/problem-text.sh <slug>` for the statement in English and Korean.
2. Every case, hidden ones too, in grading order:
   ```bash
   docker exec codebite-postgres psql -U codebite -d codebite -c "
     SELECT t.order_index, t.is_sample, t.input, t.expected_output FROM test_cases t
     JOIN problems p ON p.id = t.problem_id WHERE p.slug = '<slug>' ORDER BY t.order_index, t.id"
   ```
3. The Python Driver, `common/src/main/resources/drivers/<slug>/python.py`: how it reads each input line and prints the result.

Done when you can list every promise the statement makes about an input (each constraint, "sorted", "exactly one ...") and say exactly how the Driver prints an answer.

## 2. Write the Guarantee and watch it go red

1. Write `<PascalSlug>Guarantee implements ProblemGuarantee` (`TwoMenuSumGuarantee` is the model) and add it to `ProblemGuaranteesTest.GUARANTEES`.
   - `inputViolations`: one check per promise from step 1.
   - `correctOutputs`: every output the statement accepts, printed as the Driver prints it, by brute force. The Grader compares output exactly, so a case is sound only when this set is its expected output alone.
2. `./gradlew :backend:test --tests '*ProblemGuaranteesTest'`.

Done when it is red on the reported case and the failure names the right answers. Then branch:

- **Red as reported**: go on to step 3.
- **Green, and the user's output isn't among the right answers**: the case is sound and the user's program is wrong. Reply on the issue with why, close it, and stop; commit the Guarantee on its own if you like, as it guards the problem from now on.
- **Red because the statement promises something the problem never meant** (e.g. a constraint the cases were right to break): stop and Restate.

## 3. Write the migration

Create `common/src/main/resources/db/migration/V<next>__correct_<slug_with_underscores>_cases.sql`, `<next>` one above the highest version on `origin/master` in either migration directory.

1. For each red case, the smallest change to its input that restores the promise, keeping its expected output where you can. `UPDATE` it in place, matched by problem, `is_sample`, `order_index` and its old input, so the migration matches nothing if the case already changed:
   ```sql
   UPDATE test_cases SET input = E'[1,3,5,6,9]\n10', expected_output = '[1,5]'
   WHERE problem_id = (SELECT id FROM problems WHERE slug = '<slug>')
     AND is_sample = FALSE AND order_index = 8 AND input = E'[1,3,5,7,9]\n10';
   ```
2. A corrected sample is also an example: update that **Example N** in `problems.description` and the Korean `problem_translations` row, and its Diagram if it has one (`.claude/skills/add-diagram/SKILL.md`).
3. Head the migration with what was wrong, the change, and the Guarantee that checks it (V202 is the model).

Done when `./gradlew :backend:test --tests 'com.codebite.problem.*'` is green.

## 4. Judge it with every reference solution

Write the problem's cases as they stand after your migration to a JSON list of `{input, expected_output}` and run `scripts/judge-local.sh <slug> --cases <that file>`.

Done when every Language with a reference solution is ACCEPTED; `NOT JUDGED` (most problems have only a Python one) is fine. A reference solution that fails now got the old case wrong in the same way: fix `scripts/replay-solutions/<slug>.*` in the same commit.

## 5. Commit and PR

Commit `fix(problem): correct <slug> test cases` with the Guarantee, the migration and any reference solution. The PR body states which cases changed and why, says `Fixes #<n>` for a Problem Report, and notes that past Verdicts stand (docs/adr/0010). After the merge, comment on the report that the case is corrected and a resubmission will be judged against it.
