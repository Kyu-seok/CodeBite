-- V253: restate n-queens (#192, part of #168). The Korean constraints kept LeetCode's bounds
-- where the English state CodeBite's (`n <= 9` for `10`); the Korean bullets keep their prose
-- and carry the English constraints' code spans exactly. Only the Korean constraints change;
-- Slug, title, description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= n <= 10`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$n-queens$$);
