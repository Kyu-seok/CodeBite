-- V221: restate trapping-rain-water (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`n <= 2 * 10^4` for `2 * 10^5`,
-- `height[i] <= 10^5` for `10^8`); the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `n == height.length`
- `1 <= n <= 2 * 10^5`
- `0 <= height[i] <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trapping-rain-water$$);
