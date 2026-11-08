-- V236: restate finish-the-level (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`slack.length <= 10^4` for `2 * 10^5`, `slack[i]
-- <= 10^5` for `8 * 10^4`); the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= slack.length <= 2 * 10^5`
- `0 <= slack[i] <= 8 * 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$finish-the-level$$);
