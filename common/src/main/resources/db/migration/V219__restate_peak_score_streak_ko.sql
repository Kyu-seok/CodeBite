-- V219: restate peak-score-streak (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`nums.length <= 10^5` for `2 * 10^5`, `-10^4 <=
-- nums[i] <= 10^4` for `|nums[i]| <= 10^8`); the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `|nums[i]| <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-score-streak$$);
