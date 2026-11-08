-- V232: restate dual-waterbowl-flow (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`field[r][c] <= 10^5` for `80000`);
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dual-waterbowl-flow$$);
