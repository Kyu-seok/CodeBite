-- V261: restate swap-print-pairs (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`[0, 100]` nodes for `120`) and `Node.val` for
-- `Job.val`; the English span `0 <= Number of jobs <= 120` embedded prose no translation can
-- carry, so it becomes the range `[0, 120]`; the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the constraints change, English and Korean;
-- Slug, title, description, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- The number of jobs in the list is in the range `[0, 120]`.
- `0 <= Job.val <= 100`$$
WHERE slug = $$swap-print-pairs$$;

UPDATE problem_translations SET
    constraints = $$- 리스트의 작업 개수는 `[0, 120]` 범위입니다.
- `0 <= Job.val <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$swap-print-pairs$$);
