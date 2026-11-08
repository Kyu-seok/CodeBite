-- V251: restate min-daily-brew (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`volumes.length <= 5 * 10^4` for `8 * 10^4`,
-- `volumes[i] <= 500` for `600`); the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-daily-brew$$);
