-- V223: restate largest-rectangle-histogram (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`heights.length <= 10^5` for `2 *
-- 10^5`, `heights[i] <= 10^4` for `2 * 10^3`); the Korean bullets keep their prose and carry
-- the English constraints' code spans exactly. Only the Korean constraints change; Slug,
-- title, description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= heights.length <= 2 * 10^5`
- `0 <= heights[i] <= 2 * 10^3`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$largest-rectangle-histogram$$);
