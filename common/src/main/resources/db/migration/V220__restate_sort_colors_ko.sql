-- V220: restate sort-colors (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`nums.length <= 300` for `2 * 10^3`); the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= nums.length <= 2 * 10^3`
- `nums[i]`는 `0`, `1`, `2` 중 하나입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-colors$$);
