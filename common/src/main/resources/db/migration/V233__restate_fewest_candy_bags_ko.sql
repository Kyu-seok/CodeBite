-- V233: restate fewest-candy-bags (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`bagSizes[i] <= 2^31 - 1` for `10^8`, `quota <=
-- 10^4` for `8000`); the Korean bullets keep their prose and carry the English constraints'
-- code spans exactly. Only the Korean constraints change; Slug, title, description, English
-- text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 10^8`
- `0 <= quota <= 8000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-candy-bags$$);
